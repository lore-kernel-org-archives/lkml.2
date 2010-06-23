Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0FWWEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:04:44 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:51956 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0FWWEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:04:42 -0400
Date: Thu, 24 Jun 2010 00:04:40 +0200
From: Andreas Mohr <andi@lisas.de>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, sboyd@codeaurora.org, tglx@linutronix.de,
       mingo@elte.hu, heiko.carstens@de.ibm.com, eranian@google.com,
       schwidefsky@de.ibm.com, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC] [PATCH] timer: Added usleep[_range][_interruptable] timer
Message-ID: <20100623220440.GA17840@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1277326605.15159.70.camel@c-dwalke-linux.qualcomm.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you need to do some more research on what your actually doing to
> the system. From what your showing us one could make a lot of different
> arguments as to what this change will actually do. You really need some
> sort of test that doesn't leave a lot of room for argument.

I think the underlying issue he's having is that the timer APIs are simply
unadapted, they're awkward to use.

>From a driver POV, there really isn't much that you'd really CARE ABOUT
when entering any delay.

All you care about is to get a reliable delay, with the following characteristics:
- requested delay value
- wakeup spread (do I need this with hawk-eye precision, or is it ok if
wakeup is in the next century)
- something else? (perhaps "I need a warm/cold cache"?)

Whether this is preemptable, yieldable, power-managementable or entirely switch-offable
is ENTIRELY FRIGGIN' UNIMPORTANT to a driver, in most cases - it DOES NOT CARE about it.
The driver tells the OS what kind of delay characteristics it needs,
and it's the _OSes_ job to always do the most of that, be that a correspondingly deep
power management idle mode or whatever (one could argue that it should even know
on its own whether a critical section has to be obeyed or not, i.e. whether it's
preemptable or not).

This is just what a _minimal_, perfectly _adapted_ function interface should be.
And I'm afraid the kernel is somewhat off in that regard (mdelay, msleep, udelay,
... OH MY), which likely is why such discussions come up.

And if someone then says "but udelay is a tiny optimized function which is much faster
than some generic interface which would first need to execute a half-dozen branches
to figure out what mode exactly to choose", I say "to hell with it",
let's do the precisely right thing as fast as possible and not the sometimes right thing
perfectly fast (not to mention that always entering via the same central function
might have additional icache benefits, too).

Whether a particular environment is able to support useful power management quantities
in ms, us or even ns should never be a driver's job to worry about,
it should simply pass its requirements to the kernel and that's it.
Such orders of magnitude easily change over time given hardware's progress -
a well-designed, minimal kernel interface however probably won't need to.

Frankly this is just my feeling, I don't have any precise insight into these APIs,
thus I might be way off as to the complications of this and be talking out of my a... :)

Andreas Mohr
