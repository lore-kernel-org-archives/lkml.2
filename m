Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0J1PXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:23:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37744 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754760Ab0J1PW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:22:56 -0400
Date: Thu, 28 Oct 2010 11:22:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] PERF(kernel): Cleanup power events V2
In-Reply-To: <Pine.LNX.4.44L0.1010271014280.1650-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1010281117530.1601-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Alan Stern wrote:

> On Wed, 27 Oct 2010, Mathieu Desnoyers wrote:
> 
> > grep -r pm_runtime_get_noresume drivers/    hands out very interesting info.
> > 
> > e.g.:
> > 
> > drivers/usb/core/drivers.c: usb_autopm_get_interface_async()
> > 
> >         pm_runtime_get_noresume(&intf->dev);
> >         s = ACCESS_ONCE(intf->dev.power.runtime_status);
> >         if (s == RPM_SUSPENDING || s == RPM_SUSPENDED)
> >                 status = pm_request_resume(&intf->dev);
> > 
> > How is this supposed to work ?

> > If the ACCESS_ONCE can be reordered before the atomic_inc(), then I fear the
> > device can be suspended even after the check.
> 
> You are correct; the code as written may sometimes fail.  It was a
> hack from the beginning; the kind of test it performs should not be
> done outside the PM core.  However at the time it was the easiest way 
> to do what I wanted.

I forgot to mention one other thing...  The fact that this code will
sometimes behave unexpectedly isn't a bug.  That function is documented
as requiring additional locking when a driver uses it.  The need for
extra locking is unavoidable because I/O requests can arrive at any
time, even while a runtime suspend is in progress.

Therefore the fact that usb_autopm_get_interface_async() can race with 
a runtime suspend doesn't matter.  The driver making the call should 
have sufficient locking to know that the runtime suspend should fail 
because the driver is busy.

Alan Stern

