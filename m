Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0IKHuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 03:50:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:39754 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806Ab0IKHuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 03:50:24 -0400
Date: Sat, 11 Sep 2010 07:49:07 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, nico-linux-20100709@schottelius.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, flo@xssn.at,
        lenb@kernel.org, jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, nico-linux-20100709@schottelius.org,
        torvalds@linux-foundation.org, peterz@infradead.org, flo@xssn.at,
        lenb@kernel.org, jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu
In-Reply-To: <1284150773.402.122.camel@laptop>
References: <1284150773.402.122.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] x86, tsc: Fix a preemption leak in restore_sched_clock_state()
Message-ID: <tip-55496c896b8a695140045099d4e0175cf09d4eae@git.kernel.org>
Git-Commit-ID: 55496c896b8a695140045099d4e0175cf09d4eae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 11 Sep 2010 07:49:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55496c896b8a695140045099d4e0175cf09d4eae
Gitweb:     http://git.kernel.org/tip/55496c896b8a695140045099d4e0175cf09d4eae
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 10 Sep 2010 22:32:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Sep 2010 09:47:07 +0200

x86, tsc: Fix a preemption leak in restore_sched_clock_state()

Doh, a real life genuine preemption leak..

This caused a suspend failure.

Reported-bisected-and-tested-by-the-invaluable: Jeff Chua <jeff.chua.linux@gmail.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Pritz <flo@xssn.at>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@kernel.org> # Greg, please apply after: cd7240c ("x86, tsc, sched: Recompute cyc2ns_offset's during resume from")
sleep states
LKML-Reference: <1284150773.402.122.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d632934..26a863a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -655,7 +655,7 @@ void restore_sched_clock_state(void)
 
 	local_irq_save(flags);
 
-	get_cpu_var(cyc2ns_offset) = 0;
+	__get_cpu_var(cyc2ns_offset) = 0;
 	offset = cyc2ns_suspend - sched_clock();
 
 	for_each_possible_cpu(cpu)
