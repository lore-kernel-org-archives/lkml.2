Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0K3JKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:10:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:59221 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab0K3JKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:10:30 -0500
Date: Tue, 30 Nov 2010 09:09:46 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, pjt@google.com,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, efault@gmx.de,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20101130005740.080828123@google.com>
References: <20101130005740.080828123@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix unregister_fair_sched_group()
Message-ID: <tip-822bc180a7f7a7bc5fcaaea195f41b487cc8cae8@git.kernel.org>
Git-Commit-ID: 822bc180a7f7a7bc5fcaaea195f41b487cc8cae8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Nov 2010 09:09:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  822bc180a7f7a7bc5fcaaea195f41b487cc8cae8
Gitweb:     http://git.kernel.org/tip/822bc180a7f7a7bc5fcaaea195f41b487cc8cae8
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 29 Nov 2010 16:55:40 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 30 Nov 2010 10:07:10 +0100

sched: Fix unregister_fair_sched_group()

In the flipping and flopping between calling
unregister_fair_sched_group() on a per-cpu versus per-group basis
we ended up in a bad state.

Remove from the list for the passed cpu as opposed to some
arbitrary index.

( This fixes explosions w/ autogroup as well as a group
  creation/destruction stress test. )

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20101130005740.080828123@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 35a6373..66ef579 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8085,7 +8085,6 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
-	int i;
 
 	/*
 	* Only empty task groups can be destroyed; so we can speculatively
@@ -8095,7 +8094,7 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 		return;
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
-	list_del_leaf_cfs_rq(tg->cfs_rq[i]);
+	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 #else /* !CONFG_FAIR_GROUP_SCHED */
