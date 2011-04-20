Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1DTUwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7834 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab1DTUwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=wwqTpvDnqoN0GOmM74FbkjH0kKqEAC7lf2n5SAvJwxku81h+EuSjPyqEMV/8FM4iF
	zssWNOnakhUtd2V5jyyEA==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][PATCH 00/18] Increase resolution of load weights
Date: Wed, 20 Apr 2011 13:51:19 -0700
Message-Id: <1303332697-16426-1-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have attached an early version of a RFC patchset to increase resolution of
sched entity load weights. This RFC introduces SCHED_LOAD_RESOLUTION which
scales NICE_0_LOAD by a factor of 1024. The scaling is done internally and should
be completely invisible to the user.

Why do we need this?
This extra resolution allows us to scale on two dimensions - number of cpus and
the depth of hierarchies. It also allows for proper load balancing of low weight
task groups (for eg., nice+19 on autogroup).

One of the big roadblocks for increasing resolution is the use of unsigned long
for load.weight, which on 32-bit architectures can overflow with ~48 max-weight
sched entities. In this RFC we convert all uses of load.weight to u64. This is
still a work-in-progress and I have listed some of the issues I am still
investigating below.

I would like to get some feedback on the direction of this patchset. Please let
me know if there are alternative ways of doing this, and I'll be happy to
explore them as well.

The patchset applies cleanly to v2.6.39-rc4. It compiles for i386 and boots on
x86_64. Beyond the basic checks, it has not been well tested yet.

Major TODOs:
- Detect overflow in update shares calculations (time * load), and set load_avg
  to maximum possible value (~0ULL).
- tg->task_weight uses an atomic which needs to be updates to 64-bit on 32-bit
  machines. Might need to add a lock to protect this instead of atomic ops.
- Check wake-affine math and effective load calculations for overflows.
- Needs more testing and need to ensure fairness/balancing is not broken.

-Thanks,
Nikhil

Nikhil Rao (18):
  sched: introduce SCHED_POWER_SCALE to scale cpu_power calculations
  sched: increase SCHED_LOAD_SCALE resolution
  sched: use u64 for load_weight fields
  sched: update cpu_load to be u64
  sched: update this_cpu_load() to return u64 value
  sched: update source_load(), target_load() and weighted_cpuload() to
    use u64
  sched: update find_idlest_cpu() to use u64 for load
  sched: update find_idlest_group() to use u64
  sched: update division in cpu_avg_load_per_task to use div_u64
  sched: update wake_affine path to use u64, s64 for weights
  sched: update update_sg_lb_stats() to use u64
  sched: Update update_sd_lb_stats() to use u64
  sched: update f_b_g() to use u64 for weights
  sched: change type of imbalance to be u64
  sched: update h_load to use u64
  sched: update move_task() and helper functions to use u64 for weights
  sched: update f_b_q() to use u64 for weighted cpuload
  sched: update shares distribution to use u64

 drivers/cpuidle/governors/menu.c |    5 +-
 include/linux/sched.h            |   22 +++--
 kernel/sched.c                   |   61 ++++++-----
 kernel/sched_debug.c             |   10 +-
 kernel/sched_fair.c              |  218 ++++++++++++++++++++------------------
 kernel/sched_stats.h             |    2 +-
 6 files changed, 167 insertions(+), 151 deletions(-)

-- 
1.7.3.1

