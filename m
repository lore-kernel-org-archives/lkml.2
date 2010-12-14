Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab0LNKO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:14:57 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56182 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157Ab0LNKOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:14:55 -0500
Date: Tue, 14 Dec 2010 15:45:04 +0530
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
Subject: [Patch 13/21] Freeze / Thaw threads
Message-ID: <20101214154504.7037c2c0@suzukikp>
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

All the threads in the target process are issued a freeze request on an "open()".
They are woken up when we release the fd.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N.Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/gencore.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

Index: linux-2.6.36-rc7/fs/proc/gencore.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.c
+++ linux-2.6.36-rc7/fs/proc/gencore.c
@@ -24,6 +24,7 @@
 
 #include <linux/seq_file.h>
 #include <linux/elf.h>
+#include <linux/freezer.h>
 
 #include "internal.h"
 #include "gencore.h"
@@ -70,11 +71,20 @@ out:
 static int release_gencore(struct inode *inode, struct file *file)
 {
 	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct task_struct *t;
 	struct core_proc *cp;
 
 	if (!task)
 		return -EIO;
 
+	/* Thaw all frozen threads */
+	t = task;
+	read_lock(&tasklist_lock);
+	do {
+		thaw_process(t);
+	} while ((t = next_thread(t)) != task);
+	read_unlock(&tasklist_lock);
+
 	mutex_lock(&core_mutex);
 	cp = get_core_proc(task);
 	if (cp) {
@@ -117,6 +127,7 @@ static int get_elf_class(struct task_str
 static int open_gencore(struct inode *inode, struct file *filp)
 {
 	struct task_struct *task = get_proc_task(inode);
+	struct task_struct *t;
 	struct core_proc *cp;
 	int ret = 0;
 	int elf_class;
@@ -148,6 +159,21 @@ static int open_gencore(struct inode *in
 	list_add(&cp->list, &core_list);
 	mutex_unlock(&core_mutex);
 
+	/* freeze the processes */
+	t = task;
+	read_lock(&tasklist_lock);
+	do {
+		if (frozen(t) || !freezeable(t) || freezing(t))
+			continue;
+
+		if (freeze_task(t, true))
+			continue;
+
+		if (task_is_stopped_or_traced(t))
+			continue;
+	} while ((t = next_thread(t)) != task);
+	read_unlock(&tasklist_lock);
+
 out:
 	put_task_struct(task);
 	return ret;
