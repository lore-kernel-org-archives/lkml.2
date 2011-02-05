Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab1BEXjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 18:39:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:59217 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab1BEXjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 18:39:31 -0500
Subject: Re: Sun GEM PPC32 Bug?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "R. Herbst" <ruediger.herbst@googlemail.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Matt <jackdachef@gmail.com>, geert@linux-m68k.org
In-Reply-To: <4D4D9882.107@googlemail.com>
References: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>
	 <1296852667.2349.804.camel@pasglop>
	 <20110204.145508.59670453.davem@davemloft.net>
	 <4D4D9882.107@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 10:39:21 +1100
Message-ID: <1296949161.2349.839.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-05 at 19:35 +0100, R. Herbst wrote:
> > I think we're simply not resetting enough when the RX FIFO overflow
> > happens.
> >
> > Just for fun I checked the OpenBSD GEM driver to see what they do.
> > When an overflow occurs, they bump the statistic, record the current
> > read and write fifo pointer registers, and schedule a watchdog timer
> > for 400ms into the future.
> >
> > If the watchdog timer sees that the RX FIFO overflow bit is still set
> > in the RX status register, and the RX FIFO read and write pointers
> > have not changed, it resets the entire chip.
> >
> > We unconditionally reset the RX MAC when an overflow occurs, that may
> > simply not be enough to unwedge this thing. 

Right. It would be quite easy for us to do the same thing. Interestingly
enough, I have never observed this behaviour on any of my machines (a
wide range of 32-bit and 64-bit Apple machines).

Also, Apple's own driver does things differently. In case of overflow
interrupt, it seems to only bump some statistics. However, it has a
timeout if no packets have been received for a while (5 seconds) and the
Rx fifo overflow bit is set. In that case, they restart the receiver
(and the receiver only).

Their sequence for restarting the receiver however is a tad different
than ours (mostly slightly different ordering of things), it's hard to
tell whether that's relevant or not, but some of the things do make
sense, such as they stop the DMA before resetting the MAC and restart it
after re-enabling the MAC.

If I find some time tonight, else tomorrow, I'll whip up a couple of
patches:

 - One simpler re-arranging our Rx reset sequence and adding a test for
the overflow bit at the end, printing out the results, etc... 

 - One that basically always reset the chip on overflow.

>From there we can decide what works and maybe add a bit of a timeout
to the second approach if needed etc... but how often does that overflow
happens in practice ?

Cheers,
Ben.


