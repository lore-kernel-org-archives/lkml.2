Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2ENJIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:08:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38172 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2ENJIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:08:13 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB0CAFF.6060705@jp.fujitsu.com>
Date: Mon, 14 May 2012 18:06:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephane Marchesin <marcheu@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <ffwll.ch@google.com>, Rob Clark <rob.clark@linaro.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/10] shmem: replace page if mapping excludes its zone
References: <alpine.LSU.2.00.1205120447380.28861@eggly.anvils> <alpine.LSU.2.00.1205120453210.28861@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1205120453210.28861@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/12 20:59), Hugh Dickins wrote:

> The GMA500 GPU driver uses GEM shmem objects, but with a new twist:
> the backing RAM has to be below 4GB.  Not a problem while the boards
> supported only 4GB: but now Intel's D2700MUD boards support 8GB, and
> their GMA3600 is managed by the GMA500 driver.
> 
> shmem/tmpfs has never pretended to support hardware restrictions on
> the backing memory, but it might have appeared to do so before v3.1,
> and even now it works fine until a page is swapped out then back in.
> When read_cache_page_gfp() supplied a freshly allocated page for copy,
> that compensated for whatever choice might have been made by earlier
> swapin readahead; but swapoff was likely to destroy the illusion.
> 
> We'd like to continue to support GMA500, so now add a new
> shmem_should_replace_page() check on the zone when about to move
> a page from swapcache to filecache (in swapin and swapoff cases),
> with shmem_replace_page() to allocate and substitute a suitable page
> (given gma500/gem.c's mapping_set_gfp_mask GFP_KERNEL | __GFP_DMA32).
> 
> This does involve a minor extension to mem_cgroup_replace_page_cache()
> (the page may or may not have already been charged); and I've removed
> a comment and call to mem_cgroup_uncharge_cache_page(), which in fact
> is always a no-op while PageSwapCache.
> 
> Also removed optimization of an unlikely path in shmem_getpage_gfp(),
> now that we need to check PageSwapCache more carefully (a racing caller
> might already have made the copy).  And at one point shmem_unuse_inode()
> needs to use the hitherto private page_swapcount(), to guard against
> racing with inode eviction.
> 
> It would make sense to extend shmem_should_replace_page(), to cover
> cpuset and NUMA mempolicy restrictions too, but set that aside for
> now: needs a cleanup of shmem mempolicy handling, and more testing,
> and ought to handle swap faults in do_swap_page() as well as shmem.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---



Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


