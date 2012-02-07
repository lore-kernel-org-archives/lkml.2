Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab2BGSz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:55:59 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:39919 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab2BGSz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:55:57 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 0/4] CPU hotplug,
 cpusets: Fix CPU online handling related to cpusets
To: paul@paulmenage.org, a.p.zijlstra@chello.nl, mingo@elte.hu, rjw@sisk.pl,
        tj@kernel.org
Cc: frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 08 Feb 2012 00:25:41 +0530
Message-ID: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020718-8878-0000-0000-00000139E52B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a very long standing issue related to how cpusets handle CPU
hotplug events. The problem is that when a CPU goes offline, it is removed
from all cpusets. However, when that CPU comes back online, it is added
*only* to the root cpuset. Which means, any task attached to a cpuset lower
in the hierarchy will have one CPU less in its cpuset, though it had this
CPU in its cpuset before the CPU went offline.

The issue gets enormously aggravated in the case of suspend/resume. During
suspend, all non-boot CPUs are taken offline. Which means, all those CPUs
get removed from all the cpusets. When the system resumes, all CPUs are
brought back online; however, the newly onlined CPUs get added only to the
root cpuset - and all other cpusets have cpuset.cpus = 0 (boot cpu alone)!
This means, (as is obvious), all those tasks attached to non-root cpusets
will be constrained to run only on one single cpu!

So, imagine the amount of performance degradation after suspend/resume!!

In particular, libvirt is one of the active users of cpusets. And apparently,
people hit this problem long ago:
https://bugzilla.redhat.com/show_bug.cgi?id=714271

But unfortunately this never got resolved since people probably thought that
the bug was in libvirt... and all this time the kernel was the culprit!

--
 Srivatsa S. Bhat (4):
      CPU hotplug, cpuset: Maintain a copy of the cpus_allowed mask before CPU hotplug
      cpuset: Split up update_cpumask() so that its functionality can be reused
      cpuset: Add function to introduce CPUs to cpusets during CPU online
      CPU hotplug, cpusets: Differentiate the CPU online and CPU offline callbacks


  include/linux/cpuset.h |    4 +
 kernel/cpuset.c        |  177 +++++++++++++++++++++++++++++++++++++++++-------
 kernel/sched/core.c    |   12 +++
 3 files changed, 163 insertions(+), 30 deletions(-)


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

