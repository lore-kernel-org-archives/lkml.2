Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2KTIdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:33:20 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:28663 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab2KTIcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:32:46 -0500
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Balbir Singh <bsingharora@gmail.com>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 0/6] Automatic NUMA placement of tasks in cpu cgroup
Date: Tue, 20 Nov 2012 12:31:58 +0400
Message-Id: <1353400324-10897-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
CC: Tejun Heo <tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset has absolutely nothing to do with NUMA. But now that I got your
attention:

This is an attempt to ressurect a patchset that Tejun Heo sent a while ago,
aiming at deprecation of cpuacct. He only went as far as publishing the files
in the cpu cgroup, but the final work would require us to take advantage
of it by not incurring in hierarchy walks more times than necessary.

It is trivial to do it in the case where we have SCHEDSTATS enabled: we already
record a statistic that is exactly the same as cpuusage: exec_clock. That is
not collected for rt tasks, so the only thing we need to do is to also collect
it for them, and print them back for cpuusage.

In theory, it would also be possible to avoid hierarchy walks even without
SCHEDSTATS: we could modify task_group_charge() to stop walking, and then
update cpuusage only for the current group, during the walk we already do.
I didn't do so, because I believe we care more about setups that would enable
a bunch of options anyway - which is likely to include SCHEDSTATS. Custom setups
can take a much easier route and just compile out the whole thing! But let me
know if I should do it.


Glauber Costa (3):
  don't call cpuacct_charge in stop_task.c
  sched: adjust exec_clock to use it as cpu usage metric
  cpuacct: don't actually do anything.

Tejun Heo (3):
  cgroup: implement CFTYPE_NO_PREFIX
  cgroup, sched: let cpu serve the same files as cpuacct
  cgroup, sched: deprecate cpuacct

 include/linux/cgroup.h   |   1 +
 init/Kconfig             |  11 +-
 kernel/cgroup.c          |  57 ++++++++++-
 kernel/sched/core.c      | 262 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c      |   1 +
 kernel/sched/rt.c        |   2 +
 kernel/sched/sched.h     |  14 ++-
 kernel/sched/stop_task.c |   1 -
 8 files changed, 341 insertions(+), 8 deletions(-)

-- 
1.7.11.7

