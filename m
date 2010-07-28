Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0G1P54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:57:56 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:35534 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab0G1P5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:57:54 -0400
Message-ID: <4C50536A.1090205@linux.vnet.ibm.com>
Date: Wed, 28 Jul 2010 17:57:30 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Karol Lewandowski <k.lewandowsk@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: GCOV doesn't seem to work on ARM with kernel 2.6.35-rc6
References: <4C4D6458.6040402@samsung.com> <4C4D6554.30707@samsung.com> <4C4DBE8E.70102@linux.vnet.ibm.com> <4C4E8C2C.3000903@samsung.com> <4C502CC5.7070205@linux.vnet.ibm.com> <4C50342F.2080001@samsung.local>
In-Reply-To: <4C50342F.2080001@samsung.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.07.2010 15:44, Karol Lewandowski wrote:
> On 07/28/2010 03:12 PM, Peter Oberparleiter wrote:
>> On 27.07.2010 09:35, Karol Lewandowski wrote:
>>> On 07/26/2010 06:57 PM, Peter Oberparleiter wrote:
>>>> Karol Lewandowski wrote:
>>>>> On 07/26/2010 12:32 PM, Karol Lewandowski wrote:
>>>>>> I'm trying to use code coverage measurements with mainline Linux
>>>>>> kernel
>>>>>> 2.6.35-rc6 on ARM platform (specifically on Samsung's S5PC110 board).
>>> ...
>>>> I just tested gcov support for 2.6.35-rc6 on s390 and it works without
>>>> a problem. My assumption would be that you are using an EABI-GCC to
>>>> compile your kernel. Those compilers name their constructor symbols
>>>
>>> Exactly.
>>>
>>>> differently than the vanilla GCC so that the whole constructor calling
>>>> mechanism on which the gcov support relies, will fail. If that is
>>>> indeed the case, the following testing patch should solve your
>>>> problem:
>>>
>>> Yes, that was the case and your patch indeed solved my problem.
>>
>> Excellent. I could imagine that other ARM users might also benefit from
>> this patch. Before I submit it for integration though, I need to make
>> sure that it also works for kernel modules. Could you enable profiling
>> for a kernel module and verify that you are seeing files in
>> /sys/kernel/debug/gcov belonging to that module??
>
> That does work too.
>
> However, having seen this[x] patch I would ask if constructor name might
> be dynamically selected via user-(in)visible Kconfig option (like in
> that patch?) I've tested it and it does seem to work too.
>
> [x]
> http://groups.google.com/group/linux.kernel/browse_thread/thread/84439151c5386e0f/d7dbec62b9d7989f?show_docid=d7dbec62b9d7989f
>
>
> I've copy pasted interesting parts from that patch below - I'm sure you
> get the idea.
>
> Thanks.
>
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -442,7 +442,7 @@
> #ifdef CONFIG_CONSTRUCTORS
> #define KERNEL_CTORS() . = ALIGN(8); \
> VMLINUX_SYMBOL(__ctors_start) = .; \
> - *(.ctors) \
> + *(CONFIG_GCOV_CTORS) \

This should be named differently - gcov uses constructors but this 
doesn't mean that constructors rely on gcov at all.

> --- a/kernel/gcov/Kconfig
> +++ b/kernel/gcov/Kconfig
> +config GCOV_CTORS
> + string
> + depends on GCOV_KERNEL
> + default ".init_array" if ARM && AEABI
> + default ".ctors"

Is it guaranteed that gcc will only create EABI compliant object files 
if CONFIG_AEABI is defined? I don't have personal experience with arm so 
my previous assumption was that if you're using an EABI gcc, you would 
always get EABI object code, no matter what the compiler options were.

>
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2296,7 +2296,7 @@ static noinline struct module *load_module(void
> __user *umod,
> "__kcrctab_unused_gpl");
> #endif
> #ifdef CONFIG_CONSTRUCTORS
> - mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
> + mod->ctors = section_objs(hdr, sechdrs, secstrings, CONFIG_GCOV_CTORS,
> sizeof(*mod->ctors), &mod->num_ctors);



Regards,
   Peter Oberparleiter

