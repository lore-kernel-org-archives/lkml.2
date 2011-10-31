Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934787Ab1JaXDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:03:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59458 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704Ab1JaXDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <4EAE630A.6040309@gmail.com>
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org>
	<4EAC0C18.5090602@gmail.com>
	<CAEYUcX1PUgniJLqYXKM5pf_9T06OPFg4q0ZUCFc8Deu1J_R9-A@mail.gmail.com>
	<4EAD360D.6010004@gmail.com>
	<CAEYUcX2yF1hw=D8XHMGE7p4Tty+G-vmVudNsFHXUOSTGGKoq=w@mail.gmail.com>
	<4EAE630A.6040309@gmail.com>
Date: Mon, 31 Oct 2011 16:03:32 -0700
X-Google-Sender-Auth: NPKHFb1XrPlj0GD28ZU37KZh1Xo
Message-ID: <CAEYUcX3dzG_DCBSj570qGoeM00NhjCBHLS7sLKvDw2jvUJnjVg@mail.gmail.com>
Subject: Re: [PATCH] ramoops appears geared to not support ARM
From: Bryan Freed <bfreed@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, msb@chromium.org,
        seiji.aguchi@hds.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 1:57 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Il 31/10/2011 07:03, Bryan Freed ha scritto:
>>
>> On Sun, Oct 30, 2011 at 4:33 AM, Marco Stornelli
>> <marco.stornelli@gmail.com>  wrote:
>>>
>>> Il 30/10/2011 03:07, Bryan Freed ha scritto:
>>>>
>>>> Right, and that is what I do to get ARM working.  The reserve() function
>>>> calls memblock_reserve() to reserve the memory for RAMOOPS.  Keeping it
>>>> part of main memory (by not using memblock_remove()) gets the memory
>>>> properly mapped.
>>>>
>>>
>>> According to Russell, it needs to use memblock_remove to exclude that
>>> piece of memory.
>>>
>>>> The problem I think we need to resolve is that this makes the ramoops
>>>> driver messy.
>>>
>>> I agree. Indeed I think we don't need to do anything in the driver. The
>>> problem is only how to exclude a piece of memory from kernel main memory
>>> view. For x86 it's trivial, for ARM it doesn't, but it's still possible.
>>>
>>> Marco
>>
>> I will give that (using mem_remove()) a shot tomorrow.
>> My recollection on using it in last week's investigation showed the
>> ramoops driver ioremap() giving a mapping that did not correspond with
>> what the /dev/mem expected to see.  I vaguely recall /dev/mem was
>> effectively calling __va(0x02000000) which added a base address of
>> 0xc0000000 giving 0xc2000000 as the resulting virtual address.  The
>> ramoops ioremap(), however, gave some arbitrary virtual address for
>> this memory.
>> The result was that using /dev/mem to read 0x02000000 caused a panic.
>
> I don't understand this point. We have different virtual addresses and then?

Yes, we get different virtual addresses.
The /dev/mem xlate_dev_mem_ptr() is defined (for ARM) as __va(), so it
gives 0xc2000000.
The ramoops ioremap() gives 0xef90000 because
__arm_ioremap_pfn_caller() makes a fresh get_vm_area_caller() call.

On x86, the /dev/mem xlate_dev_mem_ptr() gives an ioremap_cache()
address rather than a __va() address because it (properly?) detects
the memory is not RAM (because it was reserved by BIOS, so it was not
configured with system memory).

> The linear transformation with a fixed offset is the normal way for the
> kernel to have a virtual address from a physical one when you are using a
> memory address directly mapped. The virtual address returned by ioremap it
> can be an address not directly mapped, I mean it isn't a simple linear
> transformation of the physical address used in input.

Right, that is what I see on the ARM side as well.
__arm_ioremap_pfn_caller() gets a virtual address with
get_vm_area_caller().

> It isn't normal to have a kernel panic, even if there is something wrong,
> you should receive EINVAL or something similar.

Yeah, /dev/mem will give an EFAULT on ARM if (addr + count >
__pa(high_memory)).  But we are not beyond the end of our physical
memory.  We are somewhere in the middle.  So read_mem() gets the
virtual address with xlate_dev_mem_ptr() which on ARM is just __va().
If this memory is memblock_removed, then that virtual address is not mapped.

Now that I look closer, we use copy_to_user().  So we should be
catching this fault.
I will take a closer look at this.
Either way, /dev/mem will not give us proper access to the ARM ramoops buffer.

>
>>
>> Another problem was that removing just 512KiB of memory for ramoops
>> screwed up the system memory initialization.  It appeared to me that
>> the ARM memory code expected sections to be 1MiB aligned.  I could
>> memblock_reserve anything, but I could only memblock_remove on a 1MiB
>> boundary.
>>
>
> It's an arch problem not related to the driver.

Yes, that is an arch problem.  But it is another reason to move away
from memblock_remove() and toward memblock_reserve().

>> And I cannot shake the feeling that we have a fairly simple disconnect
>> here.  Ramoops expects to use _device_ memory because it uses
>> ioremap().  But the buffer itself is accessed through /dev/mem which
>> (as we use it with no mmap() calls) expects to give access to _system_
>
> no mmap calls?! I don't understand how you are using /dev/mem.

open(), lseek(), read().  No mmap is required for RAM, right?
dd if=/dev/mem bs=1 count=1000 skip=32M

My point above about the disconnect between system memory and device
memory would be resolved if ramoops provided its own access to the
buffer.  What do you think of that idea?

bryan.

> Marco
>
