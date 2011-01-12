Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1ALQYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:24:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41166 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1ALQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:24:15 -0500
Date: Wed, 12 Jan 2011 16:23:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Alexander Holler <holler@ahsoftware.de>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: ARM: relocation out of range (when loading a module)
Message-ID: <20110112162308.GC11039@n2100.arm.linux.org.uk>
References: <4D2B4CE4.9080309@ahsoftware.de> <alpine.LFD.2.00.1101101722470.9794@xanadu.home> <4D2BFA08.5030104@ahsoftware.de> <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com> <20110111155930.GH11039@n2100.arm.linux.org.uk> <4D2D1942.4050905@ahsoftware.de> <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 10:05:19AM -0600, Dave Martin wrote:
> In general, do we expect always to be able to avoid the situation
> where branches in the kernel may need to cover too large a range ...
> and is there any strategy for working aroung it?

It's not that big a problem - 99.999999% of setups never run into the
problem.  It's only those who use large initramfs's built into their
kernel image at present, and that is ultimately solvable.

I don't think we need to litter code with TODO comments.

> If we have problems branching from the modules area into vmlinux, we
> could possibly build modules with -fPIC : this would remove the
> restriction on branch range, though there would also be some
> performance impact for the modules...

That also brings in issues with GOT tables and the like, and also requires
different build options for modules and the main kernel.  I don't think
kbuild is setup to do that - and I'd argue that it's unnecessary if we
fix the layout of the kernel image.

As I said a few emails ago, shuffling sections around in the image is
not as trivial as it looks on the face of it as we make assumptions
about what is in _stext.._etext, _sdata.._edata, whether there's anything
between _etext.._sdata, and other symbolic ranges.

At the moment, _stext.._etext + _sdata.._edata covers the entire kernel
image - with the init sections at the start of _stext.  Putting the init
sections between _etext and _sdata makes a hole in the middle of that,
which may be suboptimal for page allocation.  It also means that the
range no longer covers all kernel stuff.  Also whether _stext = _text,
_sdata = _data, etc.

Another technicality is that some of these ranges are used for stuff like
DMA API debugging:

        if (overlap(addr, len, _text, _etext) ||
            overlap(addr, len, __start_rodata, __end_rodata))
                err_printk(dev, NULL, "DMA-API: device driver maps memory from kernel text or rodata [addr=%p] [len=%lu]\n", addr, len);

The last pieces of the puzzle is whether we have anything that implicitly
relies on the init section being low down and freeing its pages (eg, as
a way of stopping that memory being used for non-DMA stuff.)

I do have a patch which shuffles some of this stuff around, but I'm not
entirely happy with it yet.

