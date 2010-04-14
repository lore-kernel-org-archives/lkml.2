Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0DNJ6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:58:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab0DNJ6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:58:06 -0400
Message-ID: <4BC5919E.1010400@redhat.com>
Date: Wed, 14 Apr 2010 12:57:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os statistics
 from host side
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com> <4BC588CF.5010507@redhat.com> <201004141743.32393.sheng@linux.intel.com>
In-Reply-To: <201004141743.32393.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 12:43 PM, Sheng Yang wrote:
> On Wednesday 14 April 2010 17:20:15 Avi Kivity wrote:
>    
>> On 04/14/2030 12:05 PM, Zhang, Yanmin wrote:
>>      
>>> Here is the new patch of V3 against tip/master of April 13th
>>> if anyone wants to try it.
>>>        
>> Thanks for persisting despite the flames.
>>
>> Can you please separate arch/x86/kvm part of the patch?  That will make
>> for easier reviewing, and will need to go through separate trees.
>>
>> Sheng, did you make any progress with the NMI injection issue?
>>      
> Yes, though some other works interrupt me lately...
>
> The very first version has issue due to SELF_IPI mode can't be used to send
> NMI according to SDM. That's the reason why x2apic don't have way to do this.
>    

Yes, I see that now.  Looks like others have the same questions...

> But later I found another issue of fail to inspect inside the guest. I think
> it's due to NMI is asynchronous event, though it should be triggered very
> quickly, you can't guarantee that the handler would be triggered before the
> state(current_vcpu) is cleared with current code.
>
> Maybe just extended the "guest state" region would be fine, if the latency is
> stable enough(though I think it maybe platform depended). I am working on this
> now.
>    

I wouldn't like to depend on model specific behaviour.

One option is to read all the information synchronously and store it in 
a per-cpu area with atomic instructions, then queue the NMI.  Another 
option is to have another callback which tells us that the NMI is done, 
and have a busy loop wait until the NMI is delivered.

-- 
error compiling committee.c: too many arguments to function

