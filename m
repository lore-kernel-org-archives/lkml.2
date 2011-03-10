Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1CJKmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:42:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45220 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab1CJKmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:42:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH 1/2] Introduce struct syscore_ops and related functionality
Date: Thu, 10 Mar 2011 11:42:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, mingo@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        tglx@linutronix.de
References: <Pine.LNX.4.44L0.1103092224480.3620-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103092224480.3620-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101142.07510.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 10, 2011, Alan Stern wrote:
> On Thu, 10 Mar 2011, Rafael J. Wysocki wrote:
> 
> > Some subsystems need to carry out suspend/resume and shutdown
> > operations with one CPU on-line and interrupts disabled.  The only
> > way to register such operations is to define a sysdev class and
> > a sysdev specifically for this purpose which is cumbersome and
> > inefficient.  Moreover, the arguments taken by sysdev suspend,
> > resume and shutdown callbacks are practically never necessary.
> > 
> > For this reason, introduce a simpler interface allowing subsystems
> > to register operations to be executed very late during system suspend
> > and shutdown and very early during resume in the form of
> > strcut syscore_ops objects.
> 
> ...
> 
> > Index: linux-2.6/drivers/base/syscore.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/drivers/base/syscore.c
> 
> It's true that the existing sys.c file lies in drivers/base; this is
> presumably because it handles a bunch of class-related registration
> stuff.  Now you're getting rid of all that, leaving just the
> power-related operations, so doesn't it make more sense to put this
> file in drivers/base/power?

I didn't, because shutdown() doesn't really belong in there (well, depending).

> > +/**
> > + * syscore_suspend - Execute all the registered system core suspend callbacks.
> > + *
> > + * This function is executed with one CPU on-line and disabled interrupts.
> > + */
> > +int syscore_suspend(void)
> > +{
> > +	struct syscore_ops *ops;
> > +
> > +	list_for_each_entry_reverse(ops, &syscore_ops_list, node)
> > +		if (ops->suspend) {
> > +			int ret = ops->suspend();
> > +			if (ret) {
> > +				pr_err("PM: System core suspend callback "
> > +					"%pF failed.\n", ops->suspend);
> > +				return ret;
> 
> If an error occurs, you need to go back and resume all the things that
> were suspended.  At least, that's what the code in sysdev_suspend does.

Right, thanks a lot!

> > +			}
> > +		}
> > +
> > +	return 0;
> > +}

Rafael
