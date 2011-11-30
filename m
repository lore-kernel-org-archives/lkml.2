Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab1K3BGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 20:06:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:41867 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab1K3BGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 20:06:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,595,1315206000"; 
   d="scan'208";a="80442247"
Date: Wed, 30 Nov 2011 09:06:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] readahead: snap readahead request to EOF
Message-ID: <20111130010604.GD11147@localhost>
References: <20111129130900.628549879@intel.com>
 <20111129131456.145362960@intel.com>
 <20111129142958.GJ5635@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129142958.GJ5635@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   Hmm, wouldn't it be cleaner to do this already in ondemand_readahead()?
> All other updates of readahead window seem to be there.

Yeah it's not that clean, however the intention is to cover the other
call site -- mmap read-around, too.

> Also shouldn't we
> take maximum readahead size into account? Reading 3/2 of max readahead
> window seems like a relatively big deal for large files...

Good point, the max readahead size is actually a must, in order to
prevent it expanding the readahead size for ever in the backwards
reading case.

This limits the size expansion to 1/4 max readahead. That means, if
the next expected readahead size will be less than 1/4 max size, it
will be merged into the current readahead window to avoid one small IO.

The backwards reading is not special cased here because it's not
frequent anyway.

 unsigned long ra_submit(struct file_ra_state *ra,
 		       struct address_space *mapping, struct file *filp)
 {
+	pgoff_t eof = ((i_size_read(mapping->host)-1) >> PAGE_CACHE_SHIFT) + 1;
+	pgoff_t start = ra->start;
+	unsigned long size = ra->size;
 	int actual;
 
+	/* snap to EOF */
+	size += min(size, ra->ra_pages / 4);
+	if (start + size > eof) {
+		ra->size = eof - start;
+		ra->async_size = 0;
+	}
+
 	actual = __do_page_cache_readahead(mapping, filp,
 					ra->start, ra->size, ra->async_size);

Thanks,
Fengguang
