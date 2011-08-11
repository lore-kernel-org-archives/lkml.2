Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1HKSk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:40:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34402 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1HKSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:40:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 11 Aug 2011 20:40:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: ohci: fix DMA unmapping in an error path
Message-ID: <20110811204042.35ec6f32@stein>
In-Reply-To: <20110811085159.42522d39@stein>
References: <20110810164515.78a8f06d@stein>
	<20110811085159.42522d39@stein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If request_irq failed, we would pass wrong arguments to
dma_free_coherent.  https://bugzilla.redhat.com/show_bug.cgi?id=728185

Reported-by: Mads Kiilerich
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2181,8 +2181,13 @@ static int ohci_enable(struct fw_card *c
 			ohci_driver_name, ohci)) {
 		fw_error("Failed to allocate interrupt %d.\n", dev->irq);
 		pci_disable_msi(dev);
-		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
-				  ohci->config_rom, ohci->config_rom_bus);
+
+		if (config_rom) {
+			dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+					  ohci->next_config_rom,
+					  ohci->next_config_rom_bus);
+			ohci->next_config_rom = NULL;
+		}
 		return -EIO;
 	}
 


-- 
Stefan Richter
-=====-==-== =--- -=-==
http://arcgraph.de/sr/
