Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0JZGon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:44:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:55637 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0JZGom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:44:42 -0400
Date: Tue, 26 Oct 2010 06:44:05 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@gmail.com, davem@davemloft.net,
        anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, jbaron@redhat.com, tglx@linutronix.de,
        mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung@gmail.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, jbaron@redhat.com,
        mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20101025131801.19160.70939.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101025131801.19160.70939.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes: Remove redundant text_mutex lock in optimize
Message-ID: <tip-43948f50276eca010a22726860dfe9a4e8130136@git.kernel.org>
Git-Commit-ID: 43948f50276eca010a22726860dfe9a4e8130136
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 06:44:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43948f50276eca010a22726860dfe9a4e8130136
Gitweb:     http://git.kernel.org/tip/43948f50276eca010a22726860dfe9a4e8130136
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 25 Oct 2010 22:18:01 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 Oct 2010 15:51:55 +0200

kprobes: Remove redundant text_mutex lock in optimize

Remove text_mutex locking in optimize_all_kprobes, because
this function doesn't modify text. It simply queues probes on
optimization list for kprobe_optimizer worker thread.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101025131801.19160.70939.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ec4210c..7c44133 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -74,7 +74,8 @@ static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobes_all_disarmed;
 
-static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
+/* This protects kprobe_table and optimizing_list */
+static DEFINE_MUTEX(kprobe_mutex);
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 static struct {
 	spinlock_t lock ____cacheline_aligned_in_smp;
@@ -595,6 +596,7 @@ static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
 }
 
 #ifdef CONFIG_SYSCTL
+/* This should be called with kprobe_mutex locked */
 static void __kprobes optimize_all_kprobes(void)
 {
 	struct hlist_head *head;
@@ -607,17 +609,16 @@ static void __kprobes optimize_all_kprobes(void)
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
