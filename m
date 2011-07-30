Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1G3GVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 02:21:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab1G3GVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 02:21:02 -0400
MIME-Version: 1.0
In-Reply-To: <1311974171.20898.393.camel@calx>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
 <1311971867-25124-2-git-send-email-hpa@linux.intel.com> <1311974171.20898.393.camel@calx>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Jul 2011 23:20:40 -0700
Message-ID: <CA+55aFwMGwVsD1Gexahio2pWd0PpaHAbvFroB3w0=JOQf1zQ_A@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: Matt Mackall <mpm@selenic.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 2:16 PM, Matt Mackall <mpm@selenic.com> wrote:
>
> I have already NAKed this approach in no uncertain terms.

Doesn't matter.

Talking about "standard hardware random number drivers" is just crazy
talk, when the instruction is a single instruction that takes tens of
nanoseconds to run. Any driver overhead would be just crazy, and no
user would ever want that anyway.

User space would never use it, because they just want to use the
instruction directly.

And kernel space doesn't want it either, for the exact same reason.
There's no point in making it anything but a simple direct function
call, because the whole functionality is so cheap.

This is not like some stupid "behind PCI" crap. It's high bandwidth
and low latency.

If anything, I think Peter's approach perhaps doesn't tie it in close
enough. Instead of making it some indirect function you register, just
make it an inline function per architecture that just returns how many
bits of randomness it gives (default to just an inline function that
returns 0 for the case of no on-CPU rng).

On x86, choice between the different possible random number generators
(if somebody cares enough about the cyrix and whatever ones) could be
a an asm_alternate() thing.

If you don't trust the CPU rng, don't bother with stupid arguments
about electron microscopes.  Test it - or more reasonably - make it
just one small part of the entropy pool. But don't make it something
heavy-weight, when the whole *point* of having the hardware is to make
it light-weight.

                 Linus
