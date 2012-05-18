Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061Ab2ERQpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:45:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758576Ab2ERQdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC v26 64/66] edac_mc: Cleanup per-dimm_info debug messages
Date: Fri, 18 May 2012 13:32:51 -0300
Message-Id: <1337358773-6919-65-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edac_mc_alloc() routine allocates one dimm_info device for all
possible memories, including the non-filled ones. The debug messages
there are somewhat confusing. So, cleans them, by moving the code
that prints the memory location to edac_mc, and using it on both
edac_mc_sysfs and edac_mc.

Also, only dumps information when DIMM/ranks are actually
filled.

After this patch, a dimm-based memory controller will print the debug
info as:

[ 1011.380027] EDAC DEBUG: edac_mc_dump_csrow: csrow->csrow_idx = 0
[ 1011.380029] EDAC DEBUG: edac_mc_dump_csrow:   csrow = ffff8801169be000
[ 1011.380031] EDAC DEBUG: edac_mc_dump_csrow:   csrow->first_page = 0x0
[ 1011.380032] EDAC DEBUG: edac_mc_dump_csrow:   csrow->last_page = 0x0
[ 1011.380034] EDAC DEBUG: edac_mc_dump_csrow:   csrow->page_mask = 0x0
[ 1011.380035] EDAC DEBUG: edac_mc_dump_csrow:   csrow->nr_channels = 3
[ 1011.380037] EDAC DEBUG: edac_mc_dump_csrow:   csrow->channels = ffff8801149c2840
[ 1011.380039] EDAC DEBUG: edac_mc_dump_csrow:   csrow->mci = ffff880117426000
[ 1011.380041] EDAC DEBUG: edac_mc_dump_channel:   channel->chan_idx = 0
[ 1011.380042] EDAC DEBUG: edac_mc_dump_channel:     channel = ffff8801149c2860
[ 1011.380044] EDAC DEBUG: edac_mc_dump_channel:     channel->csrow = ffff8801169be000
[ 1011.380046] EDAC DEBUG: edac_mc_dump_channel:     channel->dimm = ffff88010fe90400
...
[ 1011.380095] EDAC DEBUG: edac_mc_dump_dimm: dimm0: channel 0 slot 0 mapped as virtual row 0, chan 0
[ 1011.380097] EDAC DEBUG: edac_mc_dump_dimm:   dimm = ffff88010fe90400
[ 1011.380099] EDAC DEBUG: edac_mc_dump_dimm:   dimm->label = 'CPU#0Channel#0_DIMM#0'
[ 1011.380101] EDAC DEBUG: edac_mc_dump_dimm:   dimm->nr_pages = 0x40000
[ 1011.380103] EDAC DEBUG: edac_mc_dump_dimm:   dimm->grain = 8
[ 1011.380104] EDAC DEBUG: edac_mc_dump_dimm:   dimm->nr_pages = 0x40000
...

(a rank-based memory controller would print, instead of "dimm?", "rank?"
 on the above debug info)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c       |   95 +++++++++++++++++++++++++----------------
 drivers/edac/edac_mc_sysfs.c |   11 +----
 drivers/edac/edac_module.h   |    3 +
 3 files changed, 62 insertions(+), 47 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 080716b..0dfda4c 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -41,44 +41,63 @@
 static DEFINE_MUTEX(mem_ctls_mutex);
 static LIST_HEAD(mc_devices);
 
+unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
+			         unsigned len)
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
+		if (!len)
+			break;
+	}
+
+	return count;
+}
+
 #ifdef CONFIG_EDAC_DEBUG
 
 static void edac_mc_dump_channel(struct rank_info *chan)
 {
-	edac_dbg(4, "\tchannel = %p\n", chan);
-	edac_dbg(4, "\tchannel->chan_idx = %d\n", chan->chan_idx);
-	edac_dbg(4, "\tchannel->csrow = %p\n", chan->csrow);
-	edac_dbg(4, "\tchannel->dimm = %p\n", chan->dimm);
+	edac_dbg(4, "  channel->chan_idx = %d\n", chan->chan_idx);
+	edac_dbg(4, "    channel = %p\n", chan);
+	edac_dbg(4, "    channel->csrow = %p\n", chan->csrow);
+	edac_dbg(4, "    channel->dimm = %p\n", chan->dimm);
 }
 
-static void edac_mc_dump_dimm(struct dimm_info *dimm)
+static void edac_mc_dump_dimm(struct dimm_info *dimm, int number)
 {
-	int i;
-
-	edac_dbg(4, "\tdimm = %p\n", dimm);
-	edac_dbg(4, "\tdimm->label = '%s'\n", dimm->label);
-	edac_dbg(4, "\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
-	edac_dbg(4, "\tdimm location ");
-	for (i = 0; i < dimm->mci->n_layers; i++) {
-		printk(KERN_CONT "%d", dimm->location[i]);
-		if (i < dimm->mci->n_layers - 1)
-			printk(KERN_CONT ".");
-	}
-	printk(KERN_CONT "\n");
-	edac_dbg(4, "\tdimm->grain = %d\n", dimm->grain);
-	edac_dbg(4, "\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
+	char location[80];
+
+	edac_dimm_info_location(dimm, location, sizeof(location));
+
+	edac_dbg(4, "%s%i: %smapped as virtual row %d, chan %d\n",
+		 dimm->mci->mem_is_per_rank ? "rank" : "dimm",
+		 number, location, dimm->csrow, dimm->cschannel);
+	edac_dbg(4, "  dimm = %p\n", dimm);
+	edac_dbg(4, "  dimm->label = '%s'\n", dimm->label);
+	edac_dbg(4, "  dimm->nr_pages = 0x%x\n", dimm->nr_pages);
+	edac_dbg(4, "  dimm->grain = %d\n", dimm->grain);
+	edac_dbg(4, "  dimm->nr_pages = 0x%x\n", dimm->nr_pages);
 }
 
 static void edac_mc_dump_csrow(struct csrow_info *csrow)
 {
-	edac_dbg(4, "\tcsrow = %p\n", csrow);
-	edac_dbg(4, "\tcsrow->csrow_idx = %d\n", csrow->csrow_idx);
-	edac_dbg(4, "\tcsrow->first_page = 0x%lx\n", csrow->first_page);
-	edac_dbg(4, "\tcsrow->last_page = 0x%lx\n", csrow->last_page);
-	edac_dbg(4, "\tcsrow->page_mask = 0x%lx\n", csrow->page_mask);
-	edac_dbg(4, "\tcsrow->nr_channels = %d\n", csrow->nr_channels);
-	edac_dbg(4, "\tcsrow->channels = %p\n", csrow->channels);
-	edac_dbg(4, "\tcsrow->mci = %p\n", csrow->mci);
+	edac_dbg(4, "csrow->csrow_idx = %d\n", csrow->csrow_idx);
+	edac_dbg(4, "  csrow = %p\n", csrow);
+	edac_dbg(4, "  csrow->first_page = 0x%lx\n", csrow->first_page);
+	edac_dbg(4, "  csrow->last_page = 0x%lx\n", csrow->last_page);
+	edac_dbg(4, "  csrow->page_mask = 0x%lx\n", csrow->page_mask);
+	edac_dbg(4, "  csrow->nr_channels = %d\n", csrow->nr_channels);
+	edac_dbg(4, "  csrow->channels = %p\n", csrow->channels);
+	edac_dbg(4, "  csrow->mci = %p\n", csrow->mci);
 }
 
 static void edac_mc_dump_mci(struct mem_ctl_info *mci)
@@ -326,8 +345,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	memset(&pos, 0, sizeof(pos));
 	row = 0;
 	chn = 0;
-	edac_dbg(4, "initializing %d %s\n",
-		 tot_dimms, per_rank ? "ranks" : "dimms");
 	for (i = 0; i < tot_dimms; i++) {
 		chan = mci->csrows[row]->channels[chn];
 		off = EDAC_DIMM_OFF(layer, n_layers, pos[0], pos[1], pos[2]);
@@ -340,10 +357,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 		mci->dimms[off] = dimm;
 		dimm->mci = mci;
 
-		edac_dbg(2, "%d: %s%i (%d:%d:%d): row %d, chan %d\n",
-			 i, per_rank ? "rank" : "dimm", off,
-			 pos[0], pos[1], pos[2], row, chn);
-
 		/*
 		 * Copy DIMM location and initialize it.
 		 */
@@ -699,14 +712,22 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 		int i;
 
 		for (i = 0; i < mci->nr_csrows; i++) {
+			struct csrow_info *csrow = mci->csrows[i];
+			u32 nr_pages = 0;
 			int j;
 
-			edac_mc_dump_csrow(mci->csrows[i]);
-			for (j = 0; j < mci->csrows[i]->nr_channels; j++)
-				edac_mc_dump_channel(mci->csrows[i]->channels[j]);
+			for (j = 0; j < csrow->nr_channels; j++)
+				nr_pages += csrow->channels[j]->dimm->nr_pages;
+			if (!nr_pages)
+				continue;
+			edac_mc_dump_csrow(csrow);
+			for (j = 0; j < csrow->nr_channels; j++)
+				if (csrow->channels[j]->dimm->nr_pages)
+					edac_mc_dump_channel(csrow->channels[j]);
 		}
 		for (i = 0; i < mci->tot_dimms; i++)
-			edac_mc_dump_dimm(mci->dimms[i]);
+			if (mci->dimms[i]->nr_pages)
+				edac_mc_dump_dimm(mci->dimms[i], i);
 	}
 #endif
 	mutex_lock(&mem_ctls_mutex);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index eace646..7079a42 100644
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
index 1af1367..62de640 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -34,6 +34,9 @@ extern int edac_mc_get_panic_on_ue(void);
 extern int edac_get_poll_msec(void);
 extern int edac_mc_get_poll_msec(void);
 
+unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
+				 unsigned len);
+
 	/* on edac_device.c */
 extern int edac_device_register_sysfs_main_kobj(
 				struct edac_device_ctl_info *edac_dev);
-- 
1.7.8

