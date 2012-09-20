Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab2ITSwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:52:51 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57352 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab2ITStI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:49:08 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 22/23] rcu: Handle unbalanced rcu_node configurations with few CPUs
Date: Thu, 20 Sep 2012 11:48:18 -0700
Message-Id: <1348166900-18716-22-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-2876-0000-0000-00000058A179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If CONFIG_RCU_FANOUT_EXACT=y, if there are not enough CPUs (according
to nr_cpu_ids) to require more than a single rcu_node structure, but if
NR_CPUS is larger than would fit into a single rcu_node structure, then
the current rcu_init_levelspread() code is subject to integer overflow
in the eight-bit ->levelspread[] array in the rcu_state structure.

In this case, the solution is -not- to increase the size of the
elements in this array because the values in that array should be
constrained to the number of bits in an unsigned long.  Instead, this
commit replaces NR_CPUS with nr_cpu_ids in the rcu_init_levelspread()
function's initialization of the cprv local variable.  This results in
all of the arithmetic being consistently based off of the nr_cpu_ids
value, thus avoiding the overflow, which was caused by the mixing of
nr_cpu_ids and NR_CPUS.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7a91dd4..5068e51 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2721,7 +2721,7 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 	int cprv;
 	int i;
 
-	cprv = NR_CPUS;
+	cprv = nr_cpu_ids;
 	for (i = rcu_num_lvls - 1; i >= 0; i--) {
 		ccur = rsp->levelcnt[i];
 		rsp->levelspread[i] = (cprv + ccur - 1) / ccur;
-- 
1.7.8

