Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1AaXCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:02:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55400 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab1AaXCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:02:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Date: Tue, 1 Feb 2011 00:01:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.1101311442100.1931-100000@iolanthe.rowland.org> <20110131222609.GC27856@angua.secretlab.ca> <87vd1466d8.fsf@ti.com>
In-Reply-To: <87vd1466d8.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102010001.51418.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 31, 2011, Kevin Hilman wrote:
> Grant Likely <grant.likely@secretlab.ca> writes:
> 
> > On Mon, Jan 31, 2011 at 11:16:51PM +0100, Rafael J. Wysocki wrote:
> >> On Monday, January 31, 2011, Alan Stern wrote:
> >> > On Mon, 31 Jan 2011, Rafael J. Wysocki wrote:
> >> > 
> >> > > On Monday, January 31, 2011, Alan Stern wrote:
> >> > > > On Sun, 30 Jan 2011, Rafael J. Wysocki wrote:
> >> > > > 
> >> > > > > > One thing about this implementation is slightly questionable.  The new
> >> > > > > > power_domain callbacks were added to the __weak platform PM routines,
> >> > > > > > which means they will have to be included in every overriding routine
> >> > > > > > provided by a platform imiplementation.
> >> > > > > > 
> >> > > > > > Would it be better to separate these things?  Have the power_domain 
> >> > > > > > callbacks occur in a static outer function which then calls a public 
> >> > > > > > __weak inner function that can be overridden?
> >> > > > > 
> >> > > > > That certainly is a good idea, but I wasn't sure how to do that.  It looks
> >> > > > > like I could keep the __weak functions as they are and modify
> >> > > > > platform_dev_pm_ops instead to point to a new set of function that in turn
> >> > > > > would call the __weak ones.  For example, the .suspend pointer in
> >> > > > > platform_dev_pm_ops might point to a new function, say
> >> > > > > platform_pm_full_suspend() that would call the power domain functions and
> >> > > > > the "original" platform_pm_suspend().  Is that what you mean?
> >> > > > 
> >> > > > Yes.  But what about the platform_bus_set_pm_ops() interface?  Should
> >> > > > platform-specific replacements for the pm_ops functions also include
> >> > > > the power_domain callbacks?
> >> > > 
> >> > > Well, whoever uses platform_bus_set_pm_ops(), he can simply prevent power
> >> > > domains from being used by not defining them in the first place. :-)
> >> > 
> >> > But what about the case where the user _does_ want to have power
> >> > domains?
> >> 
> >> Ah, OK.  The caller of platform_bus_set_pm_ops() will replace the original
> >> platform_dev_pm_ops with his own set of operations, so he will not see the
> >> power domains.
> >> 
> >> > Do you want to make the replacement routines responsible for
> >> > invoking the power-domain callbacks, or should the platform core handle
> >> > this automatically?
> >> 
> >> Well, if someone replaces the entire platform_dev_pm_ops object, this means
> >> that on his platform power management is substantially different from the
> >> generic one.  In that case, IMO, he should be responsible for handling all
> >> of the subsystem-level aspects of power management, including power domains.
> >
> > Part of point of doing something like power_domain is to *get rid* of
> > platform_bus_set_pm_ops().  It is a horrid, stop-gap interface that
> > doesn't scale.  I don't think much consideration needs to be made for
> > users of platform_bus_set_pm_ops() in this regard.
> 
> As the author of platform_bus_set_pm_ops(), I humbly agree.  
> 
> Also, the __weak functions here were obsoleted by
> platform_bus_set_pm_ops().  Once Magnus moves to
> platform_bus_set_pm_ops() (or this new interface) the __weak attributes
> should be removed (c.f. commit log below[1] where
> platform_bus_set_pm_ops() was added.)
> 
> Kevin
> 
> commit c64a0926710153b9d44c979d2942f4a8648fd74e
> Author: Kevin Hilman <khilman@ti.com>
> Date:   Wed Aug 25 12:50:00 2010 -0700
> 
>     driver core: platform_bus: allow runtime override of dev_pm_ops
>     
>     Currently, the platform_bus allows customization of several of the
>     busses dev_pm_ops methods by using weak symbols so that platform code
>     can override them.  The weak-symbol approach is not scalable when
>     wanting to support multiple platforms in a single kernel binary.
>     
>     Instead, provide __init methods for platform code to customize the
>     dev_pm_ops methods at runtime.
>     
>     NOTE: after these dynamic methods are merged, the weak symbols should
>           be removed from drivers/base/platform.c.  AFAIK, this will only
>           affect SH and sh-mobile which should be converted to use this
>           runtime approach instead of the weak symbols.  After SH &
>           sh-mobile are converted, the weak symobols could be removed.
> --

So, it seems there are two possibilities, either (1) keep the $subject patch
as is in the hope that Magnus will use power domains instead of overriding
the __weak callbacks and remove the _weak attribute when that happens, or (2)
modify it along the lines suggested by Alan (ie. so that the _weak callbacks
stay as they are, but they won't be pointed to by platform_dev_pm_ops directly).
I'm pretty much fine with each of them, so I'd prefer to do whichever is
generally more useful.  Magnus?

Rafael
