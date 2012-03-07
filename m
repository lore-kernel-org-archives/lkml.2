Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab2CGMLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:11:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668Ab2CGMLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] edac_mc_sysfs: don't create inactive errcount sysfs nodes
Date: Wed,  7 Mar 2012 09:11:14 -0300
Message-Id: <1331122278-28458-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
References: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make any sense to create an error count node for
something that is not active. So, disable the error counters
where all DIMMs below it, on the hierarchy aren't filled.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |  110 +++++++++++++++++++++++++++--------------
 1 files changed, 72 insertions(+), 38 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index f538f9e..116934c 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -892,6 +892,28 @@ static ssize_t errcount_ue_show(struct mem_ctl_info *mci, char *data,
 		       mci->ue_per_layer[ead->n_layers - 1][index]);
 }
 
+static bool is_dimms_filled(struct mem_ctl_info *mci, int n_layers,
+			  int pos[EDAC_MAX_LAYERS])
+{
+	static struct dimm_info *dimm;
+	int i, count = 1;
+
+	dimm = GET_POS(mci->layers, mci->dimms, mci->n_layers,
+		       pos[0], pos[1], pos[2]);
+	for (i = n_layers + 1; i < mci->n_layers; i++)
+		count *= mci->layers[i].size;
+
+	debugf2("%s: layers: %d, pos: %d:%d:%d, count = %d\n",
+		__func__, n_layers, pos[0], pos[1], pos[2], count);
+	for (i = 0; i < count; i++) {
+		if (dimm->nr_pages)
+			return true;
+		dimm++;
+	}
+
+	return false;
+}
+
 static int edac_create_errcount_layer(struct mem_ctl_info *mci,
 				      struct mcidev_sysfs_attribute **erc,
 				      struct errcount_attribute_data **ercd,
@@ -903,52 +925,64 @@ static int edac_create_errcount_layer(struct mem_ctl_info *mci,
 
 	memset(&pos, 0, sizeof(pos));
 	for (i = 0; i < count; i++) {
-		p = location;
-		for (j = 0; j <= layer; j++)
-			p += sprintf(p, "_%s%d",
-				     edac_layer_name[mci->layers[j].type],
-				     pos[j]);
-
-		(*erc)->attr.name = kasprintf(GFP_KERNEL, "ce%s", location);
-		debugf4("%s() creating %s\n", __func__, (*erc)->attr.name);
-		if (!(*erc)->attr.name)
-			return -ENOMEM;
-		(*erc)->attr.mode = S_IRUGO | S_IWUSR;
-		(*erc)->show = errcount_ce_show;
-		(*erc)->priv = *ercd;
-		(*ercd)->n_layers = layer + 1;
-		memcpy((*ercd)->pos, pos, sizeof(pos));
-		err = sysfs_create_file(&mci->edac_mci_kobj, &(*erc)->attr);
-		if (err < 0) {
-			printk(KERN_ERR "sysfs_create_file failed: %d\n", err);
-			return err;
-		}
-		(*erc)++;
-		(*ercd)++;
-
-		(*erc)->attr.name = kasprintf(GFP_KERNEL, "ue%s", location);
-		debugf4("%s() creating %s\n", __func__, (*erc)->attr.name);
-		if (!(*erc)->attr.name)
-			return -ENOMEM;
-		(*erc)->attr.mode = S_IRUGO | S_IWUSR;
-		(*erc)->show = errcount_ue_show;
-		(*erc)->priv = *ercd;
-		(*ercd)->n_layers = layer + 1;
-		memcpy((*ercd)->pos, pos, sizeof(pos));
-		err = sysfs_create_file(&mci->edac_mci_kobj, &(*erc)->attr);
-		if (err < 0) {
-			printk(KERN_ERR "sysfs_create_file failed: %d\n", err);
-			return err;
+		/* Only show the nodes if is there any filled DIMM */
+		if (is_dimms_filled(mci, layer, pos)) {
+			p = location;
+			for (j = 0; j <= layer; j++)
+				p += sprintf(p, "_%s%d",
+					edac_layer_name[mci->layers[j].type],
+					pos[j]);
+
+			(*erc)->attr.name = kasprintf(GFP_KERNEL, "ce%s",
+						      location);
+			debugf2("%s() creating %s\n", __func__,
+				(*erc)->attr.name);
+			if (!(*erc)->attr.name)
+				return -ENOMEM;
+			(*erc)->attr.mode = S_IRUGO | S_IWUSR;
+			(*erc)->show = errcount_ce_show;
+			(*erc)->priv = *ercd;
+			(*ercd)->n_layers = layer + 1;
+			memcpy((*ercd)->pos, pos, sizeof(pos));
+			err = sysfs_create_file(&mci->edac_mci_kobj,
+						&(*erc)->attr);
+			if (err < 0) {
+				printk(KERN_ERR
+				       "sysfs_create_file failed: %d\n", err);
+				return err;
+			}
+			(*erc)++;
+			(*ercd)++;
+
+			(*erc)->attr.name = kasprintf(GFP_KERNEL, "ue%s",
+						      location);
+			debugf2("%s() creating %s\n", __func__,
+				(*erc)->attr.name);
+			if (!(*erc)->attr.name)
+				return -ENOMEM;
+			(*erc)->attr.mode = S_IRUGO | S_IWUSR;
+			(*erc)->show = errcount_ue_show;
+			(*erc)->priv = *ercd;
+			(*ercd)->n_layers = layer + 1;
+			memcpy((*ercd)->pos, pos, sizeof(pos));
+			err = sysfs_create_file(&mci->edac_mci_kobj,
+						&(*erc)->attr);
+			if (err < 0) {
+				printk(KERN_ERR
+				       "sysfs_create_file failed: %d\n", err);
+				return err;
+			}
+			(*erc)++;
+			(*ercd)++;
 		}
 
+		/* increment to the next position */
 		for (j = layer; j >= 0; j--) {
 			pos[j]++;
 			if (pos[j] < mci->layers[j].size)
 				break;
 			pos[j] = 0;
 		}
-		(*erc)++;
-		(*ercd)++;
 	}
 
 	return 0;
-- 
1.7.8

