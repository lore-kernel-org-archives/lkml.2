Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab1IHDHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 23:07:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:33604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898Ab1IHDHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 23:07:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="46286979"
Message-ID: <4E683108.8020000@linux.intel.com>
Date: Thu, 08 Sep 2011 11:05:44 +0800
From: Minskey Guo <chaohong_guo@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Chen Gong <gong.chen@linux.intel.com>
CC: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 5/5] mce: recover from "action required" errors reported
 in data path in usermode
References: <4e5eb50721061dbb1b@agluck-desktop.sc.intel.com> <4E6709B2.7020401@linux.intel.com>
In-Reply-To: <4E6709B2.7020401@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/07/2011 02:05 PM, Chen Gong wrote:
> 于 2011/9/1 6:26, Luck, Tony 写道:
>> From: Tony Luck<tony.luck@intel.com>
>>
>> Two new entries in the mce severity table - one notes that data errors
>> observed by innocent bystanders (who happen to share a machine check
>> bank with the cpu experiencing the error) should be left alone by using
>> the "KEEP" severity.
>>
>> Then inline in the do_machine_check() handler we process the user-mode
>> data error that was marked at MCE_AR_SEVERITY.  Even though we are in
>> "machine check context" it is almost safe to do so. We have already
>> released all the other cpus from rendezvous and we know that the cpu
>> with the error was executing user code - so it cannot have interrupts
>> locked out, or hold any locks. I.e. this is almost equivalent to a
>> page fault. Only difference (and risk) is that on x86_64 we are still
>> on the machine check stack - so if another machine check arrives, we
>> are toast (we didn't clear MCG_STATUS - yet, so cpu will reset rather
>> than taking a nested machine check on the same stack).
>>
>> Signed-off-by: Tony Luck<tony.luck@intel.com>
>> ---
>>
>> Using the "KEEP" state avoids the complexity of my earlier solution
>> that sorted the cpus by severity and ran the more serious ones first.
>>
>>   arch/x86/kernel/cpu/mcheck/mce-severity.c |   14 ++++++++++-
>>   arch/x86/kernel/cpu/mcheck/mce.c          |   35 
>> ++++++++++++++++++++--------
>>   2 files changed, 38 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c 
>> b/arch/x86/kernel/cpu/mcheck/mce-severity.c
>> index 7395d5f..c4d8b24 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
>> @@ -54,6 +54,7 @@ static struct severity {
>>   #define  MASK(x, y)    .mask = x, .result = y
>>   #define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
>>   #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
>> +#define    MCI_ADDR (MCI_STATUS_ADDRV|MCI_STATUS_MISCV)
>>   #define MCACOD 0xffff
>>
>>       MCESEV(
>> @@ -102,11 +103,22 @@ static struct severity {
>>           SER, BITCLR(MCI_STATUS_S)
>>           ),
>>
>> -    /* AR add known MCACODs here */
>>       MCESEV(
>>           PANIC, "Action required with lost events",
>>           SER, BITSET(MCI_STATUS_OVER|MCI_UC_SAR)
>>           ),
>> +
>> +    /* known AR MCACODs: */
>> +    MCESEV(
>> +        KEEP, "HT thread notices Action required: data load error",
>> +        SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, 
>> MCI_UC_SAR|MCI_ADDR|0x0134),
>> +        MCGMASK(MCG_STATUS_EIPV, 0)
>> +        ),
>> +    MCESEV(
>> +        AR, "Action required: data load error",
>> +        SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, 
>> MCI_UC_SAR|MCI_ADDR|0x0134),
>> +        USER
>> +        ),
>
> I don't think *AR* makes sense here because the following codes have a 
> assumption that it means *user space* condition. If so, in the future 
> a new *AR* severity for kernel usage is created, we can't distinguish 
> which one can call "memory_failure" as below. At least, it should have 
> a suffix such as AR_USER/AR_KERN:
>
> enum severity_level {
>         MCE_NO_SEVERITY,
>         MCE_KEEP_SEVERITY,
>         MCE_SOME_SEVERITY,
>         MCE_AO_SEVERITY,
>         MCE_UC_SEVERITY,
>         MCE_AR_USER_SEVERITY,
>     MCE_AR_KERN_SEVERITY,
>         MCE_PANIC_SEVERITY,
> };
>
>
>>       MCESEV(
>>           PANIC, "Action required: unknown MCACOD",
>>           SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR)
>> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c 
>> b/arch/x86/kernel/cpu/mcheck/mce.c
>> index 135e12d..2c59a34 100644
>> --- a/arch/x86/kernel/cpu/mcheck/mce.c
>> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
>> @@ -996,12 +996,6 @@ void do_machine_check(struct pt_regs *regs, long 
>> error_code)
>>               continue;
>>           }
>>
>> -        /*
>> -         * Kill on action required.
>> -         */
>> -        if (severity == MCE_AR_SEVERITY)
>> -            kill_it = 1;
>> -
>>           mce_read_aux(&m, i);
>>
>>           /*
>> @@ -1022,6 +1016,8 @@ void do_machine_check(struct pt_regs *regs, 
>> long error_code)
>>           }
>>       }
>>
>> +    m = *final;
>> +
>>       if (!no_way_out)
>>           mce_clear_state(toclear);
>>
>> @@ -1040,7 +1036,7 @@ void do_machine_check(struct pt_regs *regs, 
>> long error_code)
>>        * support MCE broadcasting or it has been disabled.
>>        */
>>       if (no_way_out&&  tolerant<  3)
>> -        mce_panic("Fatal machine check on current CPU", final, msg);
>> +        mce_panic("Fatal machine check on current CPU",&m, msg);
>>
>>       /*
>>        * If the error seems to be unrecoverable, something should be
>> @@ -1049,11 +1045,24 @@ void do_machine_check(struct pt_regs *regs, 
>> long error_code)
>>        * high, don't try to do anything at all.
>>        */
>>
>> -    if (kill_it&&  tolerant<  3)
>> +    if (worst != MCE_AR_SEVERITY&&  kill_it&&  tolerant<  3)
>>           force_sig(SIGBUS, current);
>>
>>       if (worst>  0)
>>           mce_report_event(regs);
>> +
>> +    if (worst == MCE_AR_SEVERITY) {
>> +        unsigned long pfn = m.addr>>  PAGE_SHIFT;
>> +
>> +        pr_err("Uncorrected hardware memory error in user-access at 
>> %llx",
>> +            m.addr);
>
> print in the MCE handler maybe makes a deadlock ? say, when other CPUs 
> are printing something, suddently they received MCE broadcast from 
> Monarch CPU, when Monarch CPU runs above codes, a deadlock happens ?
> Please fix me if I miss something :-)
>
>> +        if (__memory_failure(pfn, MCE_VECTOR, 0)<  0) {
>> +            pr_err("Memory error not recovered");
>> +            force_sig(SIGBUS, current);
>> +        } else
>> +            pr_err("Memory error recovered");
>> +    }
>
> as you mentioned in the comment, the biggest concern is that when 
> __memory_failure runs too long, if another MCE happens at the same 
> time, (assuming this MCE is happened on its sibling CPU which has the 
> same banks), the 2nd MCE will crash the system. Why not delaying the 
> process in a safer context, such as using user_return_notifer ?
>

besides, I somewhat suspect that calling __memory_failure()
in do_machine_check() will cause deadlock.

    __memory_failure() handling calls  some routines, such
as  is_free_buddy_page(),  which needs to acquire the spin
lock,  zone->lock. How can we guarantee that other CPUs
haven't acquired the lock when receiving #mc broadcast
and entering #mc handlers ?

     Moreover,  there are too many printk in __memory_failure()
which can cause deadlock.


-minskey

