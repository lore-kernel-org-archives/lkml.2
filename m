Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2FOS6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:58:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58752 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab2FOS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:58:33 -0400
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
Subject: [PATCH tip/core/rcu 6/6] rcu: Make rcutorture fakewriters invoke rcu_barrier()
Date: Fri, 15 Jun 2012 11:57:54 -0700
Message-Id: <1339786674-25265-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061518-7606-0000-0000-000001286DA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The current rcutorture rcu_barrier() testing never intentionally runs
more than one instance of rcu_barrier() at a given time.  This fails
to test the the shiny new concurrency features of rcu_barrier().  This
commit therefore modifies the rcutorture fakewriter kthread to randomly
invoke rcu_barrier() rather than the usual synchronize_rcu().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 54a3745..dfb4e20 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1025,7 +1025,11 @@ rcu_torture_fakewriter(void *arg)
 	do {
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
 		udelay(rcu_random(&rand) & 0x3ff);
-		cur_ops->sync();
+		if (cur_ops->cb_barrier != NULL &&
+		    rcu_random(&rand) % (NR_CPUS * 8) == 0)
+			cur_ops->cb_barrier();
+		else
+			cur_ops->sync();
 		rcu_stutter_wait("rcu_torture_fakewriter");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 
-- 
1.7.8

