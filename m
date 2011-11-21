Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab1KUXg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:36:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1KUXgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:36:25 -0500
Date: Mon, 21 Nov 2011 15:36:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 8/8] readahead: dont do start-of-file readahead after
 lseek()
Message-Id: <20111121153624.dea4f320.akpm@linux-foundation.org>
In-Reply-To: <20111121093847.015852579@intel.com>
References: <20111121091819.394895091@intel.com>
	<20111121093847.015852579@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 17:18:27 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Some applications (eg. blkid, id3tool etc.) seek around the file
> to get information. For example, blkid does
> 
> 	     seek to	0
> 	     read	1024
> 	     seek to	1536
> 	     read	16384
> 
> The start-of-file readahead heuristic is wrong for them, whose
> access pattern can be identified by lseek() calls.

ah, there we are.

> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/read_write.c    |    4 ++++
>  include/linux/fs.h |    1 +
>  mm/readahead.c     |    3 +++
>  3 files changed, 8 insertions(+)
> 
> --- linux-next.orig/mm/readahead.c	2011-11-20 22:02:01.000000000 +0800
> +++ linux-next/mm/readahead.c	2011-11-20 22:02:03.000000000 +0800
> @@ -629,6 +629,8 @@ ondemand_readahead(struct address_space 
>  	 * start of file
>  	 */
>  	if (!offset) {
> +		if ((ra->ra_flags & READAHEAD_LSEEK) && req_size < max)
> +			goto random_read;
>  		ra_set_pattern(ra, RA_PATTERN_INITIAL);
>  		goto initial_readahead;
>  	}
> @@ -707,6 +709,7 @@ ondemand_readahead(struct address_space 
>  	if (try_context_readahead(mapping, ra, offset, req_size, max))
>  		goto readit;
>  
> +random_read:
>  	/*
>  	 * standalone, small random read
>  	 */
> --- linux-next.orig/fs/read_write.c	2011-11-20 22:02:01.000000000 +0800
> +++ linux-next/fs/read_write.c	2011-11-20 22:02:03.000000000 +0800
> @@ -47,6 +47,10 @@ static loff_t lseek_execute(struct file 
>  		file->f_pos = offset;
>  		file->f_version = 0;
>  	}
> +
> +	if (!(file->f_ra.ra_flags & READAHEAD_LSEEK))
> +		file->f_ra.ra_flags |= READAHEAD_LSEEK;
> +
>  	return offset;
>  }

Confused.  How does READAHEAD_LSEEK get cleared again?
