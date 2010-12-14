Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab0LNKSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:18:53 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49267 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab0LNKSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:18:52 -0500
Date: Tue, 14 Dec 2010 15:49:00 +0530
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
Subject: [Patch 16/21] Wait for threads to freeze
Message-ID: <20101214154900.2d7a643c@suzukikp>
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

The threads may not have entered the "refrigerator()" by the time we start 
generating the NOTE sections, which can result in invalid register states. 
Wait for a short interval of time for the threads to freeze. The register 
information of the threads which are not frozen at the end of the interval, 
is filled with 0's, to indicate we couldn't capture the information.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>

---
 fs/proc/gencore-elf.c |   20 ++++++++++++++++++++
 fs/proc/gencore.c     |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/proc/gencore.h     |    3 +++
 3 files changed, 65 insertions(+)

Index: linux-2.6.36-rc7/fs/proc/gencore-elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore-elf.c
+++ linux-2.6.36-rc7/fs/proc/gencore-elf.c
@@ -159,6 +159,21 @@ static int fill_thread_core_info(struct 
 }
 #endif
 
+/*
+ * zero_thread_state :
+ * For threads, which are not frozen, we cannot capture the register state.
+ * We zero them out.
+ */
+static void zero_thread_state(struct elf_thread_core_info *tinfo)
+{
+	int i;
+
+	memset(&tinfo->prstatus.pr_reg, 0, sizeof(tinfo->prstatus.pr_reg));
+	for (i = 1; i < tinfo->num_notes; i++)
+		if (tinfo->notes[i].data)
+			memset(tinfo->notes[i].data, 0, tinfo->notes[i].datasz);
+}
+
 /* Returns 0 on error, 1 on success */
 static int collect_notes(struct core_proc *cp)
 {
@@ -173,10 +188,15 @@ static int collect_notes(struct core_pro
 	fill_auxv_note(&cp->auxv, cp->task->mm);
 	cp->notes_size += notesize(&cp->auxv);
 
+	/* Make sure threads are frozen, before we start collecting notes */
+	try_to_freeze_core_threads(cp);
+
 	tinfo = cp->tinfo;
 	while (tinfo != NULL) {
 		if (!fill_thread_core_info(tinfo, cp))
 			return 0;
+		if (!tinfo->frozen)
+			zero_thread_state(tinfo);
 		tinfo = tinfo->next;
 	}
 	return 1;
Index: linux-2.6.36-rc7/fs/proc/gencore.h
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.h
+++ linux-2.6.36-rc7/fs/proc/gencore.h
@@ -7,6 +7,7 @@
 #include <linux/elfcore-internal.h>
 
 struct elf_thread_core_info {
+	unsigned short frozen;
 	unsigned short num_notes;	/* Number of notes for this thread */
 	struct elf_thread_core_info *next;
 	struct task_struct *task;
@@ -28,6 +29,8 @@ struct core_proc {
 	size_t notes_size;
 };
 
+extern void try_to_freeze_core_threads(struct core_proc *cp);
+
 #ifdef CORE_DUMP_USE_REGSET
 #include <linux/regset.h>
 
Index: linux-2.6.36-rc7/fs/proc/gencore.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.c
+++ linux-2.6.36-rc7/fs/proc/gencore.c
@@ -30,6 +30,8 @@
 #include "internal.h"
 #include "gencore.h"
 
+#define FREEZE_TIMEOUT	(20 * HZ)
+
 static LIST_HEAD(core_list);
 static DEFINE_MUTEX(core_mutex);
 
@@ -45,6 +47,46 @@ static struct core_proc* get_core_proc(s
 	return NULL;
 }
 
+/* Borrowed from kernel/cgroup_freezer.c */
+static int is_task_frozen_enough(struct task_struct *task)
+{
+	return frozen(task) ||
+		(task_is_stopped_or_traced(task) && freezing(task));
+}
+/*
+ * Wait for a short interval, to let the threads freeze.
+ * If "current" is generating the core, we should skip
+ * it.
+ * Based on try_to_freeze_tasks, kernel/power/process.c
+ */
+void try_to_freeze_core_threads(struct core_proc *cp)
+{
+	unsigned long end_time;
+	struct elf_thread_core_info *tinfo;
+	unsigned todo;
+
+	end_time = jiffies + FREEZE_TIMEOUT;
+
+retry:
+	tinfo = cp->tinfo;
+	todo = 0;
+	while (tinfo != NULL) {
+		if ((tinfo->task != current) && !tinfo->frozen) {
+			if (is_task_frozen_enough(tinfo->task))
+				tinfo->frozen = 1;
+			else
+				todo++;
+		}
+		tinfo = tinfo->next;
+	}
+
+	if (!todo || time_after(jiffies, end_time))
+		return;
+
+	schedule();
+	goto retry;
+}
+
 static ssize_t read_gencore(struct file *file, char __user *buffer,
 		size_t buflen, loff_t *fpos)
 {
