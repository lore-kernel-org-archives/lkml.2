Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0KLLOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:14:38 -0500
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:43382 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab0KLLOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:14:36 -0500
Subject: [PATCH 05/17] staging/vme/tsi148: use list_for_each_safe when
	deleting resources in .remove
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:14:34 +0000
Message-ID: <20101112111434.11631.66336.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

This fixes an oops when removing the module.

Signed-off-by: Emilio G. Cota <cota@braap.org>
Acked-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/bridges/vme_tsi148.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 1cba1fa..5c25cd8 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2531,6 +2531,7 @@ err_struct:
 static void tsi148_remove(struct pci_dev *pdev)
 {
 	struct list_head *pos = NULL;
+	struct list_head *tmplist;
 	struct vme_master_resource *master_image;
 	struct vme_slave_resource *slave_image;
 	struct vme_dma_resource *dma_ctrlr;
@@ -2589,21 +2590,21 @@ static void tsi148_remove(struct pci_dev *pdev)
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
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
