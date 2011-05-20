Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463Ab1ETOCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:02:37 -0400
Received: from mail201c2.megamailservers.com ([69.49.111.102]:57975 "EHLO
	mail201c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933407Ab1ETOCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:02:35 -0400
X-POP-User: ekergarn.gaisler.com
From: Daniel Hellstrom <daniel@gaisler.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, sfr@canb.auug.org.au, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Fix merge problem between sparc32 IPI patches and schedule_ipi() callback
Date: Fri, 20 May 2011 16:01:09 +0200
Message-Id: <1305900070-23492-1-git-send-email-daniel@gaisler.com>
X-Mailer: git-send-email 1.5.4
X-CSC: 0
X-CHA: v=1.1 cv=Ma2F9VxktdrohpwE1Ldo3j5zboDzDSax3kyf6Hawm04= c=1 sm=1
		a=2QoJ5Ut_8lUA:10 a=U62ajLuCel8A:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=ebG-ZW-8AAAA:8 a=Ity87KJWW3mdQWvLj-MA:9 a=tPjFfGPRH6rT9vyXfKUA:7
		a=cCYF7-FHeg4A:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a merge conflict in arch/sparc/kernel/smp_32.c between commit
d6d048192b1d ("sparc32: implement SMP IPIs using the generic functions")
from the sparc tree and commit 184748cc50b2 ("sched: Provide
scheduler_ipi() callback in response to smp_send_reschedule()").

The patch adds a call to scheduler_ipi() from the resched IPI handler in
sparc32.

Signed-off-by: Daniel Hellstrom <daniel@gaisler.com>
---
 arch/sparc/kernel/smp_32.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 41102c5..d5b3958 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -156,11 +156,11 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 
 void smp_resched_interrupt(void)
 {
+	irq_enter();
+	scheduler_ipi();
 	local_cpu_data().irq_resched_count++;
-	/*
-	 * do nothing, since it all was about calling re-schedule
-	 * routine called by interrupt return code.
-	 */
+	irq_exit();
+	/* re-schedule routine called by interrupt return code. */
 }
 
 void smp_call_function_single_interrupt(void)
-- 
1.6.0.3

