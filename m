Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab2FAPOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:14:32 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59363 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab2FAPO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:14:29 -0400
Message-ID: <4FC8DC19.4000007@linux.vnet.ibm.com>
Date: Fri, 01 Jun 2012 20:43:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: yong.zhang0@gmail.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        peterz@infradead.org, mingo@kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        nikunj@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, rusty@rustcorp.com.au, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keir Fraser <keir@xen.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [Xen-devel] [PATCH 05/27] xen, cpu hotplug: Don't call cpu_bringup()
 in xen_play_dead()
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091124.31979.91984.stgit@srivatsabhat.in.ibm.com> <4FC8D8E30200007800087D2B@nat28.tlf.novell.com>
In-Reply-To: <4FC8D8E30200007800087D2B@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060115-5816-0000-0000-000002F73D67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 06:29 PM, Jan Beulich wrote:

>>>> On 01.06.12 at 11:11, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> wrote:
>> xen_play_dead calls cpu_bringup() which looks weird, because xen_play_dead()
>> is invoked in the cpu down path, whereas cpu_bringup() (as the name 
>> suggests) is useful in the cpu bringup path.
> 
> This might not be correct - the code as it is without this change is
> safe even when the vCPU gets onlined back later by an external
> entity (e.g. the Xen tool stack), and it would in that case resume
> at the return point of the VCPUOP_down hypercall. That might
> be a heritage from the original XenoLinux tree though, and be
> meaningless in pv-ops context - Jeremy, Konrad?
> 
> Possibly it was bogus/unused even in that original tree - Keir?
>


Thanks for your comments Jan!

In case this change is wrong, the other method I had in mind was to call
cpu_bringup_and_idle() in xen_play_dead(). (Even ARM does something similar,
in the sense that it runs the cpu bringup code including cpu_idle(), in the
cpu offline path, namely the cpu_die() function). Would that approach work
for xen as well? If yes, then we wouldn't have any issues to convert xen to
generic code.

Regards,
Srivatsa S. Bhat

> 
>> Getting rid of xen_play_dead()'s dependency on cpu_bringup() helps in 
>> hooking on to the generic SMP booting framework.
>>
>> Also remove the extra call to preempt_enable() added by commit 41bd956
>> (xen/smp: Fix CPU online/offline bug triggering a BUG: scheduling while
>> atomic) because it becomes unnecessary after this change.
>>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org 
>> Cc: xen-devel@lists.xensource.com 
>> Cc: virtualization@lists.linux-foundation.org 
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  arch/x86/xen/smp.c |    8 --------
>>  1 files changed, 0 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>> index 09a7199..602d6b7 100644
>> --- a/arch/x86/xen/smp.c
>> +++ b/arch/x86/xen/smp.c
>> @@ -417,14 +417,6 @@ static void __cpuinit xen_play_dead(void) /* used only 
>> with HOTPLUG_CPU */
>>  {
>>  	play_dead_common();
>>  	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
>> -	cpu_bringup();
>> -	/*
>> -	 * Balance out the preempt calls - as we are running in cpu_idle
>> -	 * loop which has been called at bootup from cpu_bringup_and_idle.
>> -	 * The cpucpu_bringup_and_idle called cpu_bringup which made a
>> -	 * preempt_disable() So this preempt_enable will balance it out.
>> -	 */
>> -	preempt_enable();
>>  }
>>  
>>  #else /* !CONFIG_HOTPLUG_CPU */
>>
>>

