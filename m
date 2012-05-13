Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2EMUk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:40:29 -0400
Received: from blu0-omc3-s20.blu0.hotmail.com ([65.55.116.95]:54148 "EHLO
	blu0-omc3-s20.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110Ab2EMUk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:40:26 -0400
X-Originating-IP: [64.229.84.125]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP85D30AAA2BF2CF07B1039897150@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
In-Reply-To: <4FB0197F.6010000@linux.vnet.ibm.com>
Subject: Re: Linux 3.4-rc7
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com> <4FB011E7.1000604@linux.vnet.ibm.com> <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl> <4FB0197F.6010000@linux.vnet.ibm.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sun, 13 May 2012 16:40:07 -0400
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mikulas Patocka <mpatocka@redhat.com>, stepanm@codeaurora.org,
        Thomas Gleixner <tglx@linutronix.de>,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 13 May 2012 20:40:24.0825 (UTC) FILETIME=[9F934E90:01CD3148]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, the revised change fixes the compilation error.  I'll know in a  
while if
my config boots.

Thanks,
Dave

On 13-May-12, at 4:28 PM, Srivatsa S. Bhat wrote:

> On 05/14/2012 01:38 AM, John David Anglin wrote:
>
>> On 13-May-12, at 3:56 PM, Srivatsa S. Bhat wrote:
>>
>>> The regression was introduced in the 3.4 merge window itself (by  
>>> commit
>>> 5fbd036b55 "sched: Cleanup cpu_active madness").
>>>
>>> Links to the original posting:
>>> PA_RISC: http://marc.info/?l=linux-parisc&m=133241790810604&w=2
>>
>>
>> If I had the above change, I get
>>
>>  CHK     include/generated/compile.h
>>  CC      arch/parisc/kernel/smp.o
>> arch/parisc/kernel/smp.c: In function 'smp_cpu_init':
>> arch/parisc/kernel/smp.c:300:2: error: implicit declaration of  
>> function
>> 'notify_cpu_starting' [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>> make[1]: *** [arch/parisc/kernel/smp.o] Error 1
>>
>
>
> Sorry about that. I neither have the hardware nor the toolchain
> to test it. I guess this problem doesn't exist for mn10300 since it
> already includes linux/cpu.h when CONFIG_HOTPLUG_CPU=y
>
> Does the below updated patch help for PA-RISC?
>
> ----
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>
> parisc/CPU hotplug: Add missing call to notify_cpu_starting()
>
> The scheduler depends on receiving the CPU_STARTING notification,  
> without
> which we end up into a lot of trouble. So add the missing call to
> notify_cpu_starting() in the bringup code.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
> arch/parisc/kernel/smp.c |    8 +++++++-
> 1 files changed, 7 insertions(+), 1 deletions(-)
>
>
> diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
> index 0bb1d63..4dc7b79 100644
> --- a/arch/parisc/kernel/smp.c
> +++ b/arch/parisc/kernel/smp.c
> @@ -31,6 +31,7 @@
> #include <linux/delay.h>
> #include <linux/bitops.h>
> #include <linux/ftrace.h>
> +#include <linux/cpu.h>
>
> #include <linux/atomic.h>
> #include <asm/current.h>
> @@ -295,8 +296,13 @@ smp_cpu_init(int cpunum)
>
> 		printk(KERN_CRIT "CPU#%d already initialized!\n", cpunum);
> 		machine_halt();
> -	}
> +	}
> +
> +	notify_cpu_starting(cpunum);
> +
> +	ipi_call_lock();
> 	set_cpu_online(cpunum, true);
> +	ipi_call_unlock();
>
> 	/* Initialise the idle task for this CPU */
> 	atomic_inc(&init_mm.mm_count);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
John David Anglin	dave.anglin@bell.net



