Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2HXHPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:15:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38809 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2HXHPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:15:22 -0400
Date: Fri, 24 Aug 2012 00:14:48 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, mpatocka@redhat.com,
        bharrosh@panasas.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH v6 02/13] dm: Use bioset's front_pad for
 dm_rq_clone_bio_info
Message-ID: <20120824071448.GF11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-3-git-send-email-koverstreet@google.com>
 <20120822213010.GA8020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822213010.GA8020@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 05:30:10PM -0400, Vivek Goyal wrote:
> On Wed, Aug 22, 2012 at 10:03:59AM -0700, Kent Overstreet wrote:
> > Previously, dm_rq_clone_bio_info needed to be freed by the bio's
> > destructor to avoid a memory leak in the blk_rq_prep_clone() error path.
> > This gets rid of a memory allocation and means we can kill
> > dm_rq_bio_destructor.
> > 
> > v6: Fix comment on struct dm_rq_clone_bio_info, per Tejun
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Alasdair Kergon <agk@redhat.com>
> > ---
> >  drivers/md/dm.c | 39 +++++++++++----------------------------
> >  1 file changed, 11 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 0c3d6dd..5ed9779 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -86,12 +86,17 @@ struct dm_rq_target_io {
> >  };
> >  
> >  /*
> > - * For request-based dm.
> > - * One of these is allocated per bio.
> > + * For request-based dm - the bio clones we allocate are embedded in these
> > + * structs.
> > + *
> > + * We allocate these with bio_alloc_bioset, using the front_pad parameter when
> > + * the bioset is created - this means the bio has to come at the end of the
> > + * struct.
> >   */
> >  struct dm_rq_clone_bio_info {
> >  	struct bio *orig;
> >  	struct dm_rq_target_io *tio;
> > +	struct bio clone;
> >  };
> >  
> >  union map_info *dm_get_mapinfo(struct bio *bio)
> > @@ -467,16 +472,6 @@ static void free_rq_tio(struct dm_rq_target_io *tio)
> >  	mempool_free(tio, tio->md->tio_pool);
> >  }
> >  
> > -static struct dm_rq_clone_bio_info *alloc_bio_info(struct mapped_device *md)
> > -{
> > -	return mempool_alloc(md->io_pool, GFP_ATOMIC);
> > -}
> > -
> > -static void free_bio_info(struct dm_rq_clone_bio_info *info)
> > -{
> > -	mempool_free(info, info->tio->md->io_pool);
> > -}
> > -
> 
> With this change, do you still need "_rq_bio_info_cache" slab cache? I would
> think that it can be cleaned up now?

It looks like it, but I'm hesitent to make more extensive changes to the
dm code given that I'm unfamiliar with it and I haven't been able to
personally test the request type dm target code.

That and the way io_pool is overloaded. I see too many ways I could
screw things up.

Also it looks like the equivalent change ought to be done with struct
dm_io first (then we'd have removed all the users of io_pool), but
honestly it takes me forever to do anything in the dm code so I'd rather
leave that to someone else.
