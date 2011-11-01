Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1KAVUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:20:04 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23953 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1KAVUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:20:03 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com
Subject: [PATCH v2 00/14] per-cgroup /proc/stat
Date: Tue,  1 Nov 2011 19:19:06 -0200
Message-Id: <1320182360-20043-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a new shot of the per-cgroup /proc/stat series.
I believe this series is a huge improvement over the last one.
Basically, there is a control file in the root cgroup that controls
wether or not statistics will be collected in a per-cgroup fashion.
Only when this is on, a jump label is enabled allowing the "run to parent"
to happen. The parent cgroup's kstat is coincident with the system-wide kstat,
so we don't need special code for when cgroups-disabled, either runtime or
compile time.

cpuusage and cpuacct statistics are now also available in the cpu cgroup.
Since the task_group structure is already walked by the scheduler anyway,
by keeping everything in the same cgroup, we avoid multiple walks.

I also have a follow up patch that displays the information in this file
automatically in /proc/stat when requested, but I am not including in
this series. I'd like to give some second thoughts about that: Since I
am pretty stubborn, I haven't yet given up on coming up with a way to
tie namespaces and cgroups together in a good fashion for theses cases.


Glauber Costa (14):
  trivial: initialize root cgroup's sibling list
  Change cpustat fields to an array.
  Move /proc/stat logic inside sched.c
  split kernel stat in two
  Display /proc/stat information per cgroup
  Make total_forks per-cgroup
  per-cgroup boot time
  Report steal time for cgroup
  Keep nr_iowait per cgroup
  Keep number of context switches per-cgroup
  provide a version of cpuacct statistics inside cpu cgroup
  Keep number of running processes per-cgroup
  provide a version of cpuusage statistics inside cpu cgroup
  Change CPUACCT to default n

 Documentation/feature-removal-schedule.txt |    8 +
 arch/s390/appldata/appldata_os.c           |   18 +-
 arch/x86/include/asm/i387.h                |    2 +-
 drivers/cpufreq/cpufreq_conservative.c     |   33 +-
 drivers/cpufreq/cpufreq_ondemand.c         |   33 +-
 drivers/macintosh/rack-meter.c             |    8 +-
 fs/proc/stat.c                             |  144 +------
 fs/proc/uptime.c                           |    8 +-
 include/linux/kernel_stat.h                |   56 ++-
 include/linux/sched.h                      |    5 +
 init/Kconfig                               |    1 +
 kernel/fork.c                              |    7 +-
 kernel/sched.c                             |  660 +++++++++++++++++++++++++---
 kernel/sched_debug.c                       |    3 +-
 kernel/sched_fair.c                        |   10 +
 kernel/sched_rt.c                          |    4 +
 16 files changed, 731 insertions(+), 269 deletions(-)

-- 
1.7.6.4

