Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab0ICDPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 23:15:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33516 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0ICDPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 23:15:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 3 Sep 2010 12:10:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: [PATCH 0/2 v2] Make is_mem_section_removable more conformable with
 offlining code
Message-Id: <20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100902150554.GE10265@tiehlicka.suse.cz>
References: <20100901121951.GC6663@tiehlicka.suse.cz>
	<20100901124138.GD6663@tiehlicka.suse.cz>
	<20100902144500.a0d05b08.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902082829.GA10265@tiehlicka.suse.cz>
	<20100902180343.f4232c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902092454.GA17971@tiehlicka.suse.cz>
	<AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
	<20100902131855.GC10265@tiehlicka.suse.cz>
	<AANLkTikYt3Hu_XeNuwAa9KjzfWgpC8cNen6q657ZKmm-@mail.gmail.com>
	<20100902143939.GD10265@tiehlicka.suse.cz>
	<20100902150554.GE10265@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010 17:05:54 +0200
Michal Hocko <mhocko@suse.cz> wrote:

>  extern int mem_online_node(int nid);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a4cfcdc..2b736ed 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -569,16 +569,25 @@ out:
>  EXPORT_SYMBOL_GPL(add_memory);
>  
>  #ifdef CONFIG_MEMORY_HOTREMOVE
> +
>  /*
> - * A free page on the buddy free lists (not the per-cpu lists) has PageBuddy
> - * set and the size of the free page is given by page_order(). Using this,
> - * the function determines if the pageblock contains only free pages.
> - * Due to buddy contraints, a free page at least the size of a pageblock will
> - * be located at the start of the pageblock
> + * A free or LRU pages block are removable
> + * Do not use MIGRATE_MOVABLE because it can be insufficient and
> + * other MIGRATE types are tricky.
>   */
> -static inline int pageblock_free(struct page *page)
> -{
> -	return PageBuddy(page) && page_order(page) >= pageblock_order;
> +bool is_page_removable(struct page *page)
> +{
> +	int page_block = 1 << pageblock_order;
> +	while (page_block > 0) {
> +		if (PageBuddy(page)) {
> +			page_block -= page_order(page);
> +		} else if (PageLRU(page))
> +			page_block--;
> +		else 
> +			return false;
> +	}

still seems wrong..."page" pointer should be updated.

Ok, here is my patch in reply to this mail. (changed the subject as v2.)

1. bugfix for current code.
2. show precise removable information.

Tested and seems to work well.

Thanks,
-Kame





