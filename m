Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab1DLEtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 00:49:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36110 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1DLEtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 00:49:23 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20110412025145.GJ9673@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 23:49:17 -0500
Message-ID: <1302583757.2558.21.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 11:51 +0900, Tejun Heo wrote:
> Hello, James.
> 
> On Mon, Apr 11, 2011 at 07:47:56PM -0500, James Bottomley wrote:
> > Actually, I don't think it's anything to do with the user process stuff.
> > The problem seems to be that the block delay function ends up being the
> > last user of the SCSI device, so it does the final put of the sdev when
> > it's finished processing.  This will trigger queue destruction
> > (blk_cleanup_queue) and so on with your analysis.
> 
> Hmm... this I can understand.
> 
> > The problem seems to be that with the new workqueue changes, the queue
> > itself may no longer be the last holder of a reference on the sdev
> > because the queue destruction is in the sdev release function and a
> > queue cannot now be destroyed from its own delayed work.  This is a bit
> > contrary to the principles SCSI was using, which was that we drive queue
> > lifetime from the sdev, not vice versa.
> 
> But confused here.  Why does it make any difference whether the
> release operation is in the request_fn context or not?  What makes
> SCSI refcounting different from others?

I didn't say it did.  SCSI refcounting is fairly standard.

The problem isn't really anything to do with SCSI ... it's the way block
queue destruction must now be called.  The block queue destruction
includes a synchronous flush of the work queue.  That means it can't be
called from the executing workqueue without deadlocking.  The last put
of a SCSI device destroys the queue.  This now means that the last put
of the SCSI device can't be in the block delay work path.  However, as
the device shuts down that can very well wind up happening if
blk_delay_queue() ends up being called as the device is dying.

The entangled deadlock seems to have been introduced by commit
3cca6dc1c81e2407928dc4c6105252146fd3924f prior to that, there was no
synchronous cancel in the destroy path.

A fix might be to shunt more stuff off to workqueues, but that's
producing a more complex system which would be prone to entanglements
that would be even harder to spot.

Perhaps a better solution is just not to use sync cancellations in
block?  As long as the work in the queue holds a queue ref, they can be
done asynchronously.

James


