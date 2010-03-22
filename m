Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab0CVLIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:08:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab0CVLH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:07:59 -0400
Date: Mon, 22 Mar 2010 07:07:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] mm, fs: warn on missing address space operations
Message-ID: <20100322110758.GA13690@infradead.org>
References: <20100322053937.GA17637@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322053937.GA17637@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2472,7 +2472,14 @@ int try_to_release_page(struct page *pag
>  
>  	if (mapping && mapping->a_ops->releasepage)
>  		return mapping->a_ops->releasepage(page, gfp_mask);
> -	return try_to_free_buffers(page);
> +	else {
> +		static bool warned = false;
> +		if (!warned) {
> +			warned = true;
> +			print_symbol("address_space_operations %s missing releasepage method. Use try_to_free_buffers.\n", (unsigned long)page->mapping->a_ops);
> +		}
> +		return try_to_free_buffers(page);
> +	}

I don't think this is correct.  We currently also call
try_to_free_buffers if the page does not have a mapping, and from
conversations with Andrew long time ago that case actually does seem to
be nessecary due to behaviour in ext3/jbd.  So you really should
only warn if there is a mapping to start with.  In fact your code will
dereference a potential NULL pointer in that case.

And as others said, this patch only makes sense after the existing
filesystems are updated to fill out all methods, and for the case
of try_to_free_buffers and set_page_dirty until we have suitable
and well-named default operations available.

Btw, any reason this doesn't use the %pf specifier to printk
instead of dragging in print_symbol?  Even better would
be to just print the fs type from mapping->host->i_sb->s_type->name.

