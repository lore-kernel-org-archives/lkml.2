Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab0HUAw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 20:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab0HUAw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 20:52:57 -0400
Message-ID: <4C6F235D.5040100@redhat.com>
Date: Fri, 20 Aug 2010 14:52:45 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 17/35] Implement getnsboottime kernel API
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>	 <1282291669-25709-18-git-send-email-zamsden@redhat.com>	 <1282329594.3302.39.camel@localhost.localdomain>	 <4C6F11D6.1050101@redhat.com> <1282348958.28794.21.camel@localhost.localdomain>
In-Reply-To: <1282348958.28794.21.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 02:02 PM, john stultz wrote:
> On Fri, 2010-08-20 at 13:37 -1000, Zachary Amsden wrote:
>    
>> On 08/20/2010 08:39 AM, john stultz wrote:
>>      
>>> On Thu, 2010-08-19 at 22:07 -1000, Zachary Amsden wrote:
>>>
>>>        
>>>> Add a kernel call to get the number of nanoseconds since boot.  This
>>>> is generally useful enough to make it a generic call.
>>>>
>>>>          
>>> Few comments here.
>>>
>>>
>>>        
>>>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>>> ---
>>>>    include/linux/time.h      |    1 +
>>>>    kernel/time/timekeeping.c |   27 +++++++++++++++++++++++++++
>>>>    2 files changed, 28 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/include/linux/time.h b/include/linux/time.h
>>>> index ea3559f..5d04108 100644
>>>> --- a/include/linux/time.h
>>>> +++ b/include/linux/time.h
>>>> @@ -145,6 +145,7 @@ extern void getnstimeofday(struct timespec *tv);
>>>>    extern void getrawmonotonic(struct timespec *ts);
>>>>    extern void getboottime(struct timespec *ts);
>>>>    extern void monotonic_to_bootbased(struct timespec *ts);
>>>> +extern s64 getnsboottime(void);
>>>>
>>>>          
>>> So instead of converting the timespec from getboottime, why did you add
>>> a new interface? Also if not a timespec, why did you pick a s64 instead
>>> of a ktime_t?
>>>
>>>        
>> The new interface was suggested several times, so I'm proposing it.  I'm
>> indifferent to putting it the kernel API or making it internal to KVM.
>> KVM doesn't want to deal with conversions to / from ktime_t; this code
>> uses a lot (too much) math, and it's easy to get wrong when splitting
>> sec / nsec fields.  So s64 seems a natural type for ns values.  I
>> realize it's not entirely consistent with the kernel API, but s64
>> representation for ns seems to be creeping in.
>>      
> I can understand wanting that, way back I was pushing for s64 ns
> representations for most time values, but the ktime_t was considered a
> reasonable compromise to avoid costly 64bit divides to split (sec,nsec)
> on 32bit arches.
>    

We want time in simply parseable formats, so we always end up with sec / 
msec, sec / usec, sec / nsec.  This is simply a convenient 
representation for humans.  Programmers always end up copying this model 
and it causes so many lovely bugs.  How many times can you race while 
reading CMOS Y/M/D/H/S?

Fortunately now that 64-bit computing is nearly pervasive, we can make 
most of these problems go away.

I think gettimefromboot_ns() is a good descriptive name, but slightly 
too long - it would ruin my indentation.  Perhaps getrealtime_ns()?

Zach
