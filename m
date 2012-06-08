Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2FHE1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 00:27:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45597 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2FHE1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 00:27:05 -0400
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
Subject: [PATCH rcu 1/8] rcu: RCU_FAST_NO_HZ detection of callback adoption
Date: Thu,  7 Jun 2012 21:26:48 -0700
Message-Id: <1339129615-1795-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120608042632.GA1250@linux.vnet.ibm.com>
References: <20120608042632.GA1250@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060804-6148-0000-0000-00000685AA9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

In the present implementations of CPU hotplug, the outgoing CPU is
guaranteed to run its stop-machine process on the way out, which
will guarantee that RCU_FAST_NO_HZ forces the CPU out of dyntick-idle
mode.

However, new versions of CPU hotplug might not work this way.  This
commit therefore removes this design constraint by explicitly notifying
CPUs when they adopt non-lazy RCU callbacks.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
---
 kernel/rcutree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0da7b88..3b0f133 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1397,6 +1397,8 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 	rdp->qlen_lazy += rsp->qlen_lazy;
 	rdp->qlen += rsp->qlen;
 	rdp->n_cbs_adopted += rsp->qlen;
+	if (rsp->qlen_lazy != rsp->qlen)
+		rcu_idle_count_callbacks_posted();
 	rsp->qlen_lazy = 0;
 	rsp->qlen = 0;
 
-- 
1.7.8

