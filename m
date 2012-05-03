Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2ECO1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:27:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280Ab2ECO1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:27:30 -0400
Message-ID: <4FA295BE.7010706@redhat.com>
Date: Thu, 03 May 2012 17:27:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, mtosatti@redhat.com,
        yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: [RFC] sched: make callers check lock contention for cond_resched_lock()
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com> <1336034127.13683.197.camel@twins> <20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com> <1336048150.22523.17.camel@twins> <4FA27E5E.5000002@redhat.com> <20120503231107.e8c5a5dde90e109e570ba32e@gmail.com>
In-Reply-To: <20120503231107.e8c5a5dde90e109e570ba32e@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 05:11 PM, Takuya Yoshikawa wrote:
> On Thu, 03 May 2012 15:47:26 +0300
> Avi Kivity <avi@redhat.com> wrote:
>
> > On 05/03/2012 03:29 PM, Peter Zijlstra wrote:
> > > On Thu, 2012-05-03 at 21:22 +0900, Takuya Yoshikawa wrote:
> > > > Although the real use case is out of this RFC patch, we are now discussing
> > > > a case in which we may hold a spin_lock for long time, ms order, depending
> > > > on workload;  and in that case, other threads -- VCPU threads -- should be
> > > > given higher priority for that problematic lock. 
> > >
> > > Firstly, if you can hold a lock that long, it shouldn't be a spinlock,
> > 
> > In fact with your mm preemptibility work it can be made into a mutex, if
> > the entire mmu notifier path can be done in task context.  However it
> > ends up a strange mutex - you can sleep while holding it but you may not
> > allocate, because you might recurse into an mmu notifier again.
> > 
> > Most uses of the lock only involve tweaking some bits though.
>
> I might find a real way to go.
>
> After your "mmu_lock -- TLB-flush" decoupling, we can change the current
> get_dirty work flow like this:
>
> 	for ... {
> 		take mmu_lock
> 		for 4K*8 gfns {		// with 4KB dirty_bitmap_buffer
> 			xchg dirty bits	// 64/32 gfns at once
> 			write protect them
> 		}
> 		release mmu_lock
> 		copy_to_user
> 	}
> 	TLB flush
>
> This reduces the size of dirty_bitmap_buffer and does not hold mmu_lock
> so long.

Good idea.  Hopefully the lock acquisition costs are low enough - we're
adding two atomic operations per iteration here.


-- 
error compiling committee.c: too many arguments to function

