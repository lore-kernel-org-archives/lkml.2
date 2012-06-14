Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab2FNOaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab2FNO3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:29:12 -0400
Message-ID: <4FD9F4EB.7080108@redhat.com>
Date: Thu, 14 Jun 2012 10:27:55 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, sjhill@mips.com, ralf@linux-mips.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Nicolas Pitre <nico@linaro.org>
Subject: Re: bugs in page colouring code
References: <20120613152936.363396d5@cuia.bos.redhat.com> <20120614132053.GD28714@n2100.arm.linux.org.uk>
In-Reply-To: <20120614132053.GD28714@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 09:20 AM, Russell King - ARM Linux wrote:
> On Wed, Jun 13, 2012 at 03:29:36PM -0400, Rik van Riel wrote:
>> COLOUR_ALIGN_DOWN can use the pgoff % shm_align_mask either positively
>>     or negatively, depending on the address initially found by
>>     get_unmapped_area
>>
>> static inline unsigned long COLOUR_ALIGN_DOWN(unsigned long addr,
>>                                                unsigned long pgoff)
>> {
>>          unsigned long base = addr&  ~shm_align_mask;
>>          unsigned long off = (pgoff<<  PAGE_SHIFT)&  shm_align_mask;
>>
>>          if (base + off<= addr)
>>                  return base + off;
>>
>>          return base - off;
>> }
>
> Yes, that is bollocks code, introduced by this commit:
>
> commit 7dbaa466780a754154531b44c2086f6618cee3a8
> Author: Rob Herring<rob.herring@calxeda.com>
> Date:   Tue Nov 22 04:01:07 2011 +0100

It's not just ARM that has this bug. It appears to
be cut'n'pasted from other architectures (MIPS? SPARC?).

>> The fix would be to return an address that is a whole shm_align_mask
>> lower: (((base - shm_align_mask)&  ~shm_align_mask) + off
>
> Yes, agreed.

I will make sure the arch-independent colouring
code does that.

> This brings up the question: should a MAP_PRIVATE mapping see updates
> to the backing file made via a shared mapping and/or writing the file
> directly?  After all, a r/w MAP_PRIVATE mapping which has been CoW'd
> won't see the updates.
>
> So I'd argue that a file mapped MAP_SHARED must be mapped according to
> the colour rules, but a MAP_PRIVATE is free not to be so.

OK, fair enough.

>> Secondly, MAP_FIXED never checks for page colouring alignment.
>> I assume the cache aliasing on AMD Bulldozer is merely a performance
>> issue, and we can simply ignore page colouring for MAP_FIXED?
>> That will be easy to get right in an architecture-independent
>> implementation.
>
> There's a whole bunch of issues with MAP_FIXED, specifically address
> space overflow has been discussed previously, and resulted in this patch:
>
> [PATCH 0/6] get rid of extra check for TASK_SIZE in get_unmapped_area

Turns out, get_unmapped_area_prot (the function
that calls arch_get_unmapped_area) checks for
these overflows, so we should be fine.
