Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477Ab2EDTUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:20:53 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:48164 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417Ab2EDTUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:20:51 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 5/7] Docs, cpusets: Update the cpuset documentation
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Sat, 05 May 2012 00:49:58 +0530
Message-ID: <20120504191938.4603.62771.stgit@srivatsabhat>
In-Reply-To: <20120504191535.4603.83236.stgit@srivatsabhat>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12050419-2674-0000-0000-00000448037C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the newly introduced cpuset.actual_cpus file and
describe the new semantics for updating cpusets upon CPU hotplug.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 Documentation/cgroups/cpusets.txt |   43 +++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index cefd3d8..374b9d2 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -168,7 +168,12 @@ Each cpuset is represented by a directory in the cgroup file system
 containing (on top of the standard cgroup files) the following
 files describing that cpuset:
 
- - cpuset.cpus: list of CPUs in that cpuset
+ - cpuset.cpus: list of CPUs in that cpuset, as set by the user;
+		the kernel will not alter this upon CPU hotplug;
+		this file has read/write permissions
+ - cpuset.actual_cpus: list of CPUs actually available for the tasks in the
+                       cpuset; the kernel can change this in the event of
+		       CPU hotplug; this file is read-only
  - cpuset.mems: list of Memory Nodes in that cpuset
  - cpuset.memory_migrate flag: if set, move pages to cpusets nodes
  - cpuset.cpu_exclusive flag: is cpu placement exclusive?
@@ -640,16 +645,25 @@ prior 'cpuset.mems' setting, will not be moved.
 
 There is an exception to the above.  If hotplug functionality is used
 to remove all the CPUs that are currently assigned to a cpuset,
-then all the tasks in that cpuset will be moved to the nearest ancestor
-with non-empty cpus.  But the moving of some (or all) tasks might fail if
-cpuset is bound with another cgroup subsystem which has some restrictions
-on task attaching.  In this failing case, those tasks will stay
-in the original cpuset, and the kernel will automatically update
-their cpus_allowed to allow all online CPUs.  When memory hotplug
-functionality for removing Memory Nodes is available, a similar exception
-is expected to apply there as well.  In general, the kernel prefers to
-violate cpuset placement, over starving a task that has had all
-its allowed CPUs or Memory Nodes taken offline.
+then the cpuset hierarchy is traversed, searching for the nearest
+ancestor whose cpu mask has atleast one online cpu. Then the tasks in
+the empty cpuset will be run on the cpus specified in that ancestor's cpu mask.
+Note that during CPU hotplug operations, the tasks in a cpuset will not
+be moved from one cpuset to another; only the the cpu mask of that cpuset
+will be updated to ensure that there is atleast one online cpu, by trying
+to closely resemble the cpu mask of the nearest non-empty ancestor containing
+online cpus.
+
+When memory hotplug functionality for removing Memory Nodes is available,
+if all the memory nodes currently assigned to a cpuset are removed via
+hotplug, then all the tasks in that cpuset will be moved to the nearest
+ancestor with non-empty memory nodes. But the moving of some (or all)
+tasks might fail if cpuset is bound with another cgroup subsystem which
+has some restrictions on task attaching.  In this failing case, those
+tasks will stay in the original cpuset, and the kernel will automatically
+update their mems_allowed to allow all online nodes.
+In general, the kernel prefers to violate cpuset placement, over starving
+a task that has had all its allowed CPUs or Memory Nodes taken offline.
 
 There is a second exception to the above.  GFP_ATOMIC requests are
 kernel internal allocations that must be satisfied, immediately.
@@ -730,9 +744,10 @@ cgroup.event_control   cpuset.memory_spread_page
 cgroup.procs           cpuset.memory_spread_slab
 cpuset.cpu_exclusive   cpuset.mems
 cpuset.cpus            cpuset.sched_load_balance
-cpuset.mem_exclusive   cpuset.sched_relax_domain_level
-cpuset.mem_hardwall    notify_on_release
-cpuset.memory_migrate  tasks
+cpuset.actual_cpus     cpuset.sched_relax_domain_level
+cpuset.mem_exclusive   notify_on_release
+cpuset.mem_hardwall    tasks
+cpuset.memory_migrate
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using

