Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1IGGZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:25:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38185 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741Ab1IGGVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 43/55] rcu: Make rcu_torture_boost() exit loops at end of test
Date: Tue,  6 Sep 2011 11:00:37 -0700
Message-Id: <1315332049-2604-43-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

One of the loops in rcu_torture_boost() fails to check kthread_should_stop(),
and thus might be slowing or even stopping completion of rcutorture tests
at rmmod time.  This commit adds the kthread_should_stop() check to the
offending loop.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index eb739c0..76fe893 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -779,7 +779,8 @@ static int rcu_torture_boost(void *arg)
 		 * interval.  Besides, we are running at RT priority,
 		 * so delays should be relatively rare.
 		 */
-		while (oldstarttime == boost_starttime) {
+		while (oldstarttime == boost_starttime &&
+		       !kthread_should_stop()) {
 			if (mutex_trylock(&boost_mutex)) {
 				boost_starttime = jiffies +
 						  test_boost_interval * HZ;
-- 
1.7.3.2

