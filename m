Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab2ERUji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:39:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59024 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561Ab2ERUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:39:36 -0400
Date: Fri, 18 May 2012 13:39:32 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, yehuda@hq.newdream.net,
        sage@newdream.net
Subject: Re: [PATCH 04/13] block: Add bio_clone_kmalloc()
Message-ID: <20120518203932.GD9673@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <1c7c2d4b89bc3d0e907608cec37bcf0ee50f4c0e.1337308722.git.koverstreet@google.com>
 <20120518160903.GD19388@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518160903.GD19388@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 09:09:03AM -0700, Tejun Heo wrote:
> On Thu, May 17, 2012 at 10:59:51PM -0400, koverstreet@google.com wrote:
> > @@ -729,7 +729,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
> >  	}
> >  
> >  	while (old_chain && (total < len)) {
> > -		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
> > +		tmp = bio_clone_kmalloc(old_chain, gfpmask);
> >  		if (!tmp)
> >  			goto err_out;
> >  
> > @@ -751,13 +751,9 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
> >  			if (!bp)
> >  				goto err_out;
> >  
> > -			__bio_clone(tmp, &bp->bio1);
> > -
> 
> This effectively swaps the order of bio_split() and __bio_clone().  Is
> that safe?  Also, please cc the maintainer.

Now that I look at that code some more, I'm not sure it was quite right
before - that or I don't follow how it's supposed to work.

That bio_split() effectively does its own clone, so it seems to me the
bio_kmalloc()/bio_clone_kmalloc() should only be happening in the non
split case.

Also, there's a bio_chain_clone in drivers/block/osdblk.c that looks
like it's doing something similar, probably we should have some generic
code for this.
