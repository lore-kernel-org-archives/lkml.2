Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0LABid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:38:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48683 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0LABib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:38:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 1 Dec 2010 10:32:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages
Message-Id: <20101201103254.b823eae0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101130101602.17475.32611.stgit@localhost6.localdomain6>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
	<20101130101602.17475.32611.stgit@localhost6.localdomain6>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 15:46:31 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Provide control using zone_reclaim() and a boot parameter. The
> code reuses functionality from zone_reclaim() to isolate unmapped
> pages and reclaim them as a priority, ahead of other mapped pages.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
>  include/linux/swap.h |    5 ++-
>  mm/page_alloc.c      |    7 +++--
>  mm/vmscan.c          |   72 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 79 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index eba53e7..78b0830 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -252,11 +252,12 @@ extern int vm_swappiness;
>  extern int remove_mapping(struct address_space *mapping, struct page *page);
>  extern long vm_total_pages;
>  
> -#ifdef CONFIG_NUMA
> -extern int zone_reclaim_mode;
>  extern int sysctl_min_unmapped_ratio;
>  extern int sysctl_min_slab_ratio;
>  extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
> +extern bool should_balance_unmapped_pages(struct zone *zone);
> +#ifdef CONFIG_NUMA
> +extern int zone_reclaim_mode;
>  #else
>  #define zone_reclaim_mode 0
>  static inline int zone_reclaim(struct zone *z, gfp_t mask, unsigned int order)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 62b7280..4228da3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1662,6 +1662,9 @@ zonelist_scan:
>  			unsigned long mark;
>  			int ret;
>  
> +			if (should_balance_unmapped_pages(zone))
> +				wakeup_kswapd(zone, order);
> +

Hm, I'm not sure the final vision of this feature. Does this reclaiming feature
can't be called directly via balloon driver just before alloc_page() ?

Do you need to keep page caches small even when there are free memory on host ?

Thanks,
-Kame

