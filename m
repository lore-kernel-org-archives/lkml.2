Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0J0QuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:50:05 -0400
Received: from claw.goop.org ([74.207.240.146]:44372 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab0J0QuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:50:03 -0400
Message-ID: <4CC85839.4000507@goop.org>
Date: Wed, 27 Oct 2010 09:50:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ian Campbell <ian.campbell@citrix.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic>
In-Reply-To: <20101027104020.GA16954@a1.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/27/2010 03:40 AM, Borislav Petkov wrote:
> On Wed, Oct 27, 2010 at 09:50:13AM +0100, Ian Campbell wrote:
>> Page tables should always be updated using the proper accessor
>> methods. Not doing so bypasses the paravirt infrastructure.
>>
>> In this case the failure to do so was exposed under Xen by
>> b40827fa7268 "x86-32, mm: Add an initial page table for core
>> bootstrapping".
>>
>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: H. Peter Anvin <hpa@linux.intel.com>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> ---
>>  arch/x86/include/asm/pgtable.h |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index ada823a..0b4c514 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -619,7 +619,10 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
>>   */
>>  static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
>>  {
>> -       memcpy(dst, src, count * sizeof(pgd_t));
>> +	int i;
>> +
>> +	for (i=0; i<count; i++)
>> +		set_pgd(&dst[i], src[i]);
> Hmm, this slows down clone_pgd_range(). It is called at 3 sites total,
> two of which happen only on boot in setup_arch() so they can be ignored
> but the callchain
>
> copy_process()
> ...
> mm_init()
> |->mm_alloc_pgd()
>   |->pgd_alloc()
>     |->pgd_ctor()
>       |->clone_pgd_range()
>
> could become noticeable. To be on the safe side, I'd make
> clone_pgd_range() a macro calling either the native or the xen version..

Frankly I'd want to see some numbers before getting too worried about
it; if it were a problem we could make the native set_pgd inlined into
the callside (it is just a memory write after all), which will be very
similar to memcpy in performance.

I am, however, more concerned about the effect on performance under
Xen.  xen_set_pgd will avoid doing a hypercall in this case (the
pagetable isn't yet pinned), but it has to do a moderate amount of work
to avoid doing the hypercall, and could really add some measurable
latency to process creation (which is not something we need right now). 
For that a clone_pgd_range() hypercall is the most straightforward
answer, but I'm loathe to propose that right now.

This never used to be a problem.  Perhaps we can change how
clone_pgd_range is used at boot time to avoid it in the Xen case (since
we don't care about the secondary pagetable)?

    J
