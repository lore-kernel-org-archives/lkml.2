Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2ITXUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:20:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab2ITXUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:20:05 -0400
Date: Thu, 20 Sep 2012 16:20:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 03/26] block: Refactor blk_update_request()
Message-ID: <20120920232000.GG7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-4-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-4-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 10, 2012 at 05:22:14PM -0700, Kent Overstreet wrote:
>  static void req_bio_endio(struct request *rq, struct bio *bio,
>  			  unsigned int nbytes, int error)
>  {
> +	/*
> +	 * XXX: bio_endio() does this. only need this because of the weird
> +	 * flush seq thing.
> +	 */
>  	if (error)
>  		clear_bit(BIO_UPTODATE, &bio->bi_flags);
>  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
>  		error = -EIO;

Isn't this also necessary to record errors on partial completions?

Other than that, I definitely like this.  It would be nice to note
that the custom partial bio advancing in blk_update_request() is
replaced with multiple calls to req_bio_endio().  I don't think it has
any meaningful performance implications.  It's just nice to future
readers of the commit.

Also, it would be really nice if you can verify this actually works
with partial blk_update_request().  sector update bug in the previous
patch scares me a bit.  Implementing some debug hacks in the
completion path might be the easiest way to verify.  A subtle bug here
could be pretty painful.

Thanks.

-- 
tejun
