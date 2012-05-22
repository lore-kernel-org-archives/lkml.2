Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab2EVP4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:56:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46079 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759856Ab2EVP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:56:21 -0400
Date: Tue, 22 May 2012 11:56:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
In-Reply-To: <CAF1ivSYVznOU43XT9_5d-EMNp1TQwBiYfG=PL6J1KPdmQx9pgw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1205221142570.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Lin Ming wrote:

> > (Or maybe it would be easier to make q->rpm_status be a pointer to
> > q->dev->power.rpm_status.  That way, if CONFIG_PM_RUNTIME isn't enabled
> > or block_runtime_pm_init() hasn't been called, you can have
> > q->rpm_status simply point to a static value that is permanently set to
> > RPM_ACTIVE.)
> 
> I think we need q->rpm_status.
> Block layer check ->rpm_status and client driver set this status.

No, the client driver should not have to set any status values.  The 
client driver should do as little as possible.

> And the status is synchronized with queue's spin lock.

Right, and the client driver should not need to acquire the queue's 
lock.

> If we use q->dev->power.rpm_status then how to sync it between block
> layer and client driver?
> Do you mean block layer will need to acquire q->dev->power.lock?

That's not what I mean.

What synchronization are you concerned about?  The most important race 
seems to be when a new request is added to the queue at the same time 
as a runtime suspend begins.

If q->dev->power.rpm_status has already been set to RPM_SUSPENDING or
RPM_SUSPENDED when the request is submitted, the block layer should
call pm_runtime_request_resume().  Thus if the suspend succeeds, the
device will be resumed immediately afterward.  And if the suspend
fails, the new request will be handled as usual (note that the
block_*_runtime_* routines might need to kick-start the queue to get it
going again).

Alternatively, if q->dev->power.rpm_status is still equal to RPM_ACTIVE 
when the request is submitted, the block layer will simply accept the 
request.  If the request is still on the queue when 
block_pre_runtime_suspend is called, it will return -EBUSY and the 
suspend will fail.

The only synchronization needed to make this work is that the
block_{pre,post}_runtime_suspend routines need to hold the queue's lock 
while checking to see if any requests are in the queue.  You'd expect 
that anyway.

Alan Stern

