Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1CKUVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:21:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1CKUVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:21:46 -0500
Date: Fri, 11 Mar 2011 12:16:33 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, mingo@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        tglx@linutronix.de
Subject: Re: [RFC][Update][PATCH 1/2] Introduce struct syscore_ops and
 related functionality
Message-ID: <20110311201633.GA10757@suse.de>
References: <Pine.LNX.4.44L0.1103092224480.3620-100000@netrider.rowland.org>
 <201103101230.45569.rjw@sisk.pl>
 <20110311171131.GA10437@suse.de>
 <201103112113.13807.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103112113.13807.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 09:13:13PM +0100, Rafael J. Wysocki wrote:
> On Friday, March 11, 2011, Greg KH wrote:
> > On Thu, Mar 10, 2011 at 12:30:45PM +0100, Rafael J. Wysocki wrote:
> > > On Thursday, March 10, 2011, Alan Stern wrote:
> > > > On Thu, 10 Mar 2011, Rafael J. Wysocki wrote:
> > > > 
> > > > > Some subsystems need to carry out suspend/resume and shutdown
> > > > > operations with one CPU on-line and interrupts disabled.  The only
> > > > > way to register such operations is to define a sysdev class and
> > > > > a sysdev specifically for this purpose which is cumbersome and
> > > > > inefficient.  Moreover, the arguments taken by sysdev suspend,
> > > > > resume and shutdown callbacks are practically never necessary.
> > > > > 
> > > > > For this reason, introduce a simpler interface allowing subsystems
> > > > > to register operations to be executed very late during system suspend
> > > > > and shutdown and very early during resume in the form of
> > > > > strcut syscore_ops objects.
> > > > 
> > > > ...
> > > > 
> > > > > Index: linux-2.6/drivers/base/syscore.c
> > > > > ===================================================================
> > > > > --- /dev/null
> > > > > +++ linux-2.6/drivers/base/syscore.c
> > > > 
> > > > It's true that the existing sys.c file lies in drivers/base; this is
> > > > presumably because it handles a bunch of class-related registration
> > > > stuff.  Now you're getting rid of all that, leaving just the
> > > > power-related operations, so doesn't it make more sense to put this
> > > > file in drivers/base/power?
> > > > 
> > > > > +/**
> > > > > + * syscore_suspend - Execute all the registered system core suspend callbacks.
> > > > > + *
> > > > > + * This function is executed with one CPU on-line and disabled interrupts.
> > > > > + */
> > > > > +int syscore_suspend(void)
> > > > > +{
> > > > > +	struct syscore_ops *ops;
> > > > > +
> > > > > +	list_for_each_entry_reverse(ops, &syscore_ops_list, node)
> > > > > +		if (ops->suspend) {
> > > > > +			int ret = ops->suspend();
> > > > > +			if (ret) {
> > > > > +				pr_err("PM: System core suspend callback "
> > > > > +					"%pF failed.\n", ops->suspend);
> > > > > +				return ret;
> > > > 
> > > > If an error occurs, you need to go back and resume all the things that
> > > > were suspended.  At least, that's what the code in sysdev_suspend does.
> > > > 
> > > > > +			}
> > > > > +		}
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > 
> > > Below is a new version of the patch.  I've taken your comment on the failing
> > > suspend into account, fix the list traversal direction in syscore_shutdown()
> > > and added some debug statements.
> > > 
> > > Thanks,
> > > Rafael
> > > 
> > > ---
> > > Some subsystems need to carry out suspend/resume and shutdown
> > > operations with one CPU on-line and interrupts disabled.  The only
> > > way to register such operations is to define a sysdev class and
> > > a sysdev specifically for this purpose which is cumbersome and
> > > inefficient.  Moreover, the arguments taken by sysdev suspend,
> > > resume and shutdown callbacks are practically never necessary.
> > > 
> > > For this reason, introduce a simpler interface allowing subsystems
> > > to register operations to be executed very late during system suspend
> > > and shutdown and very early during resume in the form of
> > > strcut syscore_ops objects.
> > > 
> > > ---
> > >  drivers/base/Makefile       |    2 
> > >  drivers/base/syscore.c      |  107 ++++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/syscore_ops.h |   29 +++++++++++
> > >  kernel/power/hibernate.c    |    9 +++
> > >  kernel/power/suspend.c      |    4 +
> > >  kernel/sys.c                |    4 +
> > >  6 files changed, 154 insertions(+), 1 deletion(-)
> > > 
> > > Index: linux-2.6/include/linux/syscore_ops.h
> > > ===================================================================
> > > --- /dev/null
> > > +++ linux-2.6/include/linux/syscore_ops.h
> > > @@ -0,0 +1,29 @@
> > > +/*
> > > + *  syscore_ops.h - System core operations.
> > > + *
> > > + *  Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
> > > + *
> > > + *  This file is released under the GPLv2.
> > > + */
> > > +
> > > +#ifndef _LINUX_SYSCORE_OPS_H
> > > +#define _LINUX_SYSCORE_OPS_H
> > > +
> > > +#include <linux/list.h>
> > > +
> > > +struct syscore_ops {
> > > +	struct list_head node;
> > > +	int (*suspend)(void);
> > > +	void (*resume)(void);
> > > +	void (*shutdown)(void);
> > > +};
> > > +
> > > +extern void register_syscore_ops(struct syscore_ops *ops);
> > > +extern void unregister_syscore_ops(struct syscore_ops *ops);
> > > +#ifdef CONFIG_PM_SLEEP
> > > +extern int syscore_suspend(void);
> > > +extern void syscore_resume(void);
> > > +#endif
> > 
> > Minor nit, provide inline functions for these when CONFIG_PM_SLEEP is
> > not defined so the code still builds?
> 
> The code using them depends on CONFIG_PM_SLEEP and they are nobody else's
> business. :-)

Ah, ok.

> I could avoid using the #ifdef here, but I thought I'd make it clear that
> these things were only available when CONFIG_PM_SLEEP was set.

That's fine.

> > Other than that, this looks great to me, thanks for doing this.
> 
> No problem. :-)
> 
> > Do you want me to take it through my tree, or yours?
> 
> I can handle it if you give me an ack.

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

> Do you think I should push [1/2] alone for 2.6.39 or wait for the patches
> converting subsystems to use this stuff to be ready?  I think it'll take
> some time to prepare them, especialy for things in the ARM tree that use
> sysdevs in some interesting ways ...

Send it for .39, and then start converting everyone over to using it.
It's easier once the code is in place to handle the different trees,
that way you don't have to worry about ordering issues.

thanks,

greg k-h
