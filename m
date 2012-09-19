Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2ISWn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:43:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52508 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2ISWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:43:57 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, lizefan@huawei.com
Cc: peterz@infradead.org, glommer@parallels.com, mhocko@suse.cz,
        kay.sievers@vrfy.org, mzxreary@0pointer.de, davej@redhat.com,
        ben@decadent.org.uk, pjt@google.com
Subject: [PATCHSET RFC] cpu,cpuacct: make cpu serve cpuacct files and deprecate cpuacct
Date: Wed, 19 Sep 2012 15:43:42 -0700
Message-Id: <1348094625-4471-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is an attempt at allowing quick deprecation and removal of
cpuacct.  The patchset makes cpu serve the same cpuacct.* files and
updates cgroup core such that it ignores cpuacct if requested to be
co-mounted with cpu whether CONFIG_CGROUP_CPUACCT is enabled or not.

This de-couples cpuacct deprecation on kernel side from userland
transition as long as userland is co-mounting cpu and cpuacct.  In
this series, cpuacct implementation is simply copied into cpu, the
goal being to provide base for proper optimization (most likely
periodic collection of stats across the hierarchy).

I didn't try to maintain everything the same.  /proc/cgroups and
/proc/PID/cgroup may mis-represent or miss cpuacct entry.  Faking it
completely is doable too but I'd like to keep it as simple as
possible.

* If cpuacct is not used, nothing changes of course.

* If cpuacct is requested to be co-mounted with cpu, cpuacct is not
  used.  It doesn't matter whether CONFIG_CGROUP_CPUACCT is enabled or
  not.  cpu will provide cpusage.* statistics.

* If cpuacct is requested to be mounted separately and cpuacct is
  enabled, cgroup whines before mounting it.  If cpuacct is disabled,
  it fails.

I think the resulting behavior isn't too crazy and it should allow us
to remove anything cpuacct related fairly soon.

Longer term, I'd prefer to be able to drop the compatibility hack from
cgroup core too although I don't think that's too urgent.  I think
userland can either create symlinks for compatibility -
e.g. /sys/fs/cgroup/cpuacct and /sys/fs/cgroup/cpu,cpucct both
pointing to /sys/fs/cgroup/cpu - whether cpuacct exists or not, or
just ignore anything cpuacct related.

This series is based on for-3.7-hierarchy 8c7f6edbda0 ("cgroup: mark
subsystems with broken hierarchy...") and also available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-deprecate-cpuacct

 include/linux/cgroup.h   |    1 
 init/Kconfig             |   11 ++
 kernel/cgroup.c          |   57 ++++++++++++-
 kernel/sched/core.c      |  196 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c      |    1 
 kernel/sched/rt.c        |    1 
 kernel/sched/sched.h     |    7 +
 kernel/sched/stop_task.c |    1 
 8 files changed, 269 insertions(+), 6 deletions(-)

Thanks.

--
tejun
