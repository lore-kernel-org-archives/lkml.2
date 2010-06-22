Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab0FVPRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:17:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36749 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab0FVPRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=G7sGNZ56hruHQ0PE+YzPmCTg83mRF0Ny4k8qpxAdtseX3X4+QSAIe19MVheGY2vMEr
         T2U+WAFJd2e/vXJ2BuxZmDLYE7zvCcMV8rq9kDuKO9d3DeA1mtlPnayYPNPS9a4zXBCc
         UcjguLbwsD3OpCVIUKZdCoJM01oB1Zz3hXdqI=
Message-ID: <4C20D1AE.5000205@ring3k.org>
Date: Wed, 23 Jun 2010 00:07:26 +0900
From: Mike McCormack <mikem@ring3k.org>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: oleg@redhat.com, kosaki.motohiro@jp.fujitsu.com, serue@us.ibm.com,
       jmorris@namei.org, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: Add complete process group list
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a process is in more than NGROUPS_SMALL (32) groups, it's not possible
 for any other user space process to determine the list of groups it is
 in using /proc/<pid>/status.

Increasing the list of groups listed by /proc/<pid>/status would lead to
 very long lines that file, and possible misbehavior of userspace programs
 that parse /proc/<pid>/status, so instead I have opted to create a new
 file /proc/<pid>/groups, which contains the list of supplementary groups
 for each pid.

The new file /proc/<pid>/groups consists of a single group id per line,
 with each line being 11 characters long.  This should be enough space
 for 16bit or 32bit group ids.

This feature might be useful for a server listening on a unix domain pipe
 to determine the list of groups that a client process is in from its pid.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 fs/proc/base.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index acb7ef8..689362c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -82,6 +82,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/cred.h>
+
 #include "internal.h"
 
 /* NOTE:
@@ -1325,6 +1327,57 @@ static const struct file_operations proc_pid_set_comm_operations = {
 	.release	= single_release,
 };
 
+/* supplementary groups, one per line */
+static int groups_proc_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct group_info *group_info;
+	struct task_struct *task;
+	const struct cred *cred;
+	struct pid *pid;
+	unsigned int g;
+
+	pid = proc_pid(inode);
+	task = get_pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		return -ESRCH;
+
+	cred = get_task_cred(task);
+	group_info = cred->group_info;
+
+	/*
+	 * Groups may be 16bit or 32bit.
+	 * Try to be easily machine and human readable.
+	 */
+	for (g = 0; g < group_info->ngroups; g++)
+		seq_printf(m, "%-10u\n", GROUP_AT(group_info, g));
+
+	put_cred(cred);
+	put_task_struct(task);
+
+	return 0;
+}
+
+static int groups_proc_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+
+	ret = single_open(filp, groups_proc_show, NULL);
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+
+		m->private = inode;
+	}
+	return ret;
+}
+
+static const struct file_operations proc_groups_operations = {
+	.open		= groups_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * We added or removed a vma mapping the executable. The vmas are only mapped
  * during exec and are not mapped with the mmap system call.
@@ -2586,6 +2639,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
+	REG("groups",     S_IRUSR, proc_groups_operations),
 	REG("maps",       S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, proc_numa_maps_operations),
@@ -2921,6 +2975,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
+	REG("groups",    S_IRUSR, proc_groups_operations),
 	REG("maps",      S_IRUGO, proc_maps_operations),
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, proc_numa_maps_operations),
-- 
1.5.6.5

