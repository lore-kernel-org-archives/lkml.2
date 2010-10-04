Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab0JDR6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:58:31 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47933 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756555Ab0JDR6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:58:30 -0400
Date: Mon, 4 Oct 2010 19:58:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [PATCH] Hibernate: Implement readahead when resuming
Message-ID: <20101004175822.GK1518@ucw.cz>
References: <1285416056-9735-1-git-send-email-nigel@tuxonice.net>
 <1285416056-9735-2-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285416056-9735-2-git-send-email-nigel@tuxonice.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add support for submitting reads before they're needed. This greatly
> improves the speed of resuming:
> 
> From
> 
> PM: Image read at 66 MB/s.
> 
> to
> 
> PM: Image read at 229 MB/s.
> 
> ...and removes the need for the sync_read flag.

Hmm, not bad.

> @@ -67,13 +70,14 @@ static void hib_end_bio(struct bio *bio, int err)
>   *	@off	physical offset of page.
>   *	@page:	page we're reading or writing.
>   *	@sync:	whether the i/o should be done synchronously
> + *	@ra:	whether the page is readahead
>   *

This sync flag?

Merge sync and ra into 'flags' to make code easier to read?

>   *	Straight from the textbook - allocate and initialize the bio.
>   *	If we're reading, make sure the page is marked as dirty.
>   *	Then submit it and, if @sync, wait.
>   */
>  static int submit(int rw, struct block_device *bdev, sector_t sector,
> -		struct page *page, int sync)
> +		struct page *page, int sync, int ra)
>  {
>  	const int bio_rw = rw | REQ_SYNC | REQ_UNPLUG;
>  	struct bio *bio;

> +	printk("(1) Submitting readahead of sector %llu to page %p.\n",
> +			offset, ra_page);

KERN_INFO?

> +	return submit(READ, hib_resume_bdev, offset * (PAGE_SIZE >> 9),
> +			ra_page, 0, 1);
> +}
> +
> +int start_more_readahead(void)

Too generic name for global function?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
