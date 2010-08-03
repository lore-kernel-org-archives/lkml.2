Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab0HCPo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:44:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51653 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab0HCPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Pc2hbQqLY9n1wRD+HsUsxhr2Mm1wcm7EGRuwPhQ3eK8dgdlEn3+YKxi5JW4TZT1KVK
         qYxZpRcQFKI664cXjp+PhIpPkjJysMQZ5vj2s+pQM5e3egB20bYmjy5un7DFgDkK03UA
         o9Cej2iiJl+IDRnxLTo2RNHKv1ocLKwASqxTo=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?Charles=20Cl=C3=A9ment?= <caratorn@gmail.com>,
        Jim Lieb <lieb@canonical.com>, "David S. Miller" <davem@davemloft.net>,
        Alexander Beregalov <a.beregalov@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] staging: vt6655: do not use PCI resources before pci_enable_device()
Date: Tue,  3 Aug 2010 19:44:20 +0400
Message-Id: <1280850260-6209-1-git-send-email-segooon@gmail.com>
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
 drivers/staging/vt6655/device_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index d498442..67c7b97 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -955,12 +955,13 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
     pDevice->dev = dev;
     pDevice->next_module = root_device_dev;
     root_device_dev = dev;
-    dev->irq = pcid->irq;
 
     if (pci_enable_device(pcid)) {
         device_free_info(pDevice);
         return -ENODEV;
     }
+    dev->irq = pcid->irq;
+
 #ifdef	DEBUG
 	printk("Before get pci_info memaddr is %x\n",pDevice->memaddr);
 #endif
-- 
1.7.0.4

