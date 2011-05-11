Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1EKPmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:42:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418Ab1EKPmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:42:09 -0400
Date: Wed, 11 May 2011 02:34:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, eric.dumazet@gmail.com,
        cl@linux.com, npiggin@kernel.dk
Subject: Re: [patch v2 4/5] percpu_counter: use atomic64 for counter in SMP
Message-Id: <20110511023425.2d23a38a.akpm@linux-foundation.org>
In-Reply-To: <20110511081433.987756741@sli10-conroe.sh.intel.com>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	<20110511081433.987756741@sli10-conroe.sh.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 16:10:16 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> The percpu_counter global lock is only used to protect updating fbc->count after
> we use lglock to protect percpu data. Uses atomic64 for percpu_counter, because
> it is cheaper than spinlock. This doesn't slow fast path (percpu_counter_read).
> atomic64_read equals to read fbc->count for 64-bit system, or equals to
> spin_lock-read-spin_unlock for 32-bit system.
> 
> Note, originally the percpu_counter_read for 32-bit system doesn't hold
> spin_lock, but that is buggy and might cause very wrong value accessed.
> This patch fixes the issue.
> 
> This can also improve some workloads with percpu_counter->lock heavily
> contented. For example, vm_committed_as sometimes causes the contention.
> We should tune the batch count, but if we can make percpu_counter better,
> why not? In a 24 CPUs system and 24 processes, each runs:
> while (1) {
> 	mmap(128M);
> 	munmap(128M);
> }
> we then measure how many loops each process can take:
> orig: 1226976
> patched: 6727264
> The atomic method gives 5x~6x faster.

How much slower did percpu_counter_sum() become?
