Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab0GAU4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:56:54 -0400
Received: from kroah.org ([198.145.64.141]:48021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932748Ab0GAUvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:42 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:40 2010
Message-Id: <20100701173440.545022839@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Giridhar Malavali <giridhar.malavali@qlogic.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [patch 163/164] [SCSI] qla2xxx: Disable MSI on qla24xx chips other than QLA2432.
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 6377a7ae1ab82859edccdbc8eaea63782efb134d upstream.

On specific platforms, MSI is unreliable on some of the QLA24xx chips, resulting
in fatal I/O errors under load, as reported in <http://bugs.debian.org/572322>
and by some RHEL customers.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_isr.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2169,30 +2169,28 @@ qla2x00_request_irqs(struct qla_hw_data
 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
-	    !IS_QLA8432(ha) && !IS_QLA8001(ha))
-		goto skip_msix;
+		!IS_QLA8432(ha) && !IS_QLA8001(ha))
+		goto skip_msi;
+
+	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
+		(ha->pdev->subsystem_device == 0x7040 ||
+		ha->pdev->subsystem_device == 0x7041 ||
+		ha->pdev->subsystem_device == 0x1705)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+			"MSI-X: Unsupported ISP2432 SSVID/SSDID (0x%X,0x%X).\n",
+			ha->pdev->subsystem_vendor,
+			ha->pdev->subsystem_device));
+		goto skip_msi;
+	}
 
 	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
 		!QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
 		DEBUG2(qla_printk(KERN_WARNING, ha,
 		"MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
 			ha->pdev->revision, ha->fw_attributes));
-
 		goto skip_msix;
 	}
 
-	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
-	    (ha->pdev->subsystem_device == 0x7040 ||
-		ha->pdev->subsystem_device == 0x7041 ||
-		ha->pdev->subsystem_device == 0x1705)) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "MSI-X: Unsupported ISP2432 SSVID/SSDID (0x%X, 0x%X).\n",
-		    ha->pdev->subsystem_vendor,
-		    ha->pdev->subsystem_device));
-
-		goto skip_msi;
-	}
-
 	ret = qla24xx_enable_msix(ha, rsp);
 	if (!ret) {
 		DEBUG2(qla_printk(KERN_INFO, ha,


