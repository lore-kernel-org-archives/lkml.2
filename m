Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab2KSPLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:11:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab2KSPLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:11:35 -0500
Date: Mon, 19 Nov 2012 16:11:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
Message-ID: <20121119151130.GB16803@dhcp22.suse.cz>
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

On Tue 13-11-12 16:30:36, Michal Hocko wrote:
[...]
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

This is not correct because cgroup_next_descendant_pre expects pos to be
NULL for the first iteration but the way we do iterate (visit the root
first) means that the second iteration will have last_visited != NULL
and if root doesn't have any children the iteration would go unleashed
to to the endless loop. We need something like:
	struct cgroup *prev_cgroup = (last_visited == root) ? NULL 
					: last_visited->css.cgroup;
	next_cgroup = cgroup_next_descendant_pre(prev_cgroup,
				root->css.gtoup);

-- 
Michal Hocko
SUSE Labs
