Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1ANLZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 06:25:42 -0500
Received: from mail09.linbit.com ([212.69.161.110]:54962 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1ANLZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 06:25:36 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 06:25:36 EST
Date: Fri, 14 Jan 2011 12:17:30 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: bio_add_page of higher order pages?
Message-ID: <20110114111730.GN25975@barkeeper1-xen.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Someone wants to be able to add higher order pages to a bio_vec.
This is not my idea, but I was asked to comment on it,
but I'm not sure if this was allowed or even expected.
Somehow this question came up recently, and I have not been able to find
explicit documentation stating either way.

There is

/*
 * was unsigned short, but we might as well be ready for > 64kB I/O pages
 */
struct bio_vec {
	struct page	*bv_page;
	unsigned int	bv_len;
	unsigned int	bv_offset;
};


and

/**
 *	bio_add_page	-	attempt to add page to bio
 *	@bio: destination bio
 *	@page: page to add
 *	@len: vec entry length
 *	@offset: vec entry offset
 *
 *	Attempt to add a page to the bio_vec maplist. This can fail for a
 *	number of reasons, such as the bio being full or target block
 *	device limitations. The target block device must allow bio's
 *      smaller than PAGE_SIZE, so it is always possible to add a single
 *      page to an empty bio.
 */
int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
		 unsigned int offset)



Is it legal, or even expected, to be able to
	page = alloc_pages(3);
	bio_add_page(bio, page, 4*PAGE_SIZE+1536, 2*PAGE_SIZE + 512);

That is, can bv_len and bv_offset be >= PAGE_SIZE?

If so, that should be stated somewhere,
and I think various pieces would need fixing.
__blk_queue_bounce, the md raid5 stripe cache,
drbd (where is uses tcp_sendpage for each bio_vec),
probably more.

If not, (bv_offset + bv_len) <= PAGE_SIZE
should be clearly documented and enforced.

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
