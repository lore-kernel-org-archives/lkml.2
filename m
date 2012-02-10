Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab2BJACY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:02:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758736Ab2BJABk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 30/31] edac: Fix new error counts
Date: Thu,  9 Feb 2012 22:01:29 -0200
Message-Id: <1328832090-9166-31-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c       |    6 +-----
 drivers/edac/edac_mc_sysfs.c |    9 ++++++---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 3f74ba9..6714b36 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -249,12 +249,8 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 		count *= layers[i].size;
 		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(unsigned), count);
 		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(unsigned), count);
-		if (i < n_layers - 1)
-			tot_errcount += 2 * count;
+		tot_errcount += 2 * count;
 	}
-	/*
-	 * The last error count is equal to DIMM. So, don't export it twice
-	 */
 	erc = edac_align_ptr(&ptr, sizeof(*erc), tot_errcount);
 	ercd = edac_align_ptr(&ptr, sizeof(*ercd), tot_errcount);
 	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index f8132ff..1d4ee32 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -866,7 +866,7 @@ static ssize_t errcount_ce_show(struct mem_ctl_info *mci, char *data,
 	struct errcount_attribute_data *ead = priv;
 	int i, index = 0;
 
-	for (i = 0; i < mci->n_layers - 1; i++) {
+	for (i = 0; i < ead->n_layers - 1; i++) {
 		index += ead->pos[i];
 		index *= mci->layers[i].size;
 	}
@@ -881,7 +881,8 @@ static ssize_t errcount_ue_show(struct mem_ctl_info *mci, char *data,
 	struct errcount_attribute_data *ead = priv;
 	int i, index = 0;
 
-	for (i = 0; i < mci->n_layers - 1; i++) {
+
+	for (i = 0; i < ead->n_layers - 1; i++) {
 		index += ead->pos[i];
 		index *= mci->layers[i].size;
 	}
@@ -921,6 +922,8 @@ static int edac_create_errcount_layer(struct mem_ctl_info *mci,
 			printk(KERN_ERR "sysfs_create_file failed: %d\n", err);
 			return err;
 		}
+		(*erc)++;
+		(*ercd)++;
 
 		(*erc)->attr.name = kasprintf(GFP_KERNEL, "ue%s", location);
 		debugf4("%s() creating %s\n", __func__, (*erc)->attr.name);
@@ -972,7 +975,7 @@ static int edac_create_errcount_objects(struct mem_ctl_info *mci)
 	int err, i, count;
 
 	count = 1;
-	for (i = 0; i < mci->n_layers - 1; i++) {
+	for (i = 0; i < mci->n_layers; i++) {
 		count *= mci->layers[i].size;
 		err = edac_create_errcount_layer(mci, &erc, &ercd, i, count);
 		if (err < 0)
-- 
1.7.8

