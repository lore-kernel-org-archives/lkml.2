Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2HWPCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:02:47 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64622 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2HWO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:58:47 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Cree <mcree@orcon.net.nz>
Subject: [PATCH 01/11] alpha: Fix preemption handling in idle loop
Date: Thu, 23 Aug 2012 16:58:25 +0200
Message-Id: <1345733915-20040-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
References: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_idle() is called on the boot CPU by the init code with
preemption disabled. But the cpu_idle() function in alpha
doesn't handle this when it calls schedule() directly.

Fix it by converting it into schedule_preempt_disabled().

Also disable preemption before calling cpu_idle() from
secondary CPU entry code to stay consistent with this
state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Richard Henderson<rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: alpha <linux-alpha@vger.kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/kernel/process.c |    3 ++-
 arch/alpha/kernel/smp.c     |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 153d3fc..eac5e01 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -56,7 +56,8 @@ cpu_idle(void)
 
 		while (!need_resched())
 			cpu_relax();
-		schedule();
+
+		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 35ddc02..a41ad90 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -166,6 +166,7 @@ smp_callin(void)
 	DBGS(("smp_callin: commencing CPU %d current %p active_mm %p\n",
 	      cpuid, current, current->active_mm));
 
+	preempt_disable();
 	/* Do nothing.  */
 	cpu_idle();
 }
-- 
1.7.5.4

