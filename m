Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1IGGUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:20:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37581 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab1IGGUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 32/55] rcu: Make rcu_assign_pointer() unconditionally insert a memory barrier
Date: Tue,  6 Sep 2011 11:00:26 -0700
Message-Id: <1315332049-2604-32-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-000000711742
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

Recent changes to gcc give warning messages on rcu_assign_pointers()'s
checks that allow it to determine when it is OK to omit the memory
barrier.  Stephen Hemminger tried a number of gcc tricks to silence
this warning, but #pragmas and CPP macros do not work together in the
way that would be required to make this work.

However, we now have RCU_INIT_POINTER(), which already omits this
memory barrier, and which therefore may be used when assigning NULL to
an RCU-protected pointer that is accessible to readers.  This commit
therefore makes rcu_assign_pointer() unconditionally emit the memory
barrier.

Reported-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ea80396..b2e5fe8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -443,9 +443,7 @@ extern int rcu_my_thread_group_empty(void);
 	})
 #define __rcu_assign_pointer(p, v, space) \
 	({ \
-		if (!__builtin_constant_p(v) || \
-		    ((v) != NULL)) \
-			smp_wmb(); \
+		smp_wmb(); \
 		(p) = (typeof(*v) __force space *)(v); \
 	})
 
-- 
1.7.3.2

