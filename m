Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab0HCPoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:44:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51653 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277Ab0HCPo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kHetH8CM5HwH65rGISewDuJmnxsQsMrWoV6Z6B7rJeAh3kXPevnJf6AhR8mU/i9xQi
         Xvkt4HORrFgewZLCi441f9A8ET9QtzQSX/b6YnSKqBXEiwRX9/eOIjL09j3o0Sua4Fhh
         nGC4ZOUtA6eQA6U4Rfi/CEu6wHvGqUbiytlj8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] uio: do not use PCI resources before pci_enable_device()
Date: Tue,  3 Aug 2010 19:44:23 +0400
Message-Id: <1280850264-6258-1-git-send-email-segooon@gmail.com>
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
 drivers/uio/uio_pci_generic.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index 85c9884..fc22e1e 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -128,12 +128,6 @@ static int __devinit probe(struct pci_dev *pdev,
 	struct uio_pci_generic_dev *gdev;
 	int err;
 
-	if (!pdev->irq) {
-		dev_warn(&pdev->dev, "No IRQ assigned to device: "
-			 "no support for interrupts?\n");
-		return -ENODEV;
-	}
-
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "%s: pci_enable_device failed: %d\n",
@@ -141,6 +135,13 @@ static int __devinit probe(struct pci_dev *pdev,
 		return err;
 	}
 
+	if (!pdev->irq) {
+		dev_warn(&pdev->dev, "No IRQ assigned to device: "
+			 "no support for interrupts?\n");
+		pci_disable_device(pdev);
+		return -ENODEV;
+	}
+
 	err = verify_pci_2_3(pdev);
 	if (err)
 		goto err_verify;
-- 
1.7.0.4

