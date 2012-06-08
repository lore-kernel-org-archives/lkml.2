Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab2FHE16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:27:58 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60539 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab2FHE14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:56 -0400
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
Subject: [PATCH rcu 7/8] rcu: Round FAST_NO_HZ lazy timeout to nearest second
Date: Thu,  7 Jun 2012 21:26:54 -0700
Message-Id: <1339129615-1795-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120608042632.GA1250@linux.vnet.ibm.com>
 <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-4242-0000-0000-000001E8010A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, if several CPUs in the same package have all lazy RCU
callbacks, their wakeups will be uncorrelated.  If all the CPUs are in the
same power domain (as is often the case), this will result in unnecessary
power-ups of the package.  This commit therefore uses round_jiffies()
to round the timeouts to a second boundary, increasing the odds that
they can be coalesced with each other or with other timeouts.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 5271a02..4451362b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2182,7 +2182,7 @@ static void rcu_prepare_for_idle(int cpu)
 					   jiffies + RCU_IDLE_GP_DELAY;
 		} else {
 			rdtp->idle_gp_timer_expires =
-					   jiffies + RCU_IDLE_LAZY_GP_DELAY;
+				round_jiffies(jiffies + RCU_IDLE_LAZY_GP_DELAY);
 			trace_rcu_prep_idle("Dyntick with lazy callbacks");
 		}
 		tp = &rdtp->idle_gp_timer;
-- 
1.7.8

