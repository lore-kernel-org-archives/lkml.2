Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0CXDW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:22:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:33000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab0CXDWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:22:54 -0400
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Date: Wed, 24 Mar 2010 14:20:08 +1100
Subject: [PATCH 2/3] sysfs: make s_count a kref
Cc: linux-kernel@vger.kernel.org
Message-ID: <20100324032008.2136.15346.stgit@notabene.brown>
In-Reply-To: <20100324031829.2136.66489.stgit@notabene.brown>
References: <20100324031829.2136.66489.stgit@notabene.brown>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s_count in sysfs behaves exactly like a kref, so change it to
be one.
This requires adding a KREF_INIT macro to kref.h

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/sysfs/dir.c       |   12 +++++++++---
 fs/sysfs/mount.c     |    2 +-
 fs/sysfs/sysfs.h     |   15 +++++++--------
 include/linux/kref.h |    1 +
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 76a2d10..63790ac 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -177,8 +177,14 @@ static void sysfs_free_ino(ino_t ino)
 	spin_unlock(&sysfs_ino_lock);
 }
 
-void release_sysfs_dirent(struct sysfs_dirent * sd)
+static void no_recurse(struct kref *kref)
 {
+}
+void release_sysfs_dirent(struct kref *count)
+{
+	struct sysfs_dirent *sd = container_of(count,
+					       struct sysfs_dirent,
+					       s_count);
 	struct sysfs_dirent *parent_sd;
 
  repeat:
@@ -199,7 +205,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	kmem_cache_free(sysfs_dir_cachep, sd);
 
 	sd = parent_sd;
-	if (sd && atomic_dec_and_test(&sd->s_count))
+	if (sd && kref_put(&sd->s_count, no_recurse))
 		goto repeat;
 }
 
@@ -289,7 +295,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	if (sysfs_alloc_ino(&sd->s_ino))
 		goto err_out2;
 
-	atomic_set(&sd->s_count, 1);
+	kref_init(&sd->s_count);
 	atomic_set(&sd->s_active, 1);
 
 	sd->s_name = name;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 0cb1088..07bff03 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -33,7 +33,7 @@ static const struct super_operations sysfs_ops = {
 
 struct sysfs_dirent sysfs_root = {
 	.s_name		= "",
-	.s_count	= ATOMIC_INIT(1),
+	.s_count	= KREF_INIT,
 	.s_flags	= SYSFS_DIR,
 	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
 	.s_ino		= 1,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6a2a60e..f003a88 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -49,7 +49,7 @@ struct sysfs_inode_attrs {
  * requires s_active reference.
  */
 struct sysfs_dirent {
-	atomic_t		s_count;
+	struct kref		s_count;
 	atomic_t		s_active;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -140,7 +140,7 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 				      const unsigned char *name);
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type);
 
-void release_sysfs_dirent(struct sysfs_dirent *sd);
+void release_sysfs_dirent(struct kref *count);
 
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
@@ -151,18 +151,17 @@ int sysfs_rename(struct sysfs_dirent *sd,
 
 static inline struct sysfs_dirent *__sysfs_get(struct sysfs_dirent *sd)
 {
-	if (sd) {
-		WARN_ON(!atomic_read(&sd->s_count));
-		atomic_inc(&sd->s_count);
-	}
+	if (sd)
+		kref_get(&sd->s_count);
+
 	return sd;
 }
 #define sysfs_get(sd) __sysfs_get(sd)
 
 static inline void __sysfs_put(struct sysfs_dirent *sd)
 {
-	if (sd && atomic_dec_and_test(&sd->s_count))
-		release_sysfs_dirent(sd);
+	if (sd)
+		kref_put(&sd->s_count, release_sysfs_dirent);
 }
 #define sysfs_put(sd) __sysfs_put(sd)
 
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 13003ee..b006f74 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -25,4 +25,5 @@ void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
 
+#define KREF_INIT {ATOMIC_INIT(1)}
 #endif /* _KREF_H_ */


