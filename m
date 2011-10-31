Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1JaJDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:03:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54107 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:03:49 -0400
Message-ID: <4EAE630A.6040309@gmail.com>
Date: Mon, 31 Oct 2011 09:57:46 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, msb@chromium.org,
        seiji.aguchi@hds.com
Subject: Re: [PATCH] ramoops appears geared to not support ARM
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org>	<4EAC0C18.5090602@gmail.com>	<CAEYUcX1PUgniJLqYXKM5pf_9T06OPFg4q0ZUCFc8Deu1J_R9-A@mail.gmail.com>	<4EAD360D.6010004@gmail.com> <CAEYUcX2yF1hw=D8XHMGE7p4Tty+G-vmVudNsFHXUOSTGGKoq=w@mail.gmail.com>
In-Reply-To: <CAEYUcX2yF1hw=D8XHMGE7p4Tty+G-vmVudNsFHXUOSTGGKoq=w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/10/2011 07:03, Bryan Freed ha scritto:
> On Sun, Oct 30, 2011 at 4:33 AM, Marco Stornelli
> <marco.stornelli@gmail.com>  wrote:
>>
>> Il 30/10/2011 03:07, Bryan Freed ha scritto:
>>>
>>> Right, and that is what I do to get ARM working.  The reserve() function
>>> calls memblock_reserve() to reserve the memory for RAMOOPS.  Keeping it
>>> part of main memory (by not using memblock_remove()) gets the memory
>>> properly mapped.
>>>
>>
>> According to Russell, it needs to use memblock_remove to exclude that piece of memory.
>>
>>> The problem I think we need to resolve is that this makes the ramoops
>>> driver messy.
>>
>> I agree. Indeed I think we don't need to do anything in the driver. The problem is only how to exclude a piece of memory from kernel main memory view. For x86 it's trivial, for ARM it doesn't, but it's still possible.
>>
>> Marco
>
> I will give that (using mem_remove()) a shot tomorrow.
> My recollection on using it in last week's investigation showed the
> ramoops driver ioremap() giving a mapping that did not correspond with
> what the /dev/mem expected to see.  I vaguely recall /dev/mem was
> effectively calling __va(0x02000000) which added a base address of
> 0xc0000000 giving 0xc2000000 as the resulting virtual address.  The
> ramoops ioremap(), however, gave some arbitrary virtual address for
> this memory.
> The result was that using /dev/mem to read 0x02000000 caused a panic.

I don't understand this point. We have different virtual addresses and 
then? The linear transformation with a fixed offset is the normal way 
for the kernel to have a virtual address from a physical one when you 
are using a memory address directly mapped. The virtual address returned 
by ioremap it can be an address not directly mapped, I mean it isn't a 
simple linear transformation of the physical address used in input.
It isn't normal to have a kernel panic, even if there is something 
wrong, you should receive EINVAL or something similar.

>
> Another problem was that removing just 512KiB of memory for ramoops
> screwed up the system memory initialization.  It appeared to me that
> the ARM memory code expected sections to be 1MiB aligned.  I could
> memblock_reserve anything, but I could only memblock_remove on a 1MiB
> boundary.
>

It's an arch problem not related to the driver.

> And I cannot shake the feeling that we have a fairly simple disconnect
> here.  Ramoops expects to use _device_ memory because it uses
> ioremap().  But the buffer itself is accessed through /dev/mem which
> (as we use it with no mmap() calls) expects to give access to _system_

no mmap calls?! I don't understand how you are using /dev/mem.

Marco
