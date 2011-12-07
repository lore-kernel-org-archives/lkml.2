Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1LGSKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:10:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44527 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab1LGSKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:10:18 -0500
MIME-Version: 1.0
In-Reply-To: <4EDFA9D6.5050907@zytor.com>
References: <20111207161256.GA7736@kroah.com> <20111207160824.268488820@clark.kroah.org>
 <CA+55aFwzdXwLJjUL_i247exawkzqdoCULXg81qzG4Ewn7ysn3A@mail.gmail.com> <4EDFA9D6.5050907@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Dec 2011 10:09:57 -0800
X-Google-Sender-Auth: w8ldTjFYWvj75hbAmVLZOyrAMMg
Message-ID: <CA+55aFxykes2Vk2YqGN=o=MkJukMBRcpQTN+tjmuTX_3xTstZA@mail.gmail.com>
Subject: Re: [20/80] ALSA: lx6464es - fix device communication via command bus
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Brian Gerst <brgerst@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Blechmann <tim@klingt.org>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 10:00 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I agree in principle, although I am really not happy about the idea of
> disallowing 64-bit writes from device drivers that haven't explicitly
> indicated they won't support it.

I'd really prefer going in the other direction. Especially since
64-bit writes would be optional *anyway* (ie impossible on 32-bit
hosts). So a driver should explicitly say "I can do 64-bit stuff"
rather than having to say "I cannot do it".

And if a driver *has* to have 64-bit accesses, it had better do them
all by hand, using "writeq()" and being dependent on the architecture
actually having that support. No "memcpy_toio" and friends at all.

So adding a "memcpy_toio64()" that defaults to the normal 32-bit max
but *might* do 64-bit copies sounds fine to me. But we really should
default to something that is consistent across architectures, and that
is not 64-bit accesses.

Old PCI setups actually had trouble with 64-bit accesses afaik, and
would literally get them wrong at a hardware level. I'm sure that's
not true of anything you can actually plug into a machine that
actually has a 64-bit x86 in it, but it's an example of actual
hardware limitations. I'm pretty sure there are 64-bit alpha machines
that are from that kind of timeframe, to give an example of a natively
64-bit architecture where a 64-bit write would simply not have worked
on a hardware level.

I'd suggest adding a architecture-neutral weak alias from
memcpy_toio64 to memcpy_toio (and other combinations), and then we can
independently start using it in drivers and/or start adding it in
various architectures. That automatically gives us the default
fallback for architectures that don't care or can't do it.

Hmm?

                     Linus
