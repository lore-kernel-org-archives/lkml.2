Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0LPKD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:03:27 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34773 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0LPKDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:03:24 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:30:49 +0530
Message-Id: <20101216100049.23751.2658.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 18/20] 18: uprobes: commonly used filters.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provides most commonly used filters. Prevents users from having to define
their own filters. However this would be useful once we can
dynamically associate a filter with a uprobe-event tracer.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/uprobes.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index b0d323c..44a7ff6 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1190,6 +1190,46 @@ int uprobe_post_notifier(struct pt_regs *regs)
 	return 0;
 }
 
+bool uprobes_pid_filter(struct uprobe_consumer *self, struct task_struct *t)
+{
+	if (t->tgid == (long)self->fvalue)
+		return true;
+	return false;
+}
+
+bool uprobes_tid_filter(struct uprobe_consumer *self, struct task_struct *t)
+{
+	if (t->pid == (long)self->fvalue)
+		return true;
+	return false;
+}
+
+bool uprobes_ppid_filter(struct uprobe_consumer *self, struct task_struct *t)
+{
+	pid_t pid;
+
+	rcu_read_lock();
+	pid = task_tgid_vnr(t->real_parent);
+	rcu_read_unlock();
+
+	if (pid == (long)self->fvalue)
+		return true;
+	return false;
+}
+
+bool uprobes_sid_filter(struct uprobe_consumer *self, struct task_struct *t)
+{
+	pid_t pid;
+
+	rcu_read_lock();
+	pid = pid_vnr(task_session(t));
+	rcu_read_unlock();
+
+	if (pid == (long)self->fvalue)
+		return true;
+	return false;
+}
+
 struct notifier_block uprobes_exception_nb = {
 	.notifier_call = uprobes_exception_notify,
 	.priority = 0x7ffffff0,
@@ -1207,3 +1247,4 @@ static void __exit exit_uprobes(void)
 
 module_init(init_uprobes);
 module_exit(exit_uprobes);
+
