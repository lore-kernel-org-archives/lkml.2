Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab1DAOpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:45:51 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56649 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab1DAOpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:45:47 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 01 Apr 2011 20:06:02 +0530
Message-Id: <20110401143602.15455.82211.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 2.6.39-rc1-tip 18/26] 18: uprobes: commonly used filters.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provides most commonly used filters that most users of uprobes can
reuse.  However this would be useful once we can dynamically associate a
filter with a uprobe-event tracer.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/uprobes.h |    5 +++++
 kernel/uprobes.c        |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 26c4d78..34b989f 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -65,6 +65,11 @@ struct uprobe_consumer {
 	struct uprobe_consumer *next;
 };
 
+struct uprobe_simple_consumer {
+	struct uprobe_consumer consumer;
+	pid_t fvalue;
+};
+
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
 	atomic_t		ref;
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index cdd52d0..c950f13 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1389,6 +1389,56 @@ int uprobe_post_notifier(struct pt_regs *regs)
 	return 0;
 }
 
+bool uprobes_pid_filter(struct uprobe_consumer *self, struct task_struct *t)
+{
+	struct uprobe_simple_consumer *usc;
+
+	usc = container_of(self, struct uprobe_simple_consumer, consumer);
+	if (t->tgid == usc->fvalue)
+		return true;
+	return false;
+}
+
+bool uprobes_tid_filter(struct uprobe_consumer *self, struct task_struct *t)
+{
+	struct uprobe_simple_consumer *usc;
+
+	usc = container_of(self, struct uprobe_simple_consumer, consumer);
+	if (t->pid == usc->fvalue)
+		return true;
+	return false;
+}
+
+bool uprobes_ppid_filter(struct uprobe_consumer *self, struct task_struct *t)
+{
+	pid_t pid;
+	struct uprobe_simple_consumer *usc;
+
+	usc = container_of(self, struct uprobe_simple_consumer, consumer);
+	rcu_read_lock();
+	pid = task_tgid_vnr(t->real_parent);
+	rcu_read_unlock();
+
+	if (pid == usc->fvalue)
+		return true;
+	return false;
+}
+
+bool uprobes_sid_filter(struct uprobe_consumer *self, struct task_struct *t)
+{
+	pid_t pid;
+	struct uprobe_simple_consumer *usc;
+
+	usc = container_of(self, struct uprobe_simple_consumer, consumer);
+	rcu_read_lock();
+	pid = pid_vnr(task_session(t));
+	rcu_read_unlock();
+
+	if (pid == usc->fvalue)
+		return true;
+	return false;
+}
+
 struct notifier_block uprobes_exception_nb = {
 	.notifier_call = uprobes_exception_notify,
 	.priority = 0x7ffffff0,
