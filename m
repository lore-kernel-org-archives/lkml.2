Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab1JNRd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:33:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41620 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755821Ab1JNRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:33:27 -0400
Date: Fri, 14 Oct 2011 13:33:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Grant Likely <grant.likely@secretlab.ca>
cc: Ming Lei <tom.leiming@gmail.com>, Andrei Warkentin <awarkentin@vmware.com>,
        Greg KH <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        "G, Manjunath Kondaiah" <manjugk@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, <Manjunath@jasper.es>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linux PM List <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
In-Reply-To: <CACxGe6t2Xu5B0AKZJe-6HEpxK6GfuNm0Y2Kb_bs8ZwaTz5XnRg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110141327170.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Grant Likely wrote:

> > I don't think the second part needs to be quite so invasive.
> > Certainly drivers that never defer probes shouldn't require anything to
> > be moved.
> 
> Think about that a minute.  Consider a dpm_list of devices:
>         abcDefGh
> 
> Now assume that D has an implicit dependency on G.  If D gets probed
> first, then it will be deferred until G gets probed and then D will
> get retried and moved to the end of the list resulting in:
>         abcefGhD
> Everything is good now for the order that things need to be suspended in.
> 
> Now lets assume that the drivers get linked into the kernel in a
> different order (or the modules get loaded in a different order) and G
> gets probed first, followed by D.  No deferral occurred and so no
> reordering occurs, resulting in:
>         abcDefGh (unchanged)
> But now suspend is broken because D depends on G, but G will be
> suspended before D.

However D sometimes does defer probes.  Therefore the device always
needs to be moved, even though this particular probe wasn't deferred.

>  This looks and smells like a bug to me.  In fact,
> even without using probe deferral it looks like a bug because the
> dap_list isn't taking into account the fact that there are very likely
> to be implicit dependencies between devices that are not represented
> in the device hierarchy (maybe not common in PCs, but certainly is the
> case for embedded).  But, it is also easy to solve by ensuring the
> dap_list is also probe-order sorted.
> 
> > A deferred probe _should_ move the device to the end of the list.  But
> > this needs to happen in the probe routine itself (after it has verified
> > that all the other required devices are present and before it has
> > registered any children) to prevent races.  It can't be done in a
> > central location.
> 
> I'm really concerned about drivers having to implement this and not
> getting it correct; particularly when moving a device to the end of
> the list is cheap, and it shouldn't be a problem to do the move
> unconditionally after a driver has been matches, but before probe() is
> called.

But that's too early.  What if D gets moved to the end of the list, 
then G gets added to the list and probed, and then D's probe succeeds?

And after the probe returns is too late, because by then there may well 
be child devices.

>  We may be able to keep watch to make sure that drivers using
> probe deferral are also reordering themselves, but that does nothing
> for the cases described above where the link order of the drivers
> determines probe order, not the dap_list order.

Devices need to be moved whenever they have any external dependencies,
regardless of the particular order they get probed in.

Alan Stern

