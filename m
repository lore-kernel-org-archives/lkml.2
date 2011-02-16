Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab1BPDUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:20:47 -0500
Received: from smtp-out.google.com ([74.125.121.67]:29609 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab1BPDUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:20:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=KS5B5dSlQMz/j4FaKK9YN0DbjY85KrscfLP3KhEpEk/Rtfk8ahKT5B9YZuiRgQotd
	eTnvAuU2+0FP4i79qCu6Q==
Message-Id: <20110216031841.443879120@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Feb 2011 19:18:38 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Subject: [CFS Bandwidth Control v4 7/7] sched: add documentation for bandwidth control
References: <20110216031831.571628191@google.com>
Content-Disposition: inline; filename=sched-bwc-documentation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Basic description of usage and effect for CFS Bandwidth Control.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Paul Turner <pjt@google.com>
---
 Documentation/scheduler/sched-bwc.txt |   98
 ++++++++++++++++++++++++++++++++++
  1 file changed, 98 insertions(+)

--- /dev/null
+++ b/Documentation/scheduler/sched-bwc.txt
@@ -0,0 +1,98 @@
+CFS Bandwidth Control (aka CPU hard limits)
+===========================================
+
+[ This document talks about CPU bandwidth control of CFS groups only.
+  The bandwidth control of RT groups is explained in
+  Documentation/scheduler/sched-rt-group.txt ]
+
+CFS bandwidth control is a group scheduler extension that can be used to
+control the maximum CPU bandwidth obtained by a CPU cgroup.
+
+Bandwidth allowed for a group is specified using quota and period. Within
+a given "period" (microseconds), a group is allowed to consume up to "quota"
+microseconds of CPU time, which is the upper limit or the hard limit. When the
+CPU bandwidth consumption of a group exceeds the hard limit, the tasks in the
+group are throttled and are not allowed to run until the end of the period at
+which time the group's quota is replenished.
+
+Runtime available to the group is tracked globally. At the beginning of
+every period, group's global runtime pool is replenished with "quota"
+microseconds worth of runtime. The runtime consumption happens locally at each
+CPU by fetching runtimes in "slices" from the global pool.
+
+Interface
+---------
+Quota and period can be set via cgroup files.
+
+cpu.cfs_quota_us: the enforcement interval (microseconds)
+cpu.cfs_period_us: the maximum allowed bandwidth (microseconds)
+
+Within a period of cpu.cfs_period_us, the group as a whole will not be allowed
+to consume more than cpu_cfs_quota_us worth of runtime.
+
+The default value of cpu.cfs_period_us is 500ms and the default value
+for cpu.cfs_quota_us is -1.
+
+A group with cpu.cfs_quota_us as -1 indicates that the group has infinite
+bandwidth, which means that it is not bandwidth controlled.
+
+Writing any negative value to cpu.cfs_quota_us will turn the group into
+an infinite bandwidth group. Reading cpu.cfs_quota_us for an infinite
+bandwidth group will always return -1.
+
+System wide settings
+--------------------
+The amount of runtime obtained from global pool every time a CPU wants the
+group quota locally is controlled by a sysctl parameter
+sched_cfs_bandwidth_slice_us. The current default is 10ms. This can be changed
+by writing to /proc/sys/kernel/sched_cfs_bandwidth_slice_us.
+
+Statistics
+----------
+cpu.stat file lists three different stats related to CPU bandwidth control.
+
+nr_periods: Number of enforcement intervals that have elapsed.
+nr_throttled: Number of times the group has been throttled/limited.
+throttled_time: The total time duration (in nanoseconds) for which the group
+remained throttled.
+
+These files are read-only.
+
+Hierarchy considerations
+------------------------
+Each group's bandwidth (quota and period) can be set independent of its
+parent or child groups. There are two ways in which a group can get
+throttled:
+
+- it consumed its quota within the period
+- it has quota left but the parent's quota is exhausted.
+
+In the 2nd case, even though the child has quota left, it will not be
+able to run since the parent itself is throttled. Similarly groups that are
+not bandwidth constrained might end up being throttled if any parent
+in their hierarchy is throttled.
+
+Examples
+--------
+1. Limit a group to 1 CPU worth of runtime.
+
+	If period is 500ms and quota is also 500ms, the group will get
+	1 CPU worth of runtime every 500ms.
+
+	# echo 500000 > cpu.cfs_quota_us /* quota = 500ms */
+	# echo 500000 > cpu.cfs_period_us /* period = 500ms */
+
+2. Limit a group to 2 CPUs worth of runtime on a multi-CPU machine.
+
+	With 500ms period and 1000ms quota, the group can get 2 CPUs worth of
+	runtime every 500ms.
+
+	# echo 1000000 > cpu.cfs_quota_us /* quota = 1000ms */
+	# echo 500000 > cpu.cfs_period_us /* period = 500ms */
+
+3. Limit a group to 20% of 1 CPU.
+
+	With 500ms period, 100ms quota will be equivalent to 20% of 1 CPU.
+
+	# echo 100000 > cpu.cfs_quota_us /* quota = 100ms */
+	# echo 500000 > cpu.cfs_period_us /* period = 500ms */


