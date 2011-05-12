Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1ELCkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:40:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:2856 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab1ELCkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:40:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,356,1301900400"; 
   d="scan'208";a="746009885"
Subject: Re: [patch v2 4/5] percpu_counter: use atomic64 for counter in SMP
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <20110511023425.2d23a38a.akpm@linux-foundation.org>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511081433.987756741@sli10-conroe.sh.intel.com>
	 <20110511023425.2d23a38a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:40:14 +0800
Message-ID: <1305168014.2373.7.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 17:34 +0800, Andrew Morton wrote:
> On Wed, 11 May 2011 16:10:16 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > The percpu_counter global lock is only used to protect updating fbc->count after
> > we use lglock to protect percpu data. Uses atomic64 for percpu_counter, because
> > it is cheaper than spinlock. This doesn't slow fast path (percpu_counter_read).
> > atomic64_read equals to read fbc->count for 64-bit system, or equals to
> > spin_lock-read-spin_unlock for 32-bit system.
> > 
> > Note, originally the percpu_counter_read for 32-bit system doesn't hold
> > spin_lock, but that is buggy and might cause very wrong value accessed.
> > This patch fixes the issue.
> > 
> > This can also improve some workloads with percpu_counter->lock heavily
> > contented. For example, vm_committed_as sometimes causes the contention.
> > We should tune the batch count, but if we can make percpu_counter better,
> > why not? In a 24 CPUs system and 24 processes, each runs:
> > while (1) {
> > 	mmap(128M);
> > 	munmap(128M);
> > }
> > we then measure how many loops each process can take:
> > orig: 1226976
> > patched: 6727264
> > The atomic method gives 5x~6x faster.
> 
> How much slower did percpu_counter_sum() become?
I did a stress test. 23 CPU run _add, one cpu runs _sum
In both cases (_add fast path (don't hold lock), _add slow path (hold
lock)), _sum becomes about 2.4x slower. Not too much slower, anyway,
_sum isn't frequently used.

Thanks,
Shaohua

