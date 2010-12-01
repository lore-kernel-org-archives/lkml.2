Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0LAXru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 18:47:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755023Ab0LAXrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 18:47:49 -0500
Date: Wed, 1 Dec 2010 15:46:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 3/3] NFS: Fix a memory leak in nfs_readdir
Message-Id: <20101201154651.958678f6.akpm@linux-foundation.org>
In-Reply-To: <1291245676.6609.62.camel@heimdal.trondhjem.org>
References: <1291217804-11257-1-git-send-email-Trond.Myklebust@netapp.com>
	<1291217804-11257-3-git-send-email-Trond.Myklebust@netapp.com>
	<1291217804-11257-4-git-send-email-Trond.Myklebust@netapp.com>
	<AANLkTi=C8UtWwctEgBY2584d8fDV3OHpf+mGNnQO8ZJt@mail.gmail.com>
	<1291229669.6609.24.camel@heimdal.trondhjem.org>
	<AANLkTinsEeKK9LykVAVq60Lsb3caLDJasnKH8kcgSFVp@mail.gmail.com>
	<1291234251.6609.39.camel@heimdal.trondhjem.org>
	<20101201123341.d12ef362.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1012011258220.18662@tigran.mtv.corp.google.com>
	<alpine.LSU.2.00.1012011311590.18920@tigran.mtv.corp.google.com>
	<20101201133831.ea6ba10a.akpm@linux-foundation.org>
	<1291240272.6609.50.camel@heimdal.trondhjem.org>
	<20101201141351.8609140b.akpm@linux-foundation.org>
	<AANLkTimgZPET+T16Qpj_KnpCu==97g-8+_y5dtjNOrxG@mail.gmail.com>
	<20101201143856.51f4f9d9.akpm@linux-foundation.org>
	<1291243633.6609.59.camel@heimdal.trondhjem.org>
	<1291245676.6609.62.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Dec 2010 18:21:16 -0500
Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -108,6 +108,10 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
>  	clear_page_mlock(page);
>  	remove_from_page_cache(page);
>  	ClearPageMappedToDisk(page);
> +
> +	if (mapping->a_ops->freepage)
> +		mapping->a_ops->freepage(page);
> +
>  	page_cache_release(page);	/* pagecache ref */
>  	return 0;
>  }

So here we're assuming that `mapping' was pinned by other means.

Fair enough, although subtle.  Even drop_pagecache_sb() got it right ;)

> @@ -390,6 +394,10 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
>  	__remove_from_page_cache(page);
>  	spin_unlock_irq(&mapping->tree_lock);
>  	mem_cgroup_uncharge_cache_page(page);
> +
> +	if (mapping->a_ops->freepage)
> +		mapping->a_ops->freepage(page);
> +
>  	page_cache_release(page);	/* pagecache ref */
>  	return 1;
>  failed:

And here.
