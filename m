Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0CVL12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:27:28 -0400
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:47808 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab0CVL10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:27:26 -0400
X-AuditID: c1b4fb3d-b7bf6ae000005bec-4a-4ba7541cd7de
Message-ID: <4BA75473.8090400@ericsson.com>
Date: Mon, 22 Mar 2010 12:28:51 +0100
From: "kerstin.jonsson" <kerstin.jonsson@ericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbohac@novell.com" <jbohac@novell.com>,
       Yinghai Lu <yinghai@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
 - V5
References: <4B96116A.6090705@ericsson.com>	<1268131954-13845-1-git-send-email-trenn@suse.de>	<m11vfhaz24.fsf@fess.ebiederm.org> <m1pr2z8pe9.fsf@fess.ebiederm.org>
In-Reply-To: <m1pr2z8pe9.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2010 11:27:23.0970 (UTC) FILETIME=[A4CC6220:01CAC9B2]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2010 07:42 AM, Eric W. Biederman wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>    
>> Andrew thanks for finding this.  I have a test case for this that
>> reproduces about every other time, and I will plug this patch in and
>> see it helps.  I'm not wild about how the max_loops variable is
>> reused both as a timer and as a countdown timer, but the basic
>> principle feels solid.
>>
>> I have been seeing this and for some reason I thought I was dying
>> in calibrate_delay_loop().  But this is much later and much easier
>> to deal with.  Since we make it to smp_init() there isn't any
>> good excuse for us to fail to come up.
>>
>> I'm curious how much testing have you been able to do on this piece
>> of code?
>>      
> This code definitely makes things better in my test case.
> I had the patience to wait for 12 iterations and I was
> expecting 6 failures and I saw none.
>
> I have reservations about the timeout, but the rest of the patch
> is definitely doing the right thing, and something is a lot better
> than nothing.
>
> Tested-by: "Eric W. Biederman"<ebiederm@xmission.com>
>
>
>    
We have an application that relies heavily on kexec and have seen this 
problem for quite some time without being able to pin-point the root 
cause. Through a case of serendipity we found a reliable way to trigger 
the fault, which is how I was able to get a better understanding of the 
source. My original patch is included in our kernel, which is used in an 
embedded telecom system, and quite well tested. N.B. the original 
version did not include the max_loop constraint. I have added the 
current version of the patch to our kernel, it is not yet included in 
thousands of customer nodes as is the first version, but preliminary 
tests indicates that it still works as intended.

Tested-by: "Kerstin Jonsson" <kerstin.jonsson@ericsson.com>
>> Thomas Renninger<trenn@suse.de>  writes:
>>
>>      
>>> From: Kerstin Jonsson<kerstin.jonsson@ericsson.com>
>>>
>>> When the SMP kernel decides to crash_kexec() the local APICs may have
>>> pending interrupts in their vector tables.
>>> The setup routine for the local APIC has a deficient mechanism for
>>> clearing these interrupts, it only handles interrupts that has already
>>> been dispatched to the local core for servicing (the ISR register)
>>> safely, it doesn't consider lower prioritized queued interrupts stored
>>> in the IRR register.
>>>
>>> If you have more than one pending interrupt within the same 32 bit word
>>> in the LAPIC vector table registers you may find yourself entering the
>>> IO APIC setup with pending interrupts left in the LAPIC. This is a
>>> situation for wich the IO APIC setup is not prepared. Depending of
>>> what/which interrupt vector/vectors are stuck in the APIC tables your
>>> system may show various degrees of malfunctioning.
>>> That was the reason why the check_timer() failed in our system, the
>>> timer interrupts was blocked by pending interrupts from the old kernel
>>> when routed trough the IO APIC.
>>>
>>> Additional comment from Jiri Bohac:
>>> ==============
>>> If this should go into stable release,
>>> I'd add some kind of limit on the number of iterations, just to be safe from
>>> hard to debug lock-ups:
>>>
>>> +if (loops++>  MAX_LOOPS) {
>>> +        printk("LAPIC pending clean-up")
>>> +        break;
>>> +}
>>>   while (queued);
>>>
>>> with MAX_LOOPS something like 1E9 this would leave plenty of time for the
>>> pending IRQs to be cleared and would and still cause at most a second of delay
>>> if the loop were to lock-up for whatever reason.
>>> ==============
>>>
>>> > From trenn@suse.de:
>>> V2: Use tsc if avail to bail out after 1 sec due to possible virtual apic_read
>>>      calls which may take rather long (suggested by: Avi Kivity<avi@redhat.com>)
>>>      If no tsc is available bail out quickly after cpu_khz, if we broke out too
>>>      early and still have irqs pending (which should never happen?) we still
>>>      get a WARN_ON...
>>>
>>> V3: - Fixed indentation ->  checkpatch clean
>>>      - max_loops must be signed
>>>
>>> V4: - Fix typo, mixed up tsc and ntsc in first rdtscll() call
>>>
>>> V5: Adjust WARN_ON() condition to also catch error in cpu_has_tsc case
>>>
>>> CC: jbohac@novell.com
>>> CC: "Yinghai Lu"<yinghai@kernel.org>
>>> CC: akpm@linux-foundation.org
>>> CC: mingo@elte.hu
>>> CC: "Kerstin Jonsson"<kerstin.jonsson@ericsson.com>
>>> CC: "Avi Kivity"<avi@redhat.com>
>>> Signed-off-by: Thomas Renninger<trenn@suse.de>
>>> ---
>>>   arch/x86/kernel/apic/apic.c |   41 +++++++++++++++++++++++++++++++++--------
>>>   1 files changed, 33 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>>> index 00187f1..cfcc87f 100644
>>> --- a/arch/x86/kernel/apic/apic.c
>>> +++ b/arch/x86/kernel/apic/apic.c
>>> @@ -51,6 +51,7 @@
>>>   #include<asm/smp.h>
>>>   #include<asm/mce.h>
>>>   #include<asm/kvm_para.h>
>>> +#include<asm/tsc.h>
>>>
>>>   unsigned int num_processors;
>>>
>>> @@ -1151,8 +1152,13 @@ static void __cpuinit lapic_setup_esr(void)
>>>    */
>>>   void __cpuinit setup_local_APIC(void)
>>>   {
>>> -	unsigned int value;
>>> -	int i, j;
>>> +	unsigned int value, queued;
>>> +	int i, j, acked = 0;
>>> +	unsigned long long tsc = 0, ntsc;
>>> +	long long max_loops = cpu_khz;
>>> +
>>> +	if (cpu_has_tsc)
>>> +		rdtscll(tsc);
>>>
>>>   	if (disable_apic) {
>>>   		arch_disable_smp_support();
>>> @@ -1204,13 +1210,32 @@ void __cpuinit setup_local_APIC(void)
>>>   	 * the interrupt. Hence a vector might get locked. It was noticed
>>>   	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
>>>   	 */
>>> -	for (i = APIC_ISR_NR - 1; i>= 0; i--) {
>>> -		value = apic_read(APIC_ISR + i*0x10);
>>> -		for (j = 31; j>= 0; j--) {
>>> -			if (value&  (1<<j))
>>> -				ack_APIC_irq();
>>> +	do {
>>> +		queued = 0;
>>> +		for (i = APIC_ISR_NR - 1; i>= 0; i--)
>>> +			queued |= apic_read(APIC_IRR + i*0x10);
>>> +
>>> +		for (i = APIC_ISR_NR - 1; i>= 0; i--) {
>>> +			value = apic_read(APIC_ISR + i*0x10);
>>> +			for (j = 31; j>= 0; j--) {
>>> +				if (value&  (1<<j)) {
>>> +					ack_APIC_irq();
>>> +					acked++;
>>> +				}
>>> +			}
>>>   		}
>>> -	}
>>> +		if (acked>  256) {
>>> +			printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
>>> +			       acked);
>>> +			break;
>>> +		}
>>> +		if (cpu_has_tsc) {
>>> +			rdtscll(ntsc);
>>> +			max_loops = (cpu_khz<<  10) - (ntsc - tsc);
>>> +		} else
>>> +			max_loops--;
>>> +	} while (queued&&  max_loops>  0);
>>> +	WARN_ON(max_loops<= 0);
>>>
>>>   	/*
>>>   	 * Now that we are all set up, enable the APIC
>>> -- 
>>> 1.6.3
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>        

