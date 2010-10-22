Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496Ab0JVTFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:05:52 -0400
Received: from kroah.org ([198.145.64.141]:34328 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759392Ab0JVS4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:53 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:34 2010
Message-Id: <20101022185234.003489960@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [074/103] skge: add quirk to limit DMA
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/mii.h>
 #include <linux/slab.h>
+#include <linux/dmi.h>
 #include <asm/irq.h>
 
 #include "skge.h"
@@ -3868,6 +3869,8 @@ static void __devinit skge_show_addr(str
 	netif_info(skge, probe, skge->netdev, "addr %pM\n", dev->dev_addr);
 }
 
+static int only_32bit_dma;
+
 static int __devinit skge_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
@@ -3889,7 +3892,7 @@ static int __devinit skge_probe(struct p
 
 	pci_set_master(pdev);
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!only_32bit_dma && !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	} else if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
@@ -4147,8 +4150,21 @@ static struct pci_driver skge_driver = {
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


