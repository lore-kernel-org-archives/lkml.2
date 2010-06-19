Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0FSKpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 06:45:10 -0400
Received: from verein.lst.de ([213.95.11.210]:36949 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab0FSKpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 06:45:07 -0400
Date: Sat, 19 Jun 2010 12:44:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org,
       david@fromorbit.com, hch@lst.de, axboe@kernel.dk
Subject: Re: [PATCH 1/3] writeback: Creating /sys/kernel/mm/writeback/writeback
Message-ID: <20100619104439.GA7659@lst.de>
References: <1276907415-504-1-git-send-email-mrubin@google.com> <1276907415-504-2-git-send-email-mrubin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276907415-504-2-git-send-email-mrubin@google.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 05:30:13PM -0700, Michael Rubin wrote:
> Adding the /sys/kernel/mm/writeback/writeback file.  It contains data
> to help developers and applications gain visibility into writeback
> behaviour.
> 
>     # cat /sys/kernel/mm/writeback/writeback
>     pages_dirtied:    3747
>     pages_cleaned:    3618
>     dirty_threshold:  816673
>     bg_threshold:     408336

I'm fine with exposting this. but the interface is rather awkward.
These kinds of multiple value per file interface require addition
parsing and are a pain to extend.  Please do something like

/proc/sys/vm/writeback/

			pages_dirtied
			pages_cleaned
			dirty_threshold
			background_threshold

where you can just read the value from the file.

> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index c920164..84b0181 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -1598,8 +1598,10 @@ nilfs_copy_replace_page_buffers(struct page *page, struct list_head *out)
>  	} while (bh = bh->b_this_page, bh2 = bh2->b_this_page, bh != head);
>  	kunmap_atomic(kaddr, KM_USER0);
>  
> -	if (!TestSetPageWriteback(clone_page))
> +	if (!TestSetPageWriteback(clone_page)) {
>  		inc_zone_page_state(clone_page, NR_WRITEBACK);
> +		inc_zone_page_state(clone_page, NR_PAGES_ENTERED_WRITEBACK);
> +	}
>  	unlock_page(clone_page);

I'm not very happy about having this opencoded in a filesystem.

