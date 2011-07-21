Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1GUSag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:30:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:49937 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab1GUSae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:30:34 -0400
Date: Thu, 21 Jul 2011 18:30:11 GMT
From: tip-bot for Bianca Lutz <sowilo@cs.tu-berlin.de>
Message-ID: <tip-99bc52429f11d1f4f81495ac8237085aaeb6bccf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, schnhrr@cs.tu-berlin.de,
        sowilo@cs.tu-berlin.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schnhrr@cs.tu-berlin.de, a.p.zijlstra@chello.nl,
        sowilo@cs.tu-berlin.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1310580816-10861-7-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310580816-10861-7-git-send-email-schnhrr@cs.tu-berlin.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Do not attempt to destroy uninitialized rt_bandwidth
Git-Commit-ID: 99bc52429f11d1f4f81495ac8237085aaeb6bccf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:30:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99bc52429f11d1f4f81495ac8237085aaeb6bccf
Gitweb:     http://git.kernel.org/tip/99bc52429f11d1f4f81495ac8237085aaeb6bccf
Author:     Bianca Lutz <sowilo@cs.tu-berlin.de>
AuthorDate: Wed, 13 Jul 2011 20:13:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 18:01:51 +0200

sched: Do not attempt to destroy uninitialized rt_bandwidth

If a task group is to be created and alloc_fair_sched_group() fails,
then the rt_bandwidth of the corresponding task group is not yet
initialized. The caller, sched_create_group(), starts a clean up
procedure which calls free_rt_sched_group() which unconditionally
destroys the not yet initialized rt_bandwidth.

This crashes or hangs the system in lock_hrtimer_base(): UP systems
dereference a NULL pointer, while SMP systems loop endlessly on a
condition that cannot become true.

This patch simply avoids the destruction of rt_bandwidth when the
initialization code path was not reached.

(This was discovered by accident with a custom kernel modification.)

Signed-off-by: Bianca Lutz <sowilo@cs.tu-berlin.de>
Signed-off-by: Jan Schoenherr <schnhrr@cs.tu-berlin.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1310580816-10861-7-git-send-email-schnhrr@cs.tu-berlin.de
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3b3826e..f107204 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8383,7 +8383,8 @@ static void free_rt_sched_group(struct task_group *tg)
 {
 	int i;
 
-	destroy_rt_bandwidth(&tg->rt_bandwidth);
+	if (tg->rt_se)
+		destroy_rt_bandwidth(&tg->rt_bandwidth);
 
 	for_each_possible_cpu(i) {
 		if (tg->rt_rq)
