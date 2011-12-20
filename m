Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1LTUdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:33:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43338 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1LTUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:33:00 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 20 Dec 2011 21:32:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Carl Karsten <carl@personnelware.com>
Subject: [PATCH 2/3] firewire: ohci: use dev_printk API
Message-ID: <20111220213246.7c614b16@stein>
In-Reply-To: <20111220213017.75ff380c@stein>
References: <20111220213017.75ff380c@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All messages are uniformly prefixed by driver name and device name now.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
PS, any of these three patches is applicable independently of the others.

 drivers/firewire/ohci.c |  185 +++++++++++++++++++++++-----------------
 1 file changed, 106 insertions(+), 79 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -345,7 +345,7 @@ MODULE_PARM_DESC(debug, "Verbose logging
 	", busReset events = "	__stringify(OHCI_PARAM_DEBUG_BUSRESETS)
 	", or a combination, or all = -1)");
 
-static void log_irqs(u32 evt)
+static void log_irqs(struct fw_ohci *ohci, u32 evt)
 {
 	if (likely(!(param_debug &
 			(OHCI_PARAM_DEBUG_IRQS | OHCI_PARAM_DEBUG_BUSRESETS))))
@@ -355,7 +355,8 @@ static void log_irqs(u32 evt)
 	    !(evt & OHCI1394_busReset))
 		return;
 
-	fw_notify("IRQ %08x%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n", evt,
+	dev_notice(ohci->card.device,
+	    "IRQ %08x%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n", evt,
 	    evt & OHCI1394_selfIDComplete	? " selfID"		: "",
 	    evt & OHCI1394_RQPkt		? " AR_req"		: "",
 	    evt & OHCI1394_RSPkt		? " AR_resp"		: "",
@@ -394,24 +395,29 @@ static char _p(u32 *s, int shift)
 	return port[*s >> shift & 3];
 }
 
-static void log_selfids(int node_id, int generation, int self_id_count, u32 *s)
+static void log_selfids(struct fw_ohci *ohci, int generation, int self_id_count)
 {
+	u32 *s;
+
 	if (likely(!(param_debug & OHCI_PARAM_DEBUG_SELFIDS)))
 		return;
 
-	fw_notify("%d selfIDs, generation %d, local node ID %04x\n",
-		  self_id_count, generation, node_id);
+	dev_notice(ohci->card.device,
+		   "%d selfIDs, generation %d, local node ID %04x\n",
+		   self_id_count, generation, ohci->node_id);
 
-	for (; self_id_count--; ++s)
+	for (s = ohci->self_id_buffer; self_id_count--; ++s)
 		if ((*s & 1 << 23) == 0)
-			fw_notify("selfID 0: %08x, phy %d [%c%c%c] "
+			dev_notice(ohci->card.device,
+			    "selfID 0: %08x, phy %d [%c%c%c] "
 			    "%s gc=%d %s %s%s%s\n",
 			    *s, *s >> 24 & 63, _p(s, 6), _p(s, 4), _p(s, 2),
 			    speed[*s >> 14 & 3], *s >> 16 & 63,
 			    power[*s >> 8 & 7], *s >> 22 & 1 ? "L" : "",
 			    *s >> 11 & 1 ? "c" : "", *s & 2 ? "i" : "");
 		else
-			fw_notify("selfID n: %08x, phy %d [%c%c%c%c%c%c%c%c]\n",
+			dev_notice(ohci->card.device,
+			    "selfID n: %08x, phy %d [%c%c%c%c%c%c%c%c]\n",
 			    *s, *s >> 24 & 63,
 			    _p(s, 16), _p(s, 14), _p(s, 12), _p(s, 10),
 			    _p(s,  8), _p(s,  6), _p(s,  4), _p(s,  2));
@@ -447,7 +453,8 @@ static const char *tcodes[] = {
 	[0xe] = "link internal",	[0xf] = "-reserved-",
 };
 
-static void log_ar_at_event(char dir, int speed, u32 *header, int evt)
+static void log_ar_at_event(struct fw_ohci *ohci,
+			    char dir, int speed, u32 *header, int evt)
 {
 	int tcode = header[0] >> 4 & 0xf;
 	char specific[12];
@@ -459,8 +466,9 @@ static void log_ar_at_event(char dir, in
 			evt = 0x1f;
 
 	if (evt == OHCI1394_evt_bus_reset) {
-		fw_notify("A%c evt_bus_reset, generation %d\n",
-		    dir, (header[2] >> 16) & 0xff);
+		dev_notice(ohci->card.device,
+			   "A%c evt_bus_reset, generation %d\n",
+			   dir, (header[2] >> 16) & 0xff);
 		return;
 	}
 
@@ -479,36 +487,41 @@ static void log_ar_at_event(char dir, in
 
 	switch (tcode) {
 	case 0xa:
-		fw_notify("A%c %s, %s\n", dir, evts[evt], tcodes[tcode]);
+		dev_notice(ohci->card.device,
+			   "A%c %s, %s\n",
+			   dir, evts[evt], tcodes[tcode]);
 		break;
 	case 0xe:
-		fw_notify("A%c %s, PHY %08x %08x\n",
-			  dir, evts[evt], header[1], header[2]);
+		dev_notice(ohci->card.device,
+			   "A%c %s, PHY %08x %08x\n",
+			   dir, evts[evt], header[1], header[2]);
 		break;
 	case 0x0: case 0x1: case 0x4: case 0x5: case 0x9:
-		fw_notify("A%c spd %x tl %02x, "
-		    "%04x -> %04x, %s, "
-		    "%s, %04x%08x%s\n",
-		    dir, speed, header[0] >> 10 & 0x3f,
-		    header[1] >> 16, header[0] >> 16, evts[evt],
-		    tcodes[tcode], header[1] & 0xffff, header[2], specific);
+		dev_notice(ohci->card.device,
+			   "A%c spd %x tl %02x, "
+			   "%04x -> %04x, %s, "
+			   "%s, %04x%08x%s\n",
+			   dir, speed, header[0] >> 10 & 0x3f,
+			   header[1] >> 16, header[0] >> 16, evts[evt],
+			   tcodes[tcode], header[1] & 0xffff, header[2], specific);
 		break;
 	default:
-		fw_notify("A%c spd %x tl %02x, "
-		    "%04x -> %04x, %s, "
-		    "%s%s\n",
-		    dir, speed, header[0] >> 10 & 0x3f,
-		    header[1] >> 16, header[0] >> 16, evts[evt],
-		    tcodes[tcode], specific);
+		dev_notice(ohci->card.device,
+			   "A%c spd %x tl %02x, "
+			   "%04x -> %04x, %s, "
+			   "%s%s\n",
+			   dir, speed, header[0] >> 10 & 0x3f,
+			   header[1] >> 16, header[0] >> 16, evts[evt],
+			   tcodes[tcode], specific);
 	}
 }
 
 #else
 
 #define param_debug 0
-static inline void log_irqs(u32 evt) {}
-static inline void log_selfids(int node_id, int generation, int self_id_count, u32 *s) {}
-static inline void log_ar_at_event(char dir, int speed, u32 *header, int evt) {}
+static inline void log_irqs(struct fw_ohci *ohci, u32 evt) {}
+static inline void log_selfids(struct fw_ohci *ohci, int generation, int self_id_count) {}
+static inline void log_ar_at_event(struct fw_ohci *ohci, char dir, int speed, u32 *header, int evt) {}
 
 #endif /* CONFIG_FIREWIRE_OHCI_DEBUG */
 
@@ -555,7 +568,7 @@ static int read_phy_reg(struct fw_ohci *
 		if (i >= 3)
 			msleep(1);
 	}
-	fw_error("failed to read phy reg\n");
+	dev_err(ohci->card.device, "failed to read phy reg\n");
 
 	return -EBUSY;
 }
@@ -577,7 +590,7 @@ static int write_phy_reg(const struct fw
 		if (i >= 3)
 			msleep(1);
 	}
-	fw_error("failed to write phy reg\n");
+	dev_err(ohci->card.device, "failed to write phy reg\n");
 
 	return -EBUSY;
 }
@@ -676,11 +689,14 @@ static void ar_context_release(struct ar
 
 static void ar_context_abort(struct ar_context *ctx, const char *error_msg)
 {
-	if (reg_read(ctx->ohci, CONTROL_CLEAR(ctx->regs)) & CONTEXT_RUN) {
-		reg_write(ctx->ohci, CONTROL_CLEAR(ctx->regs), CONTEXT_RUN);
-		flush_writes(ctx->ohci);
+	struct fw_ohci *ohci = ctx->ohci;
 
-		fw_error("AR error: %s; DMA stopped\n", error_msg);
+	if (reg_read(ohci, CONTROL_CLEAR(ctx->regs)) & CONTEXT_RUN) {
+		reg_write(ohci, CONTROL_CLEAR(ctx->regs), CONTEXT_RUN);
+		flush_writes(ohci);
+
+		dev_err(ohci->card.device, "AR error: %s; DMA stopped\n",
+			error_msg);
 	}
 	/* FIXME: restart? */
 }
@@ -850,7 +866,7 @@ static __le32 *handle_ar_packet(struct a
 	p.timestamp  = status & 0xffff;
 	p.generation = ohci->request_generation;
 
-	log_ar_at_event('R', p.speed, p.header, evt);
+	log_ar_at_event(ohci, 'R', p.speed, p.header, evt);
 
 	/*
 	 * Several controllers, notably from NEC and VIA, forget to
@@ -1222,21 +1238,22 @@ static void context_append(struct contex
 
 static void context_stop(struct context *ctx)
 {
+	struct fw_ohci *ohci = ctx->ohci;
 	u32 reg;
 	int i;
 
-	reg_write(ctx->ohci, CONTROL_CLEAR(ctx->regs), CONTEXT_RUN);
+	reg_write(ohci, CONTROL_CLEAR(ctx->regs), CONTEXT_RUN);
 	ctx->running = false;
 
 	for (i = 0; i < 1000; i++) {
-		reg = reg_read(ctx->ohci, CONTROL_SET(ctx->regs));
+		reg = reg_read(ohci, CONTROL_SET(ctx->regs));
 		if ((reg & CONTEXT_ACTIVE) == 0)
 			return;
 
 		if (i)
 			udelay(10);
 	}
-	fw_error("Error: DMA context still active (0x%08x)\n", reg);
+	dev_err(ohci->card.device, "DMA context still active (0x%08x)\n", reg);
 }
 
 struct driver_data {
@@ -1416,7 +1433,7 @@ static int handle_at_packet(struct conte
 	evt = le16_to_cpu(last->transfer_status) & 0x1f;
 	packet->timestamp = le16_to_cpu(last->res_count);
 
-	log_ar_at_event('T', packet->speed, packet->header, evt);
+	log_ar_at_event(ohci, 'T', packet->speed, packet->header, evt);
 
 	switch (evt) {
 	case OHCI1394_evt_timeout:
@@ -1545,7 +1562,7 @@ static void handle_local_lock(struct fw_
 			goto out;
 		}
 
-	fw_error("swap not done (CSR lock timeout)\n");
+	dev_err(ohci->card.device, "swap not done (CSR lock timeout)\n");
 	fw_fill_response(&response, packet->header, RCODE_BUSY, NULL, 0);
 
  out:
@@ -1621,11 +1638,13 @@ static void detect_dead_context(struct f
 	ctl = reg_read(ohci, CONTROL_SET(regs));
 	if (ctl & CONTEXT_DEAD) {
 #ifdef CONFIG_FIREWIRE_OHCI_DEBUG
-		fw_error("DMA context %s has stopped, error code: %s\n",
-			 name, evts[ctl & 0x1f]);
+		dev_err(ohci->card.device,
+			"DMA context %s has stopped, error code: %s\n",
+			name, evts[ctl & 0x1f]);
 #else
-		fw_error("DMA context %s has stopped, error code: %#x\n",
-			 name, ctl & 0x1f);
+		dev_err(ohci->card.device,
+			"DMA context %s has stopped, error code: %#x\n",
+			name, ctl & 0x1f);
 #endif
 	}
 }
@@ -1777,7 +1796,8 @@ static int find_and_insert_self_id(struc
 
 	reg = reg_read(ohci, OHCI1394_NodeID);
 	if (!(reg & OHCI1394_NodeID_idValid)) {
-		fw_notify("node ID not valid, new bus reset in progress\n");
+		dev_notice(ohci->card.device,
+			   "node ID not valid, new bus reset in progress\n");
 		return -EBUSY;
 	}
 	self_id |= ((reg & 0x3f) << 24); /* phy ID */
@@ -1823,11 +1843,12 @@ static void bus_reset_work(struct work_s
 
 	reg = reg_read(ohci, OHCI1394_NodeID);
 	if (!(reg & OHCI1394_NodeID_idValid)) {
-		fw_notify("node ID not valid, new bus reset in progress\n");
+		dev_notice(ohci->card.device,
+			   "node ID not valid, new bus reset in progress\n");
 		return;
 	}
 	if ((reg & OHCI1394_NodeID_nodeNumber) == 63) {
-		fw_notify("malconfigured bus\n");
+		dev_notice(ohci->card.device, "malconfigured bus\n");
 		return;
 	}
 	ohci->node_id = reg & (OHCI1394_NodeID_busNumber |
@@ -1841,7 +1862,7 @@ static void bus_reset_work(struct work_s
 
 	reg = reg_read(ohci, OHCI1394_SelfIDCount);
 	if (reg & OHCI1394_SelfIDCount_selfIDError) {
-		fw_notify("inconsistent self IDs\n");
+		dev_notice(ohci->card.device, "inconsistent self IDs\n");
 		return;
 	}
 	/*
@@ -1853,7 +1874,7 @@ static void bus_reset_work(struct work_s
 	self_id_count = (reg >> 3) & 0xff;
 
 	if (self_id_count > 252) {
-		fw_notify("inconsistent self IDs\n");
+		dev_notice(ohci->card.device, "inconsistent self IDs\n");
 		return;
 	}
 
@@ -1871,11 +1892,13 @@ static void bus_reset_work(struct work_s
 			 */
 			if (cond_le32_to_cpu(ohci->self_id_cpu[i])
 							== 0xffff008f) {
-				fw_notify("ignoring spurious self IDs\n");
+				dev_notice(ohci->card.device,
+					   "ignoring spurious self IDs\n");
 				self_id_count = j;
 				break;
 			} else {
-				fw_notify("inconsistent self IDs\n");
+				dev_notice(ohci->card.device,
+					   "inconsistent self IDs\n");
 				return;
 			}
 		}
@@ -1886,13 +1909,14 @@ static void bus_reset_work(struct work_s
 	if (ohci->quirks & QUIRK_TI_SLLZ059) {
 		self_id_count = find_and_insert_self_id(ohci, self_id_count);
 		if (self_id_count < 0) {
-			fw_notify("could not construct local self ID\n");
+			dev_notice(ohci->card.device,
+				   "could not construct local self ID\n");
 			return;
 		}
 	}
 
 	if (self_id_count == 0) {
-		fw_notify("inconsistent self IDs\n");
+		dev_notice(ohci->card.device, "inconsistent self IDs\n");
 		return;
 	}
 	rmb();
@@ -1913,8 +1937,8 @@ static void bus_reset_work(struct work_s
 
 	new_generation = (reg_read(ohci, OHCI1394_SelfIDCount) >> 16) & 0xff;
 	if (new_generation != generation) {
-		fw_notify("recursive bus reset detected, "
-			  "discarding self ids\n");
+		dev_notice(ohci->card.device,
+			   "new bus reset, discarding self ids\n");
 		return;
 	}
 
@@ -1985,8 +2009,7 @@ static void bus_reset_work(struct work_s
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  free_rom, free_rom_bus);
 
-	log_selfids(ohci->node_id, generation,
-		    self_id_count, ohci->self_id_buffer);
+	log_selfids(ohci, generation, self_id_count);
 
 	fw_core_handle_bus_reset(&ohci->card, ohci->node_id, generation,
 				 self_id_count, ohci->self_id_buffer,
@@ -2011,7 +2034,7 @@ static irqreturn_t irq_handler(int irq,
 	 */
 	reg_write(ohci, OHCI1394_IntEventClear,
 		  event & ~(OHCI1394_busReset | OHCI1394_postedWriteErr));
-	log_irqs(event);
+	log_irqs(ohci, event);
 
 	if (event & OHCI1394_selfIDComplete)
 		queue_work(fw_workqueue, &ohci->bus_reset_work);
@@ -2053,8 +2076,8 @@ static irqreturn_t irq_handler(int irq,
 	}
 
 	if (unlikely(event & OHCI1394_regAccessFail))
-		fw_error("Register access failure - "
-			 "please notify linux1394-devel@lists.sf.net\n");
+		dev_err(ohci->card.device,
+			"register access failure - please notify linux1394-devel@lists.sf.net\n");
 
 	if (unlikely(event & OHCI1394_postedWriteErr)) {
 		reg_read(ohci, OHCI1394_PostedWriteAddressHi);
@@ -2062,12 +2085,13 @@ static irqreturn_t irq_handler(int irq,
 		reg_write(ohci, OHCI1394_IntEventClear,
 			  OHCI1394_postedWriteErr);
 		if (printk_ratelimit())
-			fw_error("PCI posted write error\n");
+			dev_err(ohci->card.device, "PCI posted write error\n");
 	}
 
 	if (unlikely(event & OHCI1394_cycleTooLong)) {
 		if (printk_ratelimit())
-			fw_notify("isochronous cycle too long\n");
+			dev_notice(ohci->card.device,
+				   "isochronous cycle too long\n");
 		reg_write(ohci, OHCI1394_LinkControlSet,
 			  OHCI1394_LinkControl_cycleMaster);
 	}
@@ -2080,7 +2104,8 @@ static irqreturn_t irq_handler(int irq,
 		 * them at least two cycles later.  (FIXME?)
 		 */
 		if (printk_ratelimit())
-			fw_notify("isochronous cycle inconsistent\n");
+			dev_notice(ohci->card.device,
+				   "isochronous cycle inconsistent\n");
 	}
 
 	if (unlikely(event & OHCI1394_unrecoverableError))
@@ -2207,7 +2232,7 @@ static int ohci_enable(struct fw_card *c
 	int i, ret;
 
 	if (software_reset(ohci)) {
-		fw_error("Failed to reset ohci card.\n");
+		dev_err(card->device, "failed to reset ohci card\n");
 		return -EBUSY;
 	}
 
@@ -2231,7 +2256,7 @@ static int ohci_enable(struct fw_card *c
 	}
 
 	if (!lps) {
-		fw_error("Failed to set Link Power Status\n");
+		dev_err(card->device, "failed to set Link Power Status\n");
 		return -EIO;
 	}
 
@@ -2240,7 +2265,7 @@ static int ohci_enable(struct fw_card *c
 		if (ret < 0)
 			return ret;
 		if (ret)
-			fw_notify("local TSB41BA3D phy\n");
+			dev_notice(card->device, "local TSB41BA3D phy\n");
 		else
 			ohci->quirks &= ~QUIRK_TI_SLLZ059;
 	}
@@ -2340,7 +2365,8 @@ static int ohci_enable(struct fw_card *c
 	if (request_irq(dev->irq, irq_handler,
 			pci_dev_msi_enabled(dev) ? 0 : IRQF_SHARED,
 			ohci_driver_name, ohci)) {
-		fw_error("Failed to allocate interrupt %d.\n", dev->irq);
+		dev_err(card->device, "failed to allocate interrupt %d\n",
+			dev->irq);
 		pci_disable_msi(dev);
 
 		if (config_rom) {
@@ -2505,7 +2531,7 @@ static int ohci_cancel_packet(struct fw_
 		dma_unmap_single(ohci->card.device, packet->payload_bus,
 				 packet->payload_length, DMA_TO_DEVICE);
 
-	log_ar_at_event('T', packet->speed, packet->header, 0x20);
+	log_ar_at_event(ohci, 'T', packet->speed, packet->header, 0x20);
 	driver_data->packet = NULL;
 	packet->ack = RCODE_CANCELLED;
 	packet->callback(packet, &ohci->card, packet->ack);
@@ -3459,7 +3485,7 @@ static int __devinit pci_probe(struct pc
 
 	err = pci_enable_device(dev);
 	if (err) {
-		fw_error("Failed to enable OHCI hardware\n");
+		dev_err(&dev->dev, "failed to enable OHCI hardware\n");
 		goto fail_free;
 	}
 
@@ -3474,13 +3500,13 @@ static int __devinit pci_probe(struct pc
 
 	err = pci_request_region(dev, 0, ohci_driver_name);
 	if (err) {
-		fw_error("MMIO resource unavailable\n");
+		dev_err(&dev->dev, "MMIO resource unavailable\n");
 		goto fail_disable;
 	}
 
 	ohci->registers = pci_iomap(dev, 0, OHCI1394_REGISTER_SIZE);
 	if (ohci->registers == NULL) {
-		fw_error("Failed to remap registers\n");
+		dev_err(&dev->dev, "failed to remap registers\n");
 		err = -ENXIO;
 		goto fail_iomem;
 	}
@@ -3569,9 +3595,10 @@ static int __devinit pci_probe(struct pc
 		goto fail_contexts;
 
 	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
-	fw_notify("Added fw-ohci device %s, OHCI v%x.%x, "
+	dev_notice(&dev->dev,
+		  "added OHCI v%x.%x device as card %d, "
 		  "%d IR + %d IT contexts, quirks 0x%x\n",
-		  dev_name(&dev->dev), version >> 16, version & 0xff,
+		  version >> 16, version & 0xff, ohci->card.index,
 		  ohci->n_ir, ohci->n_it, ohci->quirks);
 
 	return 0;
@@ -3600,7 +3627,7 @@ static int __devinit pci_probe(struct pc
 	pmac_ohci_off(dev);
  fail:
 	if (err == -ENOMEM)
-		fw_error("Out of memory\n");
+		dev_err(&dev->dev, "out of memory\n");
 
 	return err;
 }
@@ -3644,7 +3671,7 @@ static void pci_remove(struct pci_dev *d
 	kfree(ohci);
 	pmac_ohci_off(dev);
 
-	fw_notify("Removed fw-ohci device.\n");
+	dev_notice(&dev->dev, "removed fw-ohci device\n");
 }
 
 #ifdef CONFIG_PM
@@ -3658,12 +3685,12 @@ static int pci_suspend(struct pci_dev *d
 	pci_disable_msi(dev);
 	err = pci_save_state(dev);
 	if (err) {
-		fw_error("pci_save_state failed\n");
+		dev_err(&dev->dev, "pci_save_state failed\n");
 		return err;
 	}
 	err = pci_set_power_state(dev, pci_choose_state(dev, state));
 	if (err)
-		fw_error("pci_set_power_state failed with %d\n", err);
+		dev_err(&dev->dev, "pci_set_power_state failed with %d\n", err);
 	pmac_ohci_off(dev);
 
 	return 0;
@@ -3679,7 +3706,7 @@ static int pci_resume(struct pci_dev *de
 	pci_restore_state(dev);
 	err = pci_enable_device(dev);
 	if (err) {
-		fw_error("pci_enable_device failed\n");
+		dev_err(&dev->dev, "pci_enable_device failed\n");
 		return err;
 	}
 


-- 
Stefan Richter
-=====-==-== ==-- =-=--
http://arcgraph.de/sr/
