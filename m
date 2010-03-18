Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab0CRIsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:48:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0CRIsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:48:12 -0400
Message-ID: <4BA1E8A9.90100@redhat.com>
Date: Wed, 17 Mar 2010 22:47:37 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>,
       "Huang, Zhiteng" <zhiteng.huang@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <1268717232.2813.36.camel@localhost> <4BA1B132.5030509@redhat.com> <201003181322.28594.sheng@linux.intel.com> <201003181341.15407.sheng@linux.intel.com>
In-Reply-To: <201003181341.15407.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 07:41 PM, Sheng Yang wrote:
> On Thursday 18 March 2010 13:22:28 Sheng Yang wrote:
>    
>> On Thursday 18 March 2010 12:50:58 Zachary Amsden wrote:
>>      
>>> On 03/17/2010 03:19 PM, Sheng Yang wrote:
>>>        
>>>> On Thursday 18 March 2010 05:14:52 Zachary Amsden wrote:
>>>>          
>>>>> On 03/16/2010 11:28 PM, Sheng Yang wrote:
>>>>>            
>>>>>> On Wednesday 17 March 2010 10:34:33 Zhang, Yanmin wrote:
>>>>>>              
>>>>>>> On Tue, 2010-03-16 at 11:32 +0200, Avi Kivity wrote:
>>>>>>>                
>>>>>>>> On 03/16/2010 09:48 AM, Zhang, Yanmin wrote:
>>>>>>>>                  
>>>>>>>>> Right, but there is a scope between kvm_guest_enter and really
>>>>>>>>> running in guest os, where a perf event might overflow. Anyway,
>>>>>>>>> the scope is very narrow, I will change it to use flag PF_VCPU.
>>>>>>>>>                    
>>>>>>>> There is also a window between setting the flag and calling 'int
>>>>>>>> $2' where an NMI might happen and be accounted incorrectly.
>>>>>>>>
>>>>>>>> Perhaps separate the 'int $2' into a direct call into perf and
>>>>>>>> another call for the rest of NMI handling.  I don't see how it
>>>>>>>> would work on svm though - AFAICT the NMI is held whereas vmx
>>>>>>>> swallows it.
>>>>>>>>
>>>>>>>>     I guess NMIs
>>>>>>>> will be disabled until the next IRET so it isn't racy, just tricky.
>>>>>>>>                  
>>>>>>> I'm not sure if vmexit does break NMI context or not. Hardware NMI
>>>>>>> context isn't reentrant till a IRET. YangSheng would like to double
>>>>>>> check it.
>>>>>>>                
>>>>>> After more check, I think VMX won't remained NMI block state for
>>>>>> host. That's means, if NMI happened and processor is in VMX non-root
>>>>>> mode, it would only result in VMExit, with a reason indicate that
>>>>>> it's due to NMI happened, but no more state change in the host.
>>>>>>
>>>>>> So in that meaning, there _is_ a window between VMExit and KVM handle
>>>>>> the NMI. Moreover, I think we _can't_ stop the re-entrance of NMI
>>>>>> handling code because "int $2" don't have effect to block following
>>>>>> NMI.
>>>>>>
>>>>>> And if the NMI sequence is not important(I think so), then we need to
>>>>>> generate a real NMI in current vmexit-after code. Seems let APIC send
>>>>>> a NMI IPI to itself is a good idea.
>>>>>>
>>>>>> I am debugging a patch based on apic->send_IPI_self(NMI_VECTOR) to
>>>>>> replace "int $2". Something unexpected is happening...
>>>>>>              
>>>>> You can't use the APIC to send vectors 0x00-0x1f, or at least, aren't
>>>>> supposed to be able to.
>>>>>            
>>>> Um? Why?
>>>>
>>>> Especially kernel is already using it to deliver NMI.
>>>>          
>>> That's the only defined case, and it is defined because the vector field
>>> is ignore for DM_NMI.  Vol 3A (exact section numbers may vary depending
>>> on your version).
>>>
>>> 8.5.1 / 8.6.1
>>>
>>> '100 (NMI) Delivers an NMI interrupt to the target processor or
>>> processors.  The vector information is ignored'
>>>
>>> 8.5.2  Valid Interrupt Vectors
>>>
>>> 'Local and I/O APICs support 240 of these vectors (in the range of 16 to
>>> 255) as valid interrupts.'
>>>
>>> 8.8.4 Interrupt Acceptance for Fixed Interrupts
>>>
>>> '...; vectors 0 through 15 are reserved by the APIC (see also: Section
>>> 8.5.2, "Valid Interrupt Vectors")'
>>>
>>> So I misremembered, apparently you can deliver interrupts 0x10-0x1f, but
>>> vectors 0x00-0x0f are not valid to send via APIC or I/O APIC.
>>>        
>> As you pointed out, NMI is not "Fixed interrupt". If we want to send NMI,
>>   it would need a specific delivery mode rather than vector number.
>>
>> And if you look at code, if we specific NMI_VECTOR, the delivery mode would
>>   be set to NMI.
>>
>> So what's wrong here?
>>      
> OK, I think I understand your points now. You meant that these vectors can't
> be filled in vector field directly, right? But NMI is a exception due to
> DM_NMI. Is that your point? I think we agree on this.
>    

Yes, I think we agree.  NMI is the only vector in 0x0-0xf which can be 
sent via self-IPI because the vector itself does not matter for NMI.

Zach
