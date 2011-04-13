Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab1DMVZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:25:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56933 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1DMVZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:25:13 -0400
Message-ID: <4DA6145D.9070703@kernel.org>
Date: Wed, 13 Apr 2011 14:23:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@elte.hu>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com>
In-Reply-To: <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020201.4DA6149E.00E4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 01:54 PM, Linus Torvalds wrote:
> On Wed, Apr 13, 2011 at 1:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> can you try following change ? it will push gart to 0x80000000
>>
>> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
>> index 86d1ad4..3b6a9d5 100644
>> --- a/arch/x86/kernel/aperture_64.c
>> +++ b/arch/x86/kernel/aperture_64.c
>> @@ -83,7 +83,7 @@ static u32 __init allocate_aperture(void)
>>         * so don't use 512M below as gart iommu, leave the space for kernel
>>         * code for safe
>>         */
>> -       addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
>> +       addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<21);
> 
> What are all the magic numbers, and why would 0x80000000 be special?

that is the old value when kernel was doing bottom-up bootmem allocation.

> 
> Why don't we write code that just works?
> 
> Or absent a "just works" set of patches, why don't we revert to code
> that has years of testing?
> 
> This kind of "I broke things, so now I will jiggle things randomly
> until they unbreak" is not acceptable.
> 
> Either explain why that fixes a real BUG (and why the magic constants
> need to be what they are), or just revert the patch that caused the
> problem, and go back to the allocation patters that have years of
> experience.
> 
> Guys, we've had this discussion before, in PCI allocation. We don't do
> this. We tried switching the PCI region allocations to top-down, and
> IT WAS A FAILURE. We reverted it to what we had years of testing with.
> 
> Don't just make random changes. There really are only two acceptable
> models of development: "think and analyze" or "years and years of
> testing on thousands of machines". Those two really do work.

We did do the analyzing, and only difference seems to be:
good one is using 0x80000000
and bad one is using 0xa0000000.

We try to figure out if it needs low address and it happen to work 
because kernel was doing bottom up allocation.

Thanks

Yinghai
