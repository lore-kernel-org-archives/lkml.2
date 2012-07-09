Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab2GITQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:16:00 -0400
Received: from waste.org ([173.11.57.241]:47038 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab2GITP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:15:59 -0400
Message-ID: <1341861346.23136.69.camel@calx>
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
From: Matt Mackall <mpm@selenic.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Date: Mon, 09 Jul 2012 14:15:46 -0500
In-Reply-To: <20120706165257.GD10798@thunk.org>
References: <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
	 <1341524367.4020.1324.camel@calx>
	 <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
	 <20120705220040.GA15685@thunk.org>
	 <CA+55aFzFMZpiDMJO9UxoXSjOCzvxn7tgvmAHLM36OmaiMasQhw@mail.gmail.com>
	 <1341527482.4020.1355.camel@calx> <20120705232136.GD15685@thunk.org>
	 <CA+55aFxhobNMY5RLmH+tKox8voqfH-bVqKVF03JeeVrHkhLcaQ@mail.gmail.com>
	 <20120706130127.GB10798@thunk.org>
	 <CA+55aFw90o8btDJhztkS=2NXiZvXNAkCsZkx-p9+RRx-cMQc6A@mail.gmail.com>
	 <20120706165257.GD10798@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 12:52 -0400, Theodore Ts'o wrote:
> On Fri, Jul 06, 2012 at 09:24:00AM -0700, Linus Torvalds wrote:
> > On Fri, Jul 6, 2012 at 6:01 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > > What in the world is "fast count"?  I've grepped for it,
> > > and I can't find it.
> > 
> > It's your own fast-pool counter that Matt was talking about.
> 
> When he said "check it against HZ", it confused me, since there's no
> way to compare it against HZ.  But yes, I can certainly not give any
> credit for entropy if __IRQF_TIMER is set, or keep track of whether
> the previous interrupt had __IRQF_TIMER set in its descriptor.  That's
> simple enough.
> 
> I thought he was saying there was some way to distinguish between
> interrupts triggered by the clock interrupt versus other devices on
> the same irq channel --- and I couldn't figure out any to do that in
> an architecture independent way.

Sorry.. offline for the weekend.

Let me restate:

- on some architectures, we will call into the RNG on timer interrupts
- this is generally desirable, as most time sources are asynchronous to
sched_clock() and thus a source of entropy
- we also want to keep conditional checks like IRQF_TIMER off the fast
path
- but on systems where the timer interrupt is the primary time source,
we may get effectively no entropy when the system is quiescent
- so we should check the fast pool count against HZ before crediting
- but even then, we still should mix the fast pool

Something like:

add_some_randomness(...) /* always mix */
if (fast_pool->count > HZ) {
  fast_pool->count = 0;
  credit_entropy_pool(...); /* only credit when we've got > HZ events */
}

That should be safe on all systems.

-- 
Mathematics is the supreme nostalgia of our time.


