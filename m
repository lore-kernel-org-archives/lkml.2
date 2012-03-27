Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab2C0Pe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:34:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39913 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab2C0Pev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:34:51 -0400
Date: Tue, 27 Mar 2012 08:34:24 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-yaezmlbriluh166tfkgni22m@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/x86/smp:
  Do not enable IRQs over calibrate_delay()
Git-Commit-ID: bc758133ed73d4b06952bec21da23e28e62bf3ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 27 Mar 2012 08:34:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc758133ed73d4b06952bec21da23e28e62bf3ba
Gitweb:     http://git.kernel.org/tip/bc758133ed73d4b06952bec21da23e28e62bf3ba
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 26 Mar 2012 13:16:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 27 Mar 2012 14:50:10 +0200

sched/x86/smp: Do not enable IRQs over calibrate_delay()

We should not ever enable IRQs until we're fully set up. This opens up
a window where interrupts can hit the cpu and interrupts can do
wakeups, wakeups need state that isn't set-up yet, in particular this
cpu isn't elegible to run tasks, so if any cpu-affine task that got
created in CPU_UP_PREPARE manages to get a wakeup, its affinity mask
will get broken and we'll run into lots of 'interesting' problems.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-yaezmlbriluh166tfkgni22m@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 58f7816..89571a0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -219,14 +219,9 @@ static void __cpuinit smp_callin(void)
 	 * Update loops_per_jiffy in cpu_data. Previous call to
 	 * smp_store_cpu_info() stored a value that is close but not as
 	 * accurate as the value just calculated.
-	 *
-	 * Need to enable IRQs because it can take longer and then
-	 * the NMI watchdog might kill us.
 	 */
-	local_irq_enable();
 	calibrate_delay();
 	cpu_data(cpuid).loops_per_jiffy = loops_per_jiffy;
-	local_irq_disable();
 	pr_debug("Stack at about %p\n", &cpuid);
 
 	/*
