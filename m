Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab1JSRNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:13:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55029 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1JSRNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:13:04 -0400
Date: Wed, 19 Oct 2011 10:12:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com
Subject: Re: [PATCH 10/10] block: fix request_queue lifetime handling by
 making blk_queue_cleanup() proper shutdown
Message-ID: <20111019171259.GE25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-11-git-send-email-tj@kernel.org>
 <20111019161840.GG1140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019161840.GG1140@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 19, 2011 at 12:18:40PM -0400, Vivek Goyal wrote:
> > diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> > index 900a0c9..8edb949 100644
> > --- a/block/blk-throttle.c
> > +++ b/block/blk-throttle.c
> > @@ -309,6 +309,10 @@ static struct throtl_grp * throtl_get_tg(struct throtl_data *td)
> >  	struct blkio_cgroup *blkcg;
> >  	struct request_queue *q = td->queue;
> >  
> > +	/* no throttling for dead queue */
> > +	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
> > +		return NULL;
> > +
> 
> May be blk_throtl_bio() is probably a better place to do this check, just
> before callig throtl_get_tg().

Hmmm... the thing is you need to check DEAD again once after releasing
and re-grabbing the queuelock, os if we move the test into the caller,
we end up having one in the caller and one in the callee, so I thought
it would be better to keep them in the same function.  My opinion on
it isn't too strong tho.  If you feel strong about it, please feel
free to move it.

Thank you.

-- 
tejun
