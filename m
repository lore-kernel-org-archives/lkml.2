Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0CQVP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0CQVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:15:27 -0400
Message-ID: <4BA1464C.2020507@redhat.com>
Date: Wed, 17 Mar 2010 11:14:52 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       "Huang, Zhiteng" <zhiteng.huang@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <1268717232.2813.36.camel@localhost> <4B9F5021.3080206@redhat.com> <1268793273.2813.70.camel@localhost> <201003171728.43739.sheng@linux.intel.com>
In-Reply-To: <201003171728.43739.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 11:28 PM, Sheng Yang wrote:
> On Wednesday 17 March 2010 10:34:33 Zhang, Yanmin wrote:
>    
>> On Tue, 2010-03-16 at 11:32 +0200, Avi Kivity wrote:
>>      
>>> On 03/16/2010 09:48 AM, Zhang, Yanmin wrote:
>>>        
>>>> Right, but there is a scope between kvm_guest_enter and really running
>>>> in guest os, where a perf event might overflow. Anyway, the scope is
>>>> very narrow, I will change it to use flag PF_VCPU.
>>>>          
>>> There is also a window between setting the flag and calling 'int $2'
>>> where an NMI might happen and be accounted incorrectly.
>>>
>>> Perhaps separate the 'int $2' into a direct call into perf and another
>>> call for the rest of NMI handling.  I don't see how it would work on svm
>>> though - AFAICT the NMI is held whereas vmx swallows it.
>>>
>>>   I guess NMIs
>>> will be disabled until the next IRET so it isn't racy, just tricky.
>>>        
>> I'm not sure if vmexit does break NMI context or not. Hardware NMI context
>> isn't reentrant till a IRET. YangSheng would like to double check it.
>>      
> After more check, I think VMX won't remained NMI block state for host. That's
> means, if NMI happened and processor is in VMX non-root mode, it would only
> result in VMExit, with a reason indicate that it's due to NMI happened, but no
> more state change in the host.
>
> So in that meaning, there _is_ a window between VMExit and KVM handle the NMI.
> Moreover, I think we _can't_ stop the re-entrance of NMI handling code because
> "int $2" don't have effect to block following NMI.
>
> And if the NMI sequence is not important(I think so), then we need to generate
> a real NMI in current vmexit-after code. Seems let APIC send a NMI IPI to
> itself is a good idea.
>
> I am debugging a patch based on apic->send_IPI_self(NMI_VECTOR) to replace
> "int $2". Something unexpected is happening...
>    

You can't use the APIC to send vectors 0x00-0x1f, or at least, aren't 
supposed to be able to.

Zach
