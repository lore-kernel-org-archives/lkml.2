Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab2HJR2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:28:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab2HJR22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:28:28 -0400
Date: Fri, 10 Aug 2012 19:28:24 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 02/11] memcg: Reclaim when more than one page needed.
Message-ID: <20120810172824.GA14591@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-3-git-send-email-glommer@parallels.com>
 <20120810154240.GG1425@dhcp22.suse.cz>
 <50253B95.7010905@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50253B95.7010905@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 11-08-12 01:49:25, KAMEZAWA Hiroyuki wrote:
> (2012/08/11 0:42), Michal Hocko wrote:
> >On Thu 09-08-12 17:01:10, Glauber Costa wrote:
> >[...]
> >>@@ -2317,18 +2318,18 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >>  	} else
> >>  		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> >>  	/*
> >>-	 * nr_pages can be either a huge page (HPAGE_PMD_NR), a batch
> >>-	 * of regular pages (CHARGE_BATCH), or a single regular page (1).
> >>-	 *
> >>  	 * Never reclaim on behalf of optional batching, retry with a
> >>  	 * single page instead.
> >>  	 */
> >>-	if (nr_pages == CHARGE_BATCH)
> >>+	if (nr_pages > min_pages)
> >>  		return CHARGE_RETRY;
> >
> >This is dangerous because THP charges will be retried now while they
> >previously failed with CHARGE_NOMEM which means that we will keep
> >attempting potentially endlessly.
> 
> with THP, I thought nr_pages == min_pages, and no retry.

right you are.

> >Why cannot we simply do if (nr_pages < CHARGE_BATCH) and get rid of the
> >min_pages altogether?
> 
> Hm, I think a slab can be larger than CHARGE_BATCH.
>
> >Also the comment doesn't seem to be valid anymore.
> >
> I agree it's not clean. Because our assumption on nr_pages are changed,
> I think this behavior should not depend on nr_pages value..
> Shouldn't we have a flag to indicate "trial-for-batched charge" ?

dunno, it would require a new parameter anyway (because abusing gfp
doesn't seem great idea).

> 
> 
> Thanks,
> -Kame
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
