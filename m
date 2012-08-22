Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab2HVQYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:24:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48199 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab2HVQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:24:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "3.2.x.." <stable@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 04/10] h8300: Add missing RCU idle APIs on idle loop
Date: Wed, 22 Aug 2012 18:23:42 +0200
Message-Id: <1345652628-15060-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345652628-15060-1-git-send-email-fweisbec@gmail.com>
References: <1345652628-15060-1-git-send-email-fweisbec@gmail.com>
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

Add this missing pair of calls in the h8300's idle loop.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: 3.2.x.. <stable@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/h8300/kernel/process.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 0e9c315..f153ed1 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -36,6 +36,7 @@
 #include <linux/reboot.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 #include <asm/traps.h>
@@ -78,8 +79,10 @@ void (*idle)(void) = default_idle;
 void cpu_idle(void)
 {
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			idle();
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 	}
 }
-- 
1.7.5.4

