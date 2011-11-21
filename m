Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab1KUVvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:51:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1KUVvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:51:47 -0500
Date: Mon, 21 Nov 2011 13:51:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] writeback: fix dirtied pages accounting on redirty
Message-Id: <20111121135146.0fc7e3a7.akpm@linux-foundation.org>
In-Reply-To: <20111121131216.032489128@intel.com>
References: <20111121130342.211953629@intel.com>
	<20111121131216.032489128@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 21:03:46 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> De-account the accumulative dirty counters on page redirty.
> 
> Page redirties (very common in ext4) will introduce mismatch between
> counters (a) and (b)
> 
> a) NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied
> b) NR_WRITTEN, BDI_WRITTEN
> 
> This will introduce systematic errors in balanced_rate and result in
> dirty page position errors (ie. the dirty pages are no longer balanced
> around the global/bdi setpoints).
> 
> ...
>
> --- linux-next.orig/mm/page-writeback.c	2011-11-17 20:57:15.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-11-17 20:57:16.000000000 +0800
> @@ -1792,6 +1792,17 @@ int __set_page_dirty_nobuffers(struct pa
>  }
>  EXPORT_SYMBOL(__set_page_dirty_nobuffers);
>  
> +void account_page_redirty(struct page *page)
> +{
> +	struct address_space *mapping = page->mapping;
> +	if (mapping && mapping_cap_account_dirty(mapping)) {
> +		current->nr_dirtied--;
> +		dec_zone_page_state(page, NR_DIRTIED);
> +		dec_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
> +	}
> +}

Again, writeback doesn't seem to be the best place to be adding
undocumented code.

> +EXPORT_SYMBOL(account_page_redirty);

The export is unneeded?


