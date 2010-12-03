Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab0LCJ53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:57:29 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44783 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab0LCJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:57:27 -0500
X-AuditID: b753bd60-a69a5ba000003e7d-0a-4cf8bf04e40a
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v5 1/8] [CLEANUP] kprobes: Rename old_p to more
	appropriate name
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Dec 2010 18:53:50 +0900
Message-ID: <20101203095350.2961.48110.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101203095325.2961.75137.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095325.2961.75137.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename irrelevant uses of "old_p" to more appropriate names.
Originally, "old_p" just meant "the old kprobe on given address"
but current code uses that name as "just another kprobe" or
something like that. This patch renames those pointer names
to more appropriate one for maintainability.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
---

 kernel/kprobes.c |   93 +++++++++++++++++++++++++++---------------------------
 1 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9737a76..8c3aa14 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -357,10 +357,10 @@ static inline int kprobe_aggrprobe(struct kprobe *p)
 /*
  * Keep all fields in the kprobe consistent
  */
-static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
+static inline void copy_kprobe(struct kprobe *ap, struct kprobe *p)
 {
-	memcpy(&p->opcode, &old_p->opcode, sizeof(kprobe_opcode_t));
-	memcpy(&p->ainsn, &old_p->ainsn, sizeof(struct arch_specific_insn));
+	memcpy(&p->opcode, &ap->opcode, sizeof(kprobe_opcode_t));
+	memcpy(&p->ainsn, &ap->ainsn, sizeof(struct arch_specific_insn));
 }
 
 #ifdef CONFIG_OPTPROBES
@@ -671,12 +671,12 @@ int proc_kprobes_optimization_handler(struct ctl_table *table, int write,
 
 static void __kprobes __arm_kprobe(struct kprobe *p)
 {
-	struct kprobe *old_p;
+	struct kprobe *_p;
 
 	/* Check collision with other optimized kprobes */
-	old_p = get_optimized_kprobe((unsigned long)p->addr);
-	if (unlikely(old_p))
-		unoptimize_kprobe(old_p); /* Fallback to unoptimized kprobe */
+	_p = get_optimized_kprobe((unsigned long)p->addr);
+	if (unlikely(_p))
+		unoptimize_kprobe(_p); /* Fallback to unoptimized kprobe */
 
 	arch_arm_kprobe(p);
 	optimize_kprobe(p);	/* Try to optimize (add kprobe to a list) */
@@ -684,15 +684,15 @@ static void __kprobes __arm_kprobe(struct kprobe *p)
 
 static void __kprobes __disarm_kprobe(struct kprobe *p)
 {
-	struct kprobe *old_p;
+	struct kprobe *_p;
 
 	unoptimize_kprobe(p);	/* Try to unoptimize */
 	arch_disarm_kprobe(p);
 
 	/* If another kprobe was blocked, optimize it. */
-	old_p = get_optimized_kprobe((unsigned long)p->addr);
-	if (unlikely(old_p))
-		optimize_kprobe(old_p);
+	_p = get_optimized_kprobe((unsigned long)p->addr);
+	if (unlikely(_p))
+		optimize_kprobe(_p);
 }
 
 #else /* !CONFIG_OPTPROBES */
@@ -993,18 +993,18 @@ static void __kprobes init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
  * This is the second or subsequent kprobe at the address - handle
  * the intricacies
  */
-static int __kprobes register_aggr_kprobe(struct kprobe *old_p,
+static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
 					  struct kprobe *p)
 {
 	int ret = 0;
-	struct kprobe *ap = old_p;
+	struct kprobe *ap = orig_p;
 
-	if (!kprobe_aggrprobe(old_p)) {
-		/* If old_p is not an aggr_kprobe, create new aggr_kprobe. */
-		ap = alloc_aggr_kprobe(old_p);
+	if (!kprobe_aggrprobe(orig_p)) {
+		/* If orig_p is not an aggr_kprobe, create new aggr_kprobe. */
+		ap = alloc_aggr_kprobe(orig_p);
 		if (!ap)
 			return -ENOMEM;
-		init_aggr_kprobe(ap, old_p);
+		init_aggr_kprobe(ap, orig_p);
 	}
 
 	if (kprobe_gone(ap)) {
@@ -1098,34 +1098,33 @@ static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
 /* Check passed kprobe is valid and return kprobe in kprobe_table. */
 static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
 {
-	struct kprobe *old_p, *list_p;
+	struct kprobe *ap, *list_p;
 
-	old_p = get_kprobe(p->addr);
-	if (unlikely(!old_p))
+	ap = get_kprobe(p->addr);
+	if (unlikely(!ap))
 		return NULL;
 
-	if (p != old_p) {
-		list_for_each_entry_rcu(list_p, &old_p->list, list)
+	if (p != ap) {
+		list_for_each_entry_rcu(list_p, &ap->list, list)
 			if (list_p == p)
 			/* kprobe p is a valid probe */
 				goto valid;
 		return NULL;
 	}
 valid:
-	return old_p;
+	return ap;
 }
 
 /* Return error if the kprobe is being re-registered */
 static inline int check_kprobe_rereg(struct kprobe *p)
 {
 	int ret = 0;
-	struct kprobe *old_p;
 
 	mutex_lock(&kprobe_mutex);
-	old_p = __get_valid_kprobe(p);
-	if (old_p)
+	if (__get_valid_kprobe(p))
 		ret = -EINVAL;
 	mutex_unlock(&kprobe_mutex);
+
 	return ret;
 }
 
@@ -1234,43 +1233,43 @@ EXPORT_SYMBOL_GPL(register_kprobe);
  */
 static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 {
-	struct kprobe *old_p, *list_p;
+	struct kprobe *ap, *list_p;
 
-	old_p = __get_valid_kprobe(p);
-	if (old_p == NULL)
+	ap = __get_valid_kprobe(p);
+	if (ap == NULL)
 		return -EINVAL;
 
-	if (old_p == p ||
-	    (kprobe_aggrprobe(old_p) &&
-	     list_is_singular(&old_p->list))) {
+	if (ap == p ||
+	    (kprobe_aggrprobe(ap) &&
+	     list_is_singular(&ap->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
 		 * enabled and not gone - otherwise, the breakpoint would
 		 * already have been removed. We save on flushing icache.
 		 */
-		if (!kprobes_all_disarmed && !kprobe_disabled(old_p))
-			disarm_kprobe(old_p);
-		hlist_del_rcu(&old_p->hlist);
+		if (!kprobes_all_disarmed && !kprobe_disabled(ap))
+			disarm_kprobe(ap);
+		hlist_del_rcu(&ap->hlist);
 	} else {
 		if (p->break_handler && !kprobe_gone(p))
-			old_p->break_handler = NULL;
+			ap->break_handler = NULL;
 		if (p->post_handler && !kprobe_gone(p)) {
-			list_for_each_entry_rcu(list_p, &old_p->list, list) {
+			list_for_each_entry_rcu(list_p, &ap->list, list) {
 				if ((list_p != p) && (list_p->post_handler))
 					goto noclean;
 			}
-			old_p->post_handler = NULL;
+			ap->post_handler = NULL;
 		}
 noclean:
 		list_del_rcu(&p->list);
-		if (!kprobe_disabled(old_p)) {
-			try_to_disable_aggr_kprobe(old_p);
+		if (!kprobe_disabled(ap)) {
+			try_to_disable_aggr_kprobe(ap);
 			if (!kprobes_all_disarmed) {
-				if (kprobe_disabled(old_p))
-					disarm_kprobe(old_p);
+				if (kprobe_disabled(ap))
+					disarm_kprobe(ap);
 				else
 					/* Try to optimize this probe again */
-					optimize_kprobe(old_p);
+					optimize_kprobe(ap);
 			}
 		}
 	}
@@ -1279,16 +1278,16 @@ noclean:
 
 static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 {
-	struct kprobe *old_p;
+	struct kprobe *ap;
 
 	if (list_empty(&p->list))
 		arch_remove_kprobe(p);
 	else if (list_is_singular(&p->list)) {
 		/* "p" is the last child of an aggr_kprobe */
-		old_p = list_entry(p->list.next, struct kprobe, list);
+		ap = list_entry(p->list.next, struct kprobe, list);
 		list_del(&p->list);
-		arch_remove_kprobe(old_p);
-		free_aggr_kprobe(old_p);
+		arch_remove_kprobe(ap);
+		free_aggr_kprobe(ap);
 	}
 }
 

