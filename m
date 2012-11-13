Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2KMQOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:14:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55787 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2KMQOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:14:47 -0500
Date: Tue, 13 Nov 2012 08:14:42 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
Message-ID: <20121113161442.GA18227@mtj.dyndns.org>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <1352820639-13521-3-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352820639-13521-3-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 04:30:36PM +0100, Michal Hocko wrote:
> @@ -1063,8 +1063,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  				   struct mem_cgroup *prev,
>  				   struct mem_cgroup_reclaim_cookie *reclaim)
>  {
> -	struct mem_cgroup *memcg = NULL;
> -	int id = 0;
> +	struct mem_cgroup *memcg = NULL,
> +			  *last_visited = NULL;

Nitpick but please don't do this.

> +		/*
> +		 * Root is not visited by cgroup iterators so it needs a special
> +		 * treatment.
> +		 */
> +		if (!last_visited) {
> +			css = &root->css;
> +		} else {
> +			struct cgroup *next_cgroup;
> +
> +			next_cgroup = cgroup_next_descendant_pre(
> +					last_visited->css.cgroup,
> +					root->css.cgroup);
> +			if (next_cgroup)
> +				css = cgroup_subsys_state(next_cgroup,
> +						mem_cgroup_subsys_id);

Hmmm... wouldn't it be better to move the reclaim logic into a
function and do the following?

	reclaim(root);
	for_each_descendent_pre()
		reclaim(descendant);

If this is a problem, I'd be happy to add a iterator which includes
the top node.  I'd prefer controllers not using the next functions
directly.

Thanks.

-- 
tejun
