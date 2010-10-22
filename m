Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0JVScA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:32:00 -0400
Received: from kroah.org ([198.145.64.141]:37764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758725Ab0JVSZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kulikov Vasiliy <segooon@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/31] uio: do not use PCI resources before pci_enable_device()
Date: Fri, 22 Oct 2010 11:24:50 -0700
Message-Id: <1287771916-15016-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>

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
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.2

