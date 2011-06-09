Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab1FINMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:12:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:43707 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab1FINMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:12:07 -0400
Date: Thu, 9 Jun 2011 15:12:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] mm: memcg-aware global reclaim
Message-ID: <20110609131203.GB3994@tiehlicka.suse.cz>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 01-06-11 08:25:13, Johannes Weiner wrote:
[...]

Just a minor thing. I am really slow at reviewing these days due to
other work that has to be done...

> +struct mem_cgroup *mem_cgroup_hierarchy_walk(struct mem_cgroup *root,
> +					     struct mem_cgroup *prev)
> +{
> +	struct mem_cgroup *mem;

You want mem = NULL here because you might end up using it unitialized
AFAICS (css_get_next returns with NULL).

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
> +	if (prev && prev != root)
> +		css_put(&prev->css);
> +	do {
> +		int id = root->last_scanned_child;
> +		struct cgroup_subsys_state *css;
> +
> +		rcu_read_lock();
> +		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
> +		if (css && (css == &root->css || css_tryget(css)))
> +			mem = container_of(css, struct mem_cgroup, css);
> +		rcu_read_unlock();
> +		if (!css)
> +			id = 0;
> +		root->last_scanned_child = id;
> +	} while (!mem);
> +	return mem;

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
