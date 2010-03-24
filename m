Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0CXDXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:23:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:33001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab0CXDXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:23:00 -0400
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Date: Wed, 24 Mar 2010 14:20:08 +1100
Subject: [PATCH 3/3] kref: create karef and use for sysfs_dirent->s_active
Cc: linux-kernel@vger.kernel.org
Message-ID: <20100324032008.2136.61287.stgit@notabene.brown>
In-Reply-To: <20100324031829.2136.66489.stgit@notabene.brown>
References: <20100324031829.2136.66489.stgit@notabene.brown>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->s_active is almost a kref, but needs atomic_inc_not_zero which
is not generally appropriate for a kref, as you can only access a
kreffed object if you hold a reference, and in that case the counter
cannot possibly be zero.

So introduce 'karef' - a counter of active references.  An active
reference is separate from an existential reference and normally
implies one.
For a karef, get_not_zero have be appropriate providing a separate
existential reference is held.

Then change sysfs_dirent->s_active to be the first (and so-far only)
karef. super_block->s_active is another candidate to be a karef.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/sysfs/dir.c       |   18 ++++++++++++------
 fs/sysfs/mount.c     |    1 +
 fs/sysfs/sysfs.h     |    2 +-
 include/linux/kref.h |   37 +++++++++++++++++++++++++++++++++++++
 lib/kref.c           |   13 +++++++++++++
 5 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 63790ac..f0e2303 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -97,13 +97,22 @@ struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
 {
 	if (likely(sd)
 	    && (sd->s_flags & SYSFS_FLAG_REMOVED) == 0
-	    && atomic_inc_not_zero(&sd->s_active)) {
+	    && karef_get_not_zero(&sd->s_active)) {
 		rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
 		return sd;
 	} else
 		return NULL;
 }
 
+
+static void sysfs_release(struct karef *k)
+{
+	struct sysfs_dirent *sd = container_of(k, struct sysfs_dirent, s_active);
+	struct completion *cmpl = (void*)sd->s_sibling;
+
+	complete(cmpl);
+}
+	
 /**
  *	sysfs_put_active - put an active reference to sysfs_dirent
  *	@sd: sysfs_dirent to put an active reference to
@@ -117,10 +126,7 @@ void sysfs_put_active(struct sysfs_dirent *sd)
 		return;
 
 	rwsem_release(&sd->dep_map, 1, _RET_IP_);
-	if (atomic_dec_and_test(&sd->s_active)) {
-		struct completion *cmpl = (void*)sd->s_sibling;
-		complete(cmpl);
-	}
+	karef_put(&sd->s_active, sysfs_release);
 }
 
 /**
@@ -296,7 +302,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 		goto err_out2;
 
 	kref_init(&sd->s_count);
-	atomic_set(&sd->s_active, 1);
+	karef_init(&sd->s_active);
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 07bff03..5914f87 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -34,6 +34,7 @@ static const struct super_operations sysfs_ops = {
 struct sysfs_dirent sysfs_root = {
 	.s_name		= "",
 	.s_count	= KREF_INIT,
+	.s_active	= KAREF_INIT,
 	.s_flags	= SYSFS_DIR,
 	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
 	.s_ino		= 1,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f003a88..7eb387b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -50,7 +50,7 @@ struct sysfs_inode_attrs {
  */
 struct sysfs_dirent {
 	struct kref		s_count;
-	atomic_t		s_active;
+	struct karef		s_active;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
diff --git a/include/linux/kref.h b/include/linux/kref.h
index b006f74..2671cf8 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -17,6 +17,11 @@
 
 #include <linux/types.h>
 
+/* A kref can be embedded in an object to count all references
+ * the that object.  When the last reference is dropped (kref_put)
+ * the object is destroyed.
+ * See Documentation/kref.txt
+ */
 struct kref {
 	atomic_t refcount;
 };
@@ -26,4 +31,36 @@ void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
 
 #define KREF_INIT {ATOMIC_INIT(1)}
+
+/* A karef is similar to a kref, except that it counts references
+ * which hold the object 'active' rather than 'in existence'.
+ * The object can continue to exist after the karef reaches zero
+ * so it can be safe to access the object, but not possible to
+ * get a new reference (i.e. the object cannot be re-activated).
+ * So get_not_zero makes sense for karef, while it doesn't for
+ * kref.
+ * Normally the fact that a karef is non-zero will imply a held reference
+ * on some kref.  The 'release' function for the karef would then kref_put
+ * that kref.
+ */
+struct karef {
+	struct kref kref;
+};
+
+static inline void karef_init(struct karef *karef)
+{
+	kref_init(&karef->kref);
+}
+static inline void karef_get(struct karef *karef)
+{
+	kref_get(&karef->kref);
+}
+static inline int karef_put(struct karef *karef,
+			    void (*release) (struct karef *kref))
+{
+	return kref_put(&karef->kref, (void(*)(struct kref *kref))release);
+}
+int karef_get_not_zero(struct karef *karef);
+
+#define KAREF_INIT {{ATOMIC_INIT(1)}}
 #endif /* _KREF_H_ */
diff --git a/lib/kref.c b/lib/kref.c
index 69761d3..7aadf3d 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -36,6 +36,19 @@ void kref_get(struct kref *kref)
 }
 
 /**
+ * karef_get_not_zero - increment refcount unless it is already zero
+ * @karef: object
+ *
+ * This is only safe to use if there is something separate from this
+ * karef (such as a lock or a kref) that keeps the object
+ * from being freed.
+ */
+int karef_get_not_zero(struct karef *karef)
+{
+	return atomic_inc_not_zero(&karef->kref.refcount);
+}
+
+/**
  * kref_put - decrement refcount for object.
  * @kref: object.
  * @release: pointer to the function that will clean up the object when the


