Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab1JNPhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:37:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41527 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754461Ab1JNPhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:37:41 -0400
Date: Fri, 14 Oct 2011 11:37:40 -0400 (EDT)
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
In-Reply-To: <20111013171539.GA18574@ponder.secretlab.ca>
Message-ID: <Pine.LNX.4.44L0.1110141126000.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Grant Likely wrote:

> For the deferred case; here is an example of the additional
> constraint.  Consider the following hierarchy:
> 
> -A
>  +-B
>  | +-C
>  | +-D
>  |
>  +-E
>    +-F
>    +-G
> 
> dpm_list could be ordered in at least the following ways (depending on
> exactly when devices get registered).  There are many permutation, but
> children are always be listed after its direct parent.
> 
> 1) ABECDFG (breadth first)
> 2) AEBFGCD (breadth first)
> 3) ABCDEFG (depth first)
> 4) AEFGBCD (depth first)
> 
> Now, assume that device B depends on device F, and also assume that
> there is no way either to express that in the hierarchy or even for
> the constraint to be known at device registration time (the is exactly
> the situation we're dealing with on embedded platforms).  Only the
> driver for B knows that it needs a resource provided by F's driver.
> So, the situation becomes that the ordering of dpm_list must now also
> be sorted so that non-tree dependencies are also accounted for.  Of
> the list above, only sort order 4 meets the new constraint.
> 
> The question then becomes, how can the dpm_list get resorted
> dynamically at runtime to ensure that the new constraints are always
> met without breaking old ones.  Here are some options I can think of:
> 
> 1) When a deferred probe succeeds, move the deferred device to the
> end of the dpm_list.  Then the new sort order might be one of:
> 
> 	1) AECDFGB
> 	2) AEFGCDB
> 	3) ACDEFGB
> 	4) AEFGCDB
> 
> However, that approach breaks the guarantee that children appear after
> their parents (C & D appear before B in all cases above)

How can a device acquire children before it has a driver?

> 2a) When a deferred probe succeeds, move the deferred device and it's
> entire child hierarchy to the end of the list to become one of:

This is the same as the above, under the reasonable assumption that
devices without drivers can't have any children.  Or to be more
carefully precise, that a device with children won't need to defer a
probe.

We can check that easily enough: Fail a deferral if the device already 
has children.

> 2b) alternately, when *any* probe succeeds, move the deferred device
> and its children to the end of the list.  This continues to maintain
> the parent-child relationship, and it ensures that the dpm_list is
> always also sorted in probe-order (devices bound to drivers will
> collect at the end of the list).

We do not want to move entire hierarchies.  And in fact, even in 1 or
2a, we would have to do the move from _within_ the deferred probe
routine, not afterward, to make sure that it occurs before any children
are added (and after all the prerequisite devices have been 
registered).

> 3) Add devices to dpm_list after successful probe instead of at
> device_add time.
> 
> Potential problem: this means that only devices with drivers actually
> get suspend/resume calls.  I don't know nearly enough about the PM
> subsystem, but I suspect that this is a problem.

Yes, this is no good.

> 4) ignore parent-child relationships entirely and just move devices to
> the end of the list on successful probe.  If it probed successfully,
> then it can be successfully suspended regardless of whether it has any
> children.  That breaks the parent-child ordering, but guarantees the
> probe order ordering.  Any devices without drivers will end up
> collecting at the beginning of the list, and will be suspended after
> all the devices with drivers.
> 
> Problem: Same as with 3, I suspect that even devices without drivers
> need to process PM suspend, which makes this option unworkable.
> 
> ...
> 
> For my money, I think that option 2b shows the most promise despite
> the potential O(N^2) complexity.  There may be a better algorithm for
> doing the runtime reordering that isn't O(N^2) that I haven't thought
> of.  Having a list that is strongly ordered both on hierarchy *and*
> probe order I think is the right thing to do, even without deferred
> probe support.

The answer is 1, but do the move at the appropriate time within the 
probe routine.

Alan Stern

