Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab1EaMbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:31:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:41647 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1EaMbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:31:53 -0400
Date: Tue, 31 May 2011 12:31:20 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        markus@trippelsdorf.de, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, markus@trippelsdorf.de, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306835745.2353.3.camel@twins>
References: <1306835745.2353.3.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote wakeups
Git-Commit-ID: f01114cb59d670e9b4f2c335930dd57db96e9360
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 May 2011 12:31:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f01114cb59d670e9b4f2c335930dd57db96e9360
Gitweb:     http://git.kernel.org/tip/f01114cb59d670e9b4f2c335930dd57db96e9360
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 31 May 2011 12:26:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 31 May 2011 14:19:56 +0200

sched: Fix cross-cpu clock sync on remote wakeups

Markus reported that commit 317f394160e ("sched: Move the second half
of ttwu() to the remote cpu") caused some accounting funnies on his AMD
Phenom II X4, such as weird 'top' results.

It turns out that this is due to non-synced TSC and the queued remote
wakeups stopped coupeling the two relevant cpu clocks, which leads to
wakeups seeing time jumps, which in turn lead to skewed runtime stats.

Add an explicit call to sched_clock_cpu() to couple the per-cpu clocks
to restore the normal flow of time.

Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1306835745.2353.3.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index cbb3a0e..49cc70b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2600,6 +2600,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 
 #if defined(CONFIG_SMP)
 	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+		sched_clock_cpu(cpu); /* sync clocks x-cpu */
 		ttwu_queue_remote(p, cpu);
 		return;
 	}
