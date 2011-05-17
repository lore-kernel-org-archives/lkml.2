Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1EQIon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:44:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:35131 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1EQIoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="643685559"
Message-Id: <20110517084117.572970726@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 May 2011 16:41:17 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com
Subject: [patch v3 0/3] percpu_counter: bug fix and enhancement
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch sets do two things.
1. fix bug for 32-bit system. percpu_counter uses s64 counter. Without any
locking reading s64 in 32-bit system isn't safe and can cause bad side effect.
2. improve scalability for __percpu_counter_add. In some cases, _add could
cause heavy lock contention (see patch 2 for detailed infomation and data).
The patches will remove the contention and speed up it a bit. Last post
(http://marc.info/?l=linux-kernel&m=130259547913607&w=2) simpliy uses
atomic64 for percpu_counter, but Tejun pointed out this could cause
deviation in __percpu_counter_sum.

In this impelmentation, we track _sum and _add state. When _sum starts, _add
will wait _sum to finish. This sounds scaring, since _add is fast path. But
since _sum is called rare, at most time _add doesn't need wait.

patch 1 fix s64 read bug for 32-bit system for UP
patch 2,3 fix s64 read bug for 32-bit system for MP. And it also improve the
scalability for __percpu_counter_add.

I did some benchmarks with the patches applied:
Test1:
24 CPUs do:
while {
mmap(32M);
munmap(32M);
}
Each CPU is about 7x faster to do the loop.

Test2:
One CPU does:
while {
__percpu_counter_add(+count)
__percpu_counter_add(-count)
}
the loop do 10000000 times.
in _add fast path (no locking hold):
before my patch:
real    0m0.133s
user    0m0.000s
sys     0m0.124s
after:
real    0m0.129s
user    0m0.000s
sys     0m0.120s
the difference is variation

in _add slow path (locking hold):
before my patch:
real    0m0.374s
user    0m0.000s
sys     0m0.372s
after:
real    0m0.245s
user    0m0.000s
sys     0m0.020s

Test3:
One CPU runs percpu_counter_sum, 23 CPUs run percpu_counter_add. In _add
fast path (don't hold) lock, _sum runs a little slow (about 20% slower).
In _add slow path (hold lock), _sum runs much faster (about 9x faster)

So overall my patches make percpu_counter API faster. The only exception
is _sum has a little slower in one case, but _sum is called rare, the 20%
slower doesn't matter.

Thanks,
Shaohua
