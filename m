Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1AaW3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:29:16 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51662 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab1AaW3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:29:15 -0500
Date: Mon, 31 Jan 2011 15:26:09 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Message-ID: <20110131222609.GC27856@angua.secretlab.ca>
References: <Pine.LNX.4.44L0.1101311442100.1931-100000@iolanthe.rowland.org>
 <201101312316.52116.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101312316.52116.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:16:51PM +0100, Rafael J. Wysocki wrote:
> On Monday, January 31, 2011, Alan Stern wrote:
> > On Mon, 31 Jan 2011, Rafael J. Wysocki wrote:
> > 
> > > On Monday, January 31, 2011, Alan Stern wrote:
> > > > On Sun, 30 Jan 2011, Rafael J. Wysocki wrote:
> > > > 
> > > > > > One thing about this implementation is slightly questionable.  The new
> > > > > > power_domain callbacks were added to the __weak platform PM routines,
> > > > > > which means they will have to be included in every overriding routine
> > > > > > provided by a platform imiplementation.
> > > > > > 
> > > > > > Would it be better to separate these things?  Have the power_domain 
> > > > > > callbacks occur in a static outer function which then calls a public 
> > > > > > __weak inner function that can be overridden?
> > > > > 
> > > > > That certainly is a good idea, but I wasn't sure how to do that.  It looks
> > > > > like I could keep the __weak functions as they are and modify
> > > > > platform_dev_pm_ops instead to point to a new set of function that in turn
> > > > > would call the __weak ones.  For example, the .suspend pointer in
> > > > > platform_dev_pm_ops might point to a new function, say
> > > > > platform_pm_full_suspend() that would call the power domain functions and
> > > > > the "original" platform_pm_suspend().  Is that what you mean?
> > > > 
> > > > Yes.  But what about the platform_bus_set_pm_ops() interface?  Should
> > > > platform-specific replacements for the pm_ops functions also include
> > > > the power_domain callbacks?
> > > 
> > > Well, whoever uses platform_bus_set_pm_ops(), he can simply prevent power
> > > domains from being used by not defining them in the first place. :-)
> > 
> > But what about the case where the user _does_ want to have power
> > domains?
> 
> Ah, OK.  The caller of platform_bus_set_pm_ops() will replace the original
> platform_dev_pm_ops with his own set of operations, so he will not see the
> power domains.
> 
> > Do you want to make the replacement routines responsible for
> > invoking the power-domain callbacks, or should the platform core handle
> > this automatically?
> 
> Well, if someone replaces the entire platform_dev_pm_ops object, this means
> that on his platform power management is substantially different from the
> generic one.  In that case, IMO, he should be responsible for handling all
> of the subsystem-level aspects of power management, including power domains.

Part of point of doing something like power_domain is to *get rid* of
platform_bus_set_pm_ops().  It is a horrid, stop-gap interface that
doesn't scale.  I don't think much consideration needs to be made for
users of platform_bus_set_pm_ops() in this regard.

g.

