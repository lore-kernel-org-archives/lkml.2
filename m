Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2KTX5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:57:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2KTX5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:57:37 -0500
Date: Tue, 20 Nov 2012 15:57:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: trace filemap add and del
Message-Id: <20121120155735.905bbf9e.akpm@linux-foundation.org>
In-Reply-To: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
References: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Nov 2012 20:54:10 +0100
Robert Jarzmik <robert.jarzmik@free.fr> wrote:

> Use the events API to trace filemap loading and
> unloading of file pieces into the page cache.
> 
> This patch aims at tracing the eviction reload
> cycle of executable and shared libraries pages in
> a memory constrained environment.
> 
> The typical usage is to spot a specific device and
> inode (for example /lib/libc.so) to see the eviction
> cycles, and find out if frequently used code is
> rather spread across many pages (bad) or coallesced
> (good).

I suppose that could be useful.

>
> ...
>
> +TRACE_EVENT(mm_filemap_delete_from_page_cache,
> +
> +	TP_PROTO(struct page *page),
> +
> +	TP_ARGS(page),
> +
> +	TP_STRUCT__entry(
> +		__field(struct page *, page)
> +		__field(unsigned long, i_no)

May as well call this i_ino - there's little benefit in using a
different identifier.

> +		__field(unsigned long, pageofs)

"index".

> +		__field(dev_t, s_dev)

Perhaps use super_block.s_id here

> +	),
> +
> +	TP_fast_assign(
> +		__entry->page = page;
> +		__entry->i_no = page->mapping->host->i_ino;
> +		__entry->pageofs = page->index;
> +		if (page->mapping->host->i_sb)
> +			__entry->s_dev = page->mapping->host->i_sb->s_dev;
> +		else
> +			__entry->s_dev = page->mapping->host->i_rdev;

and hence avoid all this stuff.

> +	),
> +
> +	TP_printk("page=%p pfn=%lu blk=%d:%d inode+ofs=%lu+%lu",
> +		__entry->page,
> +		page_to_pfn(__entry->page),
> +		MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
> +		__entry->i_no,
> +		__entry->pageofs << PAGE_SHIFT)
> +);
> +
> +TRACE_EVENT(mm_filemap_add_to_page_cache,

Dittoes.


