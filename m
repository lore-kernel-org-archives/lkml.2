Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668Ab2FASa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:30:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48766 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab2FASaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:30:55 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE handlers
Date: Fri,  1 Jun 2012 11:29:47 -0700
Message-Id: <1338575387-26972-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1338575387-26972-1-git-send-email-john.stultz@linaro.org>
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060118-2398-0000-0000-00000720458C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
functionality for tmpfs making use of the volatile range
management code.

Conceptually, FALLOC_FL_MARK_VOLATILE is like a delayed
FALLOC_FL_PUNCH_HOLE.  This allows applications that have
data caches that can be re-created to tell the kernel that
some memory contains data that is useful in the future, but
can be recreated if needed, so if the kernel needs, it can
zap the memory without having to swap it out.

In use, applications use FALLOC_FL_MARK_VOLATILE to mark
page ranges as volatile when they are not in use. Then later
if they wants to reuse the data, they use
FALLOC_FL_UNMARK_VOLATILE, which will return an error if the
data has been purged.

This is very much influenced by the Android Ashmem interface by
Robert Love so credits to him and the Android developers.
In many cases the code & logic come directly from the ashmem patch.
The intent of this patch is to allow for ashmem-like behavior, but
embeds the idea a little deeper into the VM code.

This is a reworked version of the fadvise volatile idea submitted
earlier to the list. Thanks to Dave Chinner for suggesting to
rework the idea in this fashion. Also thanks to Dmitry Adamushko
for continued review and bug reporting, and Dave Hansen for
help with the original design and mentoring me in the VM code.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Android Kernel Team <kernel-team@android.com>
CC: Robert Love <rlove@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Hugh Dickins <hughd@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Neil Brown <neilb@suse.de>
CC: Andrea Righi <andrea@betterlinux.com>
CC: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC: Taras Glek <tgek@mozilla.com>
CC: Mike Hommey <mh@glandium.org>
CC: Jan Kara <jack@suse.cz>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 fs/open.c              |    3 +-
 include/linux/falloc.h |    7 ++-
 mm/shmem.c             |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index d543012..448ed5a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -223,7 +223,8 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EINVAL;
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+			FALLOC_FL_MARK_VOLATILE | FALLOC_FL_UNMARK_VOLATILE))
 		return -EOPNOTSUPP;
 
 	/* Punch hole must have keep size set */
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 73e0b62..3e47ad5 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -1,9 +1,10 @@
 #ifndef _FALLOC_H_
 #define _FALLOC_H_
 
-#define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
-#define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
-
+#define FALLOC_FL_KEEP_SIZE		0x01 /* default is extend size */
+#define FALLOC_FL_PUNCH_HOLE		0x02 /* de-allocates range */
+#define FALLOC_FL_MARK_VOLATILE		0x04 /* mark range volatile */
+#define FALLOC_FL_UNMARK_VOLATILE	0x08 /* mark range non-volatile */
 #ifdef __KERNEL__
 
 /*
diff --git a/mm/shmem.c b/mm/shmem.c
index d576b84..d28daa4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -64,6 +64,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/highmem.h>
 #include <linux/seq_file.h>
 #include <linux/magic.h>
+#include <linux/volatile.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -624,11 +625,109 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 	return error;
 }
 
+static DEFINE_VOLATILE_FS_HEAD(shmem_volatile_head);
+
+static int shmem_mark_volatile(struct inode *inode, loff_t offset, loff_t len)
+{
+	loff_t lstart, lend;
+	int ret;
+
+	lstart = offset >> PAGE_CACHE_SHIFT;
+	lend = (offset+len) >> PAGE_CACHE_SHIFT;
+
+	volatile_range_lock(&shmem_volatile_head);
+	ret = volatile_range_add(&shmem_volatile_head, &inode->i_data,
+					lstart, lend);
+	if (ret > 0) { /* immdiately purge */
+		shmem_truncate_range(inode, lstart<<PAGE_CACHE_SHIFT,
+					(lend<<PAGE_CACHE_SHIFT)-1);
+		ret = 0;
+	}
+	volatile_range_unlock(&shmem_volatile_head);
+
+	return ret;
+}
+
+static int shmem_unmark_volatile(struct inode *inode, loff_t offset, loff_t len)
+{
+	loff_t lstart, lend;
+	int ret;
+
+	lstart = offset >> PAGE_CACHE_SHIFT;
+	lend = (offset+len) >> PAGE_CACHE_SHIFT;
+
+	volatile_range_lock(&shmem_volatile_head);
+	ret = volatile_range_remove(&shmem_volatile_head,
+					&inode->i_data,
+					lstart, lend);
+	volatile_range_unlock(&shmem_volatile_head);
+
+	return ret;
+}
+
+static void shmem_clear_volatile(struct inode *inode)
+{
+	volatile_range_lock(&shmem_volatile_head);
+	volatile_range_clear(&shmem_volatile_head, &inode->i_data);
+	volatile_range_unlock(&shmem_volatile_head);
+}
+
+static
+int shmem_volatile_shrink(struct shrinker *ignored, struct shrink_control *sc)
+{
+	s64 nr_to_scan = sc->nr_to_scan;
+	const gfp_t gfp_mask = sc->gfp_mask;
+	struct address_space *mapping;
+	loff_t start, end;
+	int ret;
+	s64 page_count;
+
+	if (nr_to_scan && !(gfp_mask & __GFP_FS))
+		return -1;
+
+	volatile_range_lock(&shmem_volatile_head);
+	page_count = volatile_range_lru_size(&shmem_volatile_head);
+	if (!nr_to_scan)
+		goto out;
+
+	do {
+		ret = volatile_ranges_get_last_used(&shmem_volatile_head,
+							&mapping, &start, &end);
+		if (ret) {
+			shmem_truncate_range(mapping->host,
+						start<<PAGE_CACHE_SHIFT,
+						(end<<PAGE_CACHE_SHIFT)-1);
+			nr_to_scan -= end-start;
+			page_count -= end-start;
+		};
+	} while (ret && (nr_to_scan > 0));
+
+out:
+	volatile_range_unlock(&shmem_volatile_head);
+
+	return page_count;
+}
+
+static struct shrinker shmem_volatile_shrinker = {
+	.shrink = shmem_volatile_shrink,
+	.seeks = DEFAULT_SEEKS,
+};
+
+static int __init shmem_shrinker_init(void)
+{
+	register_shrinker(&shmem_volatile_shrinker);
+	return 0;
+}
+arch_initcall(shmem_shrinker_init);
+
+
 static void shmem_evict_inode(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_xattr *xattr, *nxattr;
 
+	shmem_clear_volatile(inode);
+
 	if (inode->i_mapping->a_ops == &shmem_aops) {
 		shmem_unacct_size(info->flags, inode->i_size);
 		inode->i_size = 0;
@@ -1789,6 +1888,14 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		/* No need to unmap again: hole-punching leaves COWed pages */
 		error = 0;
 		goto out;
+	} else if (mode & FALLOC_FL_MARK_VOLATILE) {
+		/* Mark pages volatile, sort of delayed hole punching */
+		error = shmem_mark_volatile(inode, offset, len);
+		goto out;
+	} else if (mode & FALLOC_FL_UNMARK_VOLATILE) {
+		/* Mark pages non-volatile, return error if pages were purged */
+		error = shmem_unmark_volatile(inode, offset, len);
+		goto out;
 	}
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
-- 
1.7.3.2.146.gca209

