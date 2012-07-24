Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2GXOqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:46:04 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:28817 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754711Ab2GXOqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:46:02 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hLGHJEkVM1lespT_Z9_MW9TZyiWahEIDTMT9sN8uXkD.4wK
 fSWJ3ZQ8JuzSZyBBY5qOPU36dLj_sc4Z2f1kx0EdH6qPaNMjEcK04FXoqhHn
 PRnkDPU62Rtpk9pMwLMKoKbhhppjNthdaOmECKpyKlKqLyn8XmijUjxxgNxZ
 OTgNFe3ifyixUm5p83A.qpD8r8ICmWR8xO7_BmOzMXl43E9MpCS_Sa_YlOEi
 vJ6hiZyVPqjPEoM2aoQsIB_VJjD5lMfUuVXOBRgqlCY4EaXyTgdbLq8QN609
 _URV6_SLrmKBNrDhvWirItj6kQNQJYTn7QWYVlRddtMOyCaulX7c9D0gDFl0
 2ZiQK.R.5mPv.J_2KjpYWPaGpLOAFWGJAM_0rAelEzbjuHR1cxQHcMWNt5ER
 W
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 24 Jul 2012 09:45:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <jiang.liu@huawei.com>
cc: WuJianguo <wujianguo@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Mel Gorman <mgorman@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC PATCH v2] SLUB: enhance slub to handle memory nodes without
 normal memory
In-Reply-To: <1343123710-4972-1-git-send-email-jiang.liu@huawei.com>
Message-ID: <alpine.DEB.2.00.1207240931560.29808@router.home>
References: <alpine.DEB.2.00.1207181349370.22907@router.home> <1343123710-4972-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2012, Jiang Liu wrote:

>
> diff --git a/mm/slub.c b/mm/slub.c
> index 8c691fa..3976745 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2803,6 +2803,17 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
>
>  static struct kmem_cache *kmem_cache_node;
>
> +static bool node_has_normal_memory(int node)
> +{
> +	int i;
> +
> +	for (i = ZONE_NORMAL; i >= 0; i--)
> +		if (populated_zone(&NODE_DATA(node)->node_zones[i]))
> +			return true;
> +
> +	return false;
> +}

There is already a N_NORMAL_MEMORY node map that contains a list of node
that have *normal* memory usable by slab allocators etc. I think the
cleanest solution would be to clear the corresponding node bits for your
special movable only zones. Then you wont be needing to modify other
subsystems anymore.

