Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab2IUAul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:50:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39290 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663Ab2IUAuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:50:39 -0400
Date: Thu, 20 Sep 2012 17:50:35 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 21/26] block: Convert some code to
 bio_for_each_segment_all()
Message-ID: <20120921005035.GO5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-22-git-send-email-koverstreet@google.com>
 <20120921003832.GY7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921003832.GY7264@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 05:38:32PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 05:22:32PM -0700, Kent Overstreet wrote:
> > A few places in the code were either open coding or using the wrong
> > version - fix.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: NeilBrown <neilb@suse.de>
> > ---
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -921,7 +921,7 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
> >  	if (unlikely(!bvecs))
> >  		return;
> >  
> > -	bio_for_each_segment(bvec, bio, i) {
> > +	bio_for_each_segment_all(bvec, bio, i) {
> 
> I don't get this conversion.  Why is this necessary?

Not necessary, just a consistency thing - this bio is a clone that md
owns (and the clone was trimmed, so we know bi_idx is 0).

Also, it wasn't an issue here but after the patch that introduces the
bvec iter it's no longer possible to modify the biovec through
bio_for_each_segment_all() - it doesn't increment a pointer to the
current bvec, you pass in a struct bio_vec (not a pointer) which is
updated with what the current biovec would be (taking into account
bi_bvec_done and bi_size).

So because of that it is IMO more worthwhile to be consistent about
bio_for_each_segment()/bio_for_each_segment_all() usage.

Suppose I should stick all that in the patch description.
