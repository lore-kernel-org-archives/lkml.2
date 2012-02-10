Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab2BJAC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:02:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758740Ab2BJABk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 31/31] edac: Fix per layer error count counters
Date: Thu,  9 Feb 2012 22:01:30 -0200
Message-Id: <1328832090-9166-32-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c       |   21 ++++++++++++++-------
 drivers/edac/edac_mc_sysfs.c |   25 ++++++++++++++-----------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 6714b36..1eeecf7 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -247,10 +247,13 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	count = 1;
 	for (i = 0; i < n_layers; i++) {
 		count *= layers[i].size;
-		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(unsigned), count);
-		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(unsigned), count);
+		debugf4("%s: errcount layer %d size %d\n", __func__, i, count);
+		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
+		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
 		tot_errcount += 2 * count;
 	}
+
+	debugf4("%s: allocating %d error counters\n", __func__, tot_errcount);
 	erc = edac_align_ptr(&ptr, sizeof(*erc), tot_errcount);
 	ercd = edac_align_ptr(&ptr, sizeof(*ercd), tot_errcount);
 	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
@@ -872,7 +875,9 @@ static void edac_increment_ce_error(struct mem_ctl_info *mci,
 			break;
 		index += pos[i];
 		mci->ce_per_layer[i][index]++;
-		index *= mci->layers[i].size;
+
+		if (i < mci->n_layers - 1)
+			index *= mci->layers[i + 1].size;
 	}
 }
 
@@ -894,7 +899,9 @@ static void edac_increment_ue_error(struct mem_ctl_info *mci,
 			break;
 		index += pos[i];
 		mci->ue_per_layer[i][index]++;
-		index *= mci->layers[i].size;
+
+		if (i < mci->n_layers - 1)
+			index *= mci->layers[i + 1].size;
 	}
 }
 
@@ -912,9 +919,8 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 {
 	unsigned long remapped_page;
 	/* FIXME: too much for stack: move it to some pre-alocated area */
-	char detail[80 + strlen(other_detail)];
+	char detail[80], location[80];
 	char label[(EDAC_MC_LABEL_LEN + 2) * mci->tot_dimms], *p;
-	char location[80];
 	int row = -1, chan = -1;
 	int pos[EDAC_MAX_LAYERS] = { layer0, layer1, layer2 };
 	int i;
@@ -1001,8 +1007,9 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 		 */
 		if (enable_filter) {
 			strcpy(p, dimm->label);
-			p[strlen(p)] = ' ';
 			p = p + strlen(p);
+			*p = ' ';
+			p++;
 			*p = '\0';
 
 			/*
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 1d4ee32..1c3d1ed 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -628,8 +628,8 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 	cnt = 1;
 	for (i = 0; i < mci->n_layers; i++) {
 		cnt *= mci->layers[i].size;
-		memset(mci->ce_per_layer[i], 0, cnt);
-		memset(mci->ue_per_layer[i], 0, cnt);
+		memset(mci->ce_per_layer[i], 0, cnt * sizeof(u32));
+		memset(mci->ue_per_layer[i], 0, cnt * sizeof(u32));
 	}
 
 	mci->start_time = jiffies;
@@ -866,11 +866,12 @@ static ssize_t errcount_ce_show(struct mem_ctl_info *mci, char *data,
 	struct errcount_attribute_data *ead = priv;
 	int i, index = 0;
 
-	for (i = 0; i < ead->n_layers - 1; i++) {
-		index += ead->pos[i];
-		index *= mci->layers[i].size;
+	for (i = 0; i < ead->n_layers; i++) {
+		if (i < ead->n_layers - 1)
+			index += mci->layers[i + 1].size * ead->pos[i];
+		else
+			index += ead->pos[i];
 	}
-	index += ead->pos[i];
 	return sprintf(data, "%u\n",
 		       mci->ce_per_layer[ead->n_layers - 1][index]);
 }
@@ -881,12 +882,12 @@ static ssize_t errcount_ue_show(struct mem_ctl_info *mci, char *data,
 	struct errcount_attribute_data *ead = priv;
 	int i, index = 0;
 
-
-	for (i = 0; i < ead->n_layers - 1; i++) {
-		index += ead->pos[i];
-		index *= mci->layers[i].size;
+	for (i = 0; i < ead->n_layers; i++) {
+		if (i < ead->n_layers - 1)
+			index += mci->layers[i + 1].size * ead->pos[i];
+		else
+			index += ead->pos[i];
 	}
-	index += ead->pos[i];
 	return sprintf(data, "%u\n",
 		       mci->ue_per_layer[ead->n_layers - 1][index]);
 }
@@ -949,6 +950,7 @@ static int edac_create_errcount_layer(struct mem_ctl_info *mci,
 		(*erc)++;
 		(*ercd)++;
 	}
+
 	return 0;
 }
 
@@ -981,6 +983,7 @@ static int edac_create_errcount_objects(struct mem_ctl_info *mci)
 		if (err < 0)
 			goto err;
 	}
+	debugf4("%s: created %d objects\n", __func__, (unsigned)(erc - mci->errcount_attr));
 	return 0;
 err:
 	edac_remove_errcount(mci);
-- 
1.7.8

