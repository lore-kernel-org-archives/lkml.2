Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586Ab2JZRwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:52:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965524Ab2JZRwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:52:41 -0400
Message-ID: <508ACE6E.8060303@redhat.com>
Date: Fri, 26 Oct 2012 13:54:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 05/31] x86/mm: Reduce tlb flushes from ptep_set_access_flags()
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl> <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com> <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com> <508A0A0D.4090001@redhat.com> <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com> <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com> <CA+55aFwpZ5pO2G7gs3Pga5et1DQZ4qMoe1CLFkSrVQK_4K4rhA@mail.gmail.com>
In-Reply-To: <CA+55aFwpZ5pO2G7gs3Pga5et1DQZ4qMoe1CLFkSrVQK_4K4rhA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 01:01 PM, Linus Torvalds wrote:
> On Fri, Oct 26, 2012 at 5:34 AM, Michel Lespinasse <walken@google.com> wrote:
>> On Thu, Oct 25, 2012 at 9:23 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>
>>> Yes. It's not architected as far as I know, though. But I agree, it's
>>> possible - even likely - we could avoid TLB flushing entirely on x86.
>>
>> Actually, it is architected on x86. This was first described in the
>> intel appnote 317080 "TLBs, Paging-Structure Caches, and Their
>> Invalidation", last paragraph of section 5.1. Nowadays, the same
>> contents are buried somewhere in Volume 3 of the architecture manual
>> (in my copy: 4.10.4.1 Operations that Invalidate TLBs and
>> Paging-Structure Caches)
>
> Good. I should have known it must be architected, because we've gone
> back-and-forth on this in the kernel historically. We used to have
> some TLB invalidates in the faulting path because I wasn't sure
> whether they were needed or not, but we clearly don't have them any
> more (and I suspect coverage was always spotty).
>
> And Intel (and AMD) have been very good at documenting as architected
> these kinds of details that people end up relying on even if they
> weren't necessarily originally explicitly documented.
>
>>> I *suspect* that whole TLB flush just magically became an SMP one
>>> without anybody ever really thinking about it.
>>
>> I would be very worried about assuming every non-x86 arch has similar
>> TLB semantics. However, if their fault handlers always invalidate TLB
>> for pages that get spurious faults, then skipping the remote
>> invalidation would be fine. (I believe this is what
>> tlb_fix_spurious_fault() is for ?)
>
> Yes. Of course, there may be some case where we unintentionally don't
> necessarily flush a faulting address (on some architecture that needs
> it), and then removing the cross-cpu invalidate could expose that
> pre-existing bug-let, and cause an infinite loop of page faults due to
> a TLB entry that never gets invalidated even if the page tables are
> actually up-to-date.
>
> So changing the mm/pgtable-generic.c function sounds like the right
> thing to do, but would be a bit more scary.
>
> Changing the x86 version sounds safe, *especially* since you point out
> that the "fault-causes-tlb-invalidate" is architected behavior.
>
> So I'd almost be willing to drop the invalidate in just one single
> commit, because it really should be safe. The only thing it does is
> guarantee that the accessed bit gets updated, and the accessed bit
> just isn't that important. If we never flush the TLB on another CPU
> that continues to use a TLB entry where the accessed bit is set (even
> if it's cleared in the in-memory page tables), the worst that can
> happen is that the accessed bit doesn't ever get set even if that CPU
> constantly uses the page.

I suspect it would be safe to simply call tlb_fix_spurious_fault()
both on x86 and in the generic version.

If tlb_fix_spurious_fault is broken on some architecture, they
would already be running into issues like "write page fault
loops until the next context switch" :)

> Again, this can be different on non-x86 architectures with software
> dirty bits, where a stale TLB entry that never gets flushed could
> cause infinite TLB faults that never make progress, but that's really
> a TLB _walker_ issue, not a generic VM issue.

Would tlb_fix_spurious_fault take care of that on those
architectures?

