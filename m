Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2ITCN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:13:29 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60541 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab2ITCLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:31 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Sep 2012 18:52:22 -0700
Message-Id: <1348105949-25454-20-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19VXiGFVu/qofK1vjVf0mlnTVo3dFTCAJY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2333]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 20/27] userns: Add kprojid_t and associated infrastructure in projid.h
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Implement kprojid_t a cousin of the kuid_t and kgid_t.

The per user namespace mapping of project id values can be set with
/proc/<pid>/projid_map.

A full compliment of helpers is provided: make_kprojid, from_kprojid,
from_kprojid_munged, kporjid_has_mapping, projid_valid, projid_eq,
projid_eq, projid_lt.

Project identifiers are part of the generic disk quota interface,
although it appears only xfs implements project identifiers currently.

The xfs code allows anyone who has permission to set the project
identifier on a file to use any project identifier so when
setting up the user namespace project identifier mappings I do
not require a capability.

Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/base.c                 |   15 +++++
 include/linux/projid.h         |  104 ++++++++++++++++++++++++++++++++
 include/linux/user_namespace.h |    3 +
 kernel/user.c                  |    8 +++
 kernel/user_namespace.c        |  128 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 257 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/projid.h

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 138cff4..acd1960 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2991,6 +2991,11 @@ static int proc_gid_map_open(struct inode *inode, struct file *file)
 	return proc_id_map_open(inode, file, &proc_gid_seq_operations);
 }
 
+static int proc_projid_map_open(struct inode *inode, struct file *file)
+{
+	return proc_id_map_open(inode, file, &proc_projid_seq_operations);
+}
+
 static const struct file_operations proc_uid_map_operations = {
 	.open		= proc_uid_map_open,
 	.write		= proc_uid_map_write,
@@ -3006,6 +3011,14 @@ static const struct file_operations proc_gid_map_operations = {
 	.llseek		= seq_lseek,
 	.release	= proc_id_map_release,
 };
+
+static const struct file_operations proc_projid_map_operations = {
+	.open		= proc_projid_map_open,
+	.write		= proc_projid_map_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_id_map_release,
+};
 #endif /* CONFIG_USER_NS */
 
 static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
@@ -3113,6 +3126,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_USER_NS
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
+	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 #endif
 };
 
@@ -3476,6 +3490,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_USER_NS
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
+	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 #endif
 };
 
diff --git a/include/linux/projid.h b/include/linux/projid.h
new file mode 100644
index 0000000..36517b9
--- /dev/null
+++ b/include/linux/projid.h
@@ -0,0 +1,104 @@
+#ifndef _LINUX_PROJID_H
+#define _LINUX_PROJID_H
+
+/*
+ * A set of types for the internal kernel types representing project ids.
+ *
+ * The types defined in this header allow distinguishing which project ids in
+ * the kernel are values used by userspace and which project id values are
+ * the internal kernel values.  With the addition of user namespaces the values
+ * can be different.  Using the type system makes it possible for the compiler
+ * to detect when we overlook these differences.
+ *
+ */
+#include <linux/types.h>
+
+struct user_namespace;
+extern struct user_namespace init_user_ns;
+
+typedef __kernel_uid32_t projid_t;
+
+#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
+
+typedef struct {
+	projid_t val;
+} kprojid_t;
+
+static inline projid_t __kprojid_val(kprojid_t projid)
+{
+	return projid.val;
+}
+
+#define KPROJIDT_INIT(value) (kprojid_t){ value }
+
+#else
+
+typedef projid_t kprojid_t;
+
+static inline projid_t __kprojid_val(kprojid_t projid)
+{
+	return projid;
+}
+
+#define KPROJIDT_INIT(value) ((kprojid_t) value )
+
+#endif
+
+#define INVALID_PROJID KPROJIDT_INIT(-1)
+#define OVERFLOW_PROJID 65534
+
+static inline bool projid_eq(kprojid_t left, kprojid_t right)
+{
+	return __kprojid_val(left) == __kprojid_val(right);
+}
+
+static inline bool projid_lt(kprojid_t left, kprojid_t right)
+{
+	return __kprojid_val(left) < __kprojid_val(right);
+}
+
+static inline bool projid_valid(kprojid_t projid)
+{
+	return !projid_eq(projid, INVALID_PROJID);
+}
+
+#ifdef CONFIG_USER_NS
+
+extern kprojid_t make_kprojid(struct user_namespace *from, projid_t projid);
+
+extern projid_t from_kprojid(struct user_namespace *to, kprojid_t projid);
+extern projid_t from_kprojid_munged(struct user_namespace *to, kprojid_t projid);
+
+static inline bool kprojid_has_mapping(struct user_namespace *ns, kprojid_t projid)
+{
+	return from_kprojid(ns, projid) != (projid_t)-1;
+}
+
+#else
+
+static inline kprojid_t make_kprojid(struct user_namespace *from, projid_t projid)
+{
+	return KPROJIDT_INIT(projid);
+}
+
+static inline projid_t from_kprojid(struct user_namespace *to, kprojid_t kprojid)
+{
+	return __kprojid_val(kprojid);
+}
+
+static inline projid_t from_kprojid_munged(struct user_namespace *to, kprojid_t kprojid)
+{
+	projid_t projid = from_kprojid(to, kprojid);
+	if (projid == (projid_t)-1)
+		projid = OVERFLOW_PROJID;
+	return projid;
+}
+
+static inline bool kprojid_has_mapping(struct user_namespace *ns, kprojid_t projid)
+{
+	return true;
+}
+
+#endif /* CONFIG_USER_NS */
+
+#endif /* _LINUX_PROJID_H */
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 4e72922..95142ca 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -20,6 +20,7 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
 struct user_namespace {
 	struct uid_gid_map	uid_map;
 	struct uid_gid_map	gid_map;
+	struct uid_gid_map	projid_map;
 	struct kref		kref;
 	struct user_namespace	*parent;
 	kuid_t			owner;
@@ -49,8 +50,10 @@ static inline void put_user_ns(struct user_namespace *ns)
 struct seq_operations;
 extern struct seq_operations proc_uid_seq_operations;
 extern struct seq_operations proc_gid_seq_operations;
+extern struct seq_operations proc_projid_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
+extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
diff --git a/kernel/user.c b/kernel/user.c
index b815fef..750acff 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -38,6 +38,14 @@ struct user_namespace init_user_ns = {
 			.count = 4294967295U,
 		},
 	},
+	.projid_map = {
+		.nr_extents = 1,
+		.extent[0] = {
+			.first = 0,
+			.lower_first = 0,
+			.count = 4294967295U,
+		},
+	},
 	.kref = {
 		.refcount	= ATOMIC_INIT(3),
 	},
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 8660231..456a6b9 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -19,6 +19,7 @@
 #include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <linux/ctype.h>
+#include <linux/projid.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
 
@@ -295,6 +296,75 @@ gid_t from_kgid_munged(struct user_namespace *targ, kgid_t kgid)
 }
 EXPORT_SYMBOL(from_kgid_munged);
 
+/**
+ *	make_kprojid - Map a user-namespace projid pair into a kprojid.
+ *	@ns:  User namespace that the projid is in
+ *	@projid: Project identifier
+ *
+ *	Maps a user-namespace uid pair into a kernel internal kuid,
+ *	and returns that kuid.
+ *
+ *	When there is no mapping defined for the user-namespace projid
+ *	pair INVALID_PROJID is returned.  Callers are expected to test
+ *	for and handle handle INVALID_PROJID being returned.  INVALID_PROJID
+ *	may be tested for using projid_valid().
+ */
+kprojid_t make_kprojid(struct user_namespace *ns, projid_t projid)
+{
+	/* Map the uid to a global kernel uid */
+	return KPROJIDT_INIT(map_id_down(&ns->projid_map, projid));
+}
+EXPORT_SYMBOL(make_kprojid);
+
+/**
+ *	from_kprojid - Create a projid from a kprojid user-namespace pair.
+ *	@targ: The user namespace we want a projid in.
+ *	@kprojid: The kernel internal project identifier to start with.
+ *
+ *	Map @kprojid into the user-namespace specified by @targ and
+ *	return the resulting projid.
+ *
+ *	There is always a mapping into the initial user_namespace.
+ *
+ *	If @kprojid has no mapping in @targ (projid_t)-1 is returned.
+ */
+projid_t from_kprojid(struct user_namespace *targ, kprojid_t kprojid)
+{
+	/* Map the uid from a global kernel uid */
+	return map_id_up(&targ->projid_map, __kprojid_val(kprojid));
+}
+EXPORT_SYMBOL(from_kprojid);
+
+/**
+ *	from_kprojid_munged - Create a projiid from a kprojid user-namespace pair.
+ *	@targ: The user namespace we want a projid in.
+ *	@kprojid: The kernel internal projid to start with.
+ *
+ *	Map @kprojid into the user-namespace specified by @targ and
+ *	return the resulting projid.
+ *
+ *	There is always a mapping into the initial user_namespace.
+ *
+ *	Unlike from_kprojid from_kprojid_munged never fails and always
+ *	returns a valid projid.  This makes from_kprojid_munged
+ *	appropriate for use in syscalls like stat and where
+ *	failing the system call and failing to provide a valid projid are
+ *	not an options.
+ *
+ *	If @kprojid has no mapping in @targ OVERFLOW_PROJID is returned.
+ */
+projid_t from_kprojid_munged(struct user_namespace *targ, kprojid_t kprojid)
+{
+	projid_t projid;
+	projid = from_kprojid(targ, kprojid);
+
+	if (projid == (projid_t) -1)
+		projid = OVERFLOW_PROJID;
+	return projid;
+}
+EXPORT_SYMBOL(from_kprojid_munged);
+
+
 static int uid_m_show(struct seq_file *seq, void *v)
 {
 	struct user_namespace *ns = seq->private;
@@ -337,6 +407,27 @@ static int gid_m_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static int projid_m_show(struct seq_file *seq, void *v)
+{
+	struct user_namespace *ns = seq->private;
+	struct uid_gid_extent *extent = v;
+	struct user_namespace *lower_ns;
+	projid_t lower;
+
+	lower_ns = seq_user_ns(seq);
+	if ((lower_ns == ns) && lower_ns->parent)
+		lower_ns = lower_ns->parent;
+
+	lower = from_kprojid(lower_ns, KPROJIDT_INIT(extent->lower_first));
+
+	seq_printf(seq, "%10u %10u %10u\n",
+		extent->first,
+		lower,
+		extent->count);
+
+	return 0;
+}
+
 static void *m_start(struct seq_file *seq, loff_t *ppos, struct uid_gid_map *map)
 {
 	struct uid_gid_extent *extent = NULL;
@@ -362,6 +453,13 @@ static void *gid_m_start(struct seq_file *seq, loff_t *ppos)
 	return m_start(seq, ppos, &ns->gid_map);
 }
 
+static void *projid_m_start(struct seq_file *seq, loff_t *ppos)
+{
+	struct user_namespace *ns = seq->private;
+
+	return m_start(seq, ppos, &ns->projid_map);
+}
+
 static void *m_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	(*pos)++;
@@ -387,6 +485,13 @@ struct seq_operations proc_gid_seq_operations = {
 	.show = gid_m_show,
 };
 
+struct seq_operations proc_projid_seq_operations = {
+	.start = projid_m_start,
+	.stop = m_stop,
+	.next = m_next,
+	.show = projid_m_show,
+};
+
 static DEFINE_MUTEX(id_map_mutex);
 
 static ssize_t map_write(struct file *file, const char __user *buf,
@@ -434,7 +539,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	/* Require the appropriate privilege CAP_SETUID or CAP_SETGID
 	 * over the user namespace in order to set the id mapping.
 	 */
-	if (!ns_capable(ns, cap_setid))
+	if (cap_valid(cap_setid) && !ns_capable(ns, cap_setid))
 		goto out;
 
 	/* Get a buffer */
@@ -584,9 +689,30 @@ ssize_t proc_gid_map_write(struct file *file, const char __user *buf, size_t siz
 			 &ns->gid_map, &ns->parent->gid_map);
 }
 
+ssize_t proc_projid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+{
+	struct seq_file *seq = file->private_data;
+	struct user_namespace *ns = seq->private;
+	struct user_namespace *seq_ns = seq_user_ns(seq);
+
+	if (!ns->parent)
+		return -EPERM;
+
+	if ((seq_ns != ns) && (seq_ns != ns->parent))
+		return -EPERM;
+
+	/* Anyone can set any valid project id no capability needed */
+	return map_write(file, buf, size, ppos, -1,
+			 &ns->projid_map, &ns->parent->projid_map);
+}
+
 static bool new_idmap_permitted(struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
+	/* Allow anyone to set a mapping that doesn't require privilege */
+	if (!cap_valid(cap_setid))
+		return true;
+
 	/* Allow the specified ids if we have the appropriate capability
 	 * (CAP_SETUID or CAP_SETGID) over the parent user namespace.
 	 */
-- 
1.7.5.4

