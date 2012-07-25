Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2GYXif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:38:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57004 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2GYXid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:38:33 -0400
Date: Wed, 25 Jul 2012 16:38:29 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, agk@redhat.com,
        neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v4 01/12] block: Generalized bio pool freeing
Message-ID: <20120725233829.GE8673@moria.home.lan>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
 <1343160689-12378-2-git-send-email-koverstreet@google.com>
 <500FD32F.2010809@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500FD32F.2010809@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 02:06:23PM +0300, Boaz Harrosh wrote:
> On 07/24/2012 11:11 PM, Kent Overstreet wrote:
> 
> > With the old code, when you allocate a bio from a bio pool you have to
> > implement your own destructor that knows how to find the bio pool the
> > bio was originally allocated from.
> > 
> > This adds a new field to struct bio (bi_pool) and changes
> > bio_alloc_bioset() to use it. This makes various bio destructors
> > unnecessary, so they're then deleted.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> <snip>
> 
> > diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> > index fd47950..be65582 100644
> > --- a/drivers/target/target_core_iblock.c
> > +++ b/drivers/target/target_core_iblock.c
> > @@ -447,14 +447,6 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
> >  	kfree(ibr);
> >  }
> >  
> > -static void iblock_bio_destructor(struct bio *bio)
> > -{
> > -	struct se_cmd *cmd = bio->bi_private;
> > -	struct iblock_dev *ib_dev = cmd->se_dev->dev_ptr;
> > -
> > -	bio_free(bio, ib_dev->ibd_bio_set);
> > -}
> > -
> >  static struct bio *
> >  iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
> >  {
> > @@ -475,8 +467,15 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
> >  	}
> >  
> >  	bio->bi_bdev = ib_dev->ibd_bd;
> > +<<<<<<< HEAD
> >  	bio->bi_private = cmd;
> >  	bio->bi_destructor = iblock_bio_destructor;
> > +||||||| merged common ancestors
> > +	bio->bi_private = task;
> > +	bio->bi_destructor = iblock_bio_destructor;
> > +=======
> > +	bio->bi_private = task;
> > +>>>>>>> block: Generalized bio pool freeing
> >  	bio->bi_end_io = &iblock_bio_done;
> >  	bio->bi_sector = lba;
> >  	return bio;
> 
> 
> You left out a rebase merge conflict. Did you allmodconfig compile
> these patches?

Argh, clearly not. And I even fixed that rebase merge conflict at one
point, that's distressing.
