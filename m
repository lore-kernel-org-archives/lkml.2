Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739Ab2FVAJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:09:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:45737 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760704Ab2FVAJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:09:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="156931619"
Date: Thu, 21 Jun 2012 17:08:58 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alexis Cortes <alexis.cortes@ti.com>
Cc: "'Greg KH'" <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120622000858.GB629@xanatos>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
 <20120621003232.GD3255@kroah.com>
 <003001cd4fd3$a7648950$f62d9bf0$@cortes@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003001cd4fd3$a7648950$f62d9bf0$@cortes@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 12:31:12PM -0500, Alexis Cortes wrote:
> Hi Greg,
> 
> I understand your concerns, however as I mentioned before, any xHCI host
> that has this particular re-driver between its root-ports and the physical
> ports of the system will be subject to suffer of this compliance mode issue
> (once the port has entered compliance mode, it becomes unusable so no device
> that is plugged to that port will work until a warm reset is applied to it).
> For a system that has this re-driver, this problem could hit about 20%-40%
> of the times (however this percentage is subject to the quality of the
> internal connection) and unfortunately there is no way to programmatically
> detect if this re-driver is on the system.
> 
> As Sarah proposed, we certainly can apply this patch as a module parameter
> disabled by default and let know our clients that we know are using this
> re-driver to enable the feature to avoid the issue.

I don't think that would work very well.  Are those clients supposed to
notify Linux OSVs when a system will ship with that redriver so they can
turn it on for Linux preloads of those systems?  What about the average
Linux user who installs Linux themselves?

An alternative approach, since you know which clients are using the
re-driver, is to just add a quirk, and get them to tell us when they're
shipping a system with your redriver.  Then we can turn it on in the
mainline kernel, all Linux distros will pick it up, and we will avoid
disgruntled users.

Or we can just modify the timer to a more reasonable value like 10
seconds, and users will just have to put up with the longer enumeration
times.

Greg, what about exporting a sysfs file to change the polling interval?
We could run the timer every 2 seconds by default, but get powertop to
add a new setting for turning the interval off.

Sarah Sharp

> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Wednesday, June 20, 2012 7:33 PM
> > To: Sarah Sharp
> > Cc: Alexis Cortes; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org;
> > 'Quach, Brian'; 'Llamas, Jorge'
> > Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
> > 
> > On Wed, Jun 20, 2012 at 05:07:34PM -0700, Sarah Sharp wrote:
> >> > Unfortunately there is not a way to programmatically detect if the
> >> > re-driver is present on the system, and since it might affect any
> >> > host controller, I'm afraid this workaround can't be limited on the
> > driver to specific hardware.
> >>
> >> Ok, then make it a module parameter that is off by default.  Users who
> >> find they have this issue can reload the driver with the timer on, and
> >> add the module parameter to their grub linux boot line.  If we find
> >> that the redriver is used always for one particular host
> >> vendor/revision, we'll add a quirk for it.
> >>
> >> But I really don't want an extra timer running and killing power
> >> management for hosts that don't need this work around.
> > 
> > I don't want that either, but I really don't want a new module parameter
> > that no one is going to know that they need to set.
> > 
> > I think the real solution is finding what pci devices this is a problem
> > with, and using a quirk that way.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> >
> 
