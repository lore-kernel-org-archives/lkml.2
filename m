Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab2EDTVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:21:09 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:34628 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759412Ab2EDTVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:21:06 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 6/7] cpusets: Optimize the implementation of
 guarantee_online_cpus()
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Sat, 05 May 2012 00:50:25 +0530
Message-ID: <20120504192014.4603.41932.stgit@srivatsabhat>
In-Reply-To: <20120504191535.4603.83236.stgit@srivatsabhat>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12050419-8878-0000-0000-000002490DA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A cpuset's cpus_allowed mask is kept updated upon CPU hotplug
events in such a way that it always contains online cpus. Using
this observation, rework the body of guarantee_online_cpus().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpuset.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c501a90..6446095 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -301,20 +301,23 @@ static struct file_system_type cpuset_fs_type = {
  * One way or another, we guarantee to return some non-empty subset
  * of cpu_online_mask.
  *
+ * Optimization: The cpus_allowed mask of a cpuset is maintained in such
+ * a way as to always have online cpus, by doing the cpuset hiearchy walk
+ * if/when necessary during CPU hotplug. And hence, it fits the above
+ * requirement perfectly. The only point to watch out is that cpus_allowed
+ * can be empty when the cpuset has no tasks and user_cpus_allowed is empty.
+ *
  * Call with callback_mutex held.
  */
 
 static void guarantee_online_cpus(const struct cpuset *cs,
 				  struct cpumask *pmask)
 {
-	while (cs && !cpumask_intersects(cs->user_cpus_allowed,
-							cpu_online_mask))
-		cs = cs->parent;
-
-	if (cs)
-		cpumask_and(pmask, cs->user_cpus_allowed, cpu_online_mask);
+	if (cs && !cpumask_empty(cs->cpus_allowed))
+		cpumask_copy(pmask, cs->cpus_allowed);
 	else
 		cpumask_copy(pmask, cpu_online_mask);
+
 	BUG_ON(!cpumask_intersects(pmask, cpu_online_mask));
 }
 

