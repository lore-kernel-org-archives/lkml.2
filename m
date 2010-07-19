Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966995Ab0GSVlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:41:24 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53693 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966877Ab0GSViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:54 -0400
Message-Id: <20100719213853.782919513@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:34 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 16/25] GRU - add refcnt to vdata structure
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_refcnt_vdata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

The GRU vdata structure must have a reference count. 

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufile.c   |   21 +++++++++++++++++++--
 drivers/misc/sgi-gru/grumain.c   |    1 +
 drivers/misc/sgi-gru/gruprocfs.c |    1 +
 drivers/misc/sgi-gru/grutables.h |    2 ++
 4 files changed, 23 insertions(+), 2 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2010-07-19 10:25:41.002455321 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2010-07-19 10:25:49.182243660 -0500
@@ -65,6 +65,19 @@ static struct miscdevice gru_miscdev;
  * Called when unmapping a device mapping. Frees all gru resources
  * and tables belonging to the vma.
  */
+static void gru_vma_open(struct vm_area_struct *vma)
+{
+	struct gru_vma_data *vdata;
+
+	if (!vma->vm_private_data)
+		return;
+	STAT(vdata_open);
+	vdata = vma->vm_private_data;
+	atomic_inc(&vdata->vd_refcnt);
+	gru_dbg(grudev, "vma %p, file %p, vdata %p\n", vma, vma->vm_file,
+				vdata);
+}
+
 static void gru_vma_close(struct vm_area_struct *vma)
 {
 	struct gru_vma_data *vdata;
@@ -75,9 +88,12 @@ static void gru_vma_close(struct vm_area
 		return;
 
 	vdata = vma->vm_private_data;
+	gru_dbg(grudev, "vma %p, file %p, vdata %p, refcnt %d\n", vma, vma->vm_file,
+				vdata, atomic_read(&vdata->vd_refcnt));
+	if (atomic_dec_return(&vdata->vd_refcnt) != 0)
+		return;
+
 	vma->vm_private_data = NULL;
-	gru_dbg(grudev, "vma %p, file %p, vdata %p\n", vma, vma->vm_file,
-				vdata);
 	list_for_each_safe(entry, next, &vdata->vd_head) {
 		gts =
 		    list_entry(entry, struct gru_thread_state, ts_next);
@@ -597,6 +613,7 @@ static struct miscdevice gru_miscdev = {
 };
 
 const struct vm_operations_struct gru_vm_ops = {
+	.open		= gru_vma_open,
 	.close		= gru_vma_close,
 	.fault		= gru_fault,
 };
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2010-07-19 10:25:41.058388796 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2010-07-19 10:25:49.186243696 -0500
@@ -374,6 +374,7 @@ struct gru_vma_data *gru_alloc_vma_data(
 	if (IS_ERR(gms))
 		goto err;
 	vdata->vd_gms = gms;
+	atomic_set(&vdata->vd_refcnt, 1);
 
 	STAT(vdata_alloc);
 	INIT_LIST_HEAD(&vdata->vd_head);
Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2010-07-19 10:25:41.078288158 -0500

+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2010-07-19 10:25:49.214243610 -0500
@@ -42,6 +42,7 @@ static void printstat_val(struct seq_fil
 static int statistics_show(struct seq_file *s, void *p)
 {
 	printstat(s, vdata_alloc);
+	printstat(s, vdata_open);
 	printstat(s, vdata_free);
 	printstat(s, gts_alloc);
 	printstat(s, gts_free);
Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2010-07-19 10:25:41.130287807 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2010-07-19 10:25:49.242242927 -0500
@@ -174,6 +174,7 @@ extern unsigned int gru_max_gids;
  */
 struct gru_stats_s {
 	atomic_long_t vdata_alloc;
+	atomic_long_t vdata_open;
 	atomic_long_t vdata_free;
 	atomic_long_t gts_alloc;
 	atomic_long_t gts_free;
@@ -351,6 +352,7 @@ struct gru_mm_struct {
  */
 struct gru_vma_data {
 	spinlock_t		vd_lock;	/* Serialize access to vma */
+	atomic_t		vd_refcnt;
 	struct list_head	vd_head;	/* head of linked list of gts */
 	struct gru_mm_struct	*vd_gms;	/* asid & ioproc struct */
 	long			vd_user_options;/* misc user option flags */

