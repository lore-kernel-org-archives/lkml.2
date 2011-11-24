Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1KXAFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:05:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56764 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1KXAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:05:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Nov 2011 09:04:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/8] mm: memcg: remove unneeded checks from
 newpage_charge()
Message-Id: <20111124090443.d3f720c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322062951-1756-6-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-6-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 16:42:28 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Johannes Weiner <jweiner@redhat.com>
> 
> All callsites pass in freshly allocated pages and a valid mm.  As a
> result, all checks pertaining the page's mapcount, page->mapping or
> the fallback to init_mm are unneeded.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Hmm, it's true now. But for making clear our assumption to all readers of code,

could you add
VM_BUG_ON(!mm || page_mapped(page) || (page->mapping && !PageAnon(page)) ?

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memcontrol.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d4d139a..0d10be4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2679,19 +2679,8 @@ int mem_cgroup_newpage_charge(struct page *page,
>  {
>  	if (mem_cgroup_disabled())
>  		return 0;
> -	/*
> -	 * If already mapped, we don't have to account.
> -	 * If page cache, page->mapping has address_space.
> -	 * But page->mapping may have out-of-use anon_vma pointer,
> -	 * detecit it by PageAnon() check. newly-mapped-anon's page->mapping
> -	 * is NULL.
> -  	 */
> -	if (page_mapped(page) || (page->mapping && !PageAnon(page)))
> -		return 0;
> -	if (unlikely(!mm))
> -		mm = &init_mm;
>  	return mem_cgroup_charge_common(page, mm, gfp_mask,
> -				MEM_CGROUP_CHARGE_TYPE_MAPPED);
> +					MEM_CGROUP_CHARGE_TYPE_MAPPED);
>  }
>  
>  static void
> -- 
> 1.7.6.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

