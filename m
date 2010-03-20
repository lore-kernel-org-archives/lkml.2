Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab0CTL6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:58:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:56104 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0CTL6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:58:36 -0400
Subject: Re: [PATCH] MTD: Fix Orion NAND driver compilation with ARM OABI
From: David Woodhouse <dwmw2@infradead.org>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>, nico@cam.org,
       rth@twiddle.net
Cc: nico@fluxnic.net, akpm@linux-foundation.org,
       u.kleine-koenig@pengutronix.de, simon.kagstrom@netinsight.net,
       linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <badfd5ba1003200420xc0680c1h8b4cccd02a8fdaba@mail.gmail.com>
References: <20100320085507.4038.96426.stgit@pauliusz>
	 <1269078083.4028.5586.camel@macbook.infradead.org>
	 <badfd5ba1003200420xc0680c1h8b4cccd02a8fdaba@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 11:58:06 +0000
Message-ID: <1269086286.4028.6039.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 13:20 +0200, Paulius Zaleckas wrote:
> On Sat, Mar 20, 2010 at 11:41 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> > On Sat, 2010-03-20 at 10:55 +0200, Paulius Zaleckas wrote:
> >> -             uint64_t x;
> >> +             /*
> >> +              * force x variable to r2/r3 registers since ldrd instruction
> >> +              * requires first register to be even.
> >> +              */
> >> +             register uint64_t x asm ("r2");
> >> +
> >>               asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
> >
> > Hm, isn't there an asm constraint which will force it into an
> > appropriate register pair?
> 
> Not that I know of...
> 
> > Failing that, "=&r2,r4,r6,r8" ought to work.
> 
> No, fails with error: matching constraint not valid in output operand

Hm, crap -- GCC on ARM doesn't let you give specific registers, so that
trick doesn't work.

Strictly speaking, I think your version is wrong -- although you force
the variable 'x' to be stored in r2/r3, you don't actually force GCC to
use r2/r3 as the output registers for the asm statement -- it could
happily use other registers, then move their contents into r2/r3
afterwards.

Obviously it _won't_ do that most of the time, but it _could_. GCC PR
#15089 was filed for the fact that sometimes it does, but I think Nico
was missing the point -- GCC is _allowed_ to do that, and if it makes
you sad then you should be asking for better assembly constraints which
would allow you to tell it not to.

See the __asmeq() macro in <asm/system.h> for a dirty hack which will
check which registers are used and abort at compile time, although your
compilation is going to fail anyway so I'm not sure it makes much of a
difference in this particular case.

The real fix here is to add an asm constraint to GCC which allows you to
specify "any even GPR" (or whatever's most suitable for the ldrd
instruction). Being able to give specific registers, like you can on
other architectures, would be useful too.

Please file a PR, then resubmit your patch with a comment explaining
that the code is known to be broken because GCC doesn't allow you to do
any better, and containing a reference to your PR. If people copy your
code, I want them to at least know that they're propagating a bug.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

