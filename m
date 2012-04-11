Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204Ab2DKU0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:26:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761188Ab2DKU0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:26:37 -0400
Date: Wed, 11 Apr 2012 13:26:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <devel@openvz.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
Message-Id: <20120411132635.bfddc6bd.akpm@linux-foundation.org>
In-Reply-To: <1334167824-19142-1-git-send-email-glommer@parallels.com>
References: <1334167824-19142-1-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012 15:10:24 -0300
Glauber Costa <glommer@parallels.com> wrote:

> While stressing the kernel with with failing allocations today,
> I hit the following chain of events:
> 
> alloc_page_buffers():
> 
> 	bh = alloc_buffer_head(GFP_NOFS);
> 	if (!bh)
> 		goto no_grow; <= path taken
> 
> grow_dev_page():
>         bh = alloc_page_buffers(page, size, 0);
>         if (!bh)
>                 goto failed;  <= taken, consequence of the above
> 
> and then the failed path BUG()s the kernel.
> 
> The failure is inserted a litte bit artificially, but even then,
> I see no reason why it should be deemed impossible in a real box.
> 
> Even though this is not a condition that we expect to see
> around every time, failed allocations are expected to be handled,
> and BUG() sounds just too much. As a matter of fact, grow_dev_page()
> can return NULL just fine in other circumstances, so I propose we just
> remove it, then.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/buffer.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 36d6665..351e18e 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -985,7 +985,6 @@ grow_dev_page(struct block_device *bdev, sector_t block,
>  	return page;
>  
>  failed:
> -	BUG();
>  	unlock_page(page);
>  	page_cache_release(page);
>  	return NULL;

Cute.

AFAICT what happened was that in my April 2002 rewrite of this code I
put a non-fatal buffer_error() warning in that case to tell us that
something bad happened.

Years later we removed the temporary buffer_error() and mistakenly
replaced that warning with a BUG().  Only it *can* happen.

We can remove the BUG() and fix up callers, or we can pass retry=1 into
alloc_page_buffers(), so grow_dev_page() "cannot fail".  Immortal
functions are a silly fiction, so we should remove the BUG() and fix up
callers.

