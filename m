Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1KRXhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:37:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1KRXhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:37:54 -0500
Date: Fri, 18 Nov 2011 15:37:40 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-kqxwmo4xz37e1s8w0xopvr0q@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/printk] printk, lockdep: Disable lock debugging on zap_locks()
Git-Commit-ID: 94d24fc47219219b5aa23b45956cc37ee5aa5b01
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:37:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94d24fc47219219b5aa23b45956cc37ee5aa5b01
Gitweb:     http://git.kernel.org/tip/94d24fc47219219b5aa23b45956cc37ee5aa5b01
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 7 Jun 2011 11:17:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 13:35:16 +0100

printk, lockdep: Disable lock debugging on zap_locks()

zap_locks() is used by printk() in a last ditch effort to get data
out, clearly we cannot trust lock state after this so make it disable
lock debugging.

Also don't treat printk recursion through lockdep as a normal
recursion bug but try hard to get the lockdep splat out.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-kqxwmo4xz37e1s8w0xopvr0q@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lockdep.h |    4 ++++
 kernel/printk.c         |    3 ++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b6a56e3..d36619e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -343,6 +343,8 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_assert_held(l)	WARN_ON(debug_locks && !lockdep_is_held(l))
 
+#define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
+
 #else /* !LOCKDEP */
 
 static inline void lockdep_off(void)
@@ -392,6 +394,8 @@ struct lock_class_key { };
 
 #define lockdep_assert_held(l)			do { } while (0)
 
+#define lockdep_recursing(tsk)			(0)
+
 #endif /* !LOCKDEP */
 
 #ifdef CONFIG_LOCK_STAT
diff --git a/kernel/printk.c b/kernel/printk.c
index 1455a0d..6d08794 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -688,6 +688,7 @@ static void zap_locks(void)
 
 	oops_timestamp = jiffies;
 
+	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
 	raw_spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
@@ -856,7 +857,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		 * recursion and return - but flag the recursion so that
 		 * it can be printed at the next appropriate moment:
 		 */
-		if (!oops_in_progress) {
+		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
