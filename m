Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0IMXJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 19:09:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab0IMXJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 19:09:17 -0400
Date: Mon, 13 Sep 2010 16:09:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Meng <mcpacino@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: calculate block-size correctly
Message-Id: <20100913160905.332ff633.akpm@linux-foundation.org>
In-Reply-To: <20100908100710.GA26365@zhongling.bej.apac.novell.com>
References: <20100908100710.GA26365@zhongling.bej.apac.novell.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010 18:07:10 +0800
Cong Meng <mcpacino@gmail.com> wrote:

> I sent this patch half mount ago, but no response at all. If anything is
> wrong, please tell me. Thanks a lots. This is my first time to send patch
> to linux kernel.
> 
> The invocation of __getblk(bdev, block, size) will cause kernel stall if
> the @size parameter is not equal to the blockr-size of @bdev, which is saved
> in bdev->bd_inode->i_blkbits.
> 
> submit_bh() has the similar problem.
> 
> This patch calculates the block-size using i_blkbits.
> So that, for example, __getblk() can get a 4K buffer head while the
> block-size of @bdev is 1K.
> 

This comes up every couple of years and iirc we always decided that
it's a bug in the calling code somewhere.  How did you hit it?


> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1051,10 +1051,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
>  	pgoff_t index;
>  	int sizebits;
>  
> -	sizebits = -1;
> -	do {
> -		sizebits++;
> -	} while ((size << sizebits) < PAGE_SIZE);

I'm sure the existing code could use __roundup_pow_of_two() here.

