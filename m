Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1JMS2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:28:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39295 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1JMS2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:28:31 -0400
Date: Thu, 13 Oct 2011 12:28:27 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <tom.leiming@gmail.com>, Andrei Warkentin <awarkentin@vmware.com>,
        Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Manjunath@jasper.es,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
Message-ID: <20111013182827.GL18574@ponder.secretlab.ca>
References: <20111013171539.GA18574@ponder.secretlab.ca>
 <Pine.LNX.4.44L0.1110131413410.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110131413410.2026-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 02:16:42PM -0400, Alan Stern wrote:
> On Thu, 13 Oct 2011, Grant Likely wrote:
> 
> > For the deferred case; here is an example of the additional
> > constraint.  Consider the following hierarchy:
> > 
> > -A
> >  +-B
> >  | +-C
> >  | +-D
> >  |
> >  +-E
> >    +-F
> >    +-G
> > 
> > dpm_list could be ordered in at least the following ways (depending on
> > exactly when devices get registered).  There are many permutation, but
> > children are always be listed after its direct parent.
> > 
> > 1) ABECDFG (breadth first)
> > 2) AEBFGCD (breadth first)
> > 3) ABCDEFG (depth first)
> > 4) AEFGBCD (depth first)
> > 
> > Now, assume that device B depends on device F, and also assume that
> > there is no way either to express that in the hierarchy or even for
> > the constraint to be known at device registration time (the is exactly
> > the situation we're dealing with on embedded platforms).  Only the
> > driver for B knows that it needs a resource provided by F's driver.
> > So, the situation becomes that the ordering of dpm_list must now also
> > be sorted so that non-tree dependencies are also accounted for.  Of
> > the list above, only sort order 4 meets the new constraint.
> > 
> > The question then becomes, how can the dpm_list get resorted
> > dynamically at runtime to ensure that the new constraints are always
> > met without breaking old ones.  Here are some options I can think of:
> 
> This was a long message and I haven't absorbed the whole thing.  

heh; I did get rather verbose there.

> However it's worth pointing out right at the start that we already have
> device_pm_move_before(), device_pm_move_after(), and
> device_pm_move_last().  They are intended specifically to provide
> drivers with a way of making sure that dpm_list is in the right order 
> -- people have been aware of these issues for some time.

I saw those.  I also notice that they are only used by device_move()
when reparenting a device (which is another wrinkle I hadn't though
about).  Reparenting a device becomes problematic if the probe order
is also represented in the list.  If device_move() gets called, then
any implicit probe-order sorting for that device would be lost.

I also notice that device_move disregards any children when moving a
device, which could also be a problem.

Although it looks like the only users of device_move are:

drivers/media/video/pvrusb2/pvrusb2-v4l2.c
drivers/s390/cio/device.c
net/bluetooth/hci_sysfs.c
net/bluetooth/rfcomm/tty.c

So it may not be significant to adapt.

g.

