Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1EAOHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 10:07:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33908 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1EAOH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 10:07:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 1 May 2011 16:07:12 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "B.J. Buchalter" <bj@mhlabs.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: ohci: fix successive Config ROM changes
Message-ID: <20110501160712.6aeed43e@stein>
In-Reply-To: <20110430151640.6f299d63@stein>
References: <CD6504A2-9028-40AD-B185-87D1C4974955@mhlabs.com>
	<20110430132424.02166e71@stein>
	<20110430151640.6f299d63@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When fw_core_add_descriptor() or fw_core_remove_descriptor() is called
several times within the same bus generation, firewire-ohci would only
take over the first of these changes into the image that is shown in
read responses in the Configuration ROM range.

This bug always existed at least theoretically.  It became easy to
trigger since 2.6.36 commit 02d37bed188c "firewire: core: integrate
software-forced bus resets with bus management" which introduced long
mandatory delays between janitorial bus resets.

Fix this by a different buffer management for the Configuration ROM
image:

  a) Instead of holding 1 buffer during the lifetime of the fw_ohci
     instance + 1 buffer from ROM update request until self-ID-complete
     event, hold 2 buffers during the fw_ohci lifetime.  (Since
     dma_alloc_coherent() apparently takes more memory than requested,
     the new scheme does not result in more memory consumption.)

  b) Assume that we can scribble over the image for the next generation
     until the moment when the ROMheader quadlet is copied into the
     controller's corresponding register, i.e. even after the buffer
     address was written to the ConfigROMmap register.  We assumed this
     already for the first ROM quadlet but extend this assumption to the
     entire ROM now.

The new scheme eliminates not only the -EBUSY case from
ohci_set_config_rom() which caused the bug, but also its -ENOMEM case
which would likewise result in dropped Configuration ROM updates.
card->driver->set_config_rom() is now a function that never fails, just
like firewire-core's implementation already assumed all the time.

Reported-by: "B.J. Buchalter" <bj@mhlabs.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core.h |    6 
 drivers/firewire/ohci.c |  192 +++++++++++++++++-----------------------
 2 files changed, 84 insertions(+), 114 deletions(-)

Index: b/drivers/firewire/core.h
===================================================================
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -58,10 +58,10 @@ struct fw_card_driver {
 	/*
 	 * Update the config rom for an enabled card.  This function
 	 * should change the config rom that is presented on the bus
-	 * and initiate a bus reset.
+	 * and schedule a bus reset.
 	 */
-	int (*set_config_rom)(struct fw_card *card,
-			      const __be32 *config_rom, size_t length);
+	void (*set_config_rom)(struct fw_card *card,
+			       const __be32 *config_rom, size_t length);
 
 	void (*send_request)(struct fw_card *card, struct fw_packet *packet);
 	void (*send_response)(struct fw_card *card, struct fw_packet *packet);
Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -218,11 +218,13 @@ struct fw_ohci {
 	u64 mc_channels; /* channels in use by the multichannel IR context */
 	bool mc_allocated;
 
-	__be32    *config_rom;
-	dma_addr_t config_rom_bus;
-	__be32    *next_config_rom;
-	dma_addr_t next_config_rom_bus;
-	__be32     next_header;
+	/* one buffer for the current bus generation, one for the next */
+	struct config_rom_buffer {
+		__be32 header;
+		__be32 *rom;
+		dma_addr_t bus;
+	} config_rom[2];
+	unsigned int next_config_rom;
 
 	__le32    *self_id_cpu;
 	dma_addr_t self_id_bus;
@@ -1456,7 +1458,9 @@ static void handle_local_rom(struct fw_o
 			     struct fw_packet *packet, u32 csr)
 {
 	struct fw_packet response;
+	struct config_rom_buffer *crb;
 	int tcode, length, i;
+	unsigned long flags;
 
 	tcode = HEADER_GET_TCODE(packet->header[0]);
 	if (TCODE_IS_BLOCK_PACKET(tcode))
@@ -1472,8 +1476,13 @@ static void handle_local_rom(struct fw_o
 		fw_fill_response(&response, packet->header,
 				 RCODE_TYPE_ERROR, NULL, 0);
 	} else {
+		spin_lock_irqsave(&ohci->lock, flags);
+
+		crb = &ohci->config_rom[ohci->next_config_rom ^ 1];
 		fw_fill_response(&response, packet->header, RCODE_COMPLETE,
-				 (void *) ohci->config_rom + i, length);
+				 (void *)crb->rom + i, length);
+
+		spin_unlock_irqrestore(&ohci->lock, flags);
 	}
 
 	fw_core_handle_response(&ohci->card, &response);
@@ -1704,11 +1713,10 @@ static u32 update_bus_time(struct fw_ohc
 static void bus_reset_tasklet(unsigned long data)
 {
 	struct fw_ohci *ohci = (struct fw_ohci *)data;
+	struct config_rom_buffer *crb;
 	int self_id_count, i, j, reg;
 	int generation, new_generation;
 	unsigned long flags;
-	void *free_rom = NULL;
-	dma_addr_t free_rom_bus = 0;
 	bool is_new_root;
 
 	reg = reg_read(ohci, OHCI1394_NodeID);
@@ -1806,33 +1814,25 @@ static void bus_reset_tasklet(unsigned l
 
 	/*
 	 * This next bit is unrelated to the AT context stuff but we
-	 * have to do it under the spinlock also.  If a new config rom
-	 * was set up before this reset, the old one is now no longer
-	 * in use and we can free it. Update the config rom pointers
-	 * to point to the current config rom and clear the
-	 * next_config_rom pointer so a new update can take place.
+	 * have to do it under the spinlock also.
 	 */
-
-	if (ohci->next_config_rom != NULL) {
-		if (ohci->next_config_rom != ohci->config_rom) {
-			free_rom      = ohci->config_rom;
-			free_rom_bus  = ohci->config_rom_bus;
-		}
-		ohci->config_rom      = ohci->next_config_rom;
-		ohci->config_rom_bus  = ohci->next_config_rom_bus;
-		ohci->next_config_rom = NULL;
-
+	crb = &ohci->config_rom[ohci->next_config_rom];
+	if (crb->rom[0] != crb->header) {
 		/*
-		 * Restore config_rom image and manually update
-		 * config_rom registers.  Writing the header quadlet
-		 * will indicate that the config rom is ready, so we
-		 * do that last.
+		 * A new config rom was set up before this reset.
+		 * Restore the config rom image and manually update related
+		 * registers.  A non-zero header quadlet means to external
+		 * nodes that the config rom is ready, so we write it last.
 		 */
-		reg_write(ohci, OHCI1394_BusOptions,
-			  be32_to_cpu(ohci->config_rom[2]));
-		ohci->config_rom[0] = ohci->next_header;
-		reg_write(ohci, OHCI1394_ConfigROMhdr,
-			  be32_to_cpu(ohci->next_header));
+		reg_write(ohci, OHCI1394_BusOptions, be32_to_cpu(crb->rom[2]));
+		crb->rom[0] = crb->header;
+		reg_write(ohci, OHCI1394_ConfigROMhdr, be32_to_cpu(crb->header));
+
+		/* Point future ohci_set_config_rom calls to the next buffer. */
+		ohci->next_config_rom ^= 1;
+		crb = &ohci->config_rom[ohci->next_config_rom];
+		crb->header = 0;
+		crb->rom[0] = 0;
 	}
 
 #ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
@@ -1842,10 +1842,6 @@ static void bus_reset_tasklet(unsigned l
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
-	if (free_rom)
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  free_rom, free_rom_bus);
-
 	log_selfids(ohci->node_id, generation,
 		    self_id_count, ohci->self_id_buffer);
 
@@ -1972,13 +1968,16 @@ static int software_reset(struct fw_ohci
 	return -EBUSY;
 }
 
-static void copy_config_rom(__be32 *dest, const __be32 *src, size_t length)
+static void copy_config_rom(struct config_rom_buffer *buffer,
+			    const __be32 *source, size_t length)
 {
 	size_t size = length * 4;
 
-	memcpy(dest, src, size);
+	buffer->header = source[0];
+	buffer->rom[0] = 0;
+	memcpy(&buffer->rom[1], &source[1], size - 4);
 	if (size < CONFIG_ROM_SIZE)
-		memset(&dest[length], 0, CONFIG_ROM_SIZE - size);
+		memset(&buffer->rom[length], 0, CONFIG_ROM_SIZE - size);
 }
 
 static int configure_1394a_enhancements(struct fw_ohci *ohci)
@@ -2037,6 +2036,7 @@ static int ohci_enable(struct fw_card *c
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	struct pci_dev *dev = to_pci_dev(card->device);
+	struct config_rom_buffer *crb;
 	u32 lps, seconds, version, irqs;
 	int i, ret;
 
@@ -2131,31 +2131,23 @@ static int ohci_enable(struct fw_card *c
 	 * workaround here, setting the bus header to 0 and then write
 	 * the right values in the bus reset tasklet.
 	 */
-
+	crb = &ohci->config_rom[ohci->next_config_rom];
 	if (config_rom) {
-		ohci->next_config_rom =
-			dma_alloc_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-					   &ohci->next_config_rom_bus,
-					   GFP_KERNEL);
-		if (ohci->next_config_rom == NULL)
-			return -ENOMEM;
-
-		copy_config_rom(ohci->next_config_rom, config_rom, length);
+		copy_config_rom(crb, config_rom, length);
 	} else {
 		/*
-		 * In the suspend case, config_rom is NULL, which
-		 * means that we just reuse the old config rom.
+		 * During PM resume, reuse the old config rom
+		 * unless there are already rom changes pending.
 		 */
-		ohci->next_config_rom = ohci->config_rom;
-		ohci->next_config_rom_bus = ohci->config_rom_bus;
+		if (crb->header == 0) {
+			ohci->next_config_rom ^= 1;
+			crb = &ohci->config_rom[ohci->next_config_rom];
+			crb->rom[0] = 0;
+		}
 	}
-
-	ohci->next_header = ohci->next_config_rom[0];
-	ohci->next_config_rom[0] = 0;
 	reg_write(ohci, OHCI1394_ConfigROMhdr, 0);
-	reg_write(ohci, OHCI1394_BusOptions,
-		  be32_to_cpu(ohci->next_config_rom[2]));
-	reg_write(ohci, OHCI1394_ConfigROMmap, ohci->next_config_rom_bus);
+	reg_write(ohci, OHCI1394_BusOptions, be32_to_cpu(crb->rom[2]));
+	reg_write(ohci, OHCI1394_ConfigROMmap, crb->bus);
 
 	reg_write(ohci, OHCI1394_AsReqFilterHiSet, 0x80000000);
 
@@ -2166,8 +2158,7 @@ static int ohci_enable(struct fw_card *c
 			ohci_driver_name, ohci)) {
 		fw_error("Failed to allocate interrupt %d.\n", dev->irq);
 		pci_disable_msi(dev);
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  ohci->config_rom, ohci->config_rom_bus);
+
 		return -EIO;
 	}
 
@@ -2198,21 +2189,17 @@ static int ohci_enable(struct fw_card *c
 	ar_context_run(&ohci->ar_response_ctx); /* also flushes writes */
 
 	/* We are ready to go, reset bus to finish initialization. */
-	fw_schedule_bus_reset(&ohci->card, false, true);
+	fw_schedule_bus_reset(card, false, true);
 
 	return 0;
 }
 
-static int ohci_set_config_rom(struct fw_card *card,
-			       const __be32 *config_rom, size_t length)
+static void ohci_set_config_rom(struct fw_card *card,
+				const __be32 *config_rom, size_t length)
 {
-	struct fw_ohci *ohci;
+	struct fw_ohci *ohci = fw_ohci(card);
+	struct config_rom_buffer *crb;
 	unsigned long flags;
-	int ret = -EBUSY;
-	__be32 *next_config_rom;
-	dma_addr_t uninitialized_var(next_config_rom_bus);
-
-	ohci = fw_ohci(card);
 
 	/*
 	 * When the OHCI controller is enabled, the config rom update
@@ -2237,48 +2224,21 @@ static int ohci_set_config_rom(struct fw
 	 * config rom isn't ready yet.  In the bus reset tasklet we
 	 * then set up the real values for the two registers.
 	 *
-	 * We use ohci->lock to avoid racing with the code that sets
-	 * ohci->next_config_rom to NULL (see bus_reset_tasklet).
+	 * We use ohci->lock to avoid racing with the code which
+	 * corrects ConfigRomHeader and BusOptions and increments the
+	 * ohci->next_config_rom index (see bus_reset_tasklet).
 	 */
 
-	next_config_rom =
-		dma_alloc_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				   &next_config_rom_bus, GFP_KERNEL);
-	if (next_config_rom == NULL)
-		return -ENOMEM;
-
 	spin_lock_irqsave(&ohci->lock, flags);
 
-	if (ohci->next_config_rom == NULL) {
-		ohci->next_config_rom = next_config_rom;
-		ohci->next_config_rom_bus = next_config_rom_bus;
-
-		copy_config_rom(ohci->next_config_rom, config_rom, length);
-
-		ohci->next_header = config_rom[0];
-		ohci->next_config_rom[0] = 0;
-
-		reg_write(ohci, OHCI1394_ConfigROMmap,
-			  ohci->next_config_rom_bus);
-		ret = 0;
-	}
+	crb = &ohci->config_rom[ohci->next_config_rom];
+	copy_config_rom(crb, config_rom, length);
+	reg_write(ohci, OHCI1394_ConfigROMmap, crb->bus);
+	mmiowb();
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
-	/*
-	 * Now initiate a bus reset to have the changes take
-	 * effect. We clean up the old config rom memory and DMA
-	 * mappings in the bus reset tasklet, since the OHCI
-	 * controller could need to access it before the bus reset
-	 * takes effect.
-	 */
-	if (ret == 0)
-		fw_schedule_bus_reset(&ohci->card, true, true);
-	else
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  next_config_rom, next_config_rom_bus);
-
-	return ret;
+	fw_schedule_bus_reset(card, true, true);
 }
 
 static void ohci_send_request(struct fw_card *card, struct fw_packet *packet)
@@ -3219,6 +3179,17 @@ static int __devinit pci_probe(struct pc
 	if (param_quirks)
 		ohci->quirks = param_quirks;
 
+	ohci->config_rom[0].rom = dma_alloc_coherent(ohci->card.device,
+						     2 * CONFIG_ROM_SIZE,
+						     &ohci->config_rom[0].bus,
+						     GFP_KERNEL);
+	if (!ohci->config_rom[0].rom) {
+		err = -ENOMEM;
+		goto fail_iounmap;
+	}
+	ohci->config_rom[1].rom = ohci->config_rom[0].rom + CONFIG_ROM_SIZE/4;
+	ohci->config_rom[1].bus = ohci->config_rom[0].bus + CONFIG_ROM_SIZE;
+
 	/*
 	 * Because dma_alloc_coherent() allocates at least one page,
 	 * we save space by using a common buffer for the AR request/
@@ -3232,7 +3203,7 @@ static int __devinit pci_probe(struct pc
 					       GFP_KERNEL);
 	if (!ohci->misc_buffer) {
 		err = -ENOMEM;
-		goto fail_iounmap;
+		goto fail_rom_buf;
 	}
 
 	err = ar_context_init(&ohci->ar_request_ctx, ohci, 0,
@@ -3311,6 +3282,9 @@ static int __devinit pci_probe(struct pc
  fail_misc_buf:
 	dma_free_coherent(ohci->card.device, PAGE_SIZE,
 			  ohci->misc_buffer, ohci->misc_buffer_bus);
+ fail_rom_buf:
+	dma_free_coherent(ohci->card.device, 2 * CONFIG_ROM_SIZE,
+			  ohci->config_rom[0].rom, ohci->config_rom[0].bus);
  fail_iounmap:
 	pci_iounmap(dev, ohci->registers);
  fail_iomem:
@@ -3344,12 +3318,8 @@ static void pci_remove(struct pci_dev *d
 	software_reset(ohci);
 	free_irq(dev->irq, ohci);
 
-	if (ohci->next_config_rom && ohci->next_config_rom != ohci->config_rom)
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  ohci->next_config_rom, ohci->next_config_rom_bus);
-	if (ohci->config_rom)
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  ohci->config_rom, ohci->config_rom_bus);
+	dma_free_coherent(ohci->card.device, 2 * CONFIG_ROM_SIZE,
+			  ohci->config_rom[0].rom, ohci->config_rom[0].bus);
 	ar_context_release(&ohci->ar_request_ctx);
 	ar_context_release(&ohci->ar_response_ctx);
 	dma_free_coherent(ohci->card.device, PAGE_SIZE,


-- 
Stefan Richter
-=====-==-== -=-= ----=
http://arcgraph.de/sr/
