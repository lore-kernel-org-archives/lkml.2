Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966248Ab2EXUAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:00:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37021 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966126Ab2EXUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:00:16 -0400
Date: Thu, 24 May 2012 13:00:12 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 08/14] block: Kill bi_destructor
Message-ID: <20120524200012.GB18624@google.com>
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

Yeah, it's changing the semantics of bio_free(). I'll document that.

> Somehow we need to integrate two patches so that we don't have memory leak
> in bisection and reading code becomes easier.

I don't think there's any memory leak issues with this patch... there
are various annoyances with the dm code, though.

> Also then what's the need of bio_reset() in previous patch. That seems to
> be independent from getting rid of pkt_bio_destructor(). I would think
> that keep we can split the patch and keep bio_reset() logic in a separate
> patch. In fact I am not even sure that for one driver we should introduce
> bio_reset() in generic block layer. So to me we should get rid of bio_reset()
> and let all the gory details remain in driver.

Well, it would be possible to kill bi_destructor without introducing
bio_reset() - but that'd mean the kill bi_destructor patch would have to
muck around in the pktcdvd code. IMO introducing bio_reset() makes the
rest of the patch series much cleaner.
