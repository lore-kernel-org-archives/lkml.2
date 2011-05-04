Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1EDLpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:45:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38462 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab1EDLpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:45:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 4 May 2011 13:45:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire regression fix
Message-ID: <20110504134520.0a0aa35e@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the fixes branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git fixes

to receive the following update for the IEEE 1394 (FireWire) subsystem.
Thanks.

B.J. Buchalter (1):
      firewire: Fix for broken configrom updates in quick succession

 drivers/firewire/ohci.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)


commit 2e053a27d9d5ad5e0831e002cbf8043836fb2060
Author: B.J. Buchalter <bj@mhlabs.com>
Date:   Mon May 2 13:33:42 2011 -0400

    firewire: Fix for broken configrom updates in quick succession
    
    Current implementation of ohci_set_config_rom() uses a deferred
    bus reset via fw_schedule_bus_reset(). If clients add multiple
    unit descriptors to the config_rom in quick succession, the
    deferred bus reset may not have fired before succeeding update
    requests have come in. This can lead to an incorrect partial
    update of the config_rom for both addition and removal of
    config_rom descriptors, as the ohci_set_config_rom() routine
    will return -EBUSY if a previous pending update has not been
    completed yet; the requested update just gets dropped on the floor.
    
    This patch recognizes that the "in-flight" update can be modified
    until it has been processed by the bus-reset, and the locking
    in the bus_reset_tasklet ensures that the update is done atomically
    with respect to modifications made by ohci_set_config_rom(). The
    -EBUSY error case is simply removed.
    
    [Stefan R:  The bug always existed at least theoretically.  But it
    became easy to trigger since 2.6.36 commit 02d37bed188c "firewire: core:
    integrate software-forced bus resets with bus management" which
    introduced long mandatory delays between janitorial bus resets.]
    
    Signed-off-by: Benjamin Buchalter <bj@mhlabs.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (trivial style changes)
    Cc: <stable@kernel.org> # 2.6.36.y and newer

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index f903d7b6..23d1468 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2199,7 +2199,6 @@ static int ohci_set_config_rom(struct fw_card *card,
 {
 	struct fw_ohci *ohci;
 	unsigned long flags;
-	int ret = -EBUSY;
 	__be32 *next_config_rom;
 	dma_addr_t uninitialized_var(next_config_rom_bus);
 
@@ -2240,22 +2239,37 @@ static int ohci_set_config_rom(struct fw_card *card,
 
 	spin_lock_irqsave(&ohci->lock, flags);
 
+	/*
+	 * If there is not an already pending config_rom update,
+	 * push our new allocation into the ohci->next_config_rom
+	 * and then mark the local variable as null so that we
+	 * won't deallocate the new buffer.
+	 *
+	 * OTOH, if there is a pending config_rom update, just
+	 * use that buffer with the new config_rom data, and
+	 * let this routine free the unused DMA allocation.
+	 */
+
 	if (ohci->next_config_rom == NULL) {
 		ohci->next_config_rom = next_config_rom;
 		ohci->next_config_rom_bus = next_config_rom_bus;
+		next_config_rom = NULL;
+	}
 
-		copy_config_rom(ohci->next_config_rom, config_rom, length);
+	copy_config_rom(ohci->next_config_rom, config_rom, length);
 
-		ohci->next_header = config_rom[0];
-		ohci->next_config_rom[0] = 0;
+	ohci->next_header = config_rom[0];
+	ohci->next_config_rom[0] = 0;
 
-		reg_write(ohci, OHCI1394_ConfigROMmap,
-			  ohci->next_config_rom_bus);
-		ret = 0;
-	}
+	reg_write(ohci, OHCI1394_ConfigROMmap, ohci->next_config_rom_bus);
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
+	/* If we didn't use the DMA allocation, delete it. */
+	if (next_config_rom != NULL)
+		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+				  next_config_rom, next_config_rom_bus);
+
 	/*
 	 * Now initiate a bus reset to have the changes take
 	 * effect. We clean up the old config rom memory and DMA
@@ -2263,13 +2277,10 @@ static int ohci_set_config_rom(struct fw_card *card,
 	 * controller could need to access it before the bus reset
 	 * takes effect.
 	 */
-	if (ret == 0)
-		fw_schedule_bus_reset(&ohci->card, true, true);
-	else
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  next_config_rom, next_config_rom_bus);
 
-	return ret;
+	fw_schedule_bus_reset(&ohci->card, true, true);
+
+	return 0;
 }
 
 static void ohci_send_request(struct fw_card *card, struct fw_packet *packet)

-- 
Stefan Richter
-=====-==-== -=-= --=--
http://arcgraph.de/sr/
