Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3AEQ7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 11:59:22 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46377 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab3AEQ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 11:59:19 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 2/2] rcu: Make rcu_nocb_poll an early_param instead of module_param
Date: Sat,  5 Jan 2013 08:58:51 -0800
Message-Id: <1357405131-13421-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357405131-13421-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105165817.GA13260@linux.vnet.ibm.com>
 <1357405131-13421-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010516-7606-0000-0000-000007269E6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

The as-documented rcu_nocb_poll will fail to enable this feature
for two reasons.  (1) there is an extra "s" in the documented
name which is not in the code, and (2) since it uses module_param,
it really is expecting a prefix, akin to "rcutree.fanout_leaf"
and the prefix isn't documented.

However, there are several reasons why we might not want to
simply fix the typo and add the prefix:

1) we'd end up with rcutree.rcu_nocb_poll, and rather probably make
a change to rcutree.nocb_poll

2) if we did #1, then the prefix wouldn't be consistent with the
rcu_nocbs=<cpumap> parameter (i.e. one with, one without prefix)

3) the use of module_param in a header file is less than desired,
since it isn't immediately obvious that it will get processed
via rcutree.c and get the prefix from that (although use of
module_param_named() could clarify that.)

4) the implied export of /sys/module/rcutree/parameters/rcu_nocb_poll
data to userspace via module_param() doesn't really buy us anything,
as it is read-only and we can tell if it is enabled already without
it, since there is a printk at early boot telling us so.

In light of all that, just change it from a module_param() to an
early_setup() call, and worry about adding it to /sys later on if
we decide to allow a dynamic setting of it.

Also change the variable to be tagged as read_mostly, since it
will only ever be fiddled with at most, once at boot.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 kernel/rcutree_plugin.h             |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 363e348..6c72381 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2438,7 +2438,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			real-time workloads.  It can also improve energy
 			efficiency for asymmetric multiprocessors.
 
-	rcu_nocbs_poll	[KNL,BOOT]
+	rcu_nocb_poll	[KNL,BOOT]
 			Rather than requiring that offloaded CPUs
 			(specified by rcu_nocbs= above) explicitly
 			awaken the corresponding "rcuoN" kthreads,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 43dba2d..c1cc7e1 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -40,8 +40,7 @@
 #ifdef CONFIG_RCU_NOCB_CPU
 static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
 static bool have_rcu_nocb_mask;	    /* Was rcu_nocb_mask allocated? */
-static bool rcu_nocb_poll;	    /* Offload kthread are to poll. */
-module_param(rcu_nocb_poll, bool, 0444);
+static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
 static char __initdata nocb_buf[NR_CPUS * 5];
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
@@ -2159,6 +2158,13 @@ static int __init rcu_nocb_setup(char *str)
 }
 __setup("rcu_nocbs=", rcu_nocb_setup);
 
+static int __init parse_rcu_nocb_poll(char *arg)
+{
+	rcu_nocb_poll = 1;
+	return 0;
+}
+early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
+
 /* Is the specified CPU a no-CPUs CPU? */
 static bool is_nocb_cpu(int cpu)
 {
-- 
1.7.8

