Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0EQQN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:13:58 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46021 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0EQQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:13:57 -0400
Date: Mon, 17 May 2010 11:09:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Haicheng Li <haicheng.li@linux.intel.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] mem-hotplug: fix potential race while building
 zonelist for new populated zone
In-Reply-To: <4BF0FC4C.4060306@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1005171108070.20764@router.home>
References: <4BF0FC4C.4060306@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010, Haicheng Li wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 72c1211..0729a82 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2783,6 +2783,20 @@ static __init_refok int __build_all_zonelists(void
> *data)
>  {
>  	int nid;
>  	int cpu;
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +	struct zone_online_info *new = (struct zone_online_info *)data;
> +
> +	/*
> +	 * Populate the new zone before build zonelists, which could
> +	 * happen only when onlining a new node after system is booted.
> +	 */
> +	if (new) {
> +		/* We are expecting a new memory block here. */
> +		WARN_ON(!new->onlined_pages);
> +		new->zone->present_pages += new->onlined_pages;
> +		new->zone->zone_pgdat->node_present_pages +=
> new->onlined_pages;
> +	}
> +#endif


Building a zonelist now has the potential side effect of changes to the
size of the zone?

Can we have a global mutex that protects against size modification of
zonelists instead? And it could also serialize the pageset setup?



