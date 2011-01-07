Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1AGPhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:37:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:40850 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1AGPhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:37:13 -0500
Date: Fri, 7 Jan 2011 15:36:55 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, oleg@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        oleg@redhat.com, mingo@elte.hu
In-Reply-To: <1294222564.8369.6.camel@marge.simson.net>
References: <1294222564.8369.6.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Move sched_autogroup_exit() to free_signal_struct()
Message-ID: <tip-1c5354de90c900b369e2ebd36c3a065ede29eb93@git.kernel.org>
Git-Commit-ID: 1c5354de90c900b369e2ebd36c3a065ede29eb93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:36:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c5354de90c900b369e2ebd36c3a065ede29eb93
Gitweb:     http://git.kernel.org/tip/1c5354de90c900b369e2ebd36c3a065ede29eb93
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 5 Jan 2011 11:16:04 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:54:39 +0100

sched: Move sched_autogroup_exit() to free_signal_struct()

Per Oleg's suggestion, undo fork failure free/put_signal_struct change,
and move sched_autogroup_exit() to free_signal_struct() instead.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294222564.8369.6.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/fork.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 7d164e2..dc1a8bb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -169,15 +169,14 @@ EXPORT_SYMBOL(free_task);
 static inline void free_signal_struct(struct signal_struct *sig)
 {
 	taskstats_tgid_free(sig);
+	sched_autogroup_exit(sig);
 	kmem_cache_free(signal_cachep, sig);
 }
 
 static inline void put_signal_struct(struct signal_struct *sig)
 {
-	if (atomic_dec_and_test(&sig->sigcnt)) {
-		sched_autogroup_exit(sig);
+	if (atomic_dec_and_test(&sig->sigcnt))
 		free_signal_struct(sig);
-	}
 }
 
 void __put_task_struct(struct task_struct *tsk)
@@ -1318,7 +1317,7 @@ bad_fork_cleanup_mm:
 	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
-		put_signal_struct(p->signal);
+		free_signal_struct(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
