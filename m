Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1CNNnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:43:31 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59958 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab1CNNn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:43:28 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Mar 2011 19:07:35 +0530
Message-Id: <20110314133735.27435.21582.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v2 2.6.38-rc8-tip 18/20] 18: uprobes: commonly used filters.
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
index b7fd925..a7a8d5a 100644
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
index e3a3051..328053e 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1262,6 +1262,56 @@ int uprobe_post_notifier(struct pt_regs *regs)
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
