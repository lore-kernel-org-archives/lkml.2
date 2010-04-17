Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0DQSNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 14:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0DQSNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 14:13:11 -0400
Message-ID: <4BC9FA19.2070602@redhat.com>
Date: Sat, 17 Apr 2010 21:12:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Joerg Roedel <joro@8bytes.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest  os
 statistics from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <20100415104051.GC12697@8bytes.org> <4BC6EDFF.3000702@redhat.com> <201004152208.08409.sheng@linux.intel.com>
In-Reply-To: <201004152208.08409.sheng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 05:08 PM, Sheng Yang wrote:
> On Thursday 15 April 2010 18:44:15 Avi Kivity wrote:
>    
>> On 04/15/2010 01:40 PM, Joerg Roedel wrote:
>>      
>>>> That means an NMI that happens outside guest code (for example, in the
>>>> mmu, or during the exit itself) would be counted as if in guest code.
>>>>          
>>> Hmm, true. The same is true for an NMI that happens between VMSAVE and
>>> STGI but that window is smaller. Anyway, I think we don't need the
>>> busy-wait loop. The NMI should be executed at a well defined point and
>>> we set the cpu_var back to NULL after that point.
>>>        
>> The point is not well defined.  Considering there are already at least
>> two implementations svm, I don't want to rely on implementation details.
>>      
> After more investigating, I realized that I had interpreted the SDM wrong.
> Sorry.
>
> There is *no* risk with the original method of calling "int $2".
>
> According to the SDM 24.1:
>
>    
>> The following bullets detail when architectural state is and is not updated
>>      
> in response to VM exits:
> [...]
>    
>> - An NMI causes subsequent NMIs to be blocked, but only after the VM exit
>>      
> completes.
>
> So the truth is, after NMI directly caused VMExit, the following NMIs would be
> blocked, until encountered next "iret". So execute "int $2" is safe in
> vmx_complete_interrupts(), no risk in causing nested NMI. And it would unblock
> the following NMIs as well due to "iret" it executed.
>
> So there is unnecessary to make change to avoid "potential nested NMI".
>    

Let's look at the surrounding text...

>
> The following bullets detail when architectural state is and is not 
> updated in response
> to VM exits:
> •   If an event causes a VM exit directly, it does not update 
> architectural state as it
>     would have if it had it not caused the VM exit:
>     — A debug exception does not update DR6, DR7.GD, or IA32_DEBUGCTL.LBR.
>         (Information about the nature of the debug exception is saved 
> in the exit
>         qualification field.)
>     — A page fault does not update CR2. (The linear address causing 
> the page fault
>         is saved in the exit-qualification field.)
>     — An NMI causes subsequent NMIs to be blocked, but only after the 
> VM exit
>         completes.
>     — An external interrupt does not acknowledge the interrupt 
> controller and the
>         interrupt remains pending, unless the “acknowledge interrupt 
> on exit”
>         VM-exit control is 1. In such a case, the interrupt controller 
> is acknowledged
>         and the interrupt is no longer pending.


Everywhere it says state is _not_ updated, so I think what is meant is 
that NMIs are blocked, but only _until_ the VM exit completes.

I think you were right the first time around.  Can you check with your 
architecture team?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

