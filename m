Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab1JSR3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:29:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab1JSR3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:29:19 -0400
Date: Wed, 19 Oct 2011 13:29:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com
Subject: Re: [PATCH 10/10] block: fix request_queue lifetime handling by
 making blk_queue_cleanup() proper shutdown
Message-ID: <20111019172914.GI1140@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-11-git-send-email-tj@kernel.org>
 <20111019161840.GG1140@redhat.com>
 <20111019171259.GE25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019171259.GE25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 10:12:59AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 19, 2011 at 12:18:40PM -0400, Vivek Goyal wrote:
> > > diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> > > index 900a0c9..8edb949 100644
> > > --- a/block/blk-throttle.c
> > > +++ b/block/blk-throttle.c
> > > @@ -309,6 +309,10 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
> > >  	struct blkio_cgroup *blkcg;
> > >  	struct request_queue *q = td->queue;
> > >  
> > > +	/* no throttling for dead queue */
> > > +	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
> > > +		return NULL;
> > > +
> > 
> > May be blk_throtl_bio() is probably a better place to do this check, just
> > before callig throtl_get_tg().
> 
> Hmmm... the thing is you need to check DEAD again once after releasing
> and re-grabbing the queuelock, os if we move the test into the caller,
> we end up having one in the caller and one in the callee, so I thought
> it would be better to keep them in the same function.

Sorry I did not get that why do we need to check again for DEAD after
realeasing the queue lock. From throttling perspective, we grab lock
once, if queue is DEAD, release lock and just return.

blk_throtl_bio() {

  bunch_of_checks_without_queue_lock;

  spin_lock()
  if (queue_dead) {
	spin_unlock()
	return;
  }

  throtl_get_tg();
}	

> My opinion on
> it isn't too strong tho.  If you feel strong about it, please feel
> free to move it.

No, this is a minor nit. Probably will change it sometime in future as part
of some other work in blk-throttle.

Thanks
Vivek
