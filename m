Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0LCJ5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:57:37 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44806 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab0LCJ5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:57:34 -0500
X-AuditID: b753bd60-a3afaba000000f8d-51-4cf8bf0ae1de
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v5 2/8] [CLEANUP]kprobes: Cleanup disabling and
	unregistering path
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
Date: Fri, 03 Dec 2010 18:53:57 +0900
Message-ID: <20101203095356.2961.30152.stgit@ltc236.sdl.hitachi.co.jp>
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

Merge disabling kprobe to unregistering kprobe function
and add comments for disabing/unregistring process.

Current unregistering code disables(disarms) kprobes after
checking target kprobe status. This patch changes it to
disabling kprobe first after that it changing the kprobe's
state. This allows to share probe disabling code between
disable_kprobe() and unregister_kprobe().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
---

 kernel/kprobes.c |  128 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 72 insertions(+), 56 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 8c3aa14..ab99caf 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1039,23 +1039,6 @@ static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
 	return add_new_kprobe(ap, p);
 }
 
-/* Try to disable aggr_kprobe, and return 1 if succeeded.*/
-static int __kprobes try_to_disable_aggr_kprobe(struct kprobe *p)
-{
-	struct kprobe *kp;
-
-	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (!kprobe_disabled(kp))
-			/*
-			 * There is an active probe on the list.
-			 * We can't disable aggr_kprobe.
-			 */
-			return 0;
-	}
-	p->flags |= KPROBE_FLAG_DISABLED;
-	return 1;
-}
-
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
 	struct kprobe_blackpoint *kb;
@@ -1228,6 +1211,47 @@ fail_with_jump_label:
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
+/* Check if all probes on the aggrprobe are disabled */
+static int __kprobes aggr_kprobe_disabled(struct kprobe *ap)
+{
+	struct kprobe *kp;
+
+	list_for_each_entry_rcu(kp, &ap->list, list)
+		if (!kprobe_disabled(kp))
+			/*
+			 * There is an active probe on the list.
+			 * We can't disable this ap.
+			 */
+			return 0;
+
+	return 1;
+}
+
+/* Disable one kprobe: Make sure called under kprobe_mutex is locked */
+static struct kprobe *__kprobes __disable_kprobe(struct kprobe *p)
+{
+	struct kprobe *orig_p;
+
+	/* Get an original kprobe for return */
+	orig_p = __get_valid_kprobe(p);
+	if (unlikely(orig_p == NULL))
+		return NULL;
+
+	if (!kprobe_disabled(p)) {
+		/* Disable probe if it is a child probe */
+		if (p != orig_p)
+			p->flags |= KPROBE_FLAG_DISABLED;
+
+		/* Try to disarm and disable this/parent probe */
+		if (p == orig_p || aggr_kprobe_disabled(orig_p)) {
+			disarm_kprobe(orig_p);
+			orig_p->flags |= KPROBE_FLAG_DISABLED;
+		}
+	}
+
+	return orig_p;
+}
+
 /*
  * Unregister a kprobe without a scheduler synchronization.
  */
@@ -1235,22 +1259,26 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 {
 	struct kprobe *ap, *list_p;
 
-	ap = __get_valid_kprobe(p);
+	/* Disable kprobe. This will disarm it if needed. */
+	ap = __disable_kprobe(p);
 	if (ap == NULL)
 		return -EINVAL;
 
-	if (ap == p ||
-	    (kprobe_aggrprobe(ap) &&
-	     list_is_singular(&ap->list))) {
+	if (ap == p)
 		/*
-		 * Only probe on the hash list. Disarm only if kprobes are
-		 * enabled and not gone - otherwise, the breakpoint would
-		 * already have been removed. We save on flushing icache.
+		 * This probe is an independent(and non-optimized) kprobe
+		 * (not an aggrprobe). Remove from the hash list.
 		 */
-		if (!kprobes_all_disarmed && !kprobe_disabled(ap))
-			disarm_kprobe(ap);
-		hlist_del_rcu(&ap->hlist);
-	} else {
+		goto disarmed;
+
+	/* Following process expects this probe is an aggrprobe */
+	WARN_ON(!kprobe_aggrprobe(ap));
+
+	if (list_is_singular(&ap->list))
+		/* This probe is the last child of aggrprobe */
+		goto disarmed;
+	else {
+		/* If disabling probe has special handlers, update aggrprobe */
 		if (p->break_handler && !kprobe_gone(p))
 			ap->break_handler = NULL;
 		if (p->post_handler && !kprobe_gone(p)) {
@@ -1261,19 +1289,23 @@ static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 			ap->post_handler = NULL;
 		}
 noclean:
+		/*
+		 * Remove from the aggrprobe: this path will do nothing in
+		 * __unregister_kprobe_bottom().
+		 */
 		list_del_rcu(&p->list);
-		if (!kprobe_disabled(ap)) {
-			try_to_disable_aggr_kprobe(ap);
-			if (!kprobes_all_disarmed) {
-				if (kprobe_disabled(ap))
-					disarm_kprobe(ap);
-				else
-					/* Try to optimize this probe again */
-					optimize_kprobe(ap);
-			}
-		}
+		if (!kprobe_disabled(ap) && !kprobes_all_disarmed)
+			/*
+			 * Try to optimize this probe again, because post
+			 * handler may have been changed.
+			 */
+			optimize_kprobe(ap);
 	}
 	return 0;
+
+disarmed:
+	hlist_del_rcu(&ap->hlist);
+	return 0;
 }
 
 static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
@@ -1606,29 +1638,13 @@ static void __kprobes kill_kprobe(struct kprobe *p)
 int __kprobes disable_kprobe(struct kprobe *kp)
 {
 	int ret = 0;
-	struct kprobe *p;
 
 	mutex_lock(&kprobe_mutex);
 
-	/* Check whether specified probe is valid. */
-	p = __get_valid_kprobe(kp);
-	if (unlikely(p == NULL)) {
+	/* Disable this kprobe */
+	if (__disable_kprobe(kp) == NULL)
 		ret = -EINVAL;
-		goto out;
-	}
-
-	/* If the probe is already disabled (or gone), just return */
-	if (kprobe_disabled(kp))
-		goto out;
 
-	kp->flags |= KPROBE_FLAG_DISABLED;
-	if (p != kp)
-		/* When kp != p, p is always enabled. */
-		try_to_disable_aggr_kprobe(p);
-
-	if (!kprobes_all_disarmed && kprobe_disabled(p))
-		disarm_kprobe(p);
-out:
 	mutex_unlock(&kprobe_mutex);
 	return ret;
 }

