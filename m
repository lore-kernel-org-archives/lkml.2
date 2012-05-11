Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab2EKM0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:26:50 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23732 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758632Ab2EKM0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:26:05 -0400
Message-ID: <4FAD0555.4090906@parallels.com>
Date: Fri, 11 May 2012 16:25:57 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] ns: Add proc_ns_operations for mount namespaces
References: <4FAD0524.3000307@parallels.com>
In-Reply-To: <4FAD0524.3000307@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently LXC by default creates a container in a new mount
namespace. Thus in order to explore it we have to

a) find out, that a new mount namespace is in use
b) enter this other namespace

This patch solves both -- allows us to distinguish one mount
namespace from another by comparing its inode numbers and lets
us enter a mount namespace with the setns system call.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
---
 fs/namespace.c          |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/namespaces.c    |    1 +
 include/linux/proc_fs.h |    2 ++
 3 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e608199..9467904 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -20,6 +20,7 @@
 #include <linux/fs_struct.h>	/* get_fs_root et.al. */
 #include <linux/fsnotify.h>	/* fsnotify_vfsmount_delete */
 #include <linux/uaccess.h>
+#include <linux/proc_fs.h>
 #include "pnode.h"
 #include "internal.h"
 
@@ -2633,3 +2634,47 @@ bool our_mnt(struct vfsmount *mnt)
 {
 	return check_mnt(real_mount(mnt));
 }
+
+static void *mntns_get(struct task_struct *task)
+{
+	struct mnt_namespace *mn = NULL;
+	struct nsproxy *nsproxy;
+
+	rcu_read_lock();
+	nsproxy = task_nsproxy(task);
+	if (nsproxy) {
+		mn = nsproxy->mnt_ns;
+		get_mnt_ns(mn);
+	}
+	rcu_read_unlock();
+
+	return mn;
+}
+
+static void mntns_put(void *ns)
+{
+	put_mnt_ns(ns);
+}
+
+static int mntns_install(struct nsproxy *nsproxy, void *ns)
+{
+	put_mnt_ns(nsproxy->mnt_ns);
+	get_mnt_ns(ns);
+	nsproxy->mnt_ns = ns;
+	return 0;
+}
+
+static u64 mntns_get_id(void *_ns)
+{
+	struct mnt_namespace *ns = _ns;
+	return ns->root->mnt_id;
+}
+
+const struct proc_ns_operations mntns_operations = {
+	.name		= "mnt",
+	.type		= CLONE_NEWNS,
+	.get		= mntns_get,
+	.put		= mntns_put,
+	.install	= mntns_install,
+	.get_id		= mntns_get_id,
+};
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index b6c7560..e0399dd 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -24,6 +24,7 @@ static const struct proc_ns_operations *ns_entries[] = {
 #ifdef CONFIG_IPC_NS
 	&ipcns_operations,
 #endif
+	&mntns_operations,
 };
 
 static const struct file_operations ns_file_operations = {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index e5ee83a..f6311b4 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -252,6 +252,8 @@ struct proc_ns_operations {
 extern const struct proc_ns_operations netns_operations;
 extern const struct proc_ns_operations utsns_operations;
 extern const struct proc_ns_operations ipcns_operations;
+extern const struct proc_ns_operations mntns_operations;
+
 
 union proc_op {
 	int (*proc_get_link)(struct dentry *, struct path *);
-- 
1.7.6.5
