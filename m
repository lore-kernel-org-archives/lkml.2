Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab2GMDiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 23:38:22 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46970 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759455Ab2GMDiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 23:38:17 -0400
Message-ID: <4FFF979F.8070100@linux.vnet.ibm.com>
Date: Fri, 13 Jul 2012 09:05:59 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V3 2/3] kvm: Note down when cpu relax intercepted
 or pause loop exited
References: <20120712191712.30440.68944.sendpatchset@codeblue> <20120712191800.30440.16406.sendpatchset@codeblue> <4FFF2D5F.3050902@de.ibm.com>
In-Reply-To: <4FFF2D5F.3050902@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071218-3568-0000-0000-000002212239
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 01:32 AM, Christian Borntraeger wrote:
> On 12/07/12 21:18, Raghavendra K T wrote:
>> +#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
> [...]
>> +	struct {
>> +		bool cpu_relax_intercepted;
>> +		bool dy_eligible;
>> +	} ple;
>> +#endif
> [...]
>>   	}
>>   	vcpu->run = page_address(page);
>> +	vcpu->ple.cpu_relax_intercepted = false;
>> +	vcpu->ple.dy_eligible = false;
>
> This struct is only defined if CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT is set, but here it
> is always accessed. Will break on !x86&&  !s390.

Yes! I forgot about archs in init function.
How about having
#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
vcpu->ple.cpu_relax_intercepted = false;
vcpu->ple.dy_eligible = false;
#endif

This would solve all the problem.

>>
>>   	r = kvm_arch_vcpu_init(vcpu);
>>   	if (r<  0)
>> @@ -1577,6 +1579,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>   	int pass;
>>   	int i;
>>
>> +	me->ple.cpu_relax_intercepted = true;
>
> dito

currently vcpu_on_spin is used only by x86 and s390. so if some other
arch in future uses vcpu_on_spin, I believe they also have to enable
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
what do you think?

otherwise we have to add hook everywhere
>>   	/*
>>   	 * We boost the priority of a VCPU that is runnable but not
>>   	 * currently running, because it got preempted by something
>> @@ -1602,6 +1605,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>   			}
>>   		}
>>   	}
>> +	me->ple.cpu_relax_intercepted = false;
>
> again.
>
> maybe define static inline access functions in kvm_host.h that are no-ops
> if CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT is not set.
>

