Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0JZBMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:12:03 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:38622 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0JZBL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:11:56 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 06/30] staging/vme/tsi148: use list_for_each_safe when deleting resources in .remove
Date: Mon, 25 Oct 2010 21:10:52 -0400
Message-Id: <1288055476-19438-7-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

This fixes an oops when removing the module.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/bridges/vme_tsi148.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index e341122..660968e 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2532,6 +2532,7 @@ err_struct:
 static void tsi148_remove(struct pci_dev *pdev)
 {
 	struct list_head *pos = NULL;
+	struct list_head *tmplist;
 	struct vme_master_resource *master_image;
 	struct vme_slave_resource *slave_image;
 	struct vme_dma_resource *dma_ctrlr;
@@ -2590,21 +2591,21 @@ static void tsi148_remove(struct pci_dev *pdev)
 	tsi148_crcsr_exit(tsi148_bridge, pdev);
 
 	/* resources are stored in link list */
-	list_for_each(pos, &tsi148_bridge->dma_resources) {
+	list_for_each_safe(pos, tmplist, &tsi148_bridge->dma_resources) {
 		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
 		list_del(pos);
 		kfree(dma_ctrlr);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &tsi148_bridge->slave_resources) {
+	list_for_each_safe(pos, tmplist, &tsi148_bridge->slave_resources) {
 		slave_image = list_entry(pos, struct vme_slave_resource, list);
 		list_del(pos);
 		kfree(slave_image);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &tsi148_bridge->master_resources) {
+	list_for_each_safe(pos, tmplist, &tsi148_bridge->master_resources) {
 		master_image = list_entry(pos, struct vme_master_resource,
 			list);
 		list_del(pos);
-- 
1.7.1

