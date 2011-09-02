Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1IBRvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:51:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59503 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1IBRvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:51:39 -0400
Date: Fri, 2 Sep 2011 18:48:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linaro-toolchain@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <martin.schwidefsky@de.ibm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110902174812.GD6619@n2100.arm.linux.org.uk>
References: <20110823220056.GK3895@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org> <20110825145558.GF8883@n2100.arm.linux.org.uk> <201108261644.26329.arnd@arndb.de> <OF2C5ADB6A.65B1BE36-ONC12578FE.00493A67-C12578FE.004B3315@de.ibm.com> <20110901140000.GF29729@n2100.arm.linux.org.uk> <OF69A57AB0.CF22689A-ONC12578FF.004EDD71-C12578FF.005142FF@de.ibm.com> <20110902172259.GA6619@n2100.arm.linux.org.uk> <OFA88E54BC.55310B1A-ONC12578FF.00607E64-C12578FF.00611957@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFA88E54BC.55310B1A-ONC12578FF.00607E64-C12578FF.00611957@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 07:40:34PM +0200, Ulrich Weigand wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote on 09/02/2011
> 07:22:59 PM:
> > On Fri, Sep 02, 2011 at 04:47:35PM +0200, Ulrich Weigand wrote:
> > > Assume the scenario you initally describe, where a first signal is
> > > ignored and leads to system call restart.  With your latest patch,
> > > you call into syscall_restart which sets everything up to restart
> > > the call (with interrupts disabled).
> >
> > I don't think SIG_IGN signals even set the TIF work flag, so they
> > never even cause a call into do_signal().  Therefore, as far as
> > syscalls go, attempting to send a process (eg) a SIGINT which its
> > handler is set to SIG_IGN results in the process not even being
> > notified about the attempt - we won't even wake up while the
> > syscall is sleeping.
> 
> I don't see why SIG_IGN signals shouldn't set the TIF work flag;
> the decision whether to ignore a signal is only made once we've
> got to get_signal_to_deliver.

Yes, having looked deeper, you seem to be right - but only if the thread
is being ptraced.  If it's not being ptraced, ignored signals don't
make it that far.

And yes, we can end up processing the interrupt before the SVC is
executed, which is still a hole.  So we need to avoid doing the
restart in userspace - which might actually make things easier.
I'll take a look into that over the weekend.
