Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0HCJNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:13:07 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:36414 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab0HCJNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:13:04 -0400
Message-ID: <4C57DD6F.1010004@linux.vnet.ibm.com>
Date: Tue, 03 Aug 2010 11:12:15 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: "George G. Davis" <gdavis@mvista.com>
CC: Karol Lewandowski <k.lewandowsk@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: GCOV doesn't seem to work on ARM with kernel 2.6.35-rc6
References: <4C4D6458.6040402@samsung.com> <4C4D6554.30707@samsung.com> <4C4DBE8E.70102@linux.vnet.ibm.com> <4C4E8C2C.3000903@samsung.com> <4C502CC5.7070205@linux.vnet.ibm.com> <4C50342F.2080001@samsung.local> <4C50536A.1090205@linux.vnet.ibm.com> <4C51AB7F.70805@samsung.com> <20100803052051.GA17719@mvista.com>
In-Reply-To: <20100803052051.GA17719@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.08.2010 07:20, George G. Davis wrote:
> On Thu, Jul 29, 2010 at 06:25:35PM +0200, Karol Lewandowski wrote:
>> On 07/28/2010 05:57 PM, Peter Oberparleiter wrote:
>>> On 28.07.2010 15:44, Karol Lewandowski wrote:
>>>> On 07/28/2010 03:12 PM, Peter Oberparleiter wrote:
>>>>> On 27.07.2010 09:35, Karol Lewandowski wrote:
>>>>>> On 07/26/2010 06:57 PM, Peter Oberparleiter wrote:
>>>>>>> Karol Lewandowski wrote:
>>>>>>>> On 07/26/2010 12:32 PM, Karol Lewandowski wrote:
>>>>>>>>> I'm trying to use code coverage measurements with mainline Linux
>>>>>>>>> kernel
>>>>>>>>> 2.6.35-rc6 on ARM platform (specifically on Samsung's S5PC110
>>>>>>>>> board).
>>>>>> ...
>>>>>>> I just tested gcov support for 2.6.35-rc6 on s390 and it works without
>>>>>>> a problem. My assumption would be that you are using an EABI-GCC to
>>>>>>> compile your kernel. Those compilers name their constructor symbols
>>>>>>
>>>>>> Exactly.
>>>>>>
>>>>>>> differently than the vanilla GCC so that the whole constructor calling
>>>>>>> mechanism on which the gcov support relies, will fail. If that is
>>>>>>> indeed the case, the following testing patch should solve your
>>>>>>> problem:
>>>>>>
>>>>>> Yes, that was the case and your patch indeed solved my problem.
>>>>>
>>>>> Excellent. I could imagine that other ARM users might also benefit from
>>>>> this patch. Before I submit it for integration though, I need to make
>>>>> sure that it also works for kernel modules. Could you enable profiling
>>>>> for a kernel module and verify that you are seeing files in
>>>>> /sys/kernel/debug/gcov belonging to that module??
>>>>
>>>> That does work too.
>>>>
>>>> However, having seen this[x] patch I would ask if constructor name might
>>>> be dynamically selected via user-(in)visible Kconfig option (like in
>>>> that patch?) I've tested it and it does seem to work too.
>>>>
>>>> [x]
>>>> http://groups.google.com/group/linux.kernel/browse_thread/thread/84439151c5386e0f/d7dbec62b9d7989f?show_docid=d7dbec62b9d7989f
>>>>
>>>>
>>>>
>>>> I've copy pasted interesting parts from that patch below - I'm sure you
>>>> get the idea.
>>>>
>>>> Thanks.
>>>>
>>>> --- a/include/asm-generic/vmlinux.lds.h
>>>> +++ b/include/asm-generic/vmlinux.lds.h
>>>> @@ -442,7 +442,7 @@
>>>> #ifdef CONFIG_CONSTRUCTORS
>>>> #define KERNEL_CTORS() . = ALIGN(8); \
>>>> VMLINUX_SYMBOL(__ctors_start) = .; \
>>>> - *(.ctors) \
>>>> + *(CONFIG_GCOV_CTORS) \
>>>
>>> This should be named differently - gcov uses constructors but this
>>> doesn't mean that constructors rely on gcov at all.
>
> I actually changed that patch [x] long ago relative to the above but
> haven't gotten around to following up with a new version and no one
> has been anxious to reply about it since anyway.  ; )

I wasn't aware of the patch until now or I would have replied.

>  The original
> version of [x] had a GCOV_CTORS depends on GCOV_KERNEL bug where
> GCOV_KERNEL could be disabled resulting in a CONSTRUCTORS build
> error due to undefined GCOV_CTORS.  A new version of [x] is
> attached below.
>
>>>
>>>> --- a/kernel/gcov/Kconfig
>>>> +++ b/kernel/gcov/Kconfig
>>>> +config GCOV_CTORS
>>>> + string
>>>> + depends on GCOV_KERNEL
>>>> + default ".init_array" if ARM&&  AEABI
>>>> + default ".ctors"
>>>
>>> Is it guaranteed that gcc will only create EABI compliant object files
>>> if CONFIG_AEABI is defined? I don't have personal experience with arm so
>>> my previous assumption was that if you're using an EABI gcc, you would
>>> always get EABI object code, no matter what the compiler options were.
>>
>> Honestly - I don't know.  Maybe George - author of cited patch could
>> explain this?  (CC added).
>
> Yes that is correct.

Ok, that makes things easier. Your patch looks good to me, but it needs 
to be split into two parts:
1. kernel: constructor support for ARM EABI compilers
2. gcov: enable GCOV_PROFILE_ALL for arm

For both, it would be great if you could provide a good explanation of 
what the changes do and why they are needed for arm. For 1, it's 
obvious, but the author of the original arm-hack patches wasn't too 
clear about those points for 2.

Also, when you re-post these patches, please add the following people to 
cc (in addition to the current cc list):

1. For the constructor change:
Rusty Russell <rusty@rustcorp.com.au> (for module comments)
Sam Ravnborg <sam@ravnborg.org> (for kbuild comnents)
Michal Marek <mmarek@suse.cz> (for kbuild comments)
Andrew Morton <akpm@linux-foundation.org> (hopefully for integration)

2. For the gcov-arm change:
Andrew Morton <akpm@linux-foundation.org>


Regards,
   Peter

