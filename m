Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab0LCJ5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:57:54 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41839 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab0LCJ5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:57:52 -0500
X-AuditID: b753bd60-a26f8ba000000f8d-b7-4cf8bf1de6de
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v5 5/8] kprobes: Reuse unused kprobe
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
Date: Fri, 03 Dec 2010 18:54:16 +0900
Message-ID: <20101203095416.2961.39080.stgit@ltc236.sdl.hitachi.co.jp>
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

Reuse unused (waiting for unoptimizing and no user handler) kprobe
on given address instead of returning -EBUSY for registering a
new kprobe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
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

