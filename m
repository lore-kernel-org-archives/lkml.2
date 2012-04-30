Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2D3PCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 11:02:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2D3PCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 11:02:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Joe Perches <joe@perches.com>
Subject: [PATCH v2] edac_mc: Cleanup per-dimm_info debug messages
Date: Mon, 30 Apr 2012 12:02:40 -0300
Message-Id: <1335798160-9879-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <4F9E9958.6010606@redhat.com>
References: <4F9E9958.6010606@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edac_mc_alloc() routine allocates one dimm_info device for all
possible memories, including the non-filled ones. The debug messages
there are somewhat confusing. So, cleans them, by moving the code
that prints the memory location to edac_mc, and using it on both
edac_mc_sysfs and edac_mc.

After this patch, a dimm-based memory controller will print the debug
info as:

[  728.430828] EDAC DEBUG: edac_mc_dump_dimm: 	dimm2: channel 0 slot 2 mapped as virtual row 0, chan 2
[  728.430834] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->label = 'mc#0channel#0slot#2'
[  728.430839] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->nr_pages = 0x0
[  728.430846] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->grain = 0
[  728.430850] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->nr_pages = 0x0

(a rank-based memory controller would print, instead, "rank2"
 on the above debug info)

Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

v2: rebase this patch to apply after:
    http://git.infradead.org/users/mchehab/edac.git/commitdiff/a93f4f2a667afa1ff2f983b12d2062d7259c6c44
    As Joe's patches renamed debugf[0-4] to edac_dbg([0-4], and both patches
    would conflict otherwise.

 drivers/edac/edac_mc.c       |   44 ++++++++++++++++++++++++++---------------
 drivers/edac/edac_mc_sysfs.c |   11 +---------
 drivers/edac/edac_module.h   |    3 ++
 3 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index f48011f..ecb23e5 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -40,6 +40,25 @@
 static DEFINE_MUTEX(mem_ctls_mutex);
 static LIST_HEAD(mc_devices);
 
+unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
+			         int len)
+{
+	struct mem_ctl_info *mci = dimm->mci;
+	int i, n, count = 0;
+	char *p = buf;
+
+	for (i = 0; i < mci->n_layers; i++) {
+		n = snprintf(p, len, "%s %d ",
+			      edac_layer_name[mci->layers[i].type],
+			      dimm->location[i]);
+		p += n;
+		len -= n;
+		count += n;
+	}
+
+	return count;
+}
+
 #ifdef CONFIG_EDAC_DEBUG
 
 static void edac_mc_dump_channel(struct rank_info *chan)
@@ -50,20 +69,19 @@ static void edac_mc_dump_channel(struct rank_info *chan)
 	edac_dbg(4, "\tchannel->dimm = %p\n", chan->dimm);
 }
 
-static void edac_mc_dump_dimm(struct dimm_info *dimm)
+static void edac_mc_dump_dimm(struct dimm_info *dimm, int number)
 {
-	int i;
+	char location[80];
+
+	edac_dimm_info_location(dimm, location, sizeof(location));
 
 	edac_dbg(4, "\tdimm = %p\n", dimm);
+	edac_dbg(4, "\tdimm = %p\n", dimm);
+	edac_dbg(4, "\t%s%i: %smapped as virtual row %d, chan %d\n",
+		 dimm->mci->mem_is_per_rank ? "rank" : "dimm",
+		 number, location, dimm->csrow, dimm->cschannel);
 	edac_dbg(4, "\tdimm->label = '%s'\n", dimm->label);
 	edac_dbg(4, "\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
-	edac_dbg(4, "\tdimm location ");
-	for (i = 0; i < dimm->mci->n_layers; i++) {
-		printk(KERN_CONT "%d", dimm->location[i]);
-		if (i < dimm->mci->n_layers - 1)
-			printk(KERN_CONT ".");
-	}
-	printk(KERN_CONT "\n");
 	edac_dbg(4, "\tdimm->grain = %d\n", dimm->grain);
 	edac_dbg(4, "\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
 }
@@ -338,8 +356,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	memset(&pos, 0, sizeof(pos));
 	row = 0;
 	chn = 0;
-	edac_dbg(4, "initializing %d %s\n",
-		 tot_dimms, per_rank ? "ranks" : "dimms");
 	for (i = 0; i < tot_dimms; i++) {
 		chan = mci->csrows[row]->channels[chn];
 		off = EDAC_DIMM_OFF(layer, n_layers, pos[0], pos[1], pos[2]);
@@ -352,10 +368,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 		mci->dimms[off] = dimm;
 		dimm->mci = mci;
 
-		edac_dbg(2, "%d: %s%i (%d:%d:%d): row %d, chan %d\n",
-			 i, per_rank ? "rank" : "dimm", off,
-			 pos[0], pos[1], pos[2], row, chn);
-
 		/*
 		 * Copy DIMM location and initialize the memory location
 		 */
@@ -731,7 +743,7 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 				edac_mc_dump_channel(mci->csrows[i]->channels[j]);
 		}
 		for (i = 0; i < mci->tot_dimms; i++)
-			edac_mc_dump_dimm(mci->dimms[i]);
+			edac_mc_dump_dimm(mci->dimms[i], i);
 	}
 #endif
 	mutex_lock(&mem_ctls_mutex);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index fe2d922..95865a0 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -485,17 +485,8 @@ static ssize_t dimmdev_location_show(struct device *dev,
 				     struct device_attribute *mattr, char *data)
 {
 	struct dimm_info *dimm = to_dimm(dev);
-	struct mem_ctl_info *mci = dimm->mci;
-	int i;
-	char *p = data;
-
-	for (i = 0; i < mci->n_layers; i++) {
-		p += sprintf(p, "%s %d ",
-			     edac_layer_name[mci->layers[i].type],
-			     dimm->location[i]);
-	}
 
-	return p - data;
+	return edac_dimm_info_location(dimm, data, PAGE_SIZE);
 }
 
 static ssize_t dimmdev_label_show(struct device *dev,
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 1af1367..de92756 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -34,6 +34,9 @@ extern int edac_mc_get_panic_on_ue(void);
 extern int edac_get_poll_msec(void);
 extern int edac_mc_get_poll_msec(void);
 
+unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
+				 int len);
+
 	/* on edac_device.c */
 extern int edac_device_register_sysfs_main_kobj(
 				struct edac_device_ctl_info *edac_dev);
-- 
1.7.8

