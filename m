Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1BPWTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:19:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20853 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab1BPWS5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Feb 2011 17:18:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] xen-pcifront: Sanity check the MSI/MSI-X values
Date: Wed, 16 Feb 2011 17:17:17 -0500
Message-Id: <1297894638-28007-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D5C4D48.0011:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the returned vector values for any values that are
odd or plain incorrect (say vector value zero), and if so
print a warning. Also fixup the return values.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/xen-pcifront.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 3a5a6fc..6acf6ae 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -277,13 +277,20 @@ static int pci_frontend_enable_msix(struct pci_dev *dev,
 	if (likely(!err)) {
 		if (likely(!op.value)) {
 			/* we get the result */
-			for (i = 0; i < nvec; i++)
+			for (i = 0; i < nvec; i++) {
+				if (op.msix_entries[i].vector <= 0) {
+					dev_warn(&dev->dev, "MSI-X entry %d" \
+						" is zero!\n", i);
+					err = -EINVAL;
+					continue;
+				}
 				*(*vector+i) = op.msix_entries[i].vector;
-			return 0;
+			}
+			return err;
 		} else {
 			printk(KERN_DEBUG "enable msix get value %x\n",
 				op.value);
-			return op.value;
+			return err;
 		}
 	} else {
 		dev_err(&dev->dev, "enable msix get err %x\n", err);
@@ -325,6 +332,10 @@ static int pci_frontend_enable_msi(struct pci_dev *dev, int **vector)
 	err = do_pci_op(pdev, &op);
 	if (likely(!err)) {
 		*(*vector) = op.value;
+		if (op.value <= 0) {
+			dev_warn(&dev->dev, "MSI entry is zero!\n");
+			err = -EINVAL;
+		}
 	} else {
 		dev_err(&dev->dev, "pci frontend enable msi failed for dev "
 				    "%x:%x\n", op.bus, op.devfn);
-- 
1.7.1

