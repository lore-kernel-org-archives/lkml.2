Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab0GAUoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:44:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59894 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758291Ab0GAUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:44:07 -0400
Date: Thu, 1 Jul 2010 16:44:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup events
 from being lost
In-Reply-To: <201007012208.11464.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1007011627030.1303-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Rafael J. Wysocki wrote:

> > > +	if (msec) {
> > > +		ktime_t kt;
> > > +		struct timespec ts;
> > > +		unsigned long expires;
> > > +
> > > +		kt = ktime_get();
> > > +		kt = ktime_add_ns(kt, msec * NSEC_PER_MSEC);
> > > +		ts = ktime_to_timespec(kt);
> > > +		expires = timespec_to_jiffies(&ts);
> > 
> > Is this somehow better than jiffies + msecs_to_jiffies(msec)?
> 
> I'm not sure about overflows.  That said, the "+" version is used in many
> places, so there's no problem I think.

Hmm.  NSEC_PER_MSEC must be one million, right?  So if msec referred to
anything above 4 seconds (which seems unlikely but not impossible), the
multiplication would overflow on a 32-bit machine.

Apart from that, the main difference between the two patches lies in
when the events are counted, i.e., whether event_count gets incremented
at the start or when the timer expires.  I can't see that it matters 
much either way.


> Index: linux-2.6/drivers/base/power/wakeup.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/wakeup.c
> +++ linux-2.6/drivers/base/power/wakeup.c
> @@ -9,6 +9,7 @@
>  #include <linux/device.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> +#include <linux/ktime.h>

This isn't needed any more.

Alan Stern

