Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1J0NtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:49:12 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56389 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1J0NtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:49:10 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v4 0/2] CPU hotplug,
 Freezer: Fix race between CPU hotplug and freezer
Cc: a.p.zijlstra@chello.nl, rjw@sisk.pl, stern@rowland.harvard.edu,
        pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net
Date: Thu, 27 Oct 2011 19:18:59 +0530
Message-ID: <20111027134824.20916.46845.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU hotplug notifications sent out by the _cpu_up() and _cpu_down()
functions depends on the value of the 'tasks_frozen' argument passed to them.
(Examples: CPU_ONLINE, CPU_ONLINE_FROZEN, CPU_DEAD, CPU_DEAD_FROZEN).

Thus, it is essential that while the callbacks for those notifications are
running, the state of the system with respect to the tasks being frozen or
not remains unchanged, *throughout that duration*. Hence there is a need for
synchronizing the CPU hotplug code with the freezer subsystem.

This patchset introduces two freezer notifications PM_FREEZE_PREPARE and
PM_POST_THAW to announce the freezer's activities to other interested
subsystems. The CPU hotplug code hooks onto these notifications and prevents
the race between CPU hotplug and freezer, thus ensuring that CPU hotplug
notifications will always be run with the state of the system really being
what the notifications mean.


v4: * Retained the value 0 for the 'tasks_frozen' argument, while calling
      _cpu_up() and _cpu_down().
      Removed the unnecessary PM_POST_FREEZE and PM_THAW_PREPARE notifications.

v3: * Added synchronization between CPU hotplug and the freezer subsystem
      without introducing any new locks in the CPU hotplug call path.

v2: * Removed the atomic_t declaration of tasks_frozen flag and the
      atomic_[set|read] functions since they were unnecessary.
    * Updated the changelog to give an example scenario where things could go
      wrong due to the bug in the CPU hotplug call path.

References:
v1 -> http://thread.gmane.org/gmane.linux.kernel/1198312/
v2 -> http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1199087
v3 -> http://thread.gmane.org/gmane.linux.documentation/3472

--
Srivatsa S. Bhat (2):
      PM / Freezer: Introduce PM_FREEZE_PREPARE and PM_POST_THAW notifications
      CPU hotplug, Freezer: Synchronize CPU hotplug and Freezer


 Documentation/power/notifiers.txt |    4 ++
 include/linux/suspend.h           |    4 +-
 kernel/cpu.c                      |   76 +++++++++++++++++++++++++++++++++++++
 kernel/power/process.c            |    8 +++-
 4 files changed, 90 insertions(+), 2 deletions(-)


