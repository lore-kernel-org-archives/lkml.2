Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1AaKZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:25:40 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:47973 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab1AaKZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:25:38 -0500
From: Daniel Lezcano <daniel.lezcano@free.fr>
To: akpm@linux-foundation.org
Cc: ebiederm@xmission.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        clg@fr.ibm.com
Subject: [PATCH 2/4] pidns: Call pid_ns_prepare_proc from create_pid_namespace
Date: Mon, 31 Jan 2011 11:25:23 +0100
Message-Id: <1296469525-30111-3-git-send-email-daniel.lezcano@free.fr>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296469525-30111-1-git-send-email-daniel.lezcano@free.fr>
References: <1296469525-30111-1-git-send-email-daniel.lezcano@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Reorganize proc_get_sb so it can be called before the struct pid
of the first process is allocated.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
---
 fs/proc/root.c         |   25 +++++++------------------
 kernel/fork.c          |    6 ------
 kernel/pid_namespace.c |    4 ++++
 3 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index ef9fa8e..e5e2bfa 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -43,17 +43,6 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 	struct pid_namespace *ns;
 	struct proc_inode *ei;
 
-	if (proc_mnt) {
-		/* Seed the root directory with a pid so it doesn't need
-		 * to be special in base.c.  I would do this earlier but
-		 * the only task alive when /proc is mounted the first time
-		 * is the init_task and it doesn't have any pids.
-		 */
-		ei = PROC_I(proc_mnt->mnt_sb->s_root->d_inode);
-		if (!ei->pid)
-			ei->pid = find_get_pid(1);
-	}
-
 	if (flags & MS_KERNMOUNT)
 		ns = (struct pid_namespace *)data;
 	else
@@ -71,16 +60,16 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 			return ERR_PTR(err);
 		}
 
-		ei = PROC_I(sb->s_root->d_inode);
-		if (!ei->pid) {
-			rcu_read_lock();
-			ei->pid = get_pid(find_pid_ns(1, ns));
-			rcu_read_unlock();
-		}
-
 		sb->s_flags |= MS_ACTIVE;
 	}
 
+	ei = PROC_I(sb->s_root->d_inode);
+	if (!ei->pid) {
+		rcu_read_lock();
+		ei->pid = get_pid(find_pid_ns(1, ns));
+		rcu_read_unlock();
+	}
+
 	return dget(sb->s_root);
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index c9f0784..e7a5907 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1180,12 +1180,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		pid = alloc_pid(p->nsproxy->pid_ns);
 		if (!pid)
 			goto bad_fork_cleanup_io;
-
-		if (clone_flags & CLONE_NEWPID) {
-			retval = pid_ns_prepare_proc(p->nsproxy->pid_ns);
-			if (retval < 0)
-				goto bad_fork_free_pid;
-		}
 	}
 
 	p->pid = pid_nr(pid);
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a5aff94..b90e4ab 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/acct.h>
 #include <linux/slab.h>
+#include <linux/proc_fs.h>
 
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 
@@ -96,6 +97,9 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
 	for (i = 1; i < PIDMAP_ENTRIES; i++)
 		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
 
+	if (pid_ns_prepare_proc(ns))
+		goto out_free_map;
+
 	return ns;
 
 out_free_map:
-- 
1.7.1

