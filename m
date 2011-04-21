Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1DUSwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:52:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:60280 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab1DUSwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:52:12 -0400
Date: Thu, 21 Apr 2011 20:52:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
 at 0000000c IP: cfq_insert_request+0x1d/0x3f5
Message-ID: <20110421185208.GB4796@tiehlicka.suse.cz>
References: <20110420125824.GA3507@tiehlicka.suse.cz>
 <4DAEDBEB.7060904@fusionio.com>
 <20110420132903.GA13554@tiehlicka.suse.cz>
 <4DAF18DF.9080205@fusionio.com>
 <20110421071642.GA3556@tiehlicka.suse.cz>
 <5F35AAD2-8277-44BD-86B6-B1D7B816071E@kernel.dk>
 <BANLkTinYv+YW6HVCodsWcCKwMmdZFsXPRA@mail.gmail.com>
 <4DB04D4A.1000803@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB04D4A.1000803@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-04-11 17:29:14, Jens Axboe wrote:
> On 2011-04-21 16:38, Linus Torvalds wrote:
> > On Thu, Apr 21, 2011 at 12:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> I am going to bisect, let's see if I can find anything.
> >>
> >> Thanks, that would be great!
> > 
> > I'd expect it to be very timing-dependent, and thus could easily be
> > triggered (or hidden) by unrelated changes.
> > 
> > Just happening to have a request added to the elevator at _just_ the
> > same moment that another CPU is changing it and getting rid of the
> > data structures for the old one.
> 
> This particular bug does seem to trigger very reliably. The switching
> works by ensuring that we have no requests with elevator data associated
> with it before shutting down the old scheduler and attaching the new
> one. I smells more like a bug on doing an insert sort on a non-priv
> request. I bet this is it, Michal can you give it a spin?

Will try tomorrow.

> 
> diff --git a/block/elevator.c b/block/elevator.c
> index 6f6abc0..45ca1e3 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -671,7 +671,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
>  			q->boundary_rq = rq;
>  		}
>  	} else if (!(rq->cmd_flags & REQ_ELVPRIV) &&
> -		    where == ELEVATOR_INSERT_SORT)
> +		    (where == ELEVATOR_INSERT_SORT ||
> +		     where == ELEVATOR_INSERT_SORT_MERGE))
>  		where = ELEVATOR_INSERT_BACK;
>  
>  	switch (where) {
> 
> -- 
> Jens Axboe
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
