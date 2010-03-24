Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0CXFSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:18:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:35612 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab0CXFSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:18:30 -0400
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 24 Mar 2010 16:12:23 +1100
Subject: [PATCH 2/2] fs/super: remove S_BIAS
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Message-ID: <20100324051223.10015.21420.stgit@notabene.brown>
In-Reply-To: <20100324051140.10015.32854.stgit@notabene.brown>
References: <20100324051140.10015.32854.stgit@notabene.brown>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fact that S_BIAS is very large is only used four times,
all(*) with:
		if (s->s_count > S_BIAS) {
			atomic_inc(&s->s_active);

The statement "s->s_count > S_BIAS" is exactly equivalent
to "atomic_read(&s->s_active) != 0", as the bias is subtracted
as soon as s_active becomes zero.
So the above test can more simply become:

		if (atomic_inc_not_zero(&s->s_active)) {

With this in place, S_BIAS does not need to be large, and a value of
'1' will suit.  This simplifies code in a number of places and
removes the need to take a spinlock in several cases.

(*) full disclosure:  in two cases (inotify) it is
           if (s->s_count >= S_BIAS {
however the logic still holds - that can only be true if
s_active is not zero.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/notify/inotify/inotify.c |   33 ++++++++++++++-------------------
 fs/super.c                  |   16 +++++-----------
 include/linux/fs.h          |    1 -
 3 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/fs/notify/inotify/inotify.c b/fs/notify/inotify/inotify.c
index 40b1cf9..44256e5 100644
--- a/fs/notify/inotify/inotify.c
+++ b/fs/notify/inotify/inotify.c
@@ -110,14 +110,10 @@ EXPORT_SYMBOL_GPL(get_inotify_watch);
 int pin_inotify_watch(struct inotify_watch *watch)
 {
 	struct super_block *sb = watch->inode->i_sb;
-	spin_lock(&sb_lock);
-	if (sb->s_count >= S_BIAS) {
-		atomic_inc(&sb->s_active);
-		spin_unlock(&sb_lock);
+	if (atomic_inc_not_zero(&sb->s_active)) {
 		atomic_inc(&watch->count);
 		return 1;
 	}
-	spin_unlock(&sb_lock);
 	return 0;
 }
 
@@ -518,16 +514,17 @@ EXPORT_SYMBOL_GPL(inotify_init_watch);
  * ->s_umount, which will almost certainly wait until the superblock is shut
  * down and the watch in question is pining for fjords.  That's fine, but
  * there is a problem - we might have hit the window between ->s_active
- * getting to 0 / ->s_count - below S_BIAS (i.e. the moment when superblock
- * is past the point of no return and is heading for shutdown) and the
- * moment when deactivate_super() acquires ->s_umount.  We could just do
- * drop_super() yield() and retry, but that's rather antisocial and this
- * stuff is luser-triggerable.  OTOH, having grabbed ->s_umount and having
- * found that we'd got there first (i.e. that ->s_root is non-NULL) we know
- * that we won't race with inotify_umount_inodes().  So we could grab a
- * reference to watch and do the rest as above, just with drop_super() instead
- * of deactivate_super(), right?  Wrong.  We had to drop ih->mutex before we
- * could grab ->s_umount.  So the watch could've been gone already.
+ * getting to 0 (i.e. the moment when superblock is past the point of no
+ * return and is heading for shutdown) and the moment when
+ * deactivate_super() acquires ->s_umount.  We could just do drop_super()
+ * yield() and retry, but that's rather antisocial and this stuff is
+ * luser-triggerable.  OTOH, having grabbed ->s_umount and having found
+ * that we'd got there first (i.e. that ->s_root is non-NULL) we know that
+ * we won't race with inotify_umount_inodes().  So we could grab a
+ * reference to watch and do the rest as above, just with drop_super()
+ * instead of deactivate_super(), right?  Wrong.  We had to drop ih->mutex
+ * before we could grab ->s_umount.  So the watch could've been gone
+ * already.
  *
  * That still can be dealt with - we need to save watch->wd, do idr_find()
  * and compare its result with our pointer.  If they match, we either have
@@ -565,14 +562,12 @@ static int pin_to_kill(struct inotify_handle *ih, struct inotify_watch *watch)
 	struct super_block *sb = watch->inode->i_sb;
 	s32 wd = watch->wd;
 
-	spin_lock(&sb_lock);
-	if (sb->s_count >= S_BIAS) {
-		atomic_inc(&sb->s_active);
-		spin_unlock(&sb_lock);
+	if (atomic_inc_not_zero(&sb->s_active)) {
 		get_inotify_watch(watch);
 		mutex_unlock(&ih->mutex);
 		return 1;	/* the best outcome */
 	}
+	spin_lock(&sb_lock);
 	sb->s_count++;
 	spin_unlock(&sb_lock);
 	mutex_unlock(&ih->mutex); /* can't grab ->s_umount under it */
diff --git a/fs/super.c b/fs/super.c
index 34c8391..9806711 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -92,7 +92,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		 * subclass.
 		 */
 		down_write_nested(&s->s_umount, SINGLE_DEPTH_NESTING);
-		s->s_count = S_BIAS;
+		s->s_count = 1;
 		atomic_set(&s->s_active, 1);
 		mutex_init(&s->s_vfs_rename_mutex);
 		mutex_init(&s->s_dquot.dqio_mutex);
@@ -188,9 +188,7 @@ void put_super(struct super_block *sb)
 void deactivate_super(struct super_block *s)
 {
 	struct file_system_type *fs = s->s_type;
-	if (atomic_dec_and_lock(&s->s_active, &sb_lock)) {
-		s->s_count -= S_BIAS-1;
-		spin_unlock(&sb_lock);
+	if (atomic_dec_and_test(&s->s_active)) {
 		vfs_dq_off(s, 0);
 		down_write(&s->s_umount);
 		fs->kill_sb(s);
@@ -215,9 +213,7 @@ EXPORT_SYMBOL(deactivate_super);
 void deactivate_locked_super(struct super_block *s)
 {
 	struct file_system_type *fs = s->s_type;
-	if (atomic_dec_and_lock(&s->s_active, &sb_lock)) {
-		s->s_count -= S_BIAS-1;
-		spin_unlock(&sb_lock);
+	if (atomic_dec_and_test(&s->s_active)) {
 		vfs_dq_off(s, 0);
 		fs->kill_sb(s);
 		put_filesystem(fs);
@@ -247,8 +243,7 @@ static int grab_super(struct super_block *s) __releases(sb_lock)
 	down_write(&s->s_umount);
 	if (s->s_root) {
 		spin_lock(&sb_lock);
-		if (s->s_count > S_BIAS) {
-			atomic_inc(&s->s_active);
+		if (atomic_inc_not_zero(&s->s_active)) {
 			s->s_count--;
 			spin_unlock(&sb_lock);
 			return 1;
@@ -492,8 +487,7 @@ restart:
 		down_write(&sb->s_umount);
 		if (sb->s_root) {
 			spin_lock(&sb_lock);
-			if (sb->s_count > S_BIAS) {
-				atomic_inc(&sb->s_active);
+			if (atomic_inc_not_zero(&sb->s_active)) {
 				sb->s_count--;
 				spin_unlock(&sb_lock);
 				return sb;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 10b8ded..0e31ba8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1315,7 +1315,6 @@ extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
 #define sb_entry(list)  list_entry((list), struct super_block, s_list)
-#define S_BIAS (1<<30)
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
 	dev_t			s_dev;		/* search index; _not_ kdev_t */


