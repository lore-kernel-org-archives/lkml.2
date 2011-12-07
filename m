Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab1LGRsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:48:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43404 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab1LGRsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:48:15 -0500
MIME-Version: 1.0
In-Reply-To: <20111207160824.268488820@clark.kroah.org>
References: <20111207161256.GA7736@kroah.com> <20111207160824.268488820@clark.kroah.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Dec 2011 09:47:52 -0800
X-Google-Sender-Auth: 1wFbw7K_sAJ8Inm6EwgK3UG91K0
Message-ID: <CA+55aFwzdXwLJjUL_i247exawkzqdoCULXg81qzG4Ewn7ysn3A@mail.gmail.com>
Subject: Re: [20/80] ALSA: lx6464es - fix device communication via command bus
To: Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Blechmann <tim@klingt.org>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 8:06 AM, Greg KH <gregkh@suse.de> wrote:
>
> From: Tim Blechmann <tim@klingt.org>
>
> commit a29878553a9a7b4c06f93c7e383527cf014d4ceb upstream.
>
> commit 6175ddf06b6172046a329e3abfd9c901a43efd2e optimized the mem*io
> functions that have been used to send commands to the device. these
> optimizations somehow corrupted the communication with the lx6464es,
> that resulted the device to be unusable with kernels after 2.6.33.

Uhhuh. Looking at this, I understand why the driver can't really use
memcpy_toio/fromio any more, and I never noticed this problem because
it was worked around in drivers instead (or being discussed elsewhere
and I just overlooked it)

That commit (6175ddf06b61) is really bad and buggy. It probably wasn't
horribly bad back when it was done, but it's getting increasingly bad
as we change how "memcpy()" works.

For example, memcpy some day will be just "rep movsb" on newer CPU's
("enhanced fast string memcpy"), which can be optimal for memory. But
it is completely unacceptable for IO devices, so saying that "Iomem
has no special significance on x86" is just total crap.

iomem can work with regular accessors, yes, but it still has
significance even on x86: iomem is *not* RAM.

And using memcpy() is wrong, wrong, wrong. It's wrong even aside from
any future "rep movsb" issues - it's already wrong due to the crazy
"optimized x86 memcpy" that works around Atom crap. Copying stuff
backwards is not what memcpy_toio/fromio is supposed to do, partly
because it can confuse devices, but partly simply because it can
easily destroy things like PCI bursting etc. I also would not be
totally shocked to hear that some devices dislike 8-byte writes.

So I understand why the driver works around the issue, but I think the
real fix is to undo much of that broken commit in the first place.

So we should probably make memcpy_fromio/toio do the
"__inline_memcpy()" loop that we used to use: "rep movsl" followed by
conditional movsw/movsb. No, it's not necessarily optimal, but it's
*safe*, and it's quite likely *more* optimal than memcpy that may well
end up doing it a byte at a time!

So I think we should just re-instate "arch/x86/lib/io.c, copy the
"inline_memcpy" thing in there, and add a similar "rep stosl" version
for the "memset_io()". IOW, undo most of 6175ddf06b61, just make it
use the same code for 32-bit and 64-bit.

Ingo, Peter, Thomas? Comments?

                                 Linus
