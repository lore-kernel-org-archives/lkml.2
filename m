Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab2HHX6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:58:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58147 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2HHX6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:58:06 -0400
Date: Wed, 8 Aug 2012 16:57:32 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net, snitzer@redhat.com
Subject: Re: [PATCH v5 02/12] dm: Use bioset's front_pad for
 dm_rq_clone_bio_info
Message-ID: <20120808235731.GA7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-3-git-send-email-koverstreet@google.com>
 <20120808220612.GA6983@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808220612.GA6983@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:06:12PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 06, 2012 at 03:08:31PM -0700, Kent Overstreet wrote:
> > Previously, dm_rq_clone_bio_info needed to be freed by the bio's
> > destructor to avoid a memory leak in the blk_rq_prep_clone() error path.
> > This gets rid of a memory allocation and means we can kill
> > dm_rq_bio_destructor.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > ---
> >  drivers/md/dm.c |   31 +++++--------------------------
> >  1 files changed, 5 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 40b7735..4014696 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -92,6 +92,7 @@ struct dm_rq_target_io {
> >  struct dm_rq_clone_bio_info {
> >  	struct bio *orig;
> >  	struct dm_rq_target_io *tio;
> > +	struct bio clone;
> >  };
> ...
> > @@ -2696,7 +2674,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
> >  	if (!pools->tio_pool)
> >  		goto free_io_pool_and_out;
> >  
> > -	pools->bs = bioset_create(pool_size, 0);
> > +	pools->bs = bioset_create(pool_size,
> > +				  offsetof(struct dm_rq_clone_bio_info, orig));
> >  	if (!pools->bs)
> >  		goto free_tio_pool_and_out;
> 
> I do like this approach much better but this isn't something
> super-obvious.  Can we please explain what's going on?  Especially,
> the comment above dm_rq_clone_bio_info is outright misleading now.

This look better to you?

/*
 * For request-based dm - the bio clones we allocate are embedded in these
 * structs.
 *
 * We allocate these with bio_alloc_bioset, using the front_pad parameter when
 * the bioset is created - this means the bio has to come at the end of the
 * struct.
 */
struct dm_rq_clone_bio_info {
	struct bio *orig;
	struct dm_rq_target_io *tio;
	struct bio clone;
};

> Can someone more familiar review this one?  Alasdir, Mike?
> 
> Also, how was this tested?

Well, AFAICT the only request based dm target is multipath, and from the
documentation I've seen it doesn't appear to work without multipath
hardware, or at least I haven't seen it documented how. So, unless
there's another user I missed it's not been tested.

> 
> Thanks.
> 
> -- 
> tejun
