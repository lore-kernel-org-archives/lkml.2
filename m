Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967463Ab2EQRAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:00:08 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39302 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab2EQRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:00:05 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v5 0/5] CPU hotplug, cpusets, suspend/resume: Fixes,
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
Date: Thu, 17 May 2012 22:29:15 +0530
Message-ID: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051716-2674-0000-0000-00000482055D
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

The rest of the patches in the series are mostly cleanups/optimizations
(except patch 4 which is a non-critical bug fix).

--
 Srivatsa S. Bhat (5):
      CPU hotplug, cpusets, suspend: Don't modify cpusets during suspend/resume
      cpusets, hotplug: Implement cpuset tree traversal in a helper function
      cpusets, hotplug: Restructure functions that are invoked during hotplug
      cpusets: Update tasks' cpus_allowed mask upon updates to root cpuset
      cpusets: Remove/update outdated comments


  include/linux/cpuset.h |    4 +
 kernel/cpuset.c        |  161 +++++++++++++++++++++++++++++++++++-------------
 kernel/sched/core.c    |   44 +++++++++++--
 3 files changed, 159 insertions(+), 50 deletions(-)



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

