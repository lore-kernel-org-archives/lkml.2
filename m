Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028Ab2HXSkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:40:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758214Ab2HXSko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:40:44 -0400
Date: Fri, 24 Aug 2012 14:40:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, mpatocka@redhat.com,
        bharrosh@panasas.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH v6 02/13] dm: Use bioset's front_pad for
 dm_rq_clone_bio_info
Message-ID: <20120824184034.GA29932@redhat.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-3-git-send-email-koverstreet@google.com>
 <20120822213010.GA8020@redhat.com>
 <20120824071448.GF11977@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824071448.GF11977@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 12:14:48AM -0700, Kent Overstreet wrote:

[..]
> > > -static struct dm_rq_clone_bio_info *alloc_bio_info(struct mapped_device *md)
> > > -{
> > > -	return mempool_alloc(md->io_pool, GFP_ATOMIC);
> > > -}
> > > -
> > > -static void free_bio_info(struct dm_rq_clone_bio_info *info)
> > > -{
> > > -	mempool_free(info, info->tio->md->io_pool);
> > > -}
> > > -
> > 
> > With this change, do you still need "_rq_bio_info_cache" slab cache? I would
> > think that it can be cleaned up now?
> 
> It looks like it, but I'm hesitent to make more extensive changes to the
> dm code given that I'm unfamiliar with it and I haven't been able to
> personally test the request type dm target code.
> 
> That and the way io_pool is overloaded. I see too many ways I could
> screw things up.

I understand your concern but still if you leave it behind, job is
half done. You moved rq_bio_info in bio front padding but left the
associated cache and mempool behind. I would say we need to clean
it up and then get ACK from dm/md folks.

I am looking at the code and one thing which is not clear to me is
__bind_mempools() which assumes that md->io_pool is always set. With
your change md->io_pool is set only for BIO based targets and not
request based targets. So that will need some tidying up.

Testing of request based target should be easy. Just enable multipath
for your sata disk.


> 
> Also it looks like the equivalent change ought to be done with struct
> dm_io first (then we'd have removed all the users of io_pool), but
> honestly it takes me forever to do anything in the dm code so I'd rather
> leave that to someone else.

I think we can leave io_pool behind. Just that it remains null for
request based targets.

Thanks
Vivek
