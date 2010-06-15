Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab0FOJVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 05:21:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0FOJVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:21:16 -0400
Message-ID: <4C174607.4040107@redhat.com>
Date: Mon, 14 Jun 2010 23:21:11 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mtosatti@redhat.com, glommer@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 15/17] Fix AMD C1 TSC desynchronization
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-16-git-send-email-zamsden@redhat.com> <4C173E18.6000804@redhat.com>
In-Reply-To: <4C173E18.6000804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 10:47 PM, Avi Kivity wrote:
> On 06/15/2010 10:34 AM, Zachary Amsden wrote:
>> Some AMD based machines can have TSC drift when in C1 HLT state because
>> despite attempting to scale the TSC increment when dividing down the
>> P-state, the processor may return to full P-state to service cache
>> probes.  The TSC of halted CPUs can advance faster than that of running
>> CPUs as a result, causing unpredictable TSC drift.
>>
>> We implement a recommended workaround, which is disabling C1 clock 
>> ramping.
>> ---
>>   arch/x86/kvm/x86.c |   45 
>> +++++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 45 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ef847ee..8e836e9 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -56,6 +56,11 @@
>>   #include<asm/i387.h>
>>   #include<asm/xcr.h>
>>
>> +#ifdef CONFIG_K8_NB
>> +#include<linux/pci.h>
>> +#include<asm/k8.h>
>> +#endif
>> +
>>   #define MAX_IO_MSRS 256
>>   #define CR0_RESERVED_BITS                        \
>>       (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | 
>> X86_CR0_TS \
>> @@ -4287,10 +4292,43 @@ static struct notifier_block 
>> kvmclock_cpu_notifier_block = {
>>       .priority = -INT_MAX
>>   };
>>
>> +static u8 disabled_c1_ramp = 0;
>> +
>>   static void kvm_timer_init(void)
>>   {
>>       int cpu;
>>
>> +    /*
>> +     * AMD processors can de-synchronize TSC on halt in C1 state, 
>> because
>> +     * processors in lower P state will have TSC scaled properly during
>> +     * normal operation, but will have TSC scaled improperly while
>> +     * servicing cache probes.  Because there is no way to determine 
>> how
>> +     * TSC was adjusted during cache probes, there are two solutions:
>> +     * resynchronize after halt, or disable C1-clock ramping.
>> +     *
>> +     * We implemenent solution 2.
>> +     */
>> +#ifdef CONFIG_K8_NB
>> +    if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD&&
>> +        boot_cpu_data.x86 == 0x0f&&
>> +        !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
>> +        struct pci_dev *nb;
>> +        int i;
>> +        cache_k8_northbridges();
>> +        for (i = 0; i<  num_k8_northbridges; i++) {
>> +            u8 byte;
>> +            nb = k8_northbridges[i];
>> +            pci_read_config_byte(nb, 0x87,&byte);
>> +            if (byte&  1) {
>> +                printk(KERN_INFO "%s: AMD C1 clock ramping detected, 
>> performing workaround\n", __func__);
>> +                disabled_c1_ramp = byte;
>> +                pci_write_config_byte(nb, 0x87, byte&  0xFC);
>> +
>> +            }
>> +        }
>> +    }
>> +#endif
>> +
>>       register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
>>       if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
>>           cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
>> @@ -4402,6 +4440,13 @@ void kvm_arch_exit(void)
>>       unregister_hotcpu_notifier(&kvmclock_cpu_notifier_block);
>>       kvm_x86_ops = NULL;
>>       kvm_mmu_module_exit();
>> +#ifdef CONFIG_K8_NB
>> +    if (disabled_c1_ramp) {
>> +        struct pci_dev **nb;
>> +        for (nb = k8_northbridges; *nb; nb++)
>> +            pci_write_config_byte(*nb, 0x87, disabled_c1_ramp);
>> +    }
>> +#endif
>>   }
>
> Such platform hackery should be in the platform code, not in kvm.  kvm 
> might request to enable it (why not enable it unconditionally?  should 
> we disable it on hardware_disable()?

I actually have some negative effects to report from this patch - when 
under stress, my laptop spontaneously shut down.  Thermal problems?

I agree it is complete hackery.  I do not recommend this patch for 
upstream inclusion unless it is proposed also by someone more familiar 
with the hardware.

However, it was required for my testing.
