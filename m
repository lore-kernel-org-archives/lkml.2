Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0D0UoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:44:19 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41405 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab0D0Unm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:43:42 -0400
Date: Tue, 27 Apr 2010 11:45:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>, David Howells <dhowells@redhat.com>,
       Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kyle Moffett <kyle@moffetthome.net>, Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH 3/3] RFC: p9auth: add p9auth fs
Message-ID: <20100427164517.GC7530@us.ibm.com>
References: <20100427164139.GA7359@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427164139.GA7359@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces a Plan 9 style setuid capability filesystem.
See Documentation/p9auth.txt for a description of how to use this.

This fs allows the implementation of completely unprivileged
login daemons.  However, doing so requires a fundamental change
regarding linux userids: a server privileged with the new
CAP_GRANT_ID capability can create a one-time setuid capability
allowing another process to change to one specific new userid.
This is a change which must be discussed.  The use of this
privilege can be completely prevented by having init remove
CAP_GRANT_ID from its capability bounding set before forking any
processes.

Changelog
  Apr 24:
	return commit_creds (David Howells)
	switch from dev to fs (Eric Biederman)
		and move p9auth from drivers/char into kernel/

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>
---
 Documentation/p9auth.txt |   42 ++++
 MAINTAINERS              |    6 +
 init/Kconfig             |    2 +
 kernel/Kconfig.p9auth    |    9 +
 kernel/Makefile          |    1 +
 kernel/p9auth.c          |  464 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 524 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/p9auth.txt
 create mode 100644 kernel/Kconfig.p9auth
 create mode 100644 kernel/p9auth.c

diff --git a/Documentation/p9auth.txt b/Documentation/p9auth.txt
new file mode 100644
index 0000000..9e9f674
--- /dev/null
+++ b/Documentation/p9auth.txt
@@ -0,0 +1,42 @@
+The p9auth filesystem provides a plan-9 factotum-like setuid capability
+API.  Tasks which are privileged (authorized by possession of the
+CAP_GRANT_ID privilege (POSIX capability)) can write new capabilities to
+the p9authfs file called cred_grant.  The kernel then stores these until
+a task uses them by writing to the cred_use file.  Each capability
+represents the ability for a task running as userid X to switch to
+userid Y and some set of groups.  Each capability may be used only once,
+and unused capabilities are cleared after two minutes.
+
+The following examples shows how to use the API.  Shell 1 contains a
+privileged root shell.  Shell 2 contains an unprivileged shell as user
+501 in the same user namespace.  If not already done, the privileged
+shell should mount the p9auth filesystem:
+
+	mkdir /mnt/p9auth
+	mount -t p9auth p9auth /mnt/p9auth
+
+Now shell 2 somehow communicates to shell 1 that it possesses valid
+login credentials to switch to userid 502.  Shell 2 then looks up the
+groups which uid 502 is a member of, and builds a capability string to
+pass to the kernel.  It does this by concatenating the old userid, new
+userid, new primary group, number of auxiliary groups, and each
+auxiliary group, all as integers separated by '@'.  The resulting string
+is hashed with a random string.  In our example, userid 501 may
+transition to userid 502, with primary group 502 and auxiliary group 29.
+
+	capstr="501@502@502@1@29"
+	echo -n "$capstr" > /tmp/txtfile
+	randstr=`dd if=/dev/urandom count=1 2>/dev/null | \
+			uuencode -m - | head -n 2 | tail -n 1 | cut -c -8 `
+	openssl sha1 -hmac "$randstr" /tmp/txtfile | awk '{ print $2 '} \
+		> /tmp/hex
+	./unhex < /tmp/hex > /mnt/p9auth/cred_grant
+
+Note that to use an empty set of auxiliary groups, you may use
+	capstr = "501@502@02@0"
+
+The source for unhex.c can be found in the ltp testsuite under
+ltp-dev/testcases/kernel/security/p9auth.  To shell 2 it passes $capstr
+and $randstr.  Shell 2 can then transition to the new userid by doing
+
+	echo -n "$capstr@$randstr" > /mnt/p9auth/cred_use
diff --git a/MAINTAINERS b/MAINTAINERS
index a0e3c3a..6bc1bd9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4209,6 +4209,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 F:	drivers/net/wireless/p54/
 
+P9AUTH setuid capability filesystem
+M:	serue@us.ibm.com
+L:	linux-security-module@vger.kernel.org (suggested Cc:)
+S:	Maintained
+F:	kernel/p9auth.c
+
 PA SEMI ETHERNET DRIVER
 M:	Olof Johansson <olof@lixom.net>
 L:	netdev@vger.kernel.org
diff --git a/init/Kconfig b/init/Kconfig
index eb77e8c..bc7f1da 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -715,6 +715,8 @@ config NET_NS
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
 
+source "kernel/Kconfig.p9auth"
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
diff --git a/kernel/Kconfig.p9auth b/kernel/Kconfig.p9auth
new file mode 100644
index 0000000..d1c66d2
--- /dev/null
+++ b/kernel/Kconfig.p9auth
@@ -0,0 +1,9 @@
+config PLAN9AUTH
+	tristate "Plan 9 style capability device implementation"
+	default n
+	depends on CRYPTO
+	help
+	  This module implements the Plan 9 style capability device.
+
+	  To compile this driver as a module, choose
+	  M here: the module will be called p9auth.
diff --git a/kernel/Makefile b/kernel/Makefile
index a987aa1..d27dae3 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_PLAN9AUTH) += p9auth.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/p9auth.c b/kernel/p9auth.c
new file mode 100644
index 0000000..a174373
--- /dev/null
+++ b/kernel/p9auth.c
@@ -0,0 +1,464 @@
+/*
+ * Plan 9 style setuid capability implementation for the Linux Kernel
+ *
+ * Copyright 2009, 2010 Serge Hallyn <serue@us.ibm.com>
+ * Copyright 2008, 2009 Ashwin Ganti <ashwin.ganti@gmail.com>
+ *
+ * Released under the GPLv2
+ *
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/fcntl.h>
+#include <linux/uaccess.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/crypto.h>
+#include <linux/highmem.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <linux/user_namespace.h>
+
+#define MAX_DIGEST_SIZE  20
+
+struct cap_node {
+	char data[MAX_DIGEST_SIZE];
+	struct user_namespace *user_ns;
+	unsigned long time_created;
+	struct list_head list;
+};
+
+/* make CAP_HASH_COUNT_LIM configurable sometime, and per-userns */
+
+#define CAP_HASH_COUNT_LIM 4000
+
+/*
+ * cap_list, the list of valid capability tokens
+ * todo: move into user_namespace?
+ */
+static LIST_HEAD(cap_list);
+static int cap_hash_count;  /* number of entries cap_list */
+
+/*
+ * Locking: writing to both /cred_grant and /cred_use are done
+ * entirely under cap_mutex.  So the cap_list and cap_hash_count
+ * are protected by the mutex.  These are not fast paths, so a
+ * mutex is just fine.
+ *
+ * Writing to cred_crant only adds an entry to the list, so is safe.
+ * Writing to cred_use only updates current's credentials.
+ */
+static DEFINE_MUTEX(cap_mutex);
+
+MODULE_AUTHOR("Ashwin Ganti");
+MODULE_LICENSE("GPL");
+
+static char *cap_hash(char *plain_text, unsigned int plain_text_size,
+		      char *key, unsigned int key_size)
+{
+	struct scatterlist sg;
+	char *result;
+	struct crypto_hash *tfm;
+	struct hash_desc desc;
+	int ret;
+
+	tfm = crypto_alloc_hash("hmac(sha1)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR
+		       "failed to load transform for hmac(sha1): %ld\n",
+		       PTR_ERR(tfm));
+		return NULL;
+	}
+
+	desc.tfm = tfm;
+	desc.flags = 0;
+
+	result = kzalloc(MAX_DIGEST_SIZE, GFP_KERNEL);
+	if (!result) {
+		printk(KERN_ERR "out of memory!\n");
+		goto out;
+	}
+
+	sg_set_buf(&sg, plain_text, plain_text_size);
+
+	ret = crypto_hash_setkey(tfm, key, key_size);
+	if (ret) {
+		printk(KERN_ERR "setkey() failed ret=%d\n", ret);
+		kfree(result);
+		result = NULL;
+		goto out;
+	}
+
+	ret = crypto_hash_digest(&desc, &sg, plain_text_size, result);
+	if (ret) {
+		printk(KERN_ERR "digest () failed ret=%d\n", ret);
+		kfree(result);
+		result = NULL;
+		goto out;
+	}
+
+out:
+	crypto_free_hash(tfm);
+	return result;
+}
+
+struct id_set {
+	char *source_user, *target_user;
+	uid_t old_uid, new_uid;
+	gid_t new_gid;
+	unsigned int ngroups;
+	struct group_info *newgroups;
+	char *full;  /* The full entry which must be freed */
+};
+
+/*
+ * read an entry, which is of the form:
+ * source_user@target_user@target_group@numgroups@grp1..@grpn@rand
+ * and put all the values into the supplied id_set.
+ */
+static int parse_user_capability(char *s, struct id_set *set)
+{
+	char *tmp, *tmpu;
+	int i, ret;
+	unsigned long res;
+
+	tmpu = set->full = kstrdup(s, GFP_KERNEL);
+	if (!tmpu)
+		return -ENOMEM;
+
+	ret = -EINVAL;
+	set->source_user = strsep(&tmpu, "@");
+	set->target_user = strsep(&tmpu, "@");
+	tmp = strsep(&tmpu, "@");
+	if (!set->source_user || !set->target_user || !tmp)
+		goto out;
+
+	if (strict_strtoul(set->target_user, 0, &res))
+		goto out;
+	set->new_uid = (uid_t) res;
+	if (strict_strtoul(set->source_user, 0, &res))
+		goto out;
+	set->old_uid = (uid_t) res;
+	if (strict_strtoul(tmp, 0, &res))
+		goto out;
+	set->new_gid = (gid_t) res;
+
+	tmp = strsep(&tmpu, "@");
+	if (!tmp)
+		goto out;
+	if (sscanf(tmp, "%d", &set->ngroups) != 1 || set->ngroups < 0)
+		goto out;
+
+	ret = -ENOMEM;
+	set->newgroups = groups_alloc(set->ngroups);
+	if (!set->newgroups)
+		goto out;
+
+	ret = -EINVAL;
+	for (i = 0; i < set->ngroups; i++) {
+		gid_t g;
+
+		tmp = strsep(&tmpu, "@");
+		if (!tmp || sscanf(tmp, "%d", &g) != 1) {
+			groups_free(set->newgroups);
+			goto out;
+		}
+		GROUP_AT(set->newgroups, i) = g;
+	}
+
+	ret = 0;
+
+out:
+	kfree(set->full);
+	return ret;
+}
+
+static int apply_setuid_capability(struct id_set *set)
+{
+	struct cred *new;
+	int ret;
+
+	/*
+	 * Check whether the process writing to capuse
+	 * is actually owned by the source owner
+	 */
+	if (set->old_uid != current_uid()) {
+		printk(KERN_ALERT
+			"p9auth: process %d may switch from uid %d to %d, "
+			" but is uid %d (denied).\n", current->pid,
+			set->old_uid, set->new_uid, current_uid());
+		return -EFAULT;
+	}
+
+	/*
+	 * Change uid, euid, and fsuid.  The suid remains for
+	 * flexibility - though I'm torn as to the tradeoff of
+	 * usefulness vs. danger in that.
+	 */
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	ret = set_groups(new, set->newgroups);
+	if (!ret)
+		ret = cred_setresgid(new, set->new_gid, set->new_gid,
+				     set->new_gid, CRED_SETID_FORCE);
+	if (!ret)
+		ret = cred_setresuid(new, set->new_uid, set->new_uid,
+				     set->new_uid, CRED_SETID_FORCE);
+	if (ret == 0)
+		return commit_creds(new);
+	abort_creds(new);
+	return ret;
+}
+
+/* Delete a capability entry from the list */
+static void del_cap_node(struct cap_node *node)
+{
+	list_del(&node->list);
+	put_user_ns(node->user_ns);
+	kfree(node);
+	cap_hash_count--;
+}
+
+/* Expose this through sysctl eventually?  2 min timeout for hashes */
+static int cap_timeout = 120;
+
+/* Remove unused entries older tha (cap_timeout) seconds */
+static void remove_stale_entries(void)
+{
+	struct cap_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &cap_list, list)
+		if (node->time_created + HZ * cap_timeout < jiffies)
+			del_cap_node(node);
+}
+
+/*
+ * There are CAP_HASH_COUNT_LIM (4k) entries -
+ *   trim the 5 oldest even though newer than cap_timeout
+ */
+static void trim_oldest_entries(void)
+{
+	struct cap_node *node, *tmp;
+	int i = 0;
+
+	list_for_each_entry_safe(node, tmp, &cap_list, list)  {
+		if (++i > 5)
+			break;
+		del_cap_node(node);
+	}
+}
+
+/*
+ * Add a capability hash entry to the list - called by the
+ * privileged factotum server.  Called with cap_mutex held.
+ */
+static int grant_setuid_capability(char *user_buf, size_t count)
+{
+	struct cap_node *node_ptr;
+
+	if (count > MAX_DIGEST_SIZE)
+		return -EINVAL;
+	if (!capable(CAP_GRANT_ID))
+		return -EPERM;
+	node_ptr = kmalloc(sizeof(struct cap_node), GFP_KERNEL);
+	if (!node_ptr)
+		return -ENOMEM;
+
+	memcpy(node_ptr->data, user_buf, count);
+	node_ptr->user_ns = get_user_ns(current_user_ns());
+	node_ptr->time_created = jiffies;
+	list_add(&(node_ptr->list), &(cap_list));
+	cap_hash_count++;
+	remove_stale_entries();
+	if (cap_hash_count > CAP_HASH_COUNT_LIM)
+		trim_oldest_entries();
+
+	return 0;
+}
+
+/*
+ * Use a capability hash entry from the list - called by the
+ * unprivileged login daemon.  Called with cap_mutex held.
+ */
+static int use_setuid_capability(char *ubuf)
+{
+	struct cap_node *node;
+	struct id_set set;
+	int ret, found = 0;
+	char *hashed = NULL, *sep;
+	struct list_head *pos;
+
+	if (list_empty(&(cap_list)))
+		return -EINVAL;
+
+	ret = parse_user_capability(ubuf, &set);
+	if (ret)
+		return ret;
+
+	/*
+	 * hash the string user1@user2@ngrp@grp... with randstr as the key
+	 * XXX is there any vulnerability we're opening ourselves up to by
+	 * not rebuilding the string from its components?
+	 */
+	sep = strrchr(ubuf, '@');
+	if (sep) {
+		char *rand = sep + 1;
+		*sep = '\0';
+		hashed = cap_hash(ubuf, strlen(ubuf), rand, strlen(rand));
+	}
+	if (NULL == hashed) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Change the process's uid if the hash is present in the
+	 * list of hashes
+	 */
+	list_for_each(pos, &(cap_list)) {
+		node = list_entry(pos, struct cap_node, list);
+		if (current_user_ns() != node->user_ns)
+			continue;
+		if (0 == memcmp(hashed, node->data, MAX_DIGEST_SIZE)) {
+			ret = apply_setuid_capability(&set);
+			if (ret < 0)
+				goto out;
+
+			/* Capability may only be used once */
+			del_cap_node(node);
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		printk(KERN_ALERT
+		       "Invalid capabiliy written to /dev/capuse\n");
+		ret = -EFAULT;
+	}
+out:
+	put_group_info(set.newgroups);
+	kfree(hashed);
+	return ret;
+}
+
+static ssize_t p9auth_grant_write(struct file *file, const char __user *buffer,
+			       size_t count, loff_t *ppos)
+{
+	ssize_t retval = -ENOMEM;
+	char *user_buf;
+
+	if (mutex_lock_interruptible(&cap_mutex))
+		return -EINTR;
+
+	user_buf = kzalloc(count+1, GFP_KERNEL);
+	if (!user_buf)
+		goto out;
+
+	if (copy_from_user(user_buf, buffer, count)) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	retval = grant_setuid_capability(user_buf, count);
+
+	*ppos += count;
+	retval = count;
+
+out:
+	kfree(user_buf);
+	mutex_unlock(&cap_mutex);
+	return retval;
+}
+
+static const struct file_operations p9auth_grant_operations = {
+	.write		= p9auth_grant_write,
+};
+
+static ssize_t p9auth_use_write(struct file *file, const char __user *buffer,
+			       size_t count, loff_t *ppos)
+{
+	ssize_t retval = -ENOMEM;
+	char *user_buf;
+
+	if (mutex_lock_interruptible(&cap_mutex))
+		return -EINTR;
+
+	user_buf = kzalloc(count+1, GFP_KERNEL);
+	if (!user_buf)
+		goto out;
+
+	if (copy_from_user(user_buf, buffer, count)) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	retval = use_setuid_capability(user_buf);
+
+	*ppos += count;
+	retval = count;
+
+out:
+	kfree(user_buf);
+	mutex_unlock(&cap_mutex);
+	return retval;
+}
+
+static const struct file_operations p9auth_use_operations = {
+	.write		= p9auth_use_write,
+};
+
+#define P9AUTHFS_MAGIC 0xbc148c66
+
+static int p9auth_fill_super(struct super_block *sb, void *data, int silent)
+{
+	static struct tree_descr files[] = {
+		[2] = {"cred_grant", &p9auth_grant_operations, S_IWUSR},
+		[3] = {"cred_use", &p9auth_use_operations, S_IWUGO},
+		{""}
+	};
+
+	return simple_fill_super(sb, P9AUTHFS_MAGIC, files);
+}
+
+static int p9auth_get_sb(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_nodev(fs_type, flags, data, p9auth_fill_super, mnt);
+}
+
+static struct file_system_type p9auth_fs_type = {
+	.owner = THIS_MODULE,
+	.name = "p9auth",
+	.get_sb = p9auth_get_sb,
+	.kill_sb = kill_litter_super,
+};
+
+/* delete all hashed entries (at module exit) */
+static void clear_setuid_capabilities(void)
+{
+	struct cap_node *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &cap_list, list)
+		del_cap_node(node);
+}
+
+/* no __exit here because it can be called by the init function */
+static void cap_cleanup_module(void)
+{
+	clear_setuid_capabilities();
+	unregister_filesystem(&p9auth_fs_type);
+}
+
+static int __init cap_init_module(void)
+{
+	return register_filesystem(&p9auth_fs_type);
+}
+
+module_init(cap_init_module);
+module_exit(cap_cleanup_module);
-- 
1.7.0.4

