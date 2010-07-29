Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0G2QZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:25:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27941 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab0G2QZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:25:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Date: Thu, 29 Jul 2010 18:25:35 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: GCOV doesn't seem to work on ARM with kernel 2.6.35-rc6
In-reply-to: <4C50536A.1090205@linux.vnet.ibm.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gdavis@mvista.com
Message-id: <4C51AB7F.70805@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10)
 Gecko/20100620 Icedove/3.0.5
References: <4C4D6458.6040402@samsung.com> <4C4D6554.30707@samsung.com>
 <4C4DBE8E.70102@linux.vnet.ibm.com> <4C4E8C2C.3000903@samsung.com>
 <4C502CC5.7070205@linux.vnet.ibm.com> <4C50342F.2080001@samsung.local>
 <4C50536A.1090205@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 05:57 PM, Peter Oberparleiter wrote:
> On 28.07.2010 15:44, Karol Lewandowski wrote:
>> On 07/28/2010 03:12 PM, Peter Oberparleiter wrote:
>>> On 27.07.2010 09:35, Karol Lewandowski wrote:
>>>> On 07/26/2010 06:57 PM, Peter Oberparleiter wrote:
>>>>> Karol Lewandowski wrote:
>>>>>> On 07/26/2010 12:32 PM, Karol Lewandowski wrote:
>>>>>>> I'm trying to use code coverage measurements with mainline Linux
>>>>>>> kernel
>>>>>>> 2.6.35-rc6 on ARM platform (specifically on Samsung's S5PC110
>>>>>>> board).
>>>> ...
>>>>> I just tested gcov support for 2.6.35-rc6 on s390 and it works without
>>>>> a problem. My assumption would be that you are using an EABI-GCC to
>>>>> compile your kernel. Those compilers name their constructor symbols
>>>>
>>>> Exactly.
>>>>
>>>>> differently than the vanilla GCC so that the whole constructor calling
>>>>> mechanism on which the gcov support relies, will fail. If that is
>>>>> indeed the case, the following testing patch should solve your
>>>>> problem:
>>>>
>>>> Yes, that was the case and your patch indeed solved my problem.
>>>
>>> Excellent. I could imagine that other ARM users might also benefit from
>>> this patch. Before I submit it for integration though, I need to make
>>> sure that it also works for kernel modules. Could you enable profiling
>>> for a kernel module and verify that you are seeing files in
>>> /sys/kernel/debug/gcov belonging to that module??
>>
>> That does work too.
>>
>> However, having seen this[x] patch I would ask if constructor name might
>> be dynamically selected via user-(in)visible Kconfig option (like in
>> that patch?) I've tested it and it does seem to work too.
>>
>> [x]
>> http://groups.google.com/group/linux.kernel/browse_thread/thread/84439151c5386e0f/d7dbec62b9d7989f?show_docid=d7dbec62b9d7989f
>>
>>
>>
>> I've copy pasted interesting parts from that patch below - I'm sure you
>> get the idea.
>>
>> Thanks.
>>
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -442,7 +442,7 @@
>> #ifdef CONFIG_CONSTRUCTORS
>> #define KERNEL_CTORS() . = ALIGN(8); \
>> VMLINUX_SYMBOL(__ctors_start) = .; \
>> - *(.ctors) \
>> + *(CONFIG_GCOV_CTORS) \
>
> This should be named differently - gcov uses constructors but this
> doesn't mean that constructors rely on gcov at all.
>
>> --- a/kernel/gcov/Kconfig
>> +++ b/kernel/gcov/Kconfig
>> +config GCOV_CTORS
>> + string
>> + depends on GCOV_KERNEL
>> + default ".init_array" if ARM && AEABI
>> + default ".ctors"
>
> Is it guaranteed that gcc will only create EABI compliant object files
> if CONFIG_AEABI is defined? I don't have personal experience with arm so
> my previous assumption was that if you're using an EABI gcc, you would
> always get EABI object code, no matter what the compiler options were.

Honestly - I don't know.  Maybe George - author of cited patch could 
explain this?  (CC added).

Thanks.
