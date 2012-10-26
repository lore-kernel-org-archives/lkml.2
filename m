Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab2JZNOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:14:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab2JZNOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:14:20 -0400
Message-ID: <508A8D31.9000106@redhat.com>
Date: Fri, 26 Oct 2012 09:16:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Michel Lespinasse <walken@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 05/31] x86/mm: Reduce tlb flushes from ptep_set_access_flags()
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl> <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com> <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com> <508A0A0D.4090001@redhat.com> <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com> <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com> <m2pq45qu0s.fsf@firstfloor.org>
In-Reply-To: <m2pq45qu0s.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 08:48 AM, Andi Kleen wrote:
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

That is fine.

Potentially triggering a spurious page fault on
another CPU is bound to be better than always
doing a synchronous remote TLB flush, waiting
for who knows how many CPUs to acknowledge the
IPI...

