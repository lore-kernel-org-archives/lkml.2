Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab1GDQB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:01:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44331 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756875Ab1GDQBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:01:24 -0400
Date: Mon, 4 Jul 2011 12:01:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Partha Basak <p-basak2@ti.com>, Keshava Munegowda <keshava_mgowda@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Anand Gadiyar <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
In-Reply-To: <20110704093056.GD25295@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1107041157360.12242-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011, Felipe Balbi wrote:

> sounds to me like a bug on pm runtime ? If you're calling
> pm_runtime_*_sync() family, shouldn't all calls be _sync() too ?

No.  This was a deliberate design decision.  It minimizes stack usage 
and it gives a chance for some other child to resume before the parent 
is powered down.

> > static int rpm_suspend(struct device *dev, int rpmflags)
> > 	__releases(&dev->power.lock) __acquires(&dev->power.lock)
> > {
> > .
> > .
> > .
> > no_callback:
> > .
> > .
> > .
> > 	/* Maybe the parent is now able to suspend. */
> > 	if (parent && !parent->power.ignore_children &&
> > !dev->power.irq_safe) {
> > 		spin_unlock(&dev->power.lock);
> > 
> > 		spin_lock(&parent->power.lock);
> > 		rpm_idle(parent, RPM_ASYNC);
> 
> to me this is bogus, if you called pm_runtime_put_sync() should should
> be sync too. Shouldn't it ?

No, it shouldn't.

> > 		spin_unlock(&parent->power.lock);
> > 
> > 		spin_lock(&dev->power.lock);
> > 	}
> > This is the reason of directly calling the parent Runtime PM calls from
> > the children.
> > If directly calling Runtime PM APIs with parent dev-pointer isn't
> > acceptable,
> > this can be achieved by exporting wrapper APIs from the
> > parent and calling them from the chidren .suspend/.resume routines.
> 
> Still no good, IMHO.

The real problem here is that you guys are trying to use the runtime PM
framework to carry out activities during system suspend.  That won't
work; it's just a bad idea all round.  Use the proper callbacks to do
what you want.

Alan Stern

