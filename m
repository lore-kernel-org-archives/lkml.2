Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab1EGC0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:26:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35747 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab1EGCZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:25:57 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, jamal <hadi@cyberus.ca>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 2/7] ns: Introduce the setns syscall
Date: Fri,  6 May 2011 19:24:56 -0700
Message-Id: <1304735101-1824-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.1.217.g4e3aa
In-Reply-To: <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
 <1304735101-1824-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/rTMhO3EVBCradeI7sSzfrS4q0jQO4rrs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the networking stack today there is demand to handle
multiple network stacks at a time.  Not in the context
of containers but in the context of people doing interesting
things with routing.

There is also demand in the context of containers to have
an efficient way to execute some code in the container itself.
If nothing else it is very useful ad a debugging technique.

Both problems can be solved by starting some form of login
daemon in the namespaces people want access to, or you
can play games by ptracing a process and getting the
traced process to do things you want it to do. However
it turns out that a login daemon or a ptrace puppet
controller are more code, they are more prone to
failure, and generally they are less efficient than
simply changing the namespace of a process to a
specified one.

Pieces of this puzzle can also be solved by instead of
coming up with a general purpose system call coming up
with targed system calls perhaps socketat that solve
a subset of the larger problem.  Overall that appears
to be more work for less reward.

int setns(int fd, int nstype);

The fd argument is a file descriptor referring to a proc
file of the namespace you want to switch the process to.

In the setns system call the nstype is 0 or specifies
an clone flag of the namespace you intend to change
to prevent changing a namespace unintentionally.

v2: Most of the architecture support added by Daniel Lezcano <dlezcano@fr.ibm.com>
v3: ported to v2.6.36-rc4 by: Eric W. Biederman <ebiederm@xmission.com>
v4: Moved wiring up of the system call to another patch

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/nsproxy.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index a05d191..96059d8 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -22,6 +22,9 @@
 #include <linux/pid_namespace.h>
 #include <net/net_namespace.h>
 #include <linux/ipc_namespace.h>
+#include <linux/proc_fs.h>
+#include <linux/file.h>
+#include <linux/syscalls.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
@@ -233,6 +236,40 @@ void exit_task_namespaces(struct task_struct *p)
 	switch_task_namespaces(p, NULL);
 }
 
+SYSCALL_DEFINE2(setns, int, fd, int, nstype)
+{
+	const struct proc_ns_operations *ops;
+	struct task_struct *tsk = current;
+	struct nsproxy *new_nsproxy;
+	struct proc_inode *ei;
+	struct file *file;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	file = proc_ns_fget(fd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	err = -EINVAL;
+	ei = PROC_I(file->f_dentry->d_inode);
+	ops = ei->ns_ops;
+	if (nstype && (ops->type != nstype))
+		goto out;
+
+	new_nsproxy = create_new_namespaces(0, tsk, tsk->fs);
+	err = ops->install(new_nsproxy, ei->ns);
+	if (err) {
+		free_nsproxy(new_nsproxy);
+		goto out;
+	}
+	switch_task_namespaces(tsk, new_nsproxy);
+out:
+	fput(file);
+	return err;
+}
+
 static int __init nsproxy_cache_init(void)
 {
 	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
-- 
1.6.5.2.143.g8cc62

