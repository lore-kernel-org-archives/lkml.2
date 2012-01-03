Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2ACLQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 06:16:06 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46937 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2ACLQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 06:16:03 -0500
Message-ID: <4F02E377.2050409@arm.com>
Date: Tue, 03 Jan 2012 11:16:07 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Yang Bai <hamo.by@gmail.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm: Fix linux-next compile error in arch/arm/common/gic.c
References: <1325521990-4445-1-git-send-email-joerg.roedel@amd.com> <CAO_0yfOzVCK8OGL5G9Aej+V4AZ12EMFKi3HafAX0JzeW9C3FtQ@mail.gmail.com>
In-Reply-To: <CAO_0yfOzVCK8OGL5G9Aej+V4AZ12EMFKi3HafAX0JzeW9C3FtQ@mail.gmail.com>
X-Enigmail-Version: 1.3.4
X-OriginalArrivalTime: 03 Jan 2012 11:15:56.0066 (UTC) FILETIME=[101B9020:01CCCA09]
X-MC-Unique: 112010311155806201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Will to the loop as he's the author of the logical map stuff,
though I'm not sure he'll read that before next week...]

On 03/01/12 00:44, Yang Bai wrote:
> On Tue, Jan 3, 2012 at 12:33 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
>> With CONFIG_SMP=n the following compile error occurs:
>>
>>  CC      arch/arm/common/gic.o
>> arch/arm/common/gic.c: In function 'gic_init_bases':
>> arch/arm/common/gic.c:679:4: error: implicit declaration of function 'cpu_logical_map' [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> This patch fixes the problem.
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>> ---
>>  arch/arm/common/gic.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
>> index b2dc2dd..b33f6b0 100644
>> --- a/arch/arm/common/gic.c
>> +++ b/arch/arm/common/gic.c
>> @@ -676,7 +676,10 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>>                }
>>
>>                for_each_possible_cpu(cpu) {
>> -                       unsigned long offset = percpu_offset * cpu_logical_map(cpu);
>> +                       unsigned long offset = percpu_offset;
>> +#ifdef CONFIG_SMP
>> +                       offset *= cpu_logical_map(cpu);
>> +#endif
>>                        *per_cpu_ptr(gic->dist_base.percpu_base, cpu) = dist_base + offset;
>>                        *per_cpu_ptr(gic->cpu_base.percpu_base, cpu) = cpu_base + offset;
>>                }
>> --
>> 1.7.5.4
>>
>>
> 
> Is this the right way to fix it? Or shall we do like this:
> 
> #ifdef CONFIG_SMP
> ...
> #else
> #define cpu_logical_map() 1
> #endif
> 
> and leave the gic.c code unchanged.

Well, both patches are wrong. In the UP case (and assuming we're running
on physical CPU 0), offset should be 0.

The second patch would be my favorite approach, except that
cpu_logical_map(x) should return either "x" or 0. And I'm not sure how
to handle the (unlikely?) case of running a UP kernel on a secondary CPU...

	M.
-- 
Jazz is not dead. It just smells funny...

