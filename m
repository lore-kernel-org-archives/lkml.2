Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0DOIGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0DOIGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:06:04 -0400
Message-ID: <4BC6C8CD.1020801@redhat.com>
Date: Thu, 15 Apr 2010 11:05:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os statistics
 from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com>	 <4BC588CF.5010507@redhat.com> <1902445479.2078.458.camel@ymzhang.sh.intel.com>
In-Reply-To: <1902445479.2078.458.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2030 04:04 AM, Zhang, Yanmin wrote:
>
>> An even more accurate way to determine this is to check whether the
>> interrupt frame points back at the 'int $2' instruction.  However we
>> plan to switch to a self-IPI method to inject the NMI, and I'm not sure
>> wether APIC NMIs are accepted on an instruction boundary or whether
>> there's some latency involved.
>>      
> Yes. But the frame pointer checking seems a little complicated.
>    

An even bigger disadvantage is that it won't work with Sheng's patch, 
self-NMIs are not synchronous.

>>>    	trace_kvm_entry(vcpu->vcpu_id);
>>> +
>>> +	percpu_write(current_vcpu, vcpu);
>>>    	kvm_x86_ops->run(vcpu);
>>> +	percpu_write(current_vcpu, NULL);
>>>
>>>        
>> If you move this around the 'int $2' instructions you will close the
>> race, as a stray NMI won't catch us updating the rip cache.  But that
>> depends on whether self-IPI is accepted on the next instruction or not.
>>      
> Right. The kernel part has dependency on the self-IPI implementation.
> I will move above percpu_write(current_vcpu, vcpu) (or a new wrapper function)
> just around 'int $2'.
>
>    

Or create a new function to inject the interrupt in x86.c.  That will 
reduce duplication between svm.c and vmx.c.

> Sheng would find a solution on the self-IPI delivery. Let's separate my patch
> and self-IPI as 2 issues as we don't know when the self-IPI delivery would be
> resolved.
>    

Sure.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

