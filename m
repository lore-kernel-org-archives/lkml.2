Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2GPR1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:27:01 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60715 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2GPR05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:26:57 -0400
Message-ID: <50044E58.60905@linux.vnet.ibm.com>
Date: Mon, 16 Jul 2012 22:54:40 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V4 2/3] kvm: Note down when cpu relax intercepted
 or pause loop exited
References: <20120716082445.23477.15128.sendpatchset@codeblue.in.ibm.com> <20120716082514.23477.23849.sendpatchset@codeblue.in.ibm.com> <5003E682.20909@redhat.com>
In-Reply-To: <5003E682.20909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071607-7014-0000-0000-00000190CD0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 03:31 PM, Avi Kivity wrote:
> On 07/16/2012 11:25 AM, Raghavendra K T wrote:
>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>>
>> Noting pause loop exited vcpu or cpu relax intercepted helps in
>> filtering right candidate to yield. Wrong selection of vcpu;
>> i.e., a vcpu that just did a pl-exit or cpu relax intercepted may
>> contribute to performance degradation.
>>
>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>> ---
>> V2 was:
>> Reviewed-by: Rik van Riel<riel@redhat.com>
>>
>>   include/linux/kvm_host.h |   37 +++++++++++++++++++++++++++++++++++++
>>   virt/kvm/kvm_main.c      |    5 +++++
>>   2 files changed, 42 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index c446435..fa353bd 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -183,6 +183,18 @@ struct kvm_vcpu {
>>   	} async_pf;
>>   #endif
>>
>> +#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
>> +	/*
>> +	 * Cpu relax intercept or pause loop exit optimization
>> +	 * cpu_relax_intercepted: set when a vcpu does a pause loop exit
>> +	 *  or cpu relax intercepted.
>> +	 * dy_eligible: indicates whether vcpu is eligible for directed yield.
>> +	 */
>> +	struct {
>> +		bool cpu_relax_intercepted;
>> +		bool dy_eligible;
>> +	} ple;
>
> Naming:
>
> - ple is the x86 name, but this is common code.  I'd call it spin_loop.

agree.

> - cpu_relax_intercepted: can call it in_spin_loop,

Yes

the original name can
> me "are we intercepting cpu_relax or not" which may be useful at one
> point (when we know we aren't overcommitted)

Okay.
So are you saying allow vcpu to spin in non over-commit scenarios? So 
that we avoid all yield_to etc...

( Or even in some other place where it is useful).

> - dy_eligible: I'd like to understand the algorithm more and would want
> the name to reflect it, will come to this later if I have a better idea.

Yes, welcome any good name.

I had thought eligible initially, but felt it is too generic.

The intention of variable is to decide whether the vcpu is eligible for 
directed yield, so made it short, and added eligible.

>> +#endif
>
> blank line.

oops! 'll take care of this.

>
>>   	struct kvm_vcpu_arch arch;
>>   };
>>
>
>

