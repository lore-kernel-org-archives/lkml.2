Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab0ICOQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:16:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49564 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755160Ab0ICOQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:16:05 -0400
Date: Fri, 3 Sep 2010 10:16:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [linux-pm] [PATCH] libata: skip EH autopsy and recovery during
 suspend
In-Reply-To: <4C80B81F.8090803@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1009031006510.1548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Tejun Heo wrote:

> > Tejun, I'm planning to make a few changes to the block layer and the
> > SCSI core in order to implement delayed autosuspend.  These changes
> > will affect system sleep too, so you may need to know about them.
> > 
> > Each request_queue structure will have an rpm_status variable that gets
> > updated as the corresponding device is suspended or resumed.  When the
> > status is SUSPENDING or RESUMING, requests will not be sent from the
> > request_queue to the driver unless they have cmd_type set to
> > REQ_TYPE_PM_SUSPEND or REQ_TYPE_PM_RESUME (actually I may combine those
> > two into a single REQ_TYPE_PM type).  If other types of request are
> > added to the queue when the status isn't ACTIVE, they will cause a
> > runtime resume to be started.
> > 
> > Initially this will affect only drivers using the SCSI layer.  
> > Commands sent during error handling won't be affected though, because
> > the SCSI error handler doesn't use requests or queues -- it sends
> > commands directly to the lower-level driver.
> > 
> > Does that all sound okay to you?
> 
> Hmm... I can't really tell much without looking at the actual patch
> but I'm a bit doubtful about using REQ_TYPE_* for suspend/resumes,
> well, for that matter, for any other purpose than actual IO requests.
> The current REQ_TYPE_PM_* are only used by ide and it's really messy.

Yes.  I'm hoping that these changes will help simplify IDE, but I 
haven't looked at it yet.

> Those special requests are very difficult to use in generic manner.
> ie. How should remapping / cloning drivers like md, dm and loopback
> handle them?

They should never need to handle them.  These requests get used only
for preparing a device to change power modes.  Logical devices don't
need them, only physical devices do.  For example, you can't put a
logical RAID device into low-power mode; all you can do is put the
underlying physical drives into low power.

>  They end up just being a mechanism for specific low
> level drivers to feed certain requests back to themselves to implement
> suspend/resume sequence and as there's no clear defined common usage,
> the meaning of those flags becomes ambiguous and confusing depending
> on drivers and so on.

With my changes there now will be a clear defined usage.

> Another issue is that power management is probably better handled as a
> sub problem of generic IO exception handling.  If you throw in
> hot[un]plugs and transport errors and consider what should happen when
> those events happen together, things get hairy if power management is
> not well integrated with the usual exceptionn handling.

I don't see why.  Power management is not exceptional.  The relation
with hot [un]plug is already taken care of.  Transport error recovery
will block runtime power management if it occurs while the device is at
full power; it is an issue only if it occurs during a power transition.  
The SCSI error handler should work okay since it doesn't send commands
through the block layer.

Alan Stern

