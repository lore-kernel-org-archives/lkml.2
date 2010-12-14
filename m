Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab0LNKLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:11:55 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:33224 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491Ab0LNKLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:11:53 -0500
Date: Tue, 14 Dec 2010 15:42:04 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 11/21] Track the core generation requests
Message-ID: <20101214154204.21048247@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep track of the core generation requests. Concurrent core generation requests 
for the same target process are not allowed.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N.Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/gencore.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/proc/gencore.h |   12 +++++++
 2 files changed, 95 insertions(+), 2 deletions(-)

Index: linux-2.6.36-rc7/fs/proc/gencore.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.c
+++ linux-2.6.36-rc7/fs/proc/gencore.c
@@ -24,21 +24,102 @@
 
 #include <linux/seq_file.h>
 #include "internal.h"
+#include "gencore.h"
+
+static LIST_HEAD(core_list);
+static DEFINE_MUTEX(core_mutex);
+
+/* Called with core_mutex held */
+static struct core_proc* get_core_proc(struct task_struct *t)
+{
+	struct core_proc *cp;
+
+	list_for_each_entry(cp, &core_list, list) {
+		if (cp->task == t->group_leader)
+			return cp;
+	}
+	return NULL;
+}
 
 static ssize_t read_gencore(struct file *file, char __user *buffer,
 		size_t buflen, loff_t *fpos)
 {
-	return 0;
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct core_proc *cp;
+	ssize_t ret = 0;
+
+	if (!task)
+		return -EIO;
+
+	mutex_lock(&core_mutex);
+	cp = get_core_proc(task);
+	if (!cp) {
+		mutex_unlock(&core_mutex);
+		ret = -EIO;
+		goto out;
+	}
+	mutex_unlock(&core_mutex);
+
+out:
+	put_task_struct(task);
+	return ret;
 }
 
 static int release_gencore(struct inode *inode, struct file *file)
 {
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct core_proc *cp;
+
+	if (!task)
+		return -EIO;
+
+	mutex_lock(&core_mutex);
+	cp = get_core_proc(task);
+	if (cp) {
+		list_del(&cp->list);
+		kfree(cp);
+	}
+	mutex_unlock(&core_mutex);
+	put_task_struct(task);
 	return 0;
 }
 
+/*
+ * Validate if the call is valid. We also need to prevent >1 open
+ * of the same file.
+ */
 static int open_gencore(struct inode *inode, struct file *filp)
 {
-	return 0;
+	struct task_struct *task = get_proc_task(inode);
+	struct core_proc *cp;
+	int ret = 0;
+
+	if (!task)
+		return -ENOENT;
+
+	mutex_lock(&core_mutex);
+	cp = get_core_proc(task);
+	if (cp) {
+		ret = -EALREADY;
+		mutex_unlock(&core_mutex);
+		goto out;
+	}
+
+	cp = kzalloc(sizeof (*cp), GFP_KERNEL);
+	if (!cp) {
+		ret = -ENOMEM;
+		mutex_unlock(&core_mutex);
+		goto out;
+	}
+
+	cp->task = task->group_leader;
+	INIT_LIST_HEAD(&cp->list);
+	list_add(&cp->list, &core_list);
+	mutex_unlock(&core_mutex);
+
+out:
+	put_task_struct(task);
+	return ret;
 }
 
 const struct file_operations proc_gen_core_operations = {
Index: linux-2.6.36-rc7/fs/proc/gencore.h
===================================================================
--- /dev/null
+++ linux-2.6.36-rc7/fs/proc/gencore.h
@@ -0,0 +1,12 @@
+#ifndef __GEN_CORE_H
+#define __GEN_CORE_H
+
+#include <linux/list.h>
+#include <linux/sched.h>
+
+struct core_proc {
+	struct list_head list;
+	struct task_struct *task;
+};
+
+#endif
