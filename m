Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab2CGMNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:13:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683Ab2CGMLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] edac: Call the sysfs nodes as "rank" instead of "dimm" if chip select is used
Date: Wed,  7 Mar 2012 09:11:17 -0300
Message-Id: <1331122278-28458-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
References: <1331122278-28458-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The minimum hierarchy unit for csrows-based MC's is rank, and not dimm.

There are a few possible fixes here:

1) add a per-rank location at the dimm struct, and don't create one
   dimm_info entry per rank;

2) Convert the drivers to internally convert ranks into dimm's;

3) rename "dimm" with "rank";

A few drivers do (2) internally: some of them have per-dimm registers,
instead of per-rank ones; a few others have some routines to translate
between the two representations of the memory. Those drivers report the
memories via a DIMM slot and a channel.

While no better solution is done, let's do (2) for the drivers that work
with csrows/channel layers to represent a rank.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc_sysfs.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 5b48528..dd934c2 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -567,10 +567,12 @@ static struct kobj_type ktype_dimm = {
 };
 /* Create a CSROW object under specifed edac_mc_device */
 static int edac_create_dimm_object(struct mem_ctl_info *mci,
-					struct dimm_info *dimm, int index)
+					struct dimm_info *dimm, int index,
+					bool is_rank)
 {
 	struct kobject *kobj_mci = &mci->edac_mci_kobj;
 	struct kobject *kobj;
+	const char *nodename;
 	int err;
 
 	/* generate ..../edac/mc/mc<id>/dimm<index>   */
@@ -585,8 +587,12 @@ static int edac_create_dimm_object(struct mem_ctl_info *mci,
 	}
 
 	/* Instanstiate the dimm object */
+	if (!is_rank)
+		nodename = "dimm%d";
+	else
+		nodename = "rank%d";
 	err = kobject_init_and_add(&dimm->kobj, &ktype_dimm, kobj_mci,
-				   "dimm%d", index);
+				nodename, index);
 	if (err)
 		goto err_release_top_kobj;
 
@@ -1338,6 +1344,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	int err;
 	struct csrow_info *csrow;
 	struct kobject *kobj_mci = &mci->edac_mci_kobj;
+	bool is_rank = false;
 
 	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
 
@@ -1386,6 +1393,13 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 		}
 	}
 
+	for (i = 0; i < mci->n_layers; i++) {
+		if (mci->layers[i].type == EDAC_MC_LAYER_CHIP_SELECT) {
+			is_rank = true;
+			break;
+		}
+	}
+
 	/*
 	 * Make directories for each DIMM object under the mc<id> kobject
 	 */
@@ -1406,7 +1420,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 			printk(KERN_CONT "\n");
 		}
 #endif
-		err = edac_create_dimm_object(mci, dimm, j);
+		err = edac_create_dimm_object(mci, dimm, j, is_rank);
 		if (err) {
 			debugf1("%s() failure: create dimm %d obj\n",
 				__func__, j);
-- 
1.7.8

