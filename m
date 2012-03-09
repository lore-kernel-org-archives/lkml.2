Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab2CIARK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:17:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab2CIARI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:17:08 -0500
Date: Thu, 8 Mar 2012 21:08:35 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 changelog-v2] KVM: Switch to srcu-less get_dirty_log()
Message-ID: <20120309000835.GA25838@amt.cnet>
References: <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
 <20120303142148.2689454b30dc86d84c4a19f5@gmail.com>
 <20120306111540.GA29914@amt.cnet>
 <20120306234317.2817d2071038d11ab3831c82@gmail.com>
 <20120306150104.GA3041@amt.cnet>
 <20120307002317.d8682de9c6ccd6af8ccac467@gmail.com>
 <20120306152850.GB3353@amt.cnet>
 <20120307170745.3147f776.yoshikawa.takuya@oss.ntt.co.jp>
 <20120307232520.GB29570@amt.cnet>
 <20120308103545.24b81093.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308103545.24b81093.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 10:35:45AM +0900, Takuya Yoshikawa wrote:
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
> > What is worrying are large memory cases: think of the 50GB slot case.
> > 100ms hold time is pretty bad (and reacquiring the lock is relatively
> > simple).
> > 
> 
> OK, I agree basically.
> 
> But let me explain one thing before deciding what I should do next.
> 
> With my method, even when we use a 50GB slot, the hold time will be under
> 10ms -- not 100ms -- if the memory actually updated from the last time is
> 1GB (256K dirty pages).
> 
> > >   8747274.0   10973.3       33.3      -31%    -3%    256K
>   Note that this unit-test was done on my tiny core-i3 32-bit host.
>   On servers which can install more than 50GB memory, this will become
>   much faster: actually my live migration tests done on Xeon saw much
>   better numbers.  Unit-test has been tuned for the worst case.
> 
> I admit that if the dirty memory size is more than 10GB, we may see over
> 100ms hold time you are worrying about.
> 
>   For that I was proposing introducing a new GET_DIRTY_LOG API which can
>   restrict the number of dirty pages we get the log - but this is a long
>   term goal.
> 
> 
> So, I am OK to try to introduce cond_resched_lock_cb() as you suggested.
> But, as I explained above, my current implementation does not introduce
> any real regression concerning to mmu_lock hold time:
> 
>   Before we could see 10ms hold time in real workloads:
>   > funcgraph_entry:      ! 9783.060 us |  kvm_mmu_slot_remove_write_access();
> 
>   I have never seen ms hold time with my method in the same workloads.
> 
> So, it would be helpful if you can apply the patch series and I can work
> on top of that: although I cannot use servers with 100GB memory now,
> migrating a guest with 16GB memory or so may be possible later: I need
> to reserve servers for that.

Makes sense.

It looks good to me, Avi can you review & ack please?

> I also want to know "mmu_lock -- TLB flush"-decoupling plan.  We will not
> need to introduce cond_resched_lock_cb() in sched.h if that is possible.
> 
> Thanks,
> 	Takuya
