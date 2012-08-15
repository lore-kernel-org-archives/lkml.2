Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2HOJYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:24:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab2HOJYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:24:10 -0400
Date: Wed, 15 Aug 2012 11:24:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 07/11] mm: Allocate kernel pages to the right memcg
Message-ID: <20120815092404.GA23985@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-8-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344517279-30646-8-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 09-08-12 17:01:15, Glauber Costa wrote:
[...]
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b956cec..da341dc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2532,6 +2532,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  	struct page *page = NULL;
>  	int migratetype = allocflags_to_migratetype(gfp_mask);
>  	unsigned int cpuset_mems_cookie;
> +	void *handle = NULL;
>  
>  	gfp_mask &= gfp_allowed_mask;
>  
> @@ -2543,6 +2544,13 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  		return NULL;
>  
>  	/*
> +	 * Will only have any effect when __GFP_KMEMCG is set.
> +	 * This is verified in the (always inline) callee
> +	 */
> +	if (!memcg_kmem_new_page(gfp_mask, &handle, order))
> +		return NULL;

When the previous patch introduced this function I thought the handle
obfuscantion is to prevent from spreading struct mem_cgroup inside the
page allocator but memcg_kmem_commit_page uses the type directly. So why
that obfuscation? Even handle as a name sounds unnecessarily confusing.
I would go with struct mem_cgroup **memcgp or even return the pointer on
success or NULL otherwise.

[...]
> +EXPORT_SYMBOL(__free_accounted_pages);

Why exported?

Btw. this is called from call_rcu context but it itself calls call_rcu
down the chain in mem_cgroup_put. Is it safe?

[...]
> +EXPORT_SYMBOL(free_accounted_pages);

here again
-- 
Michal Hocko
SUSE Labs
