Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab2BWSEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:04:04 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42993 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab2BWSEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:04:02 -0500
Date: Thu, 23 Feb 2012 19:03:52 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 02/21] memcg: make mm_match_cgroup() hirarchical
Message-ID: <20120223180352.GA1701@cmpxchg.org>
References: <20120223133728.12988.5432.stgit@zurg>
 <20120223135146.12988.47611.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223135146.12988.47611.stgit@zurg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 05:51:46PM +0400, Konstantin Khlebnikov wrote:
> Check mm-owner cgroup membership hierarchically.

I think this one cat just beat up this other cat in front of my
window, yelling something about money and missing product.  Anyway, I
already forgot why we want this patch.  Could you describe that in the
changelog, please?

> @@ -821,6 +821,26 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
>  				struct mem_cgroup, css);
>  }
>  
> +/**
> + * mm_match_cgroup - cgroup hierarchy mm membership test
> + * @mm		mm_struct to test
> + * @cgroup	target cgroup
> + *
> + * Returns true if mm belong this cgroup or any its child in hierarchy
> + */
> +int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
> +	while (memcg != cgroup && memcg && memcg->use_hierarchy)
> +		memcg = parent_mem_cgroup(memcg);
> +	rcu_read_unlock();
> +
> +	return cgroup == memcg;
> +}

Please don't duplicate mem_cgroup_same_or_subtree()'s functionality in
a worse way.  The hierarchy information is kept in a stack such that
ancestry can be detected in linear time, check out css_is_ancestor().

If you don't want to nest rcu_read_lock(), you could push the
rcu_read_lock() from css_is_ancestor() into its sole user and provide
a __mem_cgroup_is_ancestor() that assumes rcu already read-locked.

No?
