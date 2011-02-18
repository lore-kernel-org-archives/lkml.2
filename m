Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1BRPEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:04:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab1BRPEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:04:33 -0500
Date: Fri, 18 Feb 2011 10:04:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit taking q->queue_lock is problematic
Message-ID: <20110218150429.GB26654@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
 <20110216155305.GC14653@redhat.com>
 <20110217113536.2bbf308e@notabene.brown>
 <20110217011029.GA6793@redhat.com>
 <20110217165501.47f3c26f@notabene.brown>
 <20110217165906.GE9075@redhat.com>
 <20110218134025.2a2e5bbb@notabene.brown>
 <AANLkTi=t0vFTTDr9jBZ70UmJ9YYzziA0cRP8t0T9wswW@mail.gmail.com>
 <20110218143325.5738e127@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110218143325.5738e127@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 02:33:25PM +1100, NeilBrown wrote:
> On Thu, 17 Feb 2011 22:19:52 -0500 Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Thu, Feb 17, 2011 at 9:40 PM, NeilBrown <neilb@suse.de> wrote:
> > > On Thu, 17 Feb 2011 11:59:06 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> > >> So if we do this change for performance reasons, it still makes sense
> > >> but doing this change because md provided a q->queue_lock and took away that
> > >> lock without notifying block layer hence we do this change, is still not
> > >> the right reason, IMHO.
> > >
> > > Well...I like that patch, as it makes my life easier....
> > >
> > > But I agree that md is doing something wrong.  Now that ->queue_lock is
> > > always initialised, it is wrong to leave it in a state where it not defined.
> > >
> > > So maybe I'll apply this (after testing it a bit.  The only reason for taking
> > > the lock queue_lock in a couple of places is to silence some warnings.
> > >
> > > Thanks,
> > > NeilBrown
> > >
> > >
> > > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > > index a23ffa3..909282d 100644
> > > --- a/drivers/md/raid1.c
> > > +++ b/drivers/md/raid1.c
> > > @@ -959,7 +961,9 @@ static int make_request(mddev_t *mddev, struct bio * bio)
> > >                atomic_inc(&r1_bio->remaining);
> > >                spin_lock_irqsave(&conf->device_lock, flags);
> > >                bio_list_add(&conf->pending_bio_list, mbio);
> > > +               spin_lock(mddev->queue->queue_lock);
> > >                blk_plug_device(mddev->queue);
> > > +               spin_unlock(mddev->queue->queue_lock);
> > >                spin_unlock_irqrestore(&conf->device_lock, flags);
> > >        }
> > >        r1_bio_write_done(r1_bio, bio->bi_vcnt, behind_pages, behind_pages != NULL);
> > 
> > Noticed an inconsistency, raid10.c's additional locking also protects
> > the bio_list_add() whereas raid1.c's doesn't.  Seems the additional
> > protection in raid10 isn't needed?
> 
> Correct - not needed at all.
> I put it there because it felt a little cleaner keeping the two 'lock's
> together like the two 'unlock's.  Probably confusing though...

I guess you could use blk_plug_device_unlocked() to get rid of ugliness
and this routine will take care of taking queue lock.

Thanks
Vivek
