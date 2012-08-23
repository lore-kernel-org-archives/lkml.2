Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030523Ab2HWPAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:00:08 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40650 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2HWO7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:59:11 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        "3.2.x.." <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 09/11] parisc: Add missing RCU idle APIs on idle loop
Date: Thu, 23 Aug 2012 16:58:33 +0200
Message-Id: <1345733915-20040-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
References: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the old times, the whole idle task was considered
as an RCU quiescent state. But as RCU became more and
more successful overtime, some RCU read side critical
section have been added even in the code of some
architectures idle tasks, for tracing for example.

So nowadays, rcu_idle_enter() and rcu_idle_exit() must
be called by the architecture to tell RCU about the part
in the idle loop that doesn't make use of rcu read side
critical sections, typically the part that puts the CPU
in low power mode.

This is necessary for RCU to find the quiescent states in
idle in order to complete grace periods.

Add this missing pair of calls in the parisc's idle loop.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Parisc <linux-parisc@vger.kernel.org>
Cc: 3.2.x.. <stable@vger.kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/parisc/kernel/process.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index d4b94b3..c54a4db 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -48,6 +48,7 @@
 #include <linux/unistd.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
+#include <linux/rcupdate.h>
 
 #include <asm/io.h>
 #include <asm/asm-offsets.h>
@@ -69,8 +70,10 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			barrier();
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 		check_pgt_cache();
 	}
-- 
1.7.5.4

