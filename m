Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab2JDSur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:50:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab2JDSuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:50:00 -0400
Date: Thu, 4 Oct 2012 20:49:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] mm: memcontrol: handle potential crash when rmap
 races with task exit
Message-ID: <20121004184958.GG27536@dhcp22.suse.cz>
References: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
 <1349374157-20604-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349374157-20604-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-10-12 14:09:16, Johannes Weiner wrote:
> page_referenced() counts only references of mm's that are associated
> with the memcg hierarchy that is being reclaimed.  However, if it
> races with the owner of the mm exiting, mm->owner may be NULL.  Don't
> crash, just ignore the reference.

This seems to be fixed by Hugh's patch 3a981f48 "memcg: fix use_hierarchy
css_is_ancestor oops regression" which seems to be merged already.

> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@kernel.org [3.5]
> ---
>  include/linux/memcontrol.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8d9489f..8686294 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -91,7 +91,7 @@ int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
>  
>  	rcu_read_lock();
>  	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
> -	match = __mem_cgroup_same_or_subtree(cgroup, memcg);
> +	match = memcg && __mem_cgroup_same_or_subtree(cgroup, memcg);
>  	rcu_read_unlock();
>  	return match;
>  }
> -- 
> 1.7.11.4
> 

-- 
Michal Hocko
SUSE Labs
