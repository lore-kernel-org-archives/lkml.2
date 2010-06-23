Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0FWUlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:41:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab0FWUlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:41:52 -0400
Date: Wed, 23 Jun 2010 16:41:19 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tao Ma <tao.ma@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
       Christoph Hellwig <hch@lst.de>, stable@kernel.org
Subject: Re: block: Don't count_vm_events for discard bio in submit_bio.
Message-ID: <20100623204118.GB31560@redhat.com>
References: <1277263491-4068-1-git-send-email-tao.ma@oracle.com>
 <20100623124046.4dec96d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623124046.4dec96d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23 2010 at  3:40pm -0400,
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 23 Jun 2010 11:24:51 +0800
> Tao Ma <tao.ma@oracle.com> wrote:
> 
> > In submit_bio, we count vm events by check READ/WRITE.
> > But actually DISCARD_NOBARRIER also has the WRITE flag set.
> > It looks as if in blkdev_issue_discard, we also add a
> > page as the payload and the bio_has_data check isn't enough.
> > So add another check for discard bio.
> > 
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Tao Ma <tao.ma@oracle.com>
> > ---
> >  block/blk-core.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index f84cce4..a725602 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1586,7 +1586,7 @@ void submit_bio(int rw, struct bio *bio)
> >  	 * If it's a regular read/write or a barrier with data attached,
> >  	 * go through the normal accounting stuff before submission.
> >  	 */
> > -	if (bio_has_data(bio)) {
> > +	if (bio_has_data(bio) && !(rw & BIO_RW_DISCARD)) {
> >  		if (rw & WRITE) {
> >  			count_vm_events(PGPGOUT, count);
> >  		} else {
> 
> Yes, that's a buglet.
> 
> Note that Christoph's "[PATCH, RFC] block: don't allocate a payload for
> discard request" will fix it in a better way.

Oddly, even with Christoph's patch, bio_has_data() is still true once
the discard bio gets to DM.

Figuring out why is on my near-term TODO.

Mike
