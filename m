Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1EKPj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:39:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:34940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab1EKPja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:39:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,351,1301900400"; 
   d="scan'208";a="187276"
Message-Id: <20110511081012.903869567@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 11 May 2011 16:10:12 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com, npiggin@kernel.dk
Subject: [patch v2 0/5] percpu_counter: bug fix and enhancement
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch sets do two things.
1. fix bug for 32-bit system. percpu_counter uses s64 counter. Without any
locking reading s64 in 32-bit system isn't safe and can cause bad side effect.
2. improve scalability for __percpu_counter_add. In some cases, _add could
cause heavy lock contention (see patch 4 for detailed infomation and data).
The patches will remove the contention and speed up it a bit. Last post
(http://marc.info/?l=linux-kernel&m=130259547913607&w=2) simpliy uses
atomic64 for percpu_counter, but Tejun pointed out this could cause
deviation in __percpu_counter_sum.
The new implementation uses lglock to protect percpu data. Each cpu has its
private lock while other cpu doesn't take. In this way _add doesn't need take
global lock anymore and remove the deviation. This still gives me about
about 5x ~ 6x faster (not that faster than the original 7x faster, but still
good) with the workload mentioned in patch 4.

patch 1 fix s64 read bug for 32-bit system for UP
patch 2 convert lglock to be used by dynamaically allocated structre. Later
patch will use lglock for percpu_counter
patch 3,4 fix s64 read bug for 32-bit system for MP. And it also improve the
scalability for __percpu_counter_add.
patch 5 is from Christoph Lameter to make __percpu_counter_add fastpath
preemptless. I added it here because I converted percpu_counter to use
lglock. All bugs are from mine.

Comments and suggestions are welcomed!

Thanks,
Shaohua
