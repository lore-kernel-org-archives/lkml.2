Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1EDVYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:24:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab1EDVY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:24:29 -0400
Date: Wed, 4 May 2011 23:24:27 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] writeback: avoid extra sync work at enqueue time
Message-ID: <20110504212427.GI6968@quack.suse.cz>
References: <20110502031750.135798606@intel.com>
 <20110502033035.789279347@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502033035.789279347@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 02-05-11 11:17:53, Wu Fengguang wrote:
> This removes writeback_control.wb_start and does more straightforward
> sync livelock prevention by setting .older_than_this to prevent extra
> inodes from being enqueued in the first place.
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-05-02 11:17:24.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-05-02 11:17:27.000000000 +0800
> @@ -683,10 +672,12 @@ static long wb_writeback(struct bdi_writ
>  	 *                   (quickly) tag currently dirty pages
>  	 *                   (maybe slowly) sync all tagged pages
>  	 */
> -	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
> +	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync) {
>  		write_chunk = LONG_MAX;
> +		oldest_jif = jiffies;
> +		wbc.older_than_this = &oldest_jif;
> +	}
  What are the implications of not doing dirty-time livelock avoidance for
other types of writeback? Is that a mistake? I'd prefer to have in
wb_writeback():
if (wbc.for_kupdate)
	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
else
	oldest_jif = jiffies;
wbc.older_than_this = &oldest_jif;

And when you have this, you can make wbc.older_than_this just a plain
number and remove all those checks for wbc.older_than_this == NULL.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
