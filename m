Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1EDVjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:39:06 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:47762 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1EDVjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:39:04 -0400
Date: Wed, 4 May 2011 23:38:50 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        rientjes@google.com, Michal Hocko <mhocko@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] Allocate memory cgroup structures in local nodes v2
Message-ID: <20110504213850.GA16685@cmpxchg.org>
References: <1304540783-8247-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304540783-8247-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 01:26:23PM -0700, Andi Kleen wrote:
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 9905501..a362215 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -134,7 +134,7 @@ static void *__init_refok alloc_page_cgroup(size_t size, int nid)
>  {
>  	void *addr = NULL;
>  
> -	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
> +	addr = alloc_pages_exact_node(nid, GFP_KERNEL | __GFP_NOWARN, size);

alloc_pages_exact_node is not the 'specify node as well'-version of
alloc_pages_exact, it refers to 'exact node'.  Thus the
free_pages_exact call is no longer the right counter-part.

alloc_pages_exact_node takes an order, not a size argument.

alloc_pages_exact_node returns a pointer to the struct page, not to
the allocated memory, like all other alloc_pages* functions with the
exception of alloc_pages_exact.

I don't think any of those mistakes even triggers a compiler warning.
Wow.  This API is so thoroughly fscked beyond belief that I think the
only way to top this is to have one of the functions invert the bits
of its return value depending on the parity of the uptime counter.
