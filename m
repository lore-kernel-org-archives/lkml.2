Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab0HCPoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:44:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51653 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab0HCPoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=npk5BPnICUD8LjLKv+DTGopva9TRj6naIhTd+W43eTftNnXZWYDRJN79YZEUEPvzyk
         HSw5oL9mOotCMhXHy6P5LapyktPDyoISKwi6fAg0PBUZTUVzjj3zqg1p9isXgU+W15Ra
         du5ubpIp0yyc9HCuzg32w+QVoMTpJ4zgbDadI=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Frans Pop <elendil@planet.nl>, Thomas Gleixner <tglx@linutronix.de>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] parisc: superio: do not use PCI resources before pci_enable_device()
Date: Tue,  3 Aug 2010 19:44:13 +0400
Message-Id: <1280850253-6128-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ and resource[] may not have correct values until
after PCI hotplug setup occurs at pci_enable_device() time.

The semantic match that finds this problem is as follows:

// <smpl>
@@
identifier x;
identifier request ~= "pci_request.*|pci_resource.*";
@@

(
* x->irq
|
* x->resource
|
* request(x, ...)
)
 ...
*pci_enable_device(x)
// </smpl>

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/parisc/superio.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index f7806d8..c8a36a2 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -169,8 +169,6 @@ superio_init(struct pci_dev *pcidev)
 	/* ...then properly fixup the USB to point at suckyio PIC */
 	sio->usb_pdev->irq = superio_fixup_irq(sio->usb_pdev);
 
-	printk(KERN_INFO PFX "Found NS87560 Legacy I/O device at %s (IRQ %i)\n",
-	       pci_name(pdev), pdev->irq);
 
 	pci_read_config_dword (pdev, SIO_SP1BAR, &sio->sp1_base);
 	sio->sp1_base &= ~1;
@@ -204,6 +202,9 @@ superio_init(struct pci_dev *pcidev)
 	ret = pci_enable_device(pdev);
 	BUG_ON(ret < 0);	/* not too much we can do about this... */
 
+	printk(KERN_INFO PFX "Found NS87560 Legacy I/O device at %s (IRQ %i)\n",
+	       pci_name(pdev), pdev->irq);
+
 	/*
 	 * Next project is programming the onboard interrupt controllers.
 	 * PDC hasn't done this for us, since it's using polled I/O.
-- 
1.7.0.4

