Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab1HINsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:48:39 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37378 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565Ab1HINsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:48:38 -0400
Subject: Re: exception in interrupt during elv_completed_request. (3.0)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <greg@kroah.com>, Jens Axboe <jaxboe@fusionio.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110809124842.GA17607@redhat.com>
References: <20110808145826.GA22457@redhat.com>
	 <4E3FFAB0.40205@fusionio.com> <20110808151352.GA24992@redhat.com>
	 <4E3FFDB9.3090805@fusionio.com> <20110809054323.GA3653@kroah.com>
	 <20110809124842.GA17607@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 08:48:32 -0500
Message-ID: <1312897712.12403.2.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1+jejb.1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 08:48 -0400, Dave Jones wrote:
> On Mon, Aug 08, 2011 at 10:43:23PM -0700, Greg Kroah-Hartman wrote:
>  > On Mon, Aug 08, 2011 at 05:16:09PM +0200, Jens Axboe wrote:
>  > > On 2011-08-08 17:13, Dave Jones wrote:
>  > > >  > On 2011-08-08 16:58, Dave Jones wrote:
>  > > >  > > Jens,
>  > > >  > > 
>  > > >  > > We got a report of a panic from a user when he plugged in his usb drive,
>  > > >  > > https://bugzilla.redhat.com/attachment.cgi?id=517141
>  > > >  > > 
>  > > >  > > any ideas what happened here ?
>  > > >  > 
>  > > >  > 2.6.40?
>  > > > 
>  > > > it's 3.0 in all but name. didn't want to risk breaking dumb userspace
>  > > > in an update for older fedora releases.  It does have the
>  > > > scsi_dispatch_cmd fix that went into 3.0.1, but otherwise block/
>  > > > should be stock 3.0
>  > > 
>  > > OK
>  > > 
>  > > >  > Looks like the recent SCSI removal oopses, perhaps it happened when he
>  > > >  > yanked it instead of directly on insertion?
>  > > >  
>  > > > sorry my bad, yes, this was on device removal.
>  > > > 
>  > > > according to the user, he did everything right, and unmounted safely.	
>  > > > https://bugzilla.redhat.com/show_bug.cgi?id=728872
>  > > 
>  > > James?
>  > 
>  > Should be resolved in 3.0.1 now.
>  > 
>  > If not, please let James, and me, know.
> 
> Are you talking about the scsi_dispatch_cmd fix ?  this is something else.

I'm not so sure ... it looks like a stray block put coming after queue
teardown to me.  elevator_exit() will NULL e->ops but blk_put_request()
uses it unconditionally.

That's more a fix like this, isn't it?

James

---

diff --git a/block/elevator.c b/block/elevator.c
index a3b64bc..de4bde9 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -812,7 +812,7 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 	 */
 	if (blk_account_rq(rq)) {
 		q->in_flight[rq_is_sync(rq)]--;
-		if ((rq->cmd_flags & REQ_SORTED) &&
+		if ((rq->cmd_flags & REQ_SORTED) && e->ops &&
 		    e->ops->elevator_completed_req_fn)
 			e->ops->elevator_completed_req_fn(q, rq);
 	}


