Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2GFPAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:00:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36600 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753916Ab2GFPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:00:00 -0400
Date: Fri, 6 Jul 2012 10:59:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Lin Ming <ming.m.lin@intel.com>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 3/4] block: implement runtime pm strategy
In-Reply-To: <1341561953.3023.31.camel@dabdike.hilton.com>
Message-ID: <Pine.LNX.4.44L0.1207061042550.28821-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, James Bottomley wrote:

> The mechanism is pretty much identical:  For quiesce you set the sdev
> state to SDEV_QUIESCE and then send in special requests with REQ_PREEMPT
> to bypass the suspend.  In your additional scheme you set a queue flag
> RPM_SUSPENDED by a pm specific set of callbacks and you only then accept
> requests with REQ_PM.  I don't see any difference in actual effect
> (well, except that quiesce can be done on a non-empty queue, but that's
> a simple flag difference).
> 
> What I don't want to see is duplicated mechanisms.  If you want to make
> a general quiesce mechanism in block instead of SCSI, I'm fine with
> that, but I want to see our current quiesce mechanism moved to it first
> since that demonstrates you got it right.  If you don't want to do that,
> then just use the existing mechanism in SCSI.

Moving the whole thing to block sounds like a good suggestion.  But are
the end results supposed to be the same?  For example, if a rotating
disk is put into the QUIESCE state, does it get spun down (as would
happen with a runtime suspend)?  I rather got the impression that
QUIESCE meant carrying out existing requests and not accepting new
ones, without the other actions needed for suspend.

What is the client interface for the quiesce mechanism?  There are a
few calls in scsi_transport_spi.c, but no other obvious entry points
besides sysfs.

Are you suggesting that writing "quiesce" to the state attribute should
drain the request queue and then initiate a runtime suspend?

> Now that I look at it, your q->nr_pending is an inexact duplicate of
> sdev->device_busy as well.  Again, no objection to moving this to block,
> but if you then make SCSI use it for sdev->device_busy, you'll get a
> very fast indication of whether you got this right or not, which is an
> excellent reason for unifying.

They aren't exactly the same, because nr_pending counts requests on the
queue whether or not they have been started at the SCSI level.  But
obviously they are closely related.

Alan Stern

