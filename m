Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1BKJbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 04:31:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41476 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1BKJbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 04:31:07 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1102101405010.14920@xanadu.home>
References: <4D2BFA08.5030104@ahsoftware.de>
	<AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com>
	<20110111155930.GH11039@n2100.arm.linux.org.uk>
	<4D2D1942.4050905@ahsoftware.de>
	<AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com>
	<alpine.LFD.2.00.1101121314470.25498@xanadu.home>
	<20110112184258.GH11039@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1101121350350.25498@xanadu.home>
	<AANLkTikLwTdV2B5Dyp_adCxgWcE-+Wb6uiN5MBfnA1_K@mail.gmail.com>
	<alpine.LFD.2.00.1101270030220.8580@xanadu.home>
	<20110210154322.GE1742@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1102101405010.14920@xanadu.home>
Date: Fri, 11 Feb 2011 09:31:04 +0000
Message-ID: <AANLkTi=KtFf5BU-iH-sUUL=Q30S90bk608JR4zFz2CKf@mail.gmail.com>
Subject: Re: ARM: relocation out of range (when loading a module)
From: Dave Martin <dave.martin@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sachin Verma <imschnvrm@gmail.com>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        catalin.marinas@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 7:41 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Thu, 10 Feb 2011, Russell King - ARM Linux wrote:
>
>> On Thu, Jan 27, 2011 at 12:43:54AM -0500, Nicolas Pitre wrote:
>> > The MMU-less kernel should still favor allocations close to the kernel
>> > text for modules, and anything else away from the kernel going
>> > downwards.
>> >
>> > Otherwise a veneer should be created by the module symbol resolver such
>> > that if the branch distance to reach, say, printk is too large, then the
>> > following code would have to be dynamically generated right next to the
>> > module:
>> >
>> >     ldr     pc, [pc, #-4]
>> >     .word   <far_away_symbol>
>> >
>> > Then, in your module, you patch the branch relocation for printk so that
>> > it branches to the code above instead, and then store the address of
>> > printk at the location represented by the .word directive.
>>
>> What you're suggesting is what we used to do with the old user-space
>> module tools, which would've been nice to carry forwards to the new
>> module code.  I never found a way to do it.
>>
>> The problems:
>> 1. Where do you create those veneers?
>> 2. How many veneers do you allocate space for?
>> 3. How do you determine that you need a veneer?
>>
>> While you can say "next to the module" for (1), you can only do that at
>> the point in time when the space for the module is allocated, and you
>> need to know at that point how much space you require.
>
> You would have to guess of course.  Having a guess of 1/2 the module
> size should be pretty safe.  So allocating 3/2 the space in
> module_alloc(), and then suffice to free the unused portion in
> module_finalize().
>
>> For (2), you could always allocate space for one veneer per symbol present
>> in the module, but that's very wasteful.
>>
>> (3) is almost impossible to know ahead of time as you don't have the
>> relocations, realistically you have to allocate one veneer per symbol,
>> and as you don't know whether it's a data or code symbol, you'll have
>> to allocate one veneer for every symbol in a module.
>
> I don't think you may know the number of symbols in advance either
> anyway.

You could probably cook up a good upper bound based on the size of the
kernel and the number of symbols in the module: i.e., assume that
every undefined symbol in the module needs to be fixed up to point at
the most distant symbol in the kernel.

For people with normal-sized kernels, this bound will probably work
out as zero most of the time (i.e., the current situation).  For
people with big kernels, or when many modules are already loaded, it
may work out at 100% -- but that's the price to pay for guaranteed
preallocation of the space required for the veneers.  And anyway, you
may really need a substantial chunk of those veneers in such cases.

---Dave
