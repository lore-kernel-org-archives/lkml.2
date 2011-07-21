Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1GUS2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:28:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:49825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab1GUS2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:28:10 -0400
Date: Thu, 21 Jul 2011 18:27:57 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-9bbd7374361d9bfc75108c3ad1c1b6db28b1be59@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <CAPM31R+2Ke2urUZKao5W92_LupdR4AYEv-EZWiJ3tG=tEes2cw@mail.gmail.com>
References: <CAPM31R+2Ke2urUZKao5W92_LupdR4AYEv-EZWiJ3tG=tEes2cw@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: update correct entity's runtime in check_preempt_wakeup()
Git-Commit-ID: 9bbd7374361d9bfc75108c3ad1c1b6db28b1be59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:27:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9bbd7374361d9bfc75108c3ad1c1b6db28b1be59
Gitweb:     http://git.kernel.org/tip/9bbd7374361d9bfc75108c3ad1c1b6db28b1be59
Author:     Paul Turner <pjt@google.com>
AuthorDate: Tue, 5 Jul 2011 19:07:21 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 18:01:43 +0200

sched: update correct entity's runtime in check_preempt_wakeup()

While looking at check_preempt_wakeup() I realized that we are
potentially updating the wrong entity in the fair-group scheduling
case. In this case the current task's cfs_rq may not be the same as
the one used for the comparison between the waking task and the
existing task's vruntime.

This potentially results in us using a stale vruntime in the
pre-emption decision, providing a small false preference for the
previous task. The effects of this are bounded since we always
perform a hierarchal update on the tick.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/CAPM31R+2Ke2urUZKao5W92_LupdR4AYEv-EZWiJ3tG=tEes2cw@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e7d67a9..f88720b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1919,8 +1919,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
+	update_curr(cfs_rq_of(se));
 	BUG_ON(!pse);
 	if (wakeup_preempt_entity(se, pse) == 1) {
 		/*
