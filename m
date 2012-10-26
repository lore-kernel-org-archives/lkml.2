Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2JZDyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:54:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799Ab2JZDym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:54:42 -0400
Message-ID: <508A0A0D.4090001@redhat.com>
Date: Thu, 25 Oct 2012 23:57:01 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 05/31] x86/mm: Reduce tlb flushes from ptep_set_access_flags()
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl> <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com> <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
In-Reply-To: <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 10:56 PM, Linus Torvalds wrote:

> Guess what? If you want to optimize the function to not do remote TLB
> flushes, then just do that! None of the garbage. Just change the
>
>      flush_tlb_page(vma, address);
>
> line to
>
>      __flush_tlb_one(address);

That may not even be needed.  Apparently Intel chips
automatically flush an entry from the TLB when it
causes a page fault.  I assume AMD chips do the same,
because flush_tlb_fix_spurious_fault evaluates to
nothing on x86.

> and it should damn well work. Because everything I see about
> "flush_remote" looks just wrong, wrong, wrong.

Are there architectures where we do need to flush
remote TLBs on upgrading the permissions on a PTE?

Because that is what the implementation in
pgtable-generic.c seems to be doing as well...

> And if there really is some reason for that whole flush_remote
> braindamage, then we have much bigger problems, namely the fact that
> we've broken the documented semantics of that function, and we're
> doing various other things that are completely and utterly invalid
> unless the above semantics hold.

Want to just remove the TLB flush entirely and see
if anything breaks in 3.8-rc1?

 From reading the code again, it looks like things
should indeed work ok.

