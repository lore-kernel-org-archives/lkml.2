Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab2C0QGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:06:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab2C0QGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:06:15 -0400
Date: Tue, 27 Mar 2012 12:06:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        jason.wessel@windriver.com
Subject: Re: [PATCH] x86 NMI: Be smarter about invoking panic() inside NMI
 handler.
Message-ID: <20120327160601.GA19273@redhat.com>
References: <1330588483-30957-1-git-send-email-andrey.warkentin@gmail.com>
 <CANz0V+5ayWh3-xR1i4nCqTGF+6x+f7mOeokEhCCXhvG3a3pFhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANz0V+5ayWh3-xR1i4nCqTGF+6x+f7mOeokEhCCXhvG3a3pFhw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 01:57:41PM -0400, Andrei E. Warkentin wrote:
> Hi,
> 
> 2012/3/1 Andrei Warkentin <andrey.warkentin@gmail.com>:
> > If two (or more) unknown NMIs arrive on different CPUs, there
> > is a large chance both CPUs will wind up inside panic(). This
> > is fine, unless you want to enter KDB - KDB cannot round up
> > all CPUs, because some of them are stuck inside
> > panic_smp_self_stop with NMI latched. This is
> > easy to replicate with QEMU. Boot with -smp 4 and
> > send NMI using the monitor.
> >
> > Solution for this - attempt to enter panic() from NMI
> > handler. If panic() is already active in the system,
> > just exit out of the NMI handler. This lets KDB round
> > up CPUs.
> >
> > Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
> > ---
> 
> Any feedback on this? Who are the right maintainers to bug about this?

Hmm, if try_panic fails, then the cpu continues on executing code.  This
might further corrupt an already broken system.  So I don't think this
patch will work as is.

Perhaps instead of panic'ing in the NMI context, we use irq_work and panic
in an interrupt context instead.  We still get the system to stop (though
it might still execute some interrupts) and it will be out of the NMI
context.

However, you will still run into a similar problem when in the
panic/reboot case we shutdown all the remote cpus and have them sitting in
a similar cpu_relax loop in the NMI context, while the panic'ing cpu
cleans things up.

Cheers,
Don
