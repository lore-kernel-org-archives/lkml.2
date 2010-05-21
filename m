Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab0EUQ6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:58:40 -0400
Received: from kroah.org ([198.145.64.141]:39123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512Ab0EUQyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/38] sysfs: Comment sysfs directory tagging logic
Date: Fri, 21 May 2010 09:53:55 -0700
Message-Id: <1274460848-11377-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

Add some in-line comments to explain the new infrastructure, which
was introduced to support sysfs directory tagging with namespaces.
I think an overall description someplace might be good too, but it
didn't really seem to fit into Documentation/filesystems/sysfs.txt,
which appears more geared toward users, rather than maintainers, of
sysfs.

(Tejun, please let me know if I can make anything clearer or failed
altogether to comment something that should be commented.)

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c          |    8 ++++++++
 fs/sysfs/sysfs.h        |   13 ++++++++++++-
 include/linux/kobject.h |   11 +++++++++++
 include/linux/sysfs.h   |    1 +
 lib/kobject.c           |   11 +++++++++++
 5 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a63eb4b..7e54bac 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -614,6 +614,14 @@ int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			  KOBJ_NS_TYPE_NONE, NULL, name, p_sd);
 }
 
+/**
+ *	sysfs_read_ns_type: return associated ns_type
+ *	@kobj: the kobject being queried
+ *
+ *	Each kobject can be tagged with exactly one namespace type
+ *	(i.e. network or user).  Return the ns_type associated with
+ *	this object if any
+ */
 static enum kobj_ns_type sysfs_read_ns_type(struct kobject *kobj)
 {
 	const struct kobj_ns_type_operations *ops;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 93847d5..6a13105 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -58,7 +58,7 @@ struct sysfs_dirent {
 	struct sysfs_dirent	*s_sibling;
 	const char		*s_name;
 
-	const void		*s_ns;
+	const void		*s_ns; /* namespace tag */
 	union {
 		struct sysfs_elem_dir		s_dir;
 		struct sysfs_elem_symlink	s_symlink;
@@ -82,6 +82,7 @@ struct sysfs_dirent {
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
 #define SYSFS_ACTIVE_REF		(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR)
 
+/* identify any namespace tag on sysfs_dirents */
 #define SYSFS_NS_TYPE_MASK		0xff00
 #define SYSFS_NS_TYPE_SHIFT		8
 
@@ -93,6 +94,10 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 	return sd->s_flags & SYSFS_TYPE_MASK;
 }
 
+/*
+ * Return any namespace tags on this dirent.
+ * enum kobj_ns_type is defined in linux/kobject.h
+ */
 static inline enum kobj_ns_type sysfs_ns_type(struct sysfs_dirent *sd)
 {
 	return (sd->s_flags & SYSFS_NS_TYPE_MASK) >> SYSFS_NS_TYPE_SHIFT;
@@ -123,6 +128,12 @@ struct sysfs_addrm_cxt {
 /*
  * mount.c
  */
+
+/*
+ * Each sb is associated with a set of namespace tags (i.e.
+ * the network namespace of the task which mounted this sysfs
+ * instance).
+ */
 struct sysfs_super_info {
 	const void *ns[KOBJ_NS_TYPES];
 };
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index d9456f6..b60d2df 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -136,12 +136,23 @@ struct kobj_attribute {
 
 extern const struct sysfs_ops kobj_sysfs_ops;
 
+/*
+ * Namespace types which are used to tag kobjects and sysfs entries.
+ * Network namespace will likely be the first.
+ */
 enum kobj_ns_type {
 	KOBJ_NS_TYPE_NONE = 0,
 	KOBJ_NS_TYPES
 };
 
 struct sock;
+
+/*
+ * Callbacks so sysfs can determine namespaces
+ *   @current_ns: return calling task's namespace
+ *   @netlink_ns: return namespace to which a sock belongs (right?)
+ *   @initial_ns: return the initial namespace (i.e. init_net_ns)
+ */
 struct kobj_ns_type_operations {
 	enum kobj_ns_type type;
 	const void *(*current_ns)(void);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 976c466..47f1c95 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -178,6 +178,7 @@ struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd);
 void sysfs_put(struct sysfs_dirent *sd);
 void sysfs_printk_last_file(void);
 
+/* Called to clear a ns tag when it is no longer valid */
 void sysfs_exit_ns(enum kobj_ns_type type, const void *tag);
 
 int __must_check sysfs_init(void);
diff --git a/lib/kobject.c b/lib/kobject.c
index b2c6d1f..f07c572 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -948,6 +948,17 @@ const void *kobj_ns_initial(enum kobj_ns_type type)
 	return ns;
 }
 
+/*
+ * kobj_ns_exit - invalidate a namespace tag
+ *
+ * @type: the namespace type (i.e. KOBJ_NS_TYPE_NET)
+ * @ns: the actual namespace being invalidated
+ *
+ * This is called when a tag is no longer valid.  For instance,
+ * when a network namespace exits, it uses this helper to
+ * make sure no sb's sysfs_info points to the now-invalidated
+ * netns.
+ */
 void kobj_ns_exit(enum kobj_ns_type type, const void *ns)
 {
 	sysfs_exit_ns(type, ns);
-- 
1.7.0.3

