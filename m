Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2EXOQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:16:51 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50354 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2EXOQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:16:49 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v6 0/4] CPU hotplug, cpusets, suspend/resume: Fixes,
 cleanups and optimizations
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, rientjes@google.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 24 May 2012 19:46:01 +0530
Message-ID: <20120524141510.3692.64549.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12052403-9264-0000-0000-00000192AF05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel doesn't handle cpusets properly during suspend/resume.
After a resume, all non-root cpusets end up having only 1 cpu (the boot cpu),
causing massive performance degradation of workloads. One major user of cpusets
is libvirt, which means that after a suspend/hibernation cycle, all VMs
suddenly end up running terribly slow!

Also, the kernel moves the tasks from one cpuset to another during CPU hotplug
in the suspend/resume path, leading to a task-management nightmare after
resume.

Patch 1 fixes this by keeping cpusets unmodified in the suspend/resume path.
But to ensure we don't trip over, it keeps the sched domains updated during
every CPU hotplug in the s/r path.
This is a long standing issue and we need to fix up stable kernels too.

The rest of the patches in the series are mostly cleanups/optimizations.

Changelog:

v6: Drop patch 4 (cpusets: Update tasks' cpus_allowed mask upon updates to
    root cpuset) considering how tasks in the root cpuset must be dealt with.
    No changes to other patches.

v5 : Don't do explicit save/restore of cpusets' cpu masks during s/r, to avoid
     the overhead of a new per-cpuset cpu mask to help with that. Also, ensure
     that the sched domains are updated on each hotplug.
     The s/r fix (patch 1) is now distinct from the cleanups (patches 2-5).

v4 : (Never had this version. I skipped from v3 to v5 accidentally).

v3 : Explicitly save and restore cpusets' cpu masks during s/r. Don't alter
     the semantics of regular cpu hotplug.
     http://thread.gmane.org/gmane.linux.kernel/1296339

v2 : http://thread.gmane.org/gmane.linux.documentation/4805/

v1 : thread.gmane.org/gmane.linux.kernel/1250097/

--
 Srivatsa S. Bhat (4):
      CPU hotplug, cpusets, suspend: Don't modify cpusets during suspend/resume
      cpusets, hotplug: Implement cpuset tree traversal in a helper function
      cpusets, hotplug: Restructure functions that are invoked during hotplug
      cpusets: Remove/update outdated comments


  include/linux/cpuset.h |    4 +
 kernel/cpuset.c        |  130 ++++++++++++++++++++++++++++++++++--------------
 kernel/sched/core.c    |   44 ++++++++++++++--
 3 files changed, 132 insertions(+), 46 deletions(-)



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

