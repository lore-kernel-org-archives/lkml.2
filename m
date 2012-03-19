Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161967Ab2CSFtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:49:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31285 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161945Ab2CSFtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:49:39 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 07/26] PCI: Use for_each_res with IOV releated funcs
Date: Sun, 18 Mar 2012 22:48:30 -0700
Message-Id: <1332136129-14010-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
References: <1332136129-14010-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F66C8F1.000F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/iov.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 6554e1a..f015764 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -99,17 +99,20 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	pci_setup_device(virtfn);
 	virtfn->dev.parent = dev->dev.parent;
 
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_dev_iov_resource(dev, res, i) {
+		struct resource *virtfn_res;
+
 		if (!res->parent)
 			continue;
-		virtfn->resource[i].name = pci_name(virtfn);
-		virtfn->resource[i].flags = res->flags;
+
+		virtfn_res = pci_dev_resource_n(virtfn, i - PCI_IOV_RESOURCES);
+		virtfn_res->name = pci_name(virtfn);
+		virtfn_res->flags = res->flags;
 		size = resource_size(res);
 		do_div(size, iov->total);
-		virtfn->resource[i].start = res->start + size * id;
-		virtfn->resource[i].end = virtfn->resource[i].start + size - 1;
-		rc = request_resource(res, &virtfn->resource[i]);
+		virtfn_res->start = res->start + size * id;
+		virtfn_res->end = virtfn_res->start + size - 1;
+		rc = request_resource(res, virtfn_res);
 		BUG_ON(rc);
 	}
 
@@ -313,9 +316,8 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 		return -EIO;
 
 	nres = 0;
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		bars |= (1 << (i + PCI_IOV_RESOURCES));
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_dev_iov_resource(dev, res, i) {
+		bars |= 1 << i;
 		if (res->parent)
 			nres++;
 	}
@@ -473,10 +475,9 @@ found:
 	pci_write_config_dword(dev, pos + PCI_SRIOV_SYS_PGSIZE, pgsz);
 
 	nres = 0;
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_dev_iov_resource(dev, res, i) {
 		i += __pci_read_base(dev, pci_bar_unknown, res,
-				     pos + PCI_SRIOV_BAR + i * 4);
+			     pos + PCI_SRIOV_BAR + (i - PCI_IOV_RESOURCES) * 4);
 		if (!res->flags)
 			continue;
 		if (resource_size(res) & (PAGE_SIZE - 1)) {
@@ -519,10 +520,8 @@ found:
 	return 0;
 
 failed:
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_dev_iov_resource(dev, res, i)
 		res->flags = 0;
-	}
 
 	return rc;
 }
-- 
1.7.7

