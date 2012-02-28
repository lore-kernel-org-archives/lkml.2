Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2B1ANL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:13:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48343 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab2B1ANK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:13:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Feb 2012 09:11:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 02/21] memcg: make mm_match_cgroup() hirarchical
Message-Id: <20120228091144.d174ad7b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120223135146.12988.47611.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120223135146.12988.47611.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 17:51:46 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Check mm-owner cgroup membership hierarchically.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>


Ack. but ... see below.

> ---
>  include/linux/memcontrol.h |   11 ++---------
>  mm/memcontrol.c            |   20 ++++++++++++++++++++
>  2 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8c4d74f..4822d53 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -87,15 +87,8 @@ extern struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm);
>  extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
>  extern struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont);
>  
> -static inline
> -int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
> -{
> -	struct mem_cgroup *memcg;
> -	rcu_read_lock();
> -	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
> -	rcu_read_unlock();
> -	return cgroup == memcg;
> -}
> +extern int mm_match_cgroup(const struct mm_struct *mm,
> +			   const struct mem_cgroup *cgroup);
>  
>  extern struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg);
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b8039d2..77f5d48 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
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

belongs to ?

> + */
> +int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
> +{

Please use "memcg" for representing "memory cgroup" (other function's arguments uses "memcg")

> +	struct mem_cgroup *memcg;

So, rename this as *cur_memcg or some.

> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
> +	while (memcg != cgroup && memcg && memcg->use_hierarchy)
> +		memcg = parent_mem_cgroup(memcg);

IIUC, parent_mem_cgroup() checks mem->res.parent. mem->res.parent is set only when
parent->use_hierarchy == true. Then, 

	while (memcg != cgroup)
		memcg = parent_mem_cgroup(memcg);

will be enough.

Thanks,
-Kame

