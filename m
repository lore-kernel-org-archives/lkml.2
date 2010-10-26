Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0JZD3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 23:29:54 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51457 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0JZD3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 23:29:53 -0400
X-AuditID: b753bd60-a69a5ba000003e7d-a8-4cc64b2e188a
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH] [BUGFIX][RESEND] kprobes: Remove redundant text_mutex lock in
	optimize
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 12:30:34 +0900
Message-ID: <20101026033034.28001.60101.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove text_mutex locking in optimize_all_kprobes, because
this function doesn't modify text. It simply queues probes on
optimization list for kprobe_optimizer worker thread.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org
---

 kernel/kprobes.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 56a8919..99865c3 100644
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

