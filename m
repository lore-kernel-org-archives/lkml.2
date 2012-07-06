Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2GFQYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:24:23 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50042 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab2GFQYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120706130127.GB10798@thunk.org>
References: <1341511933-11169-2-git-send-email-tytso@mit.edu>
 <1341514078.4020.1213.camel@calx> <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
 <1341524367.4020.1324.camel@calx> <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
 <20120705220040.GA15685@thunk.org> <CA+55aFzFMZpiDMJO9UxoXSjOCzvxn7tgvmAHLM36OmaiMasQhw@mail.gmail.com>
 <1341527482.4020.1355.camel@calx> <20120705232136.GD15685@thunk.org>
 <CA+55aFxhobNMY5RLmH+tKox8voqfH-bVqKVF03JeeVrHkhLcaQ@mail.gmail.com> <20120706130127.GB10798@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jul 2012 09:24:00 -0700
X-Google-Sender-Auth: D-EJecDs7AFTKwEcFa91rdAjjtE
Message-ID: <CA+55aFw90o8btDJhztkS=2NXiZvXNAkCsZkx-p9+RRx-cMQc6A@mail.gmail.com>
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 6:01 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> What in the world is "fast count"?  I've grepped for it,
> and I can't find it.

It's your own fast-pool counter that Matt was talking about.

> I can simply not credit entropy of the timer is on the irq, but I
> think you and Matt were suggesting more subtle.  I just have no idea
> how to tell if there were non-timer interrupts during the last HZ
> cycle.  Can you give me a hint?

So instead of not calling the add_interrupt_randomness() at all if the
__IRQF_TIMER bit was set, just pass it in as an argument. That way you
can still use the cycle counter for mixing stuff, but the random.c
code could at least (perhaps in the future) decide that if all it has
seen is timer interrupts, and get_cycles() always returns zero (no
cycle counter), we won't count it as entropy.

At least with no-HZ there's still going to be *some* data there
because you won't get called for every tick, so things like random app
timers etc will affect even the timer interrupt distribution, but...

                Linus
