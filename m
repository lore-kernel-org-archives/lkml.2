Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1CXD77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:59:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756651Ab1CXD75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:59:57 -0400
Date: Wed, 23 Mar 2011 20:56:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan.kim@gmail.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the cleancache tree with Linus'
 tree
Message-Id: <20110323205615.6984f974.akpm@linux-foundation.org>
In-Reply-To: <20110324135524.261bb5a9.sfr@canb.auug.org.au>
References: <20110324135524.261bb5a9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 13:55:24 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Dan,
> 
> Today's linux-next merge of the cleancache tree got a conflict in
> mm/truncate.c between commit 5adc7b518b54 ("mm: truncate: change
> remove_from_page_cache") from Linus' tree and commit 03e838947c8a
> ("mm/fs: add hooks to support cleancache") from the cleancache tree.
> 
> I fixed it up (see below) but am really not sure of the fix.  I can carry
> this fix as necessary.
> 
> Is this stuff going to be merged into Linus' tree this time round?
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc mm/truncate.c
> index a956675,cd94607..0000000
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@@ -106,8 -108,13 +108,12 @@@ truncate_complete_page(struct address_s
>   	cancel_dirty_page(page, PAGE_CACHE_SIZE);
>   
>   	clear_page_mlock(page);
>  -	remove_from_page_cache(page);
>   	ClearPageMappedToDisk(page);
>  +	delete_from_page_cache(page);
> + 	/* this must be after the remove_from_page_cache which
> + 	 * calls cleancache_put_page (and note page->mapping is now NULL)
> + 	 */
> + 	cleancache_flush_page(mapping, page);
>  -	page_cache_release(page);	/* pagecache ref */
>   	return 0;
>   }

I did the cleancache_flush_page() before the delete_from_page_cache(),
in case the delete_from_page_cache() freed the page.  I didn't actually
check whether that makes sense though.

