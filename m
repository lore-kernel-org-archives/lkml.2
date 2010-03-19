Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0CSBGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 21:06:36 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41232 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0CSBGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 21:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Ki2x1XrDLDIYtGKacLUOpVmSPSpods8mvyP2kAR9QB4ld6laqciHqJVbWBU9aiKOp5
         3kABLuQXSOiBYsmTRZe+FiTB+wezn+X1Wko9EWh8bf6ZFja0Qi09qkbs4ZaUtDfPgO96
         GqQ4CLSmLrzw5s2kmAiCZQr10Xzfnkbx1JGwc=
MIME-Version: 1.0
In-Reply-To: <49f90a801003181747m5078d9c2y3cc8421203a7b1e6@mail.gmail.com>
References: <21512362.post@talk.nabble.com> <3e8340490901162016y268e3936k4b2d3fcb2afcf216@mail.gmail.com> 
	<21512985.post@talk.nabble.com> <3e8340490901162126u109da9cbu7292fddf6d832723@mail.gmail.com> 
	<49f90a801003181710v5e08ccc8jdd26ec899e75bdb9@mail.gmail.com> 
	<3e8340491003181728r766245edo91ecc1db75f3a6df@mail.gmail.com> 
	<49f90a801003181747m5078d9c2y3cc8421203a7b1e6@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 18 Mar 2010 21:06:12 -0400
Message-ID: <3e8340491003181806t201218acod8ea408d1993cbfc@mail.gmail.com>
Subject: Re: Kernel vs user memory
To: Siddhartha Chhabra <siddhartha.chhabra@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 20:47, Siddhartha Chhabra
<siddhartha.chhabra@gmail.com> wrote:
> On Thu, Mar 18, 2010 at 8:28 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
>>
>> > If the kernel's doing a copy_from_user or copy_to_user family of calls
>> > (ie, the calls used in system call handlers when accessing user space
>> > buffers referenced in the arguments), this will trigger a page fault
>> > exactly like the userspace process would, and the PF handler will then
>> > deal with any copy on write or whatever may be needed. Of course, if a
>> > userspace access wouldn't trigger a PF, the kernel access won't
>> > either.
>>
>> > For the actual copy-on-write process itself, it would be a Bad Thing
>> > to trigger a recursive page fault, so instead the kernel will directly
>> > access the page via the direct mapped section of the address space -
>> > this will never cause a PF (on x86, this may require creating a
>> > temporary mapping for memory at a high physical address, but this
>> > still won't be a PF as it will be set up before the first access).
>> > Additionally, memory mapped IO involves direct DMA to/from pages that
>> > are simultaneously in use by userspace - this won't cause a PF in
>> > kernel mode either. Same with swap.
>>
>> > In short, some kernel accesses to user space do go through normal
>> > channels which may or may not PF; other accesses will never PF. So
>> > it's a bad idea to rely on all kernel accesses triggering a page
>> > fault.
>
>
>>
>> > Hope this helps,
>>
>> > Bryan
>
> In other words, without tying the kernel access to any specific operation
> (like COW, or copy-from/to-user, DMA, Memory mapped IO etc.), is it safe to
> say that a possibly compromised kernel wanting to read application's pages
> can do so without mapping the page to its address space, that is, without
> resulting in a page fault in the kernel mode on an attempt to access a page
> ?
>
> For example:
>
> Lets say for App A frame 5 on physical memory is mapped to its address space
> and its currently using it. The OS does a context switch, however, A's
> frames are still in the main memory. Now can the OS read these page frames
> (frame 5 in main memory) without mapping them to its address space, maybe
> just to read the application's contents and send it out to a potential
> attacker wanting to compromise the system's security ?

That is correct. The kernel can avoid a PF if it wants to by ensuring
the page tables are set up properly from the start; and physical
addresses below a certain value (which varies by architecture) can be
accessed directly without any setup at all.
