Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab2JZNX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:23:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38662 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab2JZNXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <m2pq45qu0s.fsf@firstfloor.org>
References: <20121025121617.617683848@chello.nl>
	<20121025124832.840241082@chello.nl>
	<CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com>
	<5089F5B5.1050206@redhat.com>
	<CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
	<508A0A0D.4090001@redhat.com>
	<CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com>
	<CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com>
	<m2pq45qu0s.fsf@firstfloor.org>
Date: Fri, 26 Oct 2012 06:23:24 -0700
Message-ID: <CANN689GAwKJVeZ7LW-Mv-b_DopAMMrpZw8FBEgR+EQJiyZ-oHw@mail.gmail.com>
Subject: Re: [PATCH 05/31] x86/mm: Reduce tlb flushes from ptep_set_access_flags()
From: Michel Lespinasse <walken@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 5:48 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Michel Lespinasse <walken@google.com> writes:
>
>> On Thu, Oct 25, 2012 at 9:23 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Thu, Oct 25, 2012 at 8:57 PM, Rik van Riel <riel@redhat.com> wrote:
>>>>
>>>> That may not even be needed.  Apparently Intel chips
>>>> automatically flush an entry from the TLB when it
>>>> causes a page fault.  I assume AMD chips do the same,
>>>> because flush_tlb_fix_spurious_fault evaluates to
>>>> nothing on x86.
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
> This unfortunately would only work for processes with no threads
> because it only works on the current logical CPU.

No, the point is, if we are only *increasing* permissions on a page,
we can skip the remote TLB invalidations. Later on each remote CPU
might possibly get a spurious fault on that page, but that spurious
fault will resynchronize their TLBs for that page, so that the
instruction retry after the fault won't fault again.

It is often cheaper to let remote CPUs get an occasional spurious
fault than to synchronize with them on every permission change.

Of course, none of the above applies if we are *reducing* permissions
on a page (we really can't skip TLB invalidations there)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
