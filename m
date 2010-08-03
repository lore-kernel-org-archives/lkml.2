Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0HCPpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:45:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37607 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab0HCPoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cm5kyBEdHRZ/05fT3YVMpVe25HEtMtMP/osNetZt1b45Zcl60fm8pUkVG+MkCDirjI
         yhE4HKLahW9limiPh+v4KXLZ7K+EB/eGvLz1A6ZgJW9aiF4Rl7Kfg47bjy+vP60JZ7iQ
         6WQKxUCb3Wz9V4cO5XyrGkEafVnmi45r528uQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jiri Slaby <jslaby@suse.cz>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] x86: intel_ips: do not use PCI resources before pci_enable_device()
Date: Tue,  3 Aug 2010 19:44:16 +0400
Message-Id: <1280850257-6169-1-git-send-email-segooon@gmail.com>
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
 drivers/platform/x86/intel_ips.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 0344822..90c9549 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -1432,6 +1432,12 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	spin_lock_init(&ips->turbo_status_lock);
 
+	ret = pci_enable_device(dev);
+	if (ret) {
+		dev_err(&dev->dev, "can't enable PCI device, aborting\n");
+		goto error_free;
+	}
+
 	if (!pci_resource_start(dev, 0)) {
 		dev_err(&dev->dev, "TBAR not assigned, aborting\n");
 		ret = -ENXIO;
@@ -1444,11 +1450,6 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto error_free;
 	}
 
-	ret = pci_enable_device(dev);
-	if (ret) {
-		dev_err(&dev->dev, "can't enable PCI device, aborting\n");
-		goto error_free;
-	}
 
 	ips->regmap = ioremap(pci_resource_start(dev, 0),
 			      pci_resource_len(dev, 0));
-- 
1.7.0.4

