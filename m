Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2ACOFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 09:05:39 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33972 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2ACOFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 09:05:36 -0500
Message-ID: <4F030B34.1090705@arm.com>
Date: Tue, 03 Jan 2012 14:05:40 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Yang Bai <hamo.by@gmail.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH] arm: Fix linux-next compile error in arch/arm/common/gic.c
References: <1325521990-4445-1-git-send-email-joerg.roedel@amd.com> <CAO_0yfOzVCK8OGL5G9Aej+V4AZ12EMFKi3HafAX0JzeW9C3FtQ@mail.gmail.com> <4F02E377.2050409@arm.com> <4F03085F.4060008@gmail.com>
In-Reply-To: <4F03085F.4060008@gmail.com>
X-Enigmail-Version: 1.3.4
X-OriginalArrivalTime: 03 Jan 2012 14:05:28.0701 (UTC) FILETIME=[BF787AD0:01CCCA20]
X-MC-Unique: 112010314053200801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/12 13:53, Rob Herring wrote:
> 
> 
> On 01/03/2012 05:16 AM, Marc Zyngier wrote:
>> [Adding Will to the loop as he's the author of the logical map stuff,
>> though I'm not sure he'll read that before next week...]
>>
>> On 03/01/12 00:44, Yang Bai wrote:
>>> On Tue, Jan 3, 2012 at 12:33 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
>>>> With CONFIG_SMP=n the following compile error occurs:
>>>>
>>>>  CC      arch/arm/common/gic.o
>>>> arch/arm/common/gic.c: In function 'gic_init_bases':
>>>> arch/arm/common/gic.c:679:4: error: implicit declaration of function 'cpu_logical_map' [-Werror=implicit-function-declaration]
>>>> cc1: some warnings being treated as errors
>>>>
>>>> This patch fixes the problem.
>>>>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>>>> ---
>>>>  arch/arm/common/gic.c |    5 ++++-
>>>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
>>>> index b2dc2dd..b33f6b0 100644
>>>> --- a/arch/arm/common/gic.c
>>>> +++ b/arch/arm/common/gic.c
>>>> @@ -676,7 +676,10 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>>>>                }
>>>>
>>>>                for_each_possible_cpu(cpu) {
>>>> -                       unsigned long offset = percpu_offset * cpu_logical_map(cpu);
>>>> +                       unsigned long offset = percpu_offset;
>>>> +#ifdef CONFIG_SMP
>>>> +                       offset *= cpu_logical_map(cpu);
>>>> +#endif
>>>>                        *per_cpu_ptr(gic->dist_base.percpu_base, cpu) = dist_base + offset;
>>>>                        *per_cpu_ptr(gic->cpu_base.percpu_base, cpu) = cpu_base + offset;
>>>>                }
>>>> --
>>>> 1.7.5.4
>>>>
>>>>
>>>
>>> Is this the right way to fix it? Or shall we do like this:
>>>
>>> #ifdef CONFIG_SMP
>>> ...
>>> #else
>>> #define cpu_logical_map() 1
>>> #endif
>>>
>>> and leave the gic.c code unchanged.
> 
> IIRC, part of the problem is asm/smp.h is only included by linux/smp.h
> for CONFIG_SMP, so this would have to change. Doing that could easily
> break other arches.

Ah... good point.

>>
>> Well, both patches are wrong. In the UP case (and assuming we're running
>> on physical CPU 0), offset should be 0.
>>
>> The second patch would be my favorite approach, except that
>> cpu_logical_map(x) should return either "x" or 0. And I'm not sure how
>> to handle the (unlikely?) case of running a UP kernel on a secondary CPU...
> 
> Wouldn't this be the case with 2 AMP instances of Linux running?

Yes, or kexec-ing a UP kernel on a secondary CPU. It really looks like
we ought to make this cpu_logical_map() independent from CONFIG_SMP.

	M.
-- 
Jazz is not dead. It just smells funny...

