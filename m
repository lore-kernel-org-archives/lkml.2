Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab0D1LRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:17:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28003 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0D1LRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:17:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=spK+fRDs3jjZYcQ5+3mIC/qV+6PWulyQeQICYKdCaKX8HaXoV7g2ib+vMAPxR9sAf
	s5L95zqNXFjTcL0cks1Wg==
Subject: [PATCH v2 0/6] CFS Bandwidth Control
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 28 Apr 2010 04:16:46 -0700
Message-ID: <20100428110720.7954.53537.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached v2 of our proposed approach for bandwidth provisioning
under CFS.  Bharata's original RFC motivating discussion on this topic can be
found at: http://lkml.org/lkml/2009/6/4/24

This is an evolution of our previous posting: http://lkml.org/lkml/2010/2/12/393
The improvements herein are incremental: hierarchal task tracking for better
load-balance under throttle conditions, statistics export for decision
guidance in user-space control systems, minor bugs fixed, and some code
clean-up.

The skeleton of our approach is as follows:
- As above we maintain a global pool, per-tg, pool of unassigned quota.  On it
  we track the bandwidth period, quota per period, and runtime remaining in the
  current period.  As bandwidth is used within a period it is decremented from
  runtime.  Runtime is currently synchronized using a spinlock, in the current
  implementation there's no reason this couldn't be done using atomic ops
  instead however the spinlock allows for a little more flexibility in
  experimentation with other schemes.
- When a cfs_rq participating in a bandwidth constrained task_group executes it
  acquires time in sysctl_sched_cfs_bandwidth_slice (default currently 10ms)
  size chunks from the global pool, this synchronizes under rq->lock and is part
  of the update_curr path.
- Throttled entities are dequeued immediately.  Throttled entities are gated
  from participating in the tree at the {enqueue, dequeue}_entity level.

More details on the motivation and approach, as well as performance benchmark
results can be found in the original posting.

One caveat that bears discussion is that this leads to an alternate
specification of bandwidth versus the sched_rt case.  The defined bandwidth
becomes an absolute quantifier relative to the period and is agnostic of allowed
cpus.

Open-questions:
- Is there any value in having the slice be tunable at the task-group level?
- I suspect 5ms may be a better default slice value, however I have not had the
  opportunity to verify this yet.  There's also room for some dynamic range
  here.

Acknowledgements: 
We would like to thank Bharata B Rao and Dhaval Giani for discussion and their
original proposal, many elements in this patchset are directly inspired by
their original posting.  Bharata has also been integral in the preparation of
this second version, providing valuable feedback and review.

Ken Chen also provided early review and comments.

Thanks,

- Paul and Nikhil
---

Nikhil Rao (1):
      sched: add exports tracking cfs bandwidth control statistics

Paul Turner (5):
      sched: introduce primitives to account for CFS bandwidth tracking
      sched: accumulate per-cfs_rq cpu usage
      sched: throttle cfs_rq entities which exceed their local quota
      sched: unthrottle cfs_rq(s) who ran out of quota at period refresh
      sched: hierarchical task accounting for FAIR_GROUP_SCHED


 include/linux/sched.h |    4 +
 init/Kconfig          |    9 +
 kernel/sched.c        |  347 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched_fair.c   |  240 +++++++++++++++++++++++++++++++++-
 kernel/sched_rt.c     |   24 +--
 kernel/sysctl.c       |   10 +
 6 files changed, 585 insertions(+), 49 deletions(-)

