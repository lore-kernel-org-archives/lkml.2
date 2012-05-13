Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab2EMXP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:15:27 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:32851 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2EMXPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:15:25 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 0/5] CPU hotplug,
 cpusets: Fix issues with cpusets handling during suspend/resume
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 14 May 2012 04:44:31 +0530
Message-ID: <20120513231325.3566.37740.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051323-2674-0000-0000-00000468B394
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

This patchset solves these problems by reworking the way cpusets are handled
during CPU hotplug in the suspend/resume path. This doesn't involve any
change in semantics as to how cpusets are handled during regular CPU hotplug
because it is correct as it is.

Patches 1 & 2 are cleanups that separate out hotplug handling so that we can
implement different logic for different hotplug events (CPU/Mem
online/offline). This also leads to some optimizations and more importantly
prepares the ground for any further work dealing with cpusets during hotplug.

Patch 3 is a bug fix - it ensures that the tasks attached to the root cpuset
see the updated cpus_allowed mask upon CPU hotplug.

Patches 4 and 5 implement the fix for cpusets handling during suspend/resume.

--
 Srivatsa S. Bhat (5):
      cpusets, hotplug: Implement cpuset tree traversal in a helper function
      cpusets, hotplug: Restructure functions that are invoked during hotplug
      cpusets: Update tasks' cpus_allowed mask upon updates to root cpuset
      cpusets: Add provisions for distinguishing CPU Hotplug in suspend/resume path
      cpusets, suspend: Save and restore cpusets during suspend/resume


  include/linux/cpuset.h |    4 -
 kernel/cpuset.c        |  235 +++++++++++++++++++++++++++++++++++++++---------
 kernel/sched/core.c    |   29 +++++-
 3 files changed, 218 insertions(+), 50 deletions(-)



Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

