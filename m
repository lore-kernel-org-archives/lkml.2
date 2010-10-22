Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab0JVSi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:38:56 -0400
Received: from kroah.org ([198.145.64.141]:45790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775Ab0JVSiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:52 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:00 2010
Message-Id: <20101022183600.299945982@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [46/66] skge: add quirk to limit DMA
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 392bd0cb000d4aac9e88e4f50823db85e7220688 upstream.

Skge devices installed on some Gigabyte motherboards are not able to
perform 64 dma correctly due to board PCI implementation, so limit
DMA to 32bit if such boards are detected.

Bug was reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=447489

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Tested-by: Luya Tshimbalanga <luya@fedoraproject.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/skge.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -40,6 +40,7 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/mii.h>
+#include <linux/dmi.h>
 #include <asm/irq.h>
 
 #include "skge.h"
@@ -3890,6 +3891,8 @@ static void __devinit skge_show_addr(str
 		       dev->name, dev->dev_addr);
 }
 
+static int only_32bit_dma;
+
 static int __devinit skge_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
@@ -3911,7 +3914,7 @@ static int __devinit skge_probe(struct p
 
 	pci_set_master(pdev);
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!only_32bit_dma && !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	} else if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
@@ -4168,8 +4171,21 @@ static struct pci_driver skge_driver = {
 	.shutdown =	skge_shutdown,
 };
 
+static struct dmi_system_id skge_32bit_dma_boards[] = {
+	{
+		.ident = "Gigabyte nForce boards",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co"),
+			DMI_MATCH(DMI_BOARD_NAME, "nForce"),
+		},
+	},
+	{}
+};
+
 static int __init skge_init_module(void)
 {
+	if (dmi_check_system(skge_32bit_dma_boards))
+		only_32bit_dma = 1;
 	skge_debug_init();
 	return pci_register_driver(&skge_driver);
 }


