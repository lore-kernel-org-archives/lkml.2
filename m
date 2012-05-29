Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2E2Mtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:49:36 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58046 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2E2Mtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:49:32 -0400
X-AuditID: b753bd60-97500ba000007aa1-32-4fc4c5daaf2d
X-AuditID: b753bd60-97500ba000007aa1-32-4fc4c5daaf2d
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH -tip  7/9] kprobes: Move locks into appropriate functions
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 29 May 2012 21:49:39 +0900
Message-ID: <20120529124938.9191.32209.stgit@localhost.localdomain>
In-Reply-To: <20120529124833.9191.23007.stgit@localhost.localdomain>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break a big critical region into fine-grained pieces at
registering kprobe path. This helps us to solve circular
locking dependency when introducing ftrace-based kprobes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 kernel/kprobes.c |   63 ++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 6137fe3..9e47f44 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -759,20 +759,28 @@ static __kprobes void try_to_optimize_kprobe(struct kprobe *p)
 	struct kprobe *ap;
 	struct optimized_kprobe *op;
 
+	/* For preparing optimization, jump_label_text_reserved() is called */
+	jump_label_lock();
+	mutex_lock(&text_mutex);
+
 	ap = alloc_aggr_kprobe(p);
 	if (!ap)
-		return;
+		goto out;
 
 	op = container_of(ap, struct optimized_kprobe, kp);
 	if (!arch_prepared_optinsn(&op->optinsn)) {
 		/* If failed to setup optimizing, fallback to kprobe */
 		arch_remove_optimized_kprobe(op);
 		kfree(op);
-		return;
+		goto out;
 	}
 
 	init_aggr_kprobe(ap, p);
-	optimize_kprobe(ap);
+	optimize_kprobe(ap);	/* This just kicks optimizer thread */
+
+out:
+	mutex_unlock(&text_mutex);
+	jump_label_unlock();
 }
 
 #ifdef CONFIG_SYSCTL
@@ -1144,12 +1152,6 @@ static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 	if (p->post_handler && !ap->post_handler)
 		ap->post_handler = aggr_post_handler;
 
-	if (kprobe_disabled(ap) && !kprobe_disabled(p)) {
-		ap->flags &= ~KPROBE_FLAG_DISABLED;
-		if (!kprobes_all_disarmed)
-			/* Arm the breakpoint again. */
-			__arm_kprobe(ap);
-	}
 	return 0;
 }
 
@@ -1189,11 +1191,22 @@ static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
 	int ret = 0;
 	struct kprobe *ap = orig_p;
 
+	/* For preparing optimization, jump_label_text_reserved() is called */
+	jump_label_lock();
+	/*
+	 * Get online CPUs to avoid text_mutex deadlock.with stop machine,
+	 * which is invoked by unoptimize_kprobe() in add_new_kprobe()
+	 */
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+
 	if (!kprobe_aggrprobe(orig_p)) {
 		/* If orig_p is not an aggr_kprobe, create new aggr_kprobe. */
 		ap = alloc_aggr_kprobe(orig_p);
-		if (!ap)
-			return -ENOMEM;
+		if (!ap) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		init_aggr_kprobe(ap, orig_p);
 	} else if (kprobe_unused(ap))
 		/* This probe is going to die. Rescue it */
@@ -1213,7 +1226,7 @@ static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
 			 * free aggr_probe. It will be used next time, or
 			 * freed by unregister_kprobe.
 			 */
-			return ret;
+			goto out;
 
 		/* Prepare optimized instructions if possible. */
 		prepare_optimized_kprobe(ap);
@@ -1228,7 +1241,20 @@ static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
 
 	/* Copy ap's insn slot to p */
 	copy_kprobe(ap, p);
-	return add_new_kprobe(ap, p);
+	ret = add_new_kprobe(ap, p);
+
+out:
+	mutex_unlock(&text_mutex);
+	put_online_cpus();
+	jump_label_unlock();
+
+	if (ret == 0 && kprobe_disabled(ap) && !kprobe_disabled(p)) {
+		ap->flags &= ~KPROBE_FLAG_DISABLED;
+		if (!kprobes_all_disarmed)
+			/* Arm the breakpoint again. */
+			arm_kprobe(ap);
+	}
+	return ret;
 }
 
 static int __kprobes in_kprobes_functions(unsigned long addr)
@@ -1387,10 +1413,6 @@ int __kprobes register_kprobe(struct kprobe *p)
 		return ret;
 
 	mutex_lock(&kprobe_mutex);
-	jump_label_lock(); /* needed to call jump_label_text_reserved() */
-
-	get_online_cpus();	/* For avoiding text_mutex deadlock. */
-	mutex_lock(&text_mutex);
 
 	old_p = get_kprobe(p->addr);
 	if (old_p) {
@@ -1399,7 +1421,9 @@ int __kprobes register_kprobe(struct kprobe *p)
 		goto out;
 	}
 
+	mutex_lock(&text_mutex);	/* Avoiding text modification */
 	ret = arch_prepare_kprobe(p);
+	mutex_unlock(&text_mutex);
 	if (ret)
 		goto out;
 
@@ -1408,15 +1432,12 @@ int __kprobes register_kprobe(struct kprobe *p)
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
 	if (!kprobes_all_disarmed && !kprobe_disabled(p))
-		__arm_kprobe(p);
+		arm_kprobe(p);
 
 	/* Try to optimize kprobe */
 	try_to_optimize_kprobe(p);
 
 out:
-	mutex_unlock(&text_mutex);
-	put_online_cpus();
-	jump_label_unlock();
 	mutex_unlock(&kprobe_mutex);
 
 	if (probed_mod)

