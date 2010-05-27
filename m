Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab0E0VCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:02:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759066Ab0E0VCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:02:38 -0400
Message-ID: <4BFEDDEB.9020700@redhat.com>
Date: Thu, 27 May 2010 11:02:35 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
References: <1274897088-8587-1-git-send-email-glommer@redhat.com> <4BFE2A2F.50209@redhat.com> <20100527160248.GF3445@mothafucka.localdomain> <4BFED258.40501@redhat.com> <20100527203638.GH3445@mothafucka.localdomain>
In-Reply-To: <20100527203638.GH3445@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 10:36 AM, Glauber Costa wrote:
> On Thu, May 27, 2010 at 10:13:12AM -1000, Zachary Amsden wrote:
>    
>> On 05/27/2010 06:02 AM, Glauber Costa wrote:
>>      
>>> On Thu, May 27, 2010 at 11:15:43AM +0300, Avi Kivity wrote:
>>>        
>>>> On 05/26/2010 09:04 PM, Glauber Costa wrote:
>>>>          
>>>>> This patch adds a file that documents the usage of KVM-specific
>>>>> MSRs.
>>>>>
>>>>>            
>>>> Looks good.  A few comments:
>>>>
>>>>          
>>>>> +
>>>>> +Custom MSR list
>>>>> +--------
>>>>> +
>>>>> +The current supported Custom MSR list is:
>>>>> +
>>>>> +MSR_KVM_WALL_CLOCK:  0x11
>>>>> +
>>>>> +	data: physical address of a memory area.
>>>>>            
>>>> Which must be in guest RAM (i.e., don't point it somewhere random
>>>> and expect the hypervisor to allocate it for you).
>>>>
>>>> Must be aligned to 4 bytes (we don't enforce it though).
>>>>          
>>> I don't see the reason for it.
>>>
>>> If this is a requirement, our own implementation
>>> is failing to meet it.
>>>        
>> It's so the atomic write actually is atomic.
>>      
> Which atomic write? This is the wallclock, we do no atomic writes for
> querying it. Not to confuse with system time (the other msr).
>
>    
>> Stating a 4 -byte
>> alignment requirement prevents the wall clock from crossing a page
>> boundary.
>>      
> Yes, but why require it?
>
> reading the wallclock is not a hot path for anybody, is usually done
> just once, and crossing a page boundary here does not pose any correctness
> issue.
>    

Little-endian non-atomic page crossing writes will write the small part 
of the wallclock first, so another CPU may observe the following 
wallclock sequence:

0x01ff .. 0x0100 .. 0x0200

Big-endian writes also have similar failure:

0x01ff .. 0x02ff .. 0x0200

This won't happen if there is a single instruction write of the wall 
clock word.
