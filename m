Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1LHHzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:55:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44227 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1LHHzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:55:18 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwzdXwLJjUL_i247exawkzqdoCULXg81qzG4Ewn7ysn3A@mail.gmail.com>
References: <20111207161256.GA7736@kroah.com>
	<20111207160824.268488820@clark.kroah.org>
	<CA+55aFwzdXwLJjUL_i247exawkzqdoCULXg81qzG4Ewn7ysn3A@mail.gmail.com>
Date: Thu, 8 Dec 2011 02:55:16 -0500
Message-ID: <CAMzpN2jiZn3=Og9EVhnWbEhZkvi6eebEJpR7qYn00OyJnZgcFQ@mail.gmail.com>
Subject: Re: [20/80] ALSA: lx6464es - fix device communication via command bus
From: Brian Gerst <brgerst@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Blechmann <tim@klingt.org>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 12:47 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Dec 7, 2011 at 8:06 AM, Greg KH <gregkh@suse.de> wrote:
>>
>> From: Tim Blechmann <tim@klingt.org>
>>
>> commit a29878553a9a7b4c06f93c7e383527cf014d4ceb upstream.
>>
>> commit 6175ddf06b6172046a329e3abfd9c901a43efd2e optimized the mem*io
>> functions that have been used to send commands to the device. these
>> optimizations somehow corrupted the communication with the lx6464es,
>> that resulted the device to be unusable with kernels after 2.6.33.
>
> Uhhuh. Looking at this, I understand why the driver can't really use
> memcpy_toio/fromio any more, and I never noticed this problem because
> it was worked around in drivers instead (or being discussed elsewhere
> and I just overlooked it)
>
> That commit (6175ddf06b61) is really bad and buggy. It probably wasn't
> horribly bad back when it was done, but it's getting increasingly bad
> as we change how "memcpy()" works.

When I originally wrote that patch, I didn't take into consideration
how the devices would react to the change (mostly due to 64-bit
writes).  What I meant by "nothing special" is that from the CPU
standpoint, nothing has to be done with regard to the address space or
cache coherency, unlike with some other arches.  Unfortunately too
many drivers make the assumption that accesses are 32-bit max, because
it "just worked" on 32-bit machines.

> For example, memcpy some day will be just "rep movsb" on newer CPU's
> ("enhanced fast string memcpy"), which can be optimal for memory. But
> it is completely unacceptable for IO devices, so saying that "Iomem
> has no special significance on x86" is just total crap.
>
> iomem can work with regular accessors, yes, but it still has
> significance even on x86: iomem is *not* RAM.
>
> And using memcpy() is wrong, wrong, wrong. It's wrong even aside from
> any future "rep movsb" issues - it's already wrong due to the crazy
> "optimized x86 memcpy" that works around Atom crap. Copying stuff
> backwards is not what memcpy_toio/fromio is supposed to do, partly
> because it can confuse devices, but partly simply because it can
> easily destroy things like PCI bursting etc. I also would not be
> totally shocked to hear that some devices dislike 8-byte writes.
>
> So I understand why the driver works around the issue, but I think the
> real fix is to undo much of that broken commit in the first place.
>
> So we should probably make memcpy_fromio/toio do the
> "__inline_memcpy()" loop that we used to use: "rep movsl" followed by
> conditional movsw/movsb. No, it's not necessarily optimal, but it's
> *safe*, and it's quite likely *more* optimal than memcpy that may well
> end up doing it a byte at a time!
>
> So I think we should just re-instate "arch/x86/lib/io.c, copy the
> "inline_memcpy" thing in there, and add a similar "rep stosl" version
> for the "memset_io()". IOW, undo most of 6175ddf06b61, just make it
> use the same code for 32-bit and 64-bit.

I am working on a patch implementing this, using simple string
instructions without the micro-optimizations that the normal mem*
functions have.

--
Brian Gerst
