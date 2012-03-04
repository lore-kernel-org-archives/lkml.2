Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2CDUeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 15:34:50 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47172 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab2CDUei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 15:34:38 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Mar 2012 21:34:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]
Message-ID: <20120304213421.20560675@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_FIREWIRE_OHCI_DEBUG could have been exposed to kernel tweakers
if CONFIG_EXPERT was set.  But in hindsight, this stuff is far too
useful to omit it.  So get rid of two #else branches that are only
going to bitrot otherwise.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig |    5 -----
 drivers/firewire/ohci.c  |   20 +-------------------
 2 files changed, 1 insertion(+), 24 deletions(-)

--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -28,11 +28,6 @@ config FIREWIRE_OHCI
 	  To compile this driver as a module, say M here:  The module will be
 	  called firewire-ohci.
 
-config FIREWIRE_OHCI_DEBUG
-	bool
-	depends on FIREWIRE_OHCI
-	default y
-
 config FIREWIRE_SBP2
 	tristate "Storage devices (SBP-2 protocol)"
 	depends on FIREWIRE && SCSI
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -338,8 +338,6 @@ MODULE_PARM_DESC(quirks, "Chip quirks (d
 #define OHCI_PARAM_DEBUG_IRQS		4
 #define OHCI_PARAM_DEBUG_BUSRESETS	8 /* only effective before chip init */
 
-#ifdef CONFIG_FIREWIRE_OHCI_DEBUG
-
 static int param_debug;
 module_param_named(debug, param_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
@@ -520,15 +518,6 @@ static void log_ar_at_event(struct fw_oh
 	}
 }
 
-#else
-
-#define param_debug 0
-static inline void log_irqs(struct fw_ohci *ohci, u32 evt) {}
-static inline void log_selfids(struct fw_ohci *ohci, int generation, int self_id_count) {}
-static inline void log_ar_at_event(struct fw_ohci *ohci, char dir, int speed, u32 *header, int evt) {}
-
-#endif /* CONFIG_FIREWIRE_OHCI_DEBUG */
-
 static inline void reg_write(const struct fw_ohci *ohci, int offset, u32 data)
 {
 	writel(data, ohci->registers + offset);
@@ -1640,17 +1629,10 @@ static void detect_dead_context(struct f
 	u32 ctl;
 
 	ctl = reg_read(ohci, CONTROL_SET(regs));
-	if (ctl & CONTEXT_DEAD) {
-#ifdef CONFIG_FIREWIRE_OHCI_DEBUG
+	if (ctl & CONTEXT_DEAD)
 		dev_err(ohci->card.device,
 			"DMA context %s has stopped, error code: %s\n",
 			name, evts[ctl & 0x1f]);
-#else
-		dev_err(ohci->card.device,
-			"DMA context %s has stopped, error code: %#x\n",
-			name, ctl & 0x1f);
-#endif
-	}
 }
 
 static void handle_dead_contexts(struct fw_ohci *ohci)


-- 
Stefan Richter
-=====-===-- --== --=--
http://arcgraph.de/sr/
