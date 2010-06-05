Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab0FEArT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 20:47:19 -0400
Received: from crca.org.au ([74.207.252.120]:53996 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389Ab0FEArS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 20:47:18 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C099E8C.7070302@crca.org.au>
Date: Sat, 05 Jun 2010 10:47:08 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [SUSPECTED SPAM] Re: [linux-pm] Proposal for a new algorithm
 for reading & writing a hibernation image.
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>	 <1275694775.3853.29.camel@maxim-laptop>  <4C09930E.20306@crca.org.au> <1275698169.10045.8.camel@maxim-laptop>
In-Reply-To: <1275698169.10045.8.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 05/06/10 10:36, Maxim Levitsky wrote:
> On Sat, 2010-06-05 at 09:58 +1000, Nigel Cunningham wrote:
>> On 05/06/10 09:39, Maxim Levitsky wrote:
>>> On Thu, 2010-06-03 at 16:50 +0200, Pavel Machek wrote:
>>>> "Nigel Cunningham"<ncunningham@crca.org.au>   wrote:
>>>>> On 30/05/10 15:25, Pavel Machek wrote:
>>>>>> Hi!
>>>>>>
>>>>>>> 2. Prior to writing any of the image, also set up new 4k page tables
>>>>>>> such that an attempt to make a change to any of the pages we're about to
>>>>>>> write to disk will result in a page fault, giving us an opportunity to
>>>>>>> flag the page as needing an atomic copy later. Once this is done, write
>>>>>>> protection for the page can be disabled and the write that caused the
>>>>>>> fault allowed to proceed.
>>>>>>
>>>>>> Tricky.
>>>>>>
>>>>>> page faulting code touches memory, too...
>>>>>
>>>>> Yeah. I realise we'd need to make the pages that are used to record the
>>>>> faults be unprotected themselves. I'm imagining a bitmap for that.
>>>>>
>>>>> Do you see any reason that it could be inherently impossible? That's
>>>>> what I really want to know before (potentially) wasting time trying it.
>>>>
>>>> I'm not sure it is impossible, but it certainly seems way too complex to be
>>>> practical.
>>>>
>>>> 2mb pages will probably present a problem, as will bat mappings on powerpc.
>>>
>>>
>>> Some time ago, after tuxonce caused medium fs corruption twice on my
>>> root filesystem (superblock gone for example), I was thinking too about
>>> how to make it safe to save whole memory.
>>
>> I'd be asking why you got the corruption. On the odd occasion where it
>> has been reported, it's usually been because the person didn't set up
>> their initramfs correctly (resumed after mounting filesystems). Is there
>> any chance that you did that?
>>
>>> Your tuxonice is so fast that it resembles suspend to ram.
>>
>> That depends on hard drive speed and CPU speed. I've just gotten a new
>> SSD drive, and can understand your statement now, but I wouldn't have
>> said the same beforehand.
> Nope, I have a slow laptop drive.

Oh, okay. Not much ram then? I would have thought that in most cases - 
and especially with a slow laptop drive - suspend to ram would be waaay 
faster. Ah well, there is a huge variation in specs.

>>> I have radically different proposal.
>>>
>>>
>>> Lets create a kind of self-contained very small operation system that
>>> will know to do just one thing, write the memory to disk.
>>>>  From now on I am calling this OS, a suspend module.
>>> Physically its code can be contained in linux kernel, or loaded as a
>>> module.
>>>
>>>
>>> Let see how things will work first:
>>>
>>> 1. Linux loads the suspend module to memory (if it is inside kernel
>>> image, that becomes unnecessary)
>>>
>>> At that point, its even possible to add some user plug-ins to that
>>> module for example to draw splash screen. Of course all such plug-ins
>>> must be root approved.
>>>
>>>
>>> 2. Linux turns off all devices, but hard disk.
>>> Drivers for hard drives will register for this exception.
>>>
>>>
>>> 3. Linux creates a list of memory areas to save (or exclude from save,
>>> doesn't matter)
>>>
>>> 4. Linux creates a list of hard disk sectors that will contain the
>>> image.
>>> This ensures support for swap partition and swap files as well.
>>>
>>> 5. Linux allocates small 'scratch space'
>>> Of course if memory is very tight, some swapping can happen, but that
>>> isn't significant.
>>>
>>>
>>> 6. Linux creates new page tables that cover: the suspend module, both of
>>> above lists, scratch space, and (optionally) the framebuffer RW,
>>> and rest of memory RO.
>>>
>>> 7. Linux switches to new page table, and passes control to that module.
>>> Even if the module wanted to it won't be able to change system memory.
>>> It won't even know how to do so.
>>>
>>> 8. Module optionally encrypts and/or compresses (and saves result to
>>> scratch page)
>>>
>>> 9. Module uses very simplified disk drivers to write the memory to disk.
>>> These drivers can even omit using interrupts because there is nothing
>>> else to do.
>>> It can also draw progress bar on framebuffer using optional plugin
>>>
>>> 10. Module passes control back to linux, which just shuts system off.
>>
>> Sounds a lot like kexec based hibernation that was suggested a year or
>> two back. Have you thought about resuming, too? That's the trickier part
>> of the process.
> Why its tricky?
>
> We can just reseve say 25 MB of memory and make resuming kernel only use
> it for all its needs.

Well, I suppose in this scenario, you can do it all atomically. I was 
thinking of where we do a two-part restore (still trying to maximise 
image size, but without a separate kernel).

>>> Now what code will be in the module:
>>>
>>> 1. Optional compression&   encryption - easy
>>> 2. Draw modules, also optional and easy
>>>
>>>
>>> 3. New disk drivers.
>>> This is the hard part, but if we cover libata and ahci, we will cover
>>> the common case.
>>> Other cases can be handled by existing code that saved 1/2 of ram.
>>
>> To my mind, supporting only some hardware isn't an option.
>
>
>>
>>> 4. Arch specific code. Since it doesn't deal with interrupts nor memory
>>> managment, it won't be lot of code.
>>> Again standard swsusp can be used for arches that that module wasn't
>>> ported to.
>>
>> Perhaps I'm being a pessimist, but it sounds to me like this is going to
>> be a way bigger project than you're allowing for.
> I also thinks so. This is just an idea.
>
>
> To add a comment on your idea.
>
> I think is is possible to use page faults to see which memory regions
> changed. Actually its is very interesting idea.
>
> You just need to install your own page fault handler, and make sure it
> doesn't touch any memory.

If the memory it writes to isn't protected, there'll be no recursive 
page fault and no problem, right? I'm imagining this page fault handler 
will only set a flag to record that the page needs to be atomically 
copied, copy the original contents to a page previously prepared for the 
purpose, remove the write protection for the page and allow the write to 
continue. That should be okay, right?

> Of course the sucky part will be how to edit the page tables.
> You might need to write your own code to do so to be sure.
> And this has to be arch specific.

Yeah. I wondered whether the code that's already used for creating page 
tables for the atomic restore could be reused, at least in part.

> Since userspace is frozen, you can be sure that faults can only be
> caused by access to WO memory or kernel bugs.

Userspace helpers or uswsusp shouldn't be forgotten.

Regards,

Nigel
