Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab2IZPxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:53:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab2IZPwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:52:09 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Heinz.Egger@linutronix.de, artem.bityutskiy@linux.intel.com,
        tim.bird@am.sony.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 02/10] UBI: Add fastmap stuff to ubi.h
Date: Wed, 26 Sep 2012 17:51:42 +0200
Message-Id: <1348674710-102885-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348674710-102885-1-git-send-email-richard@nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds fastmap specific data structures to ubi.h.
It moves also struct ubi_work to ubi.h as it is now needed
for more than one c file.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h |  116 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/mtd/ubi/wl.c  |   24 ----------
 2 files changed, 115 insertions(+), 25 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 383ee43..b0d3ba2 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -133,6 +133,17 @@ enum {
 	MOVE_RETRY,
 };
 
+/*
+ * Return codes of the fastmap sub-system
+ *
+ * UBI_NO_FASTMAP: No fastmap super block was found
+ * UBI_BAD_FASTMAP: A fastmap was found but it's unusable
+ */
+enum {
+	UBI_NO_FASTMAP = 1,
+	UBI_BAD_FASTMAP,
+};
+
 /**
  * struct ubi_wl_entry - wear-leveling entry.
  * @u.rb: link in the corresponding (free/used) RB-tree
@@ -199,6 +210,41 @@ struct ubi_rename_entry {
 struct ubi_volume_desc;
 
 /**
+ * struct ubi_fastmap_layout - in-memory fastmap data structure.
+ * @e: PEBs used by the current fastmap
+ * @to_be_tortured: if non-zero tortured this PEB
+ * @used_blocks: number of used PEBs
+ * @max_pool_size: maximal size of the user pool
+ * @max_wl_pool_size: maximal size of the pool used by the WL sub-system
+ */
+struct ubi_fastmap_layout {
+	struct ubi_wl_entry *e[UBI_FM_MAX_BLOCKS];
+	int to_be_tortured[UBI_FM_MAX_BLOCKS];
+	int used_blocks;
+	int max_pool_size;
+	int max_wl_pool_size;
+};
+
+/**
+ * struct ubi_fm_pool - in-memory fastmap pool
+ * @pebs: PEBs in this pool
+ * @used: number of used PEBs
+ * @size: total number of PEBs in this pool
+ * @max_size: maximal size of the pool
+ *
+ * A pool gets filled with up to max_size.
+ * If all PEBs within the pool are used a new fastmap will be written
+ * to the flash and the pool gets refilled with empty PEBs.
+ *
+ */
+struct ubi_fm_pool {
+	int pebs[UBI_FM_MAX_POOL_SIZE];
+	int used;
+	int size;
+	int max_size;
+};
+
+/**
  * struct ubi_volume - UBI volume description data structure.
  * @dev: device object to make use of the the Linux device model
  * @cdev: character device object to create character device
@@ -333,9 +379,21 @@ struct ubi_wl_entry;
  * @ltree: the lock tree
  * @alc_mutex: serializes "atomic LEB change" operations
  *
+ * @fm_disabled: non-zero if fastmap is disabled (default)
+ * @fm: in-memory data structure of the currently used fastmap
+ * @fm_pool: in-memory data structure of the fastmap pool
+ * @fm_wl_pool: in-memory data structure of the fastmap pool used by the WL
+ *		sub-system
+ * @fm_mutex: serializes ubi_update_fastmap() and protects @fm_buf
+ * @fm_buf: vmalloc()'d buffer which holds the raw fastmap
+ * @fm_size: fastmap size in bytes
+ * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
+ * @fm_work: fastmap work queue
+ *
  * @used: RB-tree of used physical eraseblocks
  * @erroneous: RB-tree of erroneous used physical eraseblocks
  * @free: RB-tree of free physical eraseblocks
+ * @free_count: Contains the number of elements in @free
  * @scrub: RB-tree of physical eraseblocks which need scrubbing
  * @pq: protection queue (contain physical eraseblocks which are temporarily
  *      protected from the wear-leveling worker)
@@ -426,10 +484,22 @@ struct ubi_device {
 	struct rb_root ltree;
 	struct mutex alc_mutex;
 
+	/* Fastmap stuff */
+	int fm_disabled;
+	struct ubi_fastmap_layout *fm;
+	struct ubi_fm_pool fm_pool;
+	struct ubi_fm_pool fm_wl_pool;
+	struct rw_semaphore fm_sem;
+	struct mutex fm_mutex;
+	void *fm_buf;
+	size_t fm_size;
+	struct work_struct fm_work;
+
 	/* Wear-leveling sub-system's stuff */
 	struct rb_root used;
 	struct rb_root erroneous;
 	struct rb_root free;
+	int free_count;
 	struct rb_root scrub;
 	struct list_head pq[UBI_PROT_QUEUE_LEN];
 	int pq_head;
@@ -596,6 +666,32 @@ struct ubi_attach_info {
 	struct kmem_cache *aeb_slab_cache;
 };
 
+/**
+ * struct ubi_work - UBI work description data structure.
+ * @list: a link in the list of pending works
+ * @func: worker function
+ * @e: physical eraseblock to erase
+ * @vol_id: the volume ID on which this erasure is being performed
+ * @lnum: the logical eraseblock number
+ * @torture: if the physical eraseblock has to be tortured
+ * @anchor: produce a anchor PEB to by used by fastmap
+ *
+ * The @func pointer points to the worker function. If the @cancel argument is
+ * not zero, the worker has to free the resources and exit immediately. The
+ * worker has to return zero in case of success and a negative error code in
+ * case of failure.
+ */
+struct ubi_work {
+	struct list_head list;
+	int (*func)(struct ubi_device *ubi, struct ubi_work *wrk, int cancel);
+	/* The below fields are only relevant to erasure works */
+	struct ubi_wl_entry *e;
+	int vol_id;
+	int lnum;
+	int torture;
+	int anchor;
+};
+
 #include "debug.h"
 
 extern struct kmem_cache *ubi_wl_entry_slab;
@@ -606,7 +702,7 @@ extern struct class *ubi_class;
 extern struct mutex ubi_devices_mutex;
 extern struct blocking_notifier_head ubi_notifiers;
 
-/* scan.c */
+/* attach.c */
 int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 		  int ec, const struct ubi_vid_hdr *vid_hdr, int bitflips);
 struct ubi_ainf_volume *ubi_find_av(const struct ubi_attach_info *ai,
@@ -664,6 +760,9 @@ int ubi_eba_atomic_leb_change(struct ubi_device *ubi, struct ubi_volume *vol,
 int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		     struct ubi_vid_hdr *vid_hdr);
 int ubi_eba_init(struct ubi_device *ubi, struct ubi_attach_info *ai);
+unsigned long long ubi_next_sqnum(struct ubi_device *ubi);
+int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
+		   struct ubi_attach_info *ai_scan);
 
 /* wl.c */
 int ubi_wl_get_peb(struct ubi_device *ubi);
@@ -674,6 +773,12 @@ int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum);
 int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai);
 void ubi_wl_close(struct ubi_device *ubi);
 int ubi_thread(void *u);
+struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor);
+int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *used_e,
+		      int lnum, int torture);
+int ubi_is_erase_work(struct ubi_work *wrk);
+void ubi_refill_pools(struct ubi_device *ubi);
+int ubi_ensure_anchor_pebs(struct ubi_device *ubi);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
@@ -711,6 +816,15 @@ void ubi_free_internal_volumes(struct ubi_device *ubi);
 void ubi_do_get_device_info(struct ubi_device *ubi, struct ubi_device_info *di);
 void ubi_do_get_volume_info(struct ubi_device *ubi, struct ubi_volume *vol,
 			    struct ubi_volume_info *vi);
+/* scan.c */
+int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
+		      int pnum, const struct ubi_vid_hdr *vid_hdr);
+
+/* fastmap.c */
+size_t ubi_calc_fm_size(struct ubi_device *ubi);
+int ubi_update_fastmap(struct ubi_device *ubi);
+int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
+		     int fm_anchor);
 
 /*
  * ubi_rb_for_each_entry - walk an RB-tree.
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 032fc57..f4d06db 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -135,30 +135,6 @@
  */
 #define WL_MAX_FAILURES 32
 
-/**
- * struct ubi_work - UBI work description data structure.
- * @list: a link in the list of pending works
- * @func: worker function
- * @e: physical eraseblock to erase
- * @vol_id: the volume ID on which this erasure is being performed
- * @lnum: the logical eraseblock number
- * @torture: if the physical eraseblock has to be tortured
- *
- * The @func pointer points to the worker function. If the @cancel argument is
- * not zero, the worker has to free the resources and exit immediately. The
- * worker has to return zero in case of success and a negative error code in
- * case of failure.
- */
-struct ubi_work {
-	struct list_head list;
-	int (*func)(struct ubi_device *ubi, struct ubi_work *wrk, int cancel);
-	/* The below fields are only relevant to erasure works */
-	struct ubi_wl_entry *e;
-	int vol_id;
-	int lnum;
-	int torture;
-};
-
 static int self_check_ec(struct ubi_device *ubi, int pnum, int ec);
 static int self_check_in_wl_tree(const struct ubi_device *ubi,
 				 struct ubi_wl_entry *e, struct rb_root *root);
-- 
1.7.6.5

