Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab1FFSDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:03:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49391 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754431Ab1FFSDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:03:30 -0400
Date: Mon, 6 Jun 2011 14:03:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Keshava Munegowda <keshava_mgowda@ti.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <b-cousson@ti.com>,
        <paul@pwsan.com>
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and
 ohci
In-Reply-To: <20110606172555.GL12242@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1106061351240.1953-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011, Felipe Balbi wrote:

> > But what is the "right thing"?  Suppose you want to have conditional 
> > support for dev_pm_ops whenever CONFIG_PM is enabled and you _also_ 
> > want to have conditional support for runtime PM whenever 
> > CONFIG_PM_RUNTIME is enabled?
> 
> we don't have this today either. Currently everybody does #ifdef
> CONFIG_PM, so either all the data is available, or none is and adding
> another #ifdef CONFIG_PM_RUNTIME for the runtime_* friends, would just
> look even uglier :-)

Like in hcd-pci.c?  :-)

> > You can obtain that same guarantee by using #ifdef ... #endif.  Even 
> > better, you can guarantee that the unused data won't be present at all, 
> > as opposed to loaded and then freed.
> 
> I agree with you here, but I give you the same question as you gave me.
> How will you have conditional on CONFIG_RUNTIME_PM and CONFIG_PM ? you'd
> need two levels of ifdefs.

Well, you'd need more #ifdefs, no question about that.  Whether you 
need more _levels_ of #ifdefs is unclear.

> > #ifdef CONFIG_PM
> > 	#define DEV_PM_OPS_REF(my_pm_ops)	&(my_pm_ops)
> > #else
> > 	#define DEV_PM_OPS_REF(my_pm_ops)	NULL
> > #endif
> > 
> > Then people could write
> > 
> > static struct platform_driver my_driver = {
> > 	...
> > 	.driver	= {
> > 		.pm = DEV_PM_OPS_REF(my_driver_pm_ops),
> > 	},
> > };
> > 
> > without worrying about whether or not my_driver_pm_ops was defined.  
> > And only one #ifdef block would be needed.
> 
> that'd be nice. Something similar to __exit_p() and __devexit_p()

Right.  Maybe even call it __pm_ops_p().

In fact, rather than tying this specifically to dev_pm_ops, it would 
make sense to have a general-purpose memory section for code that won't 
be used, and an appropriate macro (such as "__unused") to specify that 
section attribute.  Then the PM core could do:

#ifdef CONFIG_PM
	#define __pm_ops
#else
	#define __pm_ops	__unused
#endif

and that would (I think) put less of a mental burden on people.

> Well, it might work out if pm core makes dev_pm_ops only available on
> CONFIG_PM builds.

Currently the .pm member is part of struct bus_type, struct
device_driver, and others whether CONFIG_PM is enabled or not.  I don't
know if removing it when CONFIG_PM is disabled would cause build
problems -- it might.

Alan Stern

