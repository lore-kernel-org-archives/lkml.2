Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1LSUyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:54:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46503 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1LSUy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:54:29 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] MXS: Convert mutexes in clock.c to spinlocks
Date: Mon, 19 Dec 2011 21:54:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Shawn Guo <shawn.guo@freescale.com>, Wolfgang Denk <wd@denx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Stefano Babic <sbabic@denx.de>
References: <1324217174-6574-1-git-send-email-marek.vasut@gmail.com> <201112191257.06145.marek.vasut@gmail.com> <20111219121559.GF14542@n2100.arm.linux.org.uk>
In-Reply-To: <20111219121559.GF14542@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112192154.25310.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 19, 2011 at 12:57:05PM +0100, Marek Vasut wrote:
> > > There is another solution to this, which I've pointed out before when
> > > this has come up:
> > > 
> > > 1. Convert all your drivers to _also_ use
> > > clk_prepare()/clk_unprepare().
> > > 
> > >    You need to do this anyway as it will become mandatory for the
> > >    common clk stuff.
> > > 
> > > 2. Rename your existing clk_enable()/clk_disable() implementation to
> > > 
> > >    clk_prepare()/clk_unprepare().  Ensure CONFIG_HAVE_CLK_PREPARE is
> > >    selected.
> > > 
> > > 3. Provide a new no-op clk_enable()/clk_disable() functions.
> > 
> > Well, I'm still unsure how'd you then enable/disable the clock ?
> > clk_prepare/clk_unprepare is good, but how would that help in avoiding
> > the mutex/spinlock?
> 
> Then, quite simply, you don't understand clk_prepare/clk_unprepare.
> 
> Lets go back to the original discussion.  We have two classes of
> implementations of the clk API:
> 
> 1. We have those where clk_enable() and clk_disable() can be called from
>    any context.
> 
> 2. We have those where clk_enable() and clk_disable() can only be called
>    from process context.

Yes, that's the MXS clock case and that's where it gets broken.
> 
> Then we have drivers - some of which call clk_enable() and clk_disable()
> from atomic contexts.

OK

> 
> Obviously, this situation can't be unified as is, because the different
> requirements of the implementations and drivers are such that it's
> impossible to have a single implementation which works across the board.
> 
> So, to allow a single implementation to proceed, it was decided that we'd
> split clk_enable() and clk_disable() into two parts - an atomic part and
> a non-atomic part.
> 
> The atomic part keeps the clk_enable() and clk_disable() name.  The
> non-atomic part gets the new clk_prepare() and clk_unprepare() name.

Ok, understood so far.
> 
> Drivers must respect the following sequence throughout their code:
> 
> 	clk = clk_get();
> 	clk_prepare(clk);
> 	clk_enable(clk);
> 
> 	clk_disable(clk);
> 	clk_unprepare(clk);
> 	clk_put(clk);
> 
> In other words, it is _illegal_ for any driver to enable a clock which
> they have not _themselves_ prepared - in the same way that it is illegal
> to call clk_enable() on a clk that they have already put.
> 
> Drivers which only enable/disable their clocks from process context would
> pair the clk_prepare()+clk_enable() calls together, and the clk_disable()+
> clk_unprepare() calls.

I see ... so basically, the locking will happen in clk_prepare() call.
> 
> Drivers which enable/disable their clocks from atomic contexts must ensure
> that a clk is already prepared in some process context prior to calling
> clk_enable() - as it is not permitted to call clk_prepare() from atomic
> contexts.
> 
> For the PL011 UART, this means that:
> 
> 1. Clocks are prepared when the port is opened _or_ when the console is
>    configured.

Ok, so here I either lock or lock-configure-unlock ... which one is it ?
> 
> 2. Clocks are enabled when the port is opened _or_ when there is a message
>    to output through the console.

But to enable the clock, I need to lock again. Or I can lock in prepare() call, 
but then the locking is meaningless because the lock'd be held all this time and 
noone else would be able to operate with the MXS clock.
> 
> 3. Clocks are disabled when the port is closed _or_ when the console output
>    has finished.
> 
> 4. Clocks are unprepared when the port is closed.
> 
> This means that if you are capable of _only _process-context based clock
> handing, and you use this driver, your clock will be enabled for the
> console port at boot time and _never_ turned off.  That's the penalty
> you _have_ to pay to satisfy the conditions imposed by your implementation.

My implementation ... of what? Clock framework or the driver? Why would the 
spinlock be bad for this case -- only because it'd be held for too long ?

The implementation of clk_enable/clk_disable for mxs is -- from my understanding 
-- really fast:

spinlock_lock()
increase usecount
enable/disable clock by doing RMW of one bit on one register
spinlock_unlock()

And this can be made even faster via MXS hardware specifics (like bitwise-set 
registers, avoiding the RMW).

> 
> So, there are two solutions:
> 
> 1. Fix your clk API implementation such that clk_enable/clk_disable() are
>    callable from atomic contexts.

Yea ... the spinlock is IMO reasonable, I see no problem with that, the code 
path is really fast. It can be made even faster I think.
> 
> 2. Fix your clk API to rename the non-atomic clk_enable/clk_disable() to
>    clk_prepare/clk_unprepare() and provide dummy clk_enable/clk_disable().

I don't see a point in this, this'd add way more overhead and overcomplicate the 
whole stuff.
> 
> 'Fixing' the driver is not an option - and would be just a case of moving
> the existing clk_enable/clk_disable calls to where the clk_prepare/
> clk_unprepare calls currently are - crippling those implementations which
> are good citizens.

Indeed.
> 
> So, in summary, you have everything you require to fix it outside the
> driver.  You just have to decide which of the two options you want to
> proceed with, and actually (and finally) do it instead of endlessly
> procrastinating and waiting for more and more bug reports (which is
> exactly what has happened so far.)

What the hell, I just recently found this bug and I submitted a patch right 
away! What are you complaining about?!

Grumble!

But thanks for the explanation!

M
