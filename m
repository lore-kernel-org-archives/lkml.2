Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab0IVJTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:19:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37427 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0IVJTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:19:43 -0400
Date: Wed, 22 Sep 2010 14:49:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Greg Thelen <gthelen@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][-mm] memcg: generic filestat update interface.
Message-ID: <20100922091939.GK6676@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100922140817.a7ac57c2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100922140817.a7ac57c2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-09-22 14:08:17]:

> 
> based on mmotm and other memory cgroup patches in -mm queue.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This patch extracts core logic of mem_cgroup_update_file_mapped() as
> mem_cgroup_update_file_stat() and add a skin.
> 
> As a planned future update, memory cgroup has to count dirty pages to implement
> dirty_ratio/limit. And more, the number of dirty pages is required to kick flusher
> thread to start writeback. (Now, no kick.)
> 
> This patch is preparation for it and makes other statistics implementation
> clearer. Just a clean up.
> 
> Note:
> In previous patch series, I wrote a more complicated patch to make the
> more generic and wanted to avoid using switch(). But now, we found page_mapped()
> check is necessary for updage_file_mapepd().We can't avoid to add some conditions.
> I hope this style is enough easy to read and to maintainance.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> Index: mmotm-0915/mm/memcontrol.c
> ===================================================================
> --- mmotm-0915.orig/mm/memcontrol.c
> +++ mmotm-0915/mm/memcontrol.c
> @@ -1575,7 +1575,8 @@ bool mem_cgroup_handle_oom(struct mem_cg
>   * small, we check MEM_CGROUP_ON_MOVE percpu value and detect there are
>   * possibility of race condition. If there is, we take a lock.
>   */
> -void mem_cgroup_update_file_mapped(struct page *page, int val)
> +
> +static void mem_cgroup_update_file_stat(struct page *page, int idx, int val)
>  {
>  	struct mem_cgroup *mem;
>  	struct page_cgroup *pc = lookup_page_cgroup(page);
> @@ -1597,13 +1598,18 @@ void mem_cgroup_update_file_mapped(struc
>  		if (!mem || !PageCgroupUsed(pc))
>  			goto out;
>  	}
> -	if (val > 0) {
> -		this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
> -		SetPageCgroupFileMapped(pc);
> -	} else {
> -		this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
> -		if (!page_mapped(page)) /* for race between dec->inc counter */
> +
> +	this_cpu_add(mem->stat->count[idx], val);
> +
> +	switch (idx) {
> +	case MEM_CGROUP_STAT_FILE_MAPPED:
> +		if (val > 0)
> +			SetPageCgroupFileMapped(pc);
> +		else if (!page_mapped(page))
>  			ClearPageCgroupFileMapped(pc);
> +		break;
> +	default:
> +		BUG();
>  	}
> 
>  out:
> @@ -1613,6 +1619,11 @@ out:
>  	return;
>  }
> 
> +void mem_cgroup_update_file_mapped(struct page *page, int val)
> +{
> +	mem_cgroup_update_file_stat(page, MEM_CGROUP_STAT_FILE_MAPPED, val);
> +}
> +

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
