Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0KXLOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:14:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:41640 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab0KXLOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:14:17 -0500
Subject: Re: [PATCH 08/13] writeback: quit throttling when bdi dirty pages
 dropped low
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101117042850.245782303@intel.com>
References: <20101117042720.033773013@intel.com>
	 <20101117042850.245782303@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 12:13:53 +0100
Message-ID: <1290597233.2072.454.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:

> @@ -578,6 +579,25 @@ static void balance_dirty_pages(struct a
>  				    bdi_stat(bdi, BDI_WRITEBACK);
>  		}
>  
> +		/*
> +		 * bdi_thresh takes time to ramp up from the initial 0,
> +		 * especially for slow devices.
> +		 *
> +		 * It's possible that at the moment dirty throttling starts,
> +		 * 	bdi_dirty = nr_dirty
> +		 * 		  = (background_thresh + dirty_thresh) / 2
> +		 * 		  >> bdi_thresh
> +		 * Then the task could be blocked for a dozen second to flush
> +		 * all the exceeded (bdi_dirty - bdi_thresh) pages. So offer a
> +		 * complementary way to break out of the loop when 250ms worth
> +		 * of dirty pages have been cleaned during our pause time.
> +		 */
> +		if (nr_dirty < dirty_thresh &&
> +		    bdi_prev_dirty - bdi_dirty >
> +		    bdi->write_bandwidth >> (PAGE_CACHE_SHIFT + 2))
> +			break;
> +		bdi_prev_dirty = bdi_dirty;
> +
>  		if (bdi_dirty >= bdi_thresh) {
>  			pause = HZ/10;
>  			goto pause;


So we're testing to see if during our pause time (<=100ms) we've written
out 250ms worth of pages (given our current bandwidth estimation),
right? 

(1/4th of bandwidth in bytes/s is bytes per 0.25s) 

(and in your recent patches you've changed the bw to pages/s so I take
it the PAGE_CACHE_SIZE will be gone from all these sites).


