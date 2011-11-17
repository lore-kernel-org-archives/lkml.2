Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1KQHLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 02:11:22 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59649 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1KQHLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 02:11:21 -0500
X-AuditID: b753bd60-9785eba00000359c-5e-4ec4b3962599
X-AuditID: b753bd60-9785eba00000359c-5e-4ec4b3962599
Message-ID: <4EC4B38B.2010301@hitachi.com>
Date: Thu, 17 Nov 2011 16:11:07 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 3/5] x86: add a sysctl parameter to panic on stack
 overflow
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp> <20111107055301.7928.91628.stgit@ltc219.sdl.hitachi.co.jp> <20111110195538.GB22646@phenom.dumpdata.com>
In-Reply-To: <20111110195538.GB22646@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

>> diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
>> index 530cfd0..d720813 100644
>> --- a/arch/x86/kernel/irq_64.c
>> +++ b/arch/x86/kernel/irq_64.c
>> @@ -20,6 +20,8 @@
>>  #include <asm/idle.h>
>>  #include <asm/apic.h>
>>  
>> +int sysctl_panic_on_stackoverflow;
> __read_mostly

I don't mind if I add __read_mostly here, but I think it's not
necessary because this variable is seldom read as well.


>> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
>> index 6318b51..24fc654 100644
>> --- a/kernel/sysctl_binary.c
>> +++ b/kernel/sysctl_binary.c
>> @@ -137,6 +137,7 @@ static const struct bin_table bin_kern_table[] = {
>>  	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
>>  	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
>>  	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
>> +	{ CTL_INT,	KERN_PANIC_ON_STACKOVERFLOW,	"panic_on_stackoverflow" },
> This shouldn't be wrapped in the #ifdef?
>

It seems that we do not need to add this entry to bin_kern_table[]
according to the following information and patch series:

[Removing binary sysctl]
	http://lwn.net/Articles/361453/

[Removal of binary sysctl support]
	http://lwn.net/Articles/361001/

So, I'm going to remove this changes for sysctl.h and sysctl_binary.c.

Thanks


(2011/11/11 4:55), Konrad Rzeszutek Wilk wrote:
> On Mon, Nov 07, 2011 at 02:53:01PM +0900, Mitsuo Hayasaka wrote:
>> This patch adds kernel.panic_on_stackoverflow sysctl parameter,
>> which can cause a panic when detecting the stack overflow.
> 
> Why would we want to panic?
>>
>> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
>> Cc: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> ---
>>
>>  Documentation/sysctl/kernel.txt |   13 +++++++++++++
>>  arch/x86/kernel/irq_64.c        |    2 ++
>>  include/linux/kernel.h          |    1 +
>>  include/linux/sysctl.h          |    1 +
>>  kernel/sysctl.c                 |    9 +++++++++
>>  kernel/sysctl_binary.c          |    1 +
>>  6 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
>> index 704e474..eb8d263 100644
>> --- a/Documentation/sysctl/kernel.txt
>> +++ b/Documentation/sysctl/kernel.txt
>> @@ -48,6 +48,7 @@ show up in /proc/sys/kernel:
>>  - panic
>>  - panic_on_oops
>>  - panic_on_unrecovered_nmi
>> +- panic_on_stackoverflow
>>  - pid_max
>>  - powersave-nap               [ PPC only ]
>>  - printk
>> @@ -385,6 +386,18 @@ Controls the kernel's behaviour when an oops or BUG is encountered.
>>  
>>  ==============================================================
>>  
>> +panic_on_stackoverflow:
>> +
>> +Controls the kernel's behaviour when detecting stack overflow.
>> +This file shows up if CONFIG_DEBUG_STACKOVERFLOW is enabled.
>> +
>> +0: try to continue operation.
>> +
>> +1: panic immediately.
>> +
>> +==============================================================
>> +
>> +
>>  pid_max:
>>  
>>  PID allocation wrap value.  When the kernel's next PID value
>> diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
>> index 530cfd0..d720813 100644
>> --- a/arch/x86/kernel/irq_64.c
>> +++ b/arch/x86/kernel/irq_64.c
>> @@ -20,6 +20,8 @@
>>  #include <asm/idle.h>
>>  #include <asm/apic.h>
>>  
>> +int sysctl_panic_on_stackoverflow;
> 
> __read_mostly
> 
>> +
>>  DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
>>  EXPORT_PER_CPU_SYMBOL(irq_stat);
>>  
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 8eefcf7..19b3595 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -339,6 +339,7 @@ extern int panic_timeout;
>>  extern int panic_on_oops;
>>  extern int panic_on_unrecovered_nmi;
>>  extern int panic_on_io_nmi;
>> +extern int sysctl_panic_on_stackoverflow;
>>  extern const char *print_tainted(void);
>>  extern void add_taint(unsigned flag);
>>  extern int test_taint(unsigned flag);
>> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
>> index 9a1ec10..4b9dc3d 100644
>> --- a/include/linux/sysctl.h
>> +++ b/include/linux/sysctl.h
>> @@ -153,6 +153,7 @@ enum
>>  	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
>> +	KERN_PANIC_ON_STACKOVERFLOW = 77, /* int: panic on stack overflow */
>>  };
>>  
>>  
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index 11d65b5..08a18f9 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -792,6 +792,15 @@ static struct ctl_table kern_table[] = {
>>  		.mode		= 0644,
>>  		.proc_handler	= proc_dointvec,
>>  	},
>> +#if defined(CONFIG_DEBUG_STACKOVERFLOW)
>> +	{
>> +		.procname	= "panic_on_stackoverflow",
>> +		.data		= &sysctl_panic_on_stackoverflow,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec,
>> +	},
>> +#endif
>>  	{
>>  		.procname	= "bootloader_type",
>>  		.data		= &bootloader_type,
>> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
>> index 6318b51..24fc654 100644
>> --- a/kernel/sysctl_binary.c
>> +++ b/kernel/sysctl_binary.c
>> @@ -137,6 +137,7 @@ static const struct bin_table bin_kern_table[] = {
>>  	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
>>  	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
>>  	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
>> +	{ CTL_INT,	KERN_PANIC_ON_STACKOVERFLOW,	"panic_on_stackoverflow" },
> 
> This shouldn't be wrapped in the #ifdef?
> 
>>  	{}
>>  };
>>  
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 

