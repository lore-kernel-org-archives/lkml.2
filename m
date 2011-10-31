Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576Ab1JaQCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 12:02:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23761 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538Ab1JaQB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 12:01:59 -0400
Date: Mon, 31 Oct 2011 12:01:45 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: add block plug for .writepages
Message-ID: <20111031160145.GD4468@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
References: <1320075907-4079-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320075907-4079-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EAEC675.01E6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 12:45:07AM +0900, Namjae Jeon wrote:
> Add block plug for btrfs .writepages. Block plug is helpful to reduce block lock contention.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  fs/btrfs/extent_io.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d418164..8f2d6bd 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2388,6 +2388,7 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
>  	pgoff_t end;		/* Inclusive */
>  	int scanned = 0;
>  	int tag;
> +	struct blk_plug plug;
>  
>  	pagevec_init(&pvec, 0);
>  	if (wbc->range_cyclic) {
> @@ -2405,6 +2406,8 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
>  retry:
>  	if (wbc->sync_mode == WB_SYNC_ALL)
>  		tag_pages_for_writeback(mapping, index, end);
> +
> +	blk_start_plug(&plug);
>  	while (!done && !nr_to_write_done && (index <= end) &&
>  	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
>  			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
> @@ -2468,6 +2471,7 @@ retry:
>  		pagevec_release(&pvec);
>  		cond_resched();
>  	}
> +	blk_finish_plug(&plug);
>  	if (!scanned && !done) {
>  		/*
>  		 * We hit the last page and there is more work to be done: wrap

Thanks for the patch, but we actually do this at a lower level in btrfs.
The actual IO can be done to multiple block devices, so we try to plug
for each device individually.

-chris

