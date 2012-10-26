Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab2JZGmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:42:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62141 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab2JZGmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:42:05 -0400
Date: Fri, 26 Oct 2012 08:42:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/31] x86/mm: Reduce tlb flushes from
 ptep_set_access_flags()
Message-ID: <20121026064200.GB8141@gmail.com>
References: <20121025121617.617683848@chello.nl>
 <20121025124832.840241082@chello.nl>
 <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com>
 <5089F5B5.1050206@redhat.com>
 <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
 <508A0A0D.4090001@redhat.com>
 <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 25, 2012 at 8:57 PM, Rik van Riel <riel@redhat.com> wrote:
> >
> > That may not even be needed.  Apparently Intel chips 
> > automatically flush an entry from the TLB when it causes a 
> > page fault.  I assume AMD chips do the same, because 
> > flush_tlb_fix_spurious_fault evaluates to nothing on x86.
> 
> Yes. It's not architected as far as I know, though. But I 
> agree, it's possible - even likely - we could avoid TLB 
> flushing entirely on x86.
> 
> If you want to try it, I would seriously suggest you do it as 
> a separate commit though, just in case.

Ok, will do it like that. INVLPG overhead is small effect, 
nevertheless it's worth trying.

What *has* shown up in my profiles though, and which drove some 
of these changes is that for heavily threaded VM-intense 
workloads such as a single SPECjbb JVM instance running on all 
CPUs and all nodes, TLB flushes with any sort of serialization 
aspect are absolutely deadly.

So just to be *able* to verify the performance benefit and 
impact of some of the later NUMA-directed changes, we had to 
eliminate a number of scalability bottlenecks and put these 
optimization patches in front of the main changes.

That is why you have to go 20+ patches into the queue to see the 
real point :-/

> > Are there architectures where we do need to flush remote 
> > TLBs on upgrading the permissions on a PTE?
> 
> I *suspect* that whole TLB flush just magically became an SMP 
> one without anybody ever really thinking about it.

Yeah, and I think part of the problem is that it's also a not 
particularly straightforward to analyze performance bottleneck: 
SMP TLB flushing does not show up as visible high overhead in 
profiles mainly, it mostly shows up as extra idle time.

If the nature of the workload is that it has extra available 
paralellism that can fill in the idle time, it will mask much of 
the effect and there's only a slight shift in the profile.

It needs a borderline loaded system and sleep profiling to 
pinpoint these sources of overhead.

[...]
> > From reading the code again, it looks like things should 
> > indeed work ok.
> 
> I would be open to it, but just in case it causes bisectable 
> problems I'd really want to see it in two patches ("make it 
> always do the local flush" followed by "remove even the local 
> flush"), and then it would pinpoint any need.

Yeah, 100% agreed.

Thanks,

	Ingo
