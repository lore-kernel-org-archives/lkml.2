Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0CVH5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:57:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997Ab0CVH5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:57:08 -0400
Date: Mon, 22 Mar 2010 00:56:10 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] mm, fs: warn on missing address space operations
Message-Id: <20100322005610.5dfa70b1.akpm@linux-foundation.org>
In-Reply-To: <20100322053937.GA17637@laptop>
References: <20100322053937.GA17637@laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010 16:39:37 +1100 Nick Piggin <npiggin@suse.de> wrote:

> It's ugly and lazy that we do these default aops in case it has not
> been filled in by the filesystem.
> 
> A NULL operation should always mean either: we don't support the
> operation; we don't require any action; or a bug in the filesystem,
> depending on the context.
> 
> In practice, if we get rid of these fallbacks, it will be clearer
> what operations are used by a given address_space_operations struct,
> reduce branches, reduce #if BLOCK ifdefs, and should allow us to get
> rid of all the buffer_head knowledge from core mm and fs code.

I guess this is one way of waking people up.

What happens is that hundreds of bug reports land in my inbox and I get
to route them to various maintainers, most of whom don't exist, so
warnings keep on landing in my inbox.  Please send a mailing address for
my invoices.

It would be more practical, more successful and quicker to hunt down
the miscreants and send them rude emails.  Plus it would save you
money.

> We could add a patch like this which spits out a recipe for how to fix
> up filesystems and get them all converted quite easily.
> 
> ...
>
> @@ -40,8 +40,14 @@ void do_invalidatepage(struct page *page
>  	void (*invalidatepage)(struct page *, unsigned long);
>  	invalidatepage = page->mapping->a_ops->invalidatepage;
>  #ifdef CONFIG_BLOCK
> -	if (!invalidatepage)
> +	if (!invalidatepage) {
> +		static bool warned = false;
> +		if (!warned) {
> +			warned = true;
> +			print_symbol("address_space_operations %s missing invalidatepage method. Use block_invalidatepage.\n", (unsigned long)page->mapping->a_ops);
> +		}
>  		invalidatepage = block_invalidatepage;
> +	}

erk, I realise 80 cols can be a pain, but 165 cols is just out of
bounds.  Why not

	/* this fs should use block_invalidatepage() */
	WARN_ON_ONCE(!invalidatepage);


