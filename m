Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab2BDBqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:46:48 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57246 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab2BDBqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:46:33 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 38/47] lockdep: Add CPU-idle/offline warning to lockdep-RCU splat
Date: Fri,  3 Feb 2012 17:45:13 -0800
Message-Id: <1328319922-30828-38-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-2398-0000-0000-000003ED6A96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

It is illegal to use RCU from a CPU that has reported idleness or
offlinedness to RCU.  However, it can be quite difficult to determine
from a stack trace whether or not a given CPU is idle or offline.
Therefore, this commit adds idle/offline diagnostics to the lockdep-RCU
error message.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/lockdep.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8889f7d..ea9ee45 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4176,7 +4176,13 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	printk("-------------------------------\n");
 	printk("%s:%d %s!\n", file, line, s);
 	printk("\nother info that might help us debug this:\n\n");
-	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
+	printk("\n%srcu_scheduler_active = %d, debug_locks = %d\n",
+	       !rcu_lockdep_current_cpu_online()
+			? "RCU used illegally from offline CPU!\n"
+			: rcu_is_cpu_idle()
+				? "RCU used illegally from idle CPU!\n"
+				: "",
+	       rcu_scheduler_active, debug_locks);
 
 	/*
 	 * If a CPU is in the RCU-free window in idle (ie: in the section
-- 
1.7.8

