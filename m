Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab2CVVgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:36:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031091Ab2CVVgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:36:12 -0400
Date: Thu, 22 Mar 2012 14:36:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Message-Id: <20120322143610.e4df49c9.akpm@linux-foundation.org>
In-Reply-To: <4F69A4C4.4080602@jp.fujitsu.com>
References: <4F69A4C4.4080602@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 18:52:04 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

>  static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
>  			unsigned long addr, pte_t ptent, swp_entry_t *entry)
>  {
> -	int usage_count;
>  	struct page *page = NULL;
>  	swp_entry_t ent = pte_to_swp_entry(ptent);
>  
>  	if (!move_anon() || non_swap_entry(ent))
>  		return NULL;
> -	usage_count = mem_cgroup_count_swap_user(ent, &page);
> -	if (usage_count > 1) { /* we don't move shared anon */
> -		if (page)
> -			put_page(page);
> -		return NULL;
> -	}
> +#ifdef CONFIG_SWAP
> +	/*
> +	 * Avoid lookup_swap_cache() not to update statistics.
> +	 */

I don't understand this comment - what is it trying to tell us?

> +	page = find_get_page(&swapper_space, ent.val);

The code won't even compile if CONFIG_SWAP=n?

> +#endif
>  	if (do_swap_account)
>  		entry->val = ent.val;
>  
