Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0IWAv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:51:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53030 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab0IWAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:51:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/8] rcu: fix sparse errors in rcutorture.c
Date: Wed, 22 Sep 2010 17:50:51 -0700
Message-Id: <1285203053-22068-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100923005033.GA22006@linux.vnet.ibm.com>
References: <20100923005033.GA22006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the sparse __rcu address-space identifier and make a couple of
variables static.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 7297102..9afa047 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -120,7 +120,7 @@ struct rcu_torture {
 };
 
 static LIST_HEAD(rcu_torture_freelist);
-static struct rcu_torture *rcu_torture_current;
+static struct rcu_torture __rcu *rcu_torture_current;
 static long rcu_torture_current_version;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
@@ -153,7 +153,8 @@ int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 #define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
 #define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
 static int fullstop = FULLSTOP_RMMOD;
-DEFINE_MUTEX(fullstop_mutex);	/* Protect fullstop transitions and spawning */
+static DEFINE_MUTEX(fullstop_mutex);
+				/* Protect fullstop transitions and spawning */
 				/*  of kthreads. */
 
 /*
@@ -737,7 +738,8 @@ rcu_torture_writer(void *arg)
 			continue;
 		rp->rtort_pipe_count = 0;
 		udelay(rcu_random(&rand) & 0x3ff);
-		old_rp = rcu_torture_current;
+		old_rp = rcu_dereference_check(rcu_torture_current,
+					       current == writer_task);
 		rp->rtort_mbtest = 1;
 		rcu_assign_pointer(rcu_torture_current, rp);
 		smp_wmb(); /* Mods to old_rp must follow rcu_assign_pointer() */
-- 
1.7.0.6

