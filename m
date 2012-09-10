Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2IJRWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:22:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37624 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2IJRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:22:16 -0400
Date: Mon, 10 Sep 2012 10:22:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, Vivek Goyal <vgoyal@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        david@fromorbit.com
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120910172210.GC14103@google.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
 <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910002810.GA23241@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Sun, Sep 09, 2012 at 05:28:10PM -0700, Kent Overstreet wrote:
> > > +	while ((bio = bio_list_pop(current->bio_list)))
> > > +		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> > > +
> > > +	*current->bio_list = nopunt;
> > 
> > Why this is necessary needs explanation and it's done in rather
> > unusual way.  I suppose the weirdness is from bio_list API
> > restriction?
> 
> It's because bio_lists are singly linked, so deleting an entry from the
> middle of the list would be a real pain - just much cleaner/simpler to
> do it this way.

Yeah, I wonder how benefical that singly linked list is.  Eh well...

> > Wouldn't the following be better?
> > 
> > 	p = mempool_alloc(bs->bi_pool, gfp_mask);
> > 	if (unlikely(!p) && gfp_mask != saved_gfp) {
> > 		punt_bios_to_rescuer(bs);
> > 		p = mempool_alloc(bs->bi_pool, saved_gfp);
> > 	}
> 
> That'd require duplicating the error handling in two different places -
> once for the initial allocation, once for the bvec allocation. And I
> really hate that writing code that does
> 
> alloc_something()
> if (fail) {
> 	alloc_something_again()
> }
> 
> it just screams ugly to me.

I don't know.  That at least represents what's going on and goto'ing
back and forth is hardly pretty.  Sometimes the code gets much uglier
/ unwieldy and we have to live with gotos.  Here, that doesn't seem to
be the case.

> +static void punt_bios_to_rescuer(struct bio_set *bs)
> +{
> +	struct bio_list punt, nopunt;
> +	struct bio *bio;
> +
> +	/*
> +	 * Don't want to punt all bios on current->bio_list; if there was a bio
> +	 * on there for a stacking driver higher up in the stack, processing it
> +	 * could require allocating bios from this bio_set, and we don't want to
> +	 * do that from our own rescuer.

Hmmm... isn't it more like we "must" process only the bios which are
from this bio_set to have any kind of forward-progress guarantee?  The
above sounds like it's just something undesirable.

Thanks.

-- 
tejun
