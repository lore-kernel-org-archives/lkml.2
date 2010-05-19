Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0ESQsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:48:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0ESQsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:48:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 2/5] [CLEANUP] kprobes: Remove redundant text_mutex
	lock in optimize
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 19 May 2010 12:53:19 -0400
Message-ID: <20100519165319.31828.63114.stgit@localhost6.localdomain6>
In-Reply-To: <20100519165305.31828.15577.stgit@localhost6.localdomain6>
References: <20100519165305.31828.15577.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove text_mutex locking in optimize_all_kprobes, because
this function doesn't modify text. It simply queues probes on
optimization list for kprobe_optimizer worker thread.

Changes in v2:
 - Update changelog.
 - Add comments for (un)optimize_all_kprobes.
 - Update kprobe_mutex comment.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---

 kernel/kprobes.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 282035f..f1351f2 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -73,7 +73,8 @@ static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobes_all_disarmed;
 
-static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
+/* This protects kprobe_table and optimizing_list */
+static DEFINE_MUTEX(kprobe_mutex);
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 static struct {
 	spinlock_t lock ____cacheline_aligned_in_smp;
@@ -594,6 +595,7 @@ static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
 }
 
 #ifdef CONFIG_SYSCTL
+/* This should be called with kprobe_mutex locked */
 static void __kprobes optimize_all_kprobes(void)
 {
 	struct hlist_head *head;
@@ -606,17 +608,16 @@ static void __kprobes optimize_all_kprobes(void)
 		return;
 
 	kprobes_allow_optimization = true;
-	mutex_lock(&text_mutex);
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
 			if (!kprobe_disabled(p))
 				optimize_kprobe(p);
 	}
-	mutex_unlock(&text_mutex);
 	printk(KERN_INFO "Kprobes globally optimized\n");
 }
 
+/* This should be called with kprobe_mutex locked */
 static void __kprobes unoptimize_all_kprobes(void)
 {
 	struct hlist_head *head;


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
