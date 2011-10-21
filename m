Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1JUMYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:24:46 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47386 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1JUMYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:24:44 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 0/3] CPU hotplug, Freezer: Fix bugs in CPU hotplug call path
To: a.p.zijlstra@chello.nl
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net
Date: Fri, 21 Oct 2011 17:54:35 +0530
Message-ID: <20111021122401.14321.45857.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the CPU hotplug infrastructure to offline/online CPUs, the cpu_up()
and cpu_down() functions are used, which internally call _cpu_up() and
_cpu_down() with the second argument *always* set to 0. The second argument
is "tasks_frozen", which should be correctly set to 1 when tasks have been
frozen, even when the freezing of tasks may be due to an event unrelated
to CPU hotplug, such as a suspend operation in progress, in which case the
freezer subsystem freezes all the freezable tasks.

Not giving the correct value for the 'tasks_frozen' argument can potentially
lead to a lot of issues since this will send wrong notifications via the
notifier mechanism leading to the execution of inappropriate code by the
callbacks registered for the notifiers. That is, instead of CPU_ONLINE_FROZEN
and CPU_DEAD_FROZEN notifications, it results in CPU_ONLINE and CPU_DEAD
notifications to be sent all the time, irrespective of the actual state of
the system (i.e., whether tasks are frozen or not).

This patch introduces a flag to indicate whether the tasks are frozen are not
(by any event) and modifies cpu_up() and cpu_down() functions to check the
value of this flag and accordingly call _cpu_up() and _cpu_down() respectively
by supplying the correct value as the second argument based on the state of
the system. This in turn means that the correct notifications are sent, thus
ensuring that all the registered callbacks do the right thing.

Additionally, to ensure that the tasks are not frozen or thawed by the freezer
subsystem while the registered callbacks are running, this patch adds a few
notifications in the freezer which is then hooked onto by the CPU hotplug
code, to avoid this race.

v3: * Added synchronization between CPU hotplug and the freezer subsystem
      without introducing any new locks in the CPU hotplug call path.

v2: * Removed the atomic_t declaration of tasks_frozen flag and the
      atomic_[set|read] functions since they were unnecessary.
    * Updated the changelog to give an example scenario where things could go
      wrong due to the bug in the CPU hotplug call path.

References:
v1 -> http://thread.gmane.org/gmane.linux.kernel/1198312/
v2 -> http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1199087

--
Srivatsa S. Bhat (3):
      CPU hotplug, Freezer: Don't hardcode 'tasks_frozen' argument in _cpu_*()
      CPU hotplug, Freezer: Synchronize CPU hotplug and freezer
      PM, Freezer, Docs: Update documentation about the new freezer notifiers


 Documentation/power/notifiers.txt |    8 ++++
 include/linux/freezer.h           |    2 +
 include/linux/suspend.h           |    6 ++-
 kernel/cpu.c                      |   76 ++++++++++++++++++++++++++++++++++++-
 kernel/power/process.c            |   32 +++++++++++++++-
 5 files changed, 120 insertions(+), 4 deletions(-)


