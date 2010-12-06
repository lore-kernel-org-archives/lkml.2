Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab0LFSRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:17:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:48084 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab0LFSRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:17:43 -0500
Date: Mon, 6 Dec 2010 18:17:12 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101203095416.2961.39080.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095416.2961.39080.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Reuse unused kprobe
Message-ID: <tip-0490cd1f9d99569d3bd64e17adc88db06a5007be@git.kernel.org>
Git-Commit-ID: 0490cd1f9d99569d3bd64e17adc88db06a5007be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 18:17:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0490cd1f9d99569d3bd64e17adc88db06a5007be
Gitweb:     http://git.kernel.org/tip/0490cd1f9d99569d3bd64e17adc88db06a5007be
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 3 Dec 2010 18:54:16 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Dec 2010 17:59:31 +0100

kprobes: Reuse unused kprobe

Reuse unused (waiting for unoptimizing and no user handler)
kprobe on given address instead of returning -EBUSY for
registering a new kprobe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
LKML-Reference: <20101203095416.2961.39080.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ba4d4c0..134754d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -692,6 +692,27 @@ static __kprobes void unoptimize_kprobe(struct kprobe *p, bool force)
 	}
 }
 
+/* Cancel unoptimizing for reusing */
+static void reuse_unused_kprobe(struct kprobe *ap)
+{
+	struct optimized_kprobe *op;
+
+	BUG_ON(!kprobe_unused(ap));
+	/*
+	 * Unused kprobe MUST be on the way of delayed unoptimizing (means
+	 * there is still a relative jump) and disabled.
+	 */
+	op = container_of(ap, struct optimized_kprobe, kp);
+	if (unlikely(list_empty(&op->list)))
+		printk(KERN_WARNING "Warning: found a stray unused "
+			"aggrprobe@%p\n", ap->addr);
+	/* Enable the probe again */
+	ap->flags &= ~KPROBE_FLAG_DISABLED;
+	/* Optimize it again (remove from op->list) */
+	BUG_ON(!kprobe_optready(ap));
+	optimize_kprobe(ap);
+}
+
 /* Remove optimized instructions */
 static void __kprobes kill_optimized_kprobe(struct kprobe *p)
 {
@@ -872,6 +893,13 @@ static void __kprobes __disarm_kprobe(struct kprobe *p, bool reopt)
 #define kprobe_disarmed(p)			kprobe_disabled(p)
 #define wait_for_kprobe_optimizer()		do {} while (0)
 
+/* There should be no unused kprobes can be reused without optimization */
+static void reuse_unused_kprobe(struct kprobe *ap)
+{
+	printk(KERN_ERR "Error: There should be no unused kprobe here.\n");
+	BUG_ON(kprobe_unused(ap));
+}
+
 static __kprobes void free_aggr_kprobe(struct kprobe *p)
 {
 	arch_remove_kprobe(p);
@@ -1173,8 +1201,8 @@ static int __kprobes register_aggr_kprobe(struct kprobe *orig_p,
 			return -ENOMEM;
 		init_aggr_kprobe(ap, orig_p);
 	} else if (kprobe_unused(ap))
-		/* Busy to die */
-		return -EBUSY;
+		/* This probe is going to die. Rescue it */
+		reuse_unused_kprobe(ap);
 
 	if (kprobe_gone(ap)) {
 		/*
