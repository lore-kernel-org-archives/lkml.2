Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1HORsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:48:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab1HORsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:48:53 -0400
Date: Mon, 15 Aug 2011 13:48:45 -0400
From: Dave Jones <davej@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, Jens Axboe <jaxboe@fusionio.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: exception in interrupt during elv_completed_request. (3.0)
Message-ID: <20110815174845.GA4181@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Greg KH <greg@kroah.com>, Jens Axboe <jaxboe@fusionio.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110808145826.GA22457@redhat.com>
 <4E3FFAB0.40205@fusionio.com>
 <20110808151352.GA24992@redhat.com>
 <4E3FFDB9.3090805@fusionio.com>
 <20110809054323.GA3653@kroah.com>
 <20110809124842.GA17607@redhat.com>
 <1312897712.12403.2.camel@mulgrave>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312897712.12403.2.camel@mulgrave>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 08:48:32AM -0500, James Bottomley wrote:

 > >  > > >  > Looks like the recent SCSI removal oopses, perhaps it happened when he
 > >  > > >  > yanked it instead of directly on insertion?
 > >  > > >  
 > >  > > > sorry my bad, yes, this was on device removal.
 > >  > > > 
 > >  > > > according to the user, he did everything right, and unmounted safely.	
 > >  > > > https://bugzilla.redhat.com/show_bug.cgi?id=728872
 > >  > > 
 > >  > > James?
 > >  > 
 > >  > Should be resolved in 3.0.1 now.
 > >  > 
 > >  > If not, please let James, and me, know.
 > > 
 > > Are you talking about the scsi_dispatch_cmd fix ?  this is something else.
 > 
 > I'm not so sure ... it looks like a stray block put coming after queue
 > teardown to me.  elevator_exit() will NULL e->ops but blk_put_request()
 > uses it unconditionally.
 > 
 > That's more a fix like this, isn't it?
 > 
 > James
 > 
 > ---
 > 
 > diff --git a/block/elevator.c b/block/elevator.c
 > index a3b64bc..de4bde9 100644
 > --- a/block/elevator.c
 > +++ b/block/elevator.c
 > @@ -812,7 +812,7 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 >  	 */
 >  	if (blk_account_rq(rq)) {
 >  		q->in_flight[rq_is_sync(rq)]--;
 > -		if ((rq->cmd_flags & REQ_SORTED) &&
 > +		if ((rq->cmd_flags & REQ_SORTED) && e->ops &&
 >  		    e->ops->elevator_completed_req_fn)
 >  			e->ops->elevator_completed_req_fn(q, rq);
 >  	}

I did a build with this change for the user seeing the problem.
Apparentely, it didn't change anything.

	Dave

