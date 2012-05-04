Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab2EDTSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:18:06 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51068 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2EDTSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:18:03 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 0/7] CPU hotplug,
 cpusets: Fix issues with cpusets handling upon CPU hotplug
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Sat, 05 May 2012 00:47:20 +0530
Message-ID: <20120504191535.4603.83236.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12050419-2000-0000-0000-0000075AD29A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several issues related to how cpusets are handled during CPU
hotplug. One of the most annoying and noticeable consequences of this flaw
is that, after a suspend/resume or hibernation/restore, all non-root cpusets
will have only 1 cpu (the boot cpu) in their cpusets. Hence the tasks in
those cpusets get pinned to the boot cpu alone, leading to a drastic
performance degradation of those tasks/workloads.

One major user of cpusets is libvirt, which means that after a
suspend/hibernation cycle, all VMs suddenly end up running terribly slow!

This patchset solves these problems by reworking the way cpusets are handled
during CPU hotplug.

Patches 1 & 2 are cleanups that separate out hotplug handling so that we can
implement different logic for different hotplug events (CPU/Mem
online/offline). This also leads to some optimizations and more importantly
prepares the ground for implementing the cpuset fix for CPU hotplug.

Patches 3 & 4 are the core of the new solution for cpuset handling for
CPU hotplug. Patch 3 introduces the infrastructure needed, and Patch 4
exploits it for hotplug handling.

Patch 5 adds documentation for the new cpuset handling.
Patch 6 is an optimization opened up by the previous patches.
Patch 7 is a trivial removal of an outdated comment.

--
 Srivatsa S. Bhat (7):
      cpusets, hotplug: Implement cpuset tree traversal in a helper function
      cpusets, hotplug: Restructure functions that are invoked during hotplug
      cpusets: Introduce 'user_cpus_allowed' and rework the semantics of 'cpus_allowed'
      CPU hotplug, cpusets: Workout hotplug handling for cpusets
      Docs, cpusets: Update the cpuset documentation
      cpusets: Optimize the implementation of guarantee_online_cpus()
      cpusets: Remove out-dated comment about cpuset_track_online_cpus


  Documentation/cgroups/cpusets.txt |   43 +++--
 include/linux/cpuset.h            |    4 
 kernel/cpuset.c                   |  317 ++++++++++++++++++++++++++++---------
 kernel/sched/core.c               |    4 
 4 files changed, 274 insertions(+), 94 deletions(-)



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

