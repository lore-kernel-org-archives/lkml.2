Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab2JZSzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221Ab2JZSza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:55:30 -0400
Message-ID: <508ADD2F.6030805@redhat.com>
Date: Fri, 26 Oct 2012 14:57:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm,generic: only flush the local TLB in ptep_set_access_flags
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl> <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com> <5089F5B5.1050206@redhat.com> <CA+55aFwcj=nh1RUmEXUk6W3XwfbdQdQofkkCstbLGVo1EoKryA@mail.gmail.com> <508A0A0D.4090001@redhat.com> <CA+55aFx2fSdDcFxYmu00JP9rHiZ1BjH3tO4CfYXOhf_rjRP_Eg@mail.gmail.com> <CANN689EHj2inp+wjJGcqMHZQUV3Xm+3dAkLPOsnV4RZU+Kq5nA@mail.gmail.com> <m2pq45qu0s.fsf@firstfloor.org> <508A8D31.9000106@redhat.com> <20121026132601.GC9886@gmail.com> <20121026144615.2276cd59@dull> <CA+55aFyS_iJcKz=-zSDK+bjYiNeEzy4T5FrrGL8HBsxTOSwpJQ@mail.gmail.com>
In-Reply-To: <CA+55aFyS_iJcKz=-zSDK+bjYiNeEzy4T5FrrGL8HBsxTOSwpJQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 02:48 PM, Linus Torvalds wrote:
> On Fri, Oct 26, 2012 at 11:46 AM, Rik van Riel <riel@redhat.com> wrote:
>>
>> The function ptep_set_access_flags is only ever used to upgrade
>> access permissions to a page.
>
> NOTE: It's *not* "access permissions". It's "access flags".
>
> Big difference. This is not about permissions at all.

It looks like do_wp_page also sets the write bit in the pte
"entry" before passing it to ptep_set_access_flags, making
that the place where the write bit is set in the pte.

Is this a bug in do_wp_page?

Am I reading things wrong?

reuse:
                 flush_cache_page(vma, address, pte_pfn(orig_pte));
                 entry = pte_mkyoung(orig_pte);
                 entry = maybe_mkwrite(pte_mkdirty(entry), vma);
                 if (ptep_set_access_flags(vma, address, page_table, 
entry,1))
                         update_mmu_cache(vma, address, page_table);

