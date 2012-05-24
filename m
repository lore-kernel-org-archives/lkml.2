Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828Ab2EXT7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966220Ab2EXT6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:58:25 -0400
Date: Thu, 24 May 2012 15:58:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: axboe@kernel.dk, yehuda@hq.newdream.net, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        linux-bcache@vger.kernel.org, mpatocka@redhat.com,
        bharrosh@panasas.com, linux-fsdevel@vger.kernel.org, sage@newdream.net,
        agk@redhat.com, drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH v2 08/14] block: Kill bi_destructor
Message-ID: <20120524195810.GB28249@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-9-git-send-email-koverstreet@google.com>
 <20120524195202.GG27550@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524195202.GG27550@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 03:52:02PM -0400, Vivek Goyal wrote:
> On Wed, May 23, 2012 at 05:02:45PM -0700, Kent Overstreet wrote:
> 
> [..]
> > @@ -234,6 +234,13 @@ void bio_free(struct bio *bio, struct bio_set *bs)
> >  {
> >  	void *p;
> >  
> > +	if (!bs) {
> > +		if (bio_integrity(bio))
> > +			bio_integrity_free(bio, fs_bio_set);
> > +		kfree(bio);
> > +		return;
> > +	}
> > +
> 
> Ok, this seems to be the code which will take care of freeing kmalloced
> bio. I think putting little comment about the explicit assumption is not
> a bad idea.
> 
> Somehow we need to integrate two patches so that we don't have memory leak
> in bisection and reading code becomes easier.
> 
> Also then what's the need of bio_reset() in previous patch. That seems to
> be independent from getting rid of pkt_bio_destructor(). I would think
> that keep we can split the patch and keep bio_reset() logic in a separate
> patch. In fact I am not even sure that for one driver we should introduce
> bio_reset() in generic block layer. So to me we should get rid of bio_reset()
> and let all the gory details remain in driver.

Just noticed bio_kmalloc_destructor() will take care of freeing bio_kmalloc()
bios and it has been dropped in this patch. So memory leak point is moot.
bio_reset() question still remains though.

Thanks
Vivek
