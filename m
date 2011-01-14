Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1ANOon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:44:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1ANOoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:44:37 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: David Dillow <dillowda@ornl.gov>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: fs/direct-io.c: don't try to allocate more than BIO_MAX_PAGES in a bio
References: <1294977946.21790.20.camel@obelisk.thedillows.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 14 Jan 2011 09:44:33 -0500
In-Reply-To: <1294977946.21790.20.camel@obelisk.thedillows.org> (David
	Dillow's message of "Thu, 13 Jan 2011 23:05:46 -0500")
Message-ID: <x498vynbl4e.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Dillow <dillowda@ornl.gov> writes:

> When using devices that support max_segments > BIO_MAX_PAGES (256),
> direct IO tries to allocate a bio with more pages than allowed, which
> leads to an oops in dio_bio_alloc(). Clamp that request to the supported
> maximum.
>
> Signed-off-by: David Dillow <dillowda@ornl.gov>
> --
> dio_bio_alloc() doesn't check the result of bio_alloc(), so it
> dereferences a NULL pointer. bio_alloc(GFP_KERNEL, ...) doesn't fail
> unless it gets called for an invalid number of pages, so it seems a bit
> like overkill to check for failure in dio_bio_alloc(), though it would
> have saved me some time tracking this down.

We should always be checking return values.  Mind respinning the patch
to include that?

> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 85882f6..9eb0553 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -583,6 +583,7 @@ static int dio_new_bio(struct dio *dio, sector_t start_sector)
>  		goto out;
>  	sector = start_sector << (dio->blkbits - 9);
>  	nr_pages = min(dio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
> +	nr_pages = min(nr_pages, BIO_MAX_PAGES);

This looks fine.  Thanks for tracking it down!

Cheers,
Jeff
