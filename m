Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab2ITXgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:36:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42487 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab2ITXgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:36:35 -0400
Date: Thu, 20 Sep 2012 16:36:32 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 03/26] block: Refactor blk_update_request()
Message-ID: <20120920233632.GC5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-4-git-send-email-koverstreet@google.com>
 <20120920232000.GG7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920232000.GG7264@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 04:20:00PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Sep 10, 2012 at 05:22:14PM -0700, Kent Overstreet wrote:
> >  static void req_bio_endio(struct request *rq, struct bio *bio,
> >  			  unsigned int nbytes, int error)
> >  {
> > +	/*
> > +	 * XXX: bio_endio() does this. only need this because of the weird
> > +	 * flush seq thing.
> > +	 */
> >  	if (error)
> >  		clear_bit(BIO_UPTODATE, &bio->bi_flags);
> >  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> >  		error = -EIO;
> 
> Isn't this also necessary to record errors on partial completions?

Ah yeah, you're right. Meant to delete that comment anyways.

> Other than that, I definitely like this.  It would be nice to note
> that the custom partial bio advancing in blk_update_request() is
> replaced with multiple calls to req_bio_endio().  I don't think it has
> any meaningful performance implications.  It's just nice to future
> readers of the commit.

The number of calls to req_bio_endio() isn't changing...
blk_update_request() called it for partial completions before. It's just
where the bio itself is updated that's getting shuffled around.

Or did you mean that bio_advance() is getting called on every bio
instead of the custom advancing in blk_update_request() before? That is
different, yeah - it's now always looping over the iovec, not just for
partial completions.

Yeah, I will note that in the commit message, in case Jens sees a
performance regression from it :)

> Also, it would be really nice if you can verify this actually works
> with partial blk_update_request().  sector update bug in the previous
> patch scares me a bit.  Implementing some debug hacks in the
> completion path might be the easiest way to verify.  A subtle bug here
> could be pretty painful.

Any suggestions on how to trigger partial updates?
