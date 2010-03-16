Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966083Ab0CPJcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:32:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966063Ab0CPJck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:32:40 -0400
Message-ID: <4B9F5021.3080206@redhat.com>
Date: Tue, 16 Mar 2010 11:32:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <1268717232.2813.36.camel@localhost>	 <4B9F19F7.6000309@redhat.com> <1268725724.2813.48.camel@localhost>
In-Reply-To: <1268725724.2813.48.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 09:48 AM, Zhang, Yanmin wrote:
>
>> Excellent, support for guest kernel != host kernel is critical (I can't
>> remember the last time I ran same kernels).
>>
>> How would we support multiple guests with different kernels?
>>      
> With the patch, 'perf kvm report --sort pid" could show
> summary statistics for all guest os instances. Then, use
> parameter --pid of 'perf kvm record' to collect single problematic instance data.
>    

That certainly works, though automatic association of guest data with 
guest symbols is friendlier.

>>> diff -Nraup linux-2.6_tipmaster0315/arch/x86/kvm/vmx.c linux-2.6_tipmaster0315_perfkvm/arch/x86/kvm/vmx.c
>>> --- linux-2.6_tipmaster0315/arch/x86/kvm/vmx.c	2010-03-16 08:59:11.825295404 +0800
>>> +++ linux-2.6_tipmaster0315_perfkvm/arch/x86/kvm/vmx.c	2010-03-16 09:01:09.976084492 +0800
>>> @@ -26,6 +26,7 @@
>>>    #include<linux/sched.h>
>>>    #include<linux/moduleparam.h>
>>>    #include<linux/ftrace_event.h>
>>> +#include<linux/perf_event.h>
>>>    #include "kvm_cache_regs.h"
>>>    #include "x86.h"
>>>
>>> @@ -3632,6 +3633,43 @@ static void update_cr8_intercept(struct
>>>    	vmcs_write32(TPR_THRESHOLD, irr);
>>>    }
>>>
>>> +DEFINE_PER_CPU(int, kvm_in_guest) = {0};
>>> +
>>> +static void kvm_set_in_guest(void)
>>> +{
>>> +	percpu_write(kvm_in_guest, 1);
>>> +}
>>> +
>>> +static int kvm_is_in_guest(void)
>>> +{
>>> +	return percpu_read(kvm_in_guest);
>>> +}
>>>
>>>        
>>      
>    
>> There is already PF_VCPU for this.
>>      
> Right, but there is a scope between kvm_guest_enter and really running
> in guest os, where a perf event might overflow. Anyway, the scope is very
> narrow, I will change it to use flag PF_VCPU.
>    

There is also a window between setting the flag and calling 'int $2' 
where an NMI might happen and be accounted incorrectly.

Perhaps separate the 'int $2' into a direct call into perf and another 
call for the rest of NMI handling.  I don't see how it would work on svm 
though - AFAICT the NMI is held whereas vmx swallows it.  I guess NMIs 
will be disabled until the next IRET so it isn't racy, just tricky.

>>> +static struct perf_guest_info_callbacks kvm_guest_cbs = {
>>> +	.is_in_guest 		= kvm_is_in_guest,
>>> +	.is_user_mode		= kvm_is_user_mode,
>>> +	.get_guest_ip		= kvm_get_guest_ip,
>>> +	.reset_in_guest		= kvm_reset_in_guest,
>>> +};
>>>
>>>        
>> Should be in common code, not vmx specific.
>>      
> Right. I discussed with Yangsheng. I will move above data structures and
> callbacks to file arch/x86/kvm/x86.c, and add get_ip, a new callback to
> kvm_x86_ops.
>    

You will need access to the vcpu pointer (kvm_rip_read() needs it), you 
can put it in a percpu variable.  I guess if it's not null, you know 
you're in a guest, so no need for PF_VCPU.

-- 
error compiling committee.c: too many arguments to function

