Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1FGMZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:25:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57685
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053Ab1FGMZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:25:36 -0400
Date: Tue, 7 Jun 2011 08:25:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] mm: memcg-aware global reclaim
Message-ID: <20110607122519.GA18571@infradead.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few small nitpicks:

> +struct mem_cgroup *mem_cgroup_hierarchy_walk(struct mem_cgroup *root,
> +					     struct mem_cgroup *prev)
> +{
> +	struct mem_cgroup *mem;
> +
> +	if (mem_cgroup_disabled())
> +		return NULL;
> +
> +	if (!root)
> +		root = root_mem_cgroup;
> +	/*
> +	 * Even without hierarchy explicitely enabled in the root
> +	 * memcg, it is the ultimate parent of all memcgs.
> +	 */
> +	if (!(root == root_mem_cgroup || root->use_hierarchy))
> +		return root;

The logic here reads a bit weird, why not simply:

	 /*
	  * Even without hierarchy explicitely enabled in the root
	  * memcg, it is the ultimate parent of all memcgs.
	  */
	if (!root || root == root_mem_cgroup)
		return root_mem_cgroup;
	if (root->use_hierarchy)
		return root;


>  /*
>   * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
>   */
> -static void shrink_zone(int priority, struct zone *zone,
> -				struct scan_control *sc)
> +static void do_shrink_zone(int priority, struct zone *zone,
> +			   struct scan_control *sc)

It actually is the per-memcg shrinker now, and thus should be called
shrink_memcg.

> +		sc->mem_cgroup = mem;
> +		do_shrink_zone(priority, zone, sc);

Any passing the mem_cgroup explicitly instead of hiding it in the
scan_control would make that much more obvious.  If there's a good
reason to pass it in the structure the same probably applies to the
zone and priority, too.

Shouldn't we also have a non-cgroups stub of shrink_zone to directly
call do_shrink_zone/shrink_memcg with a NULL memcg and thus optimize
the whole loop away for it?

