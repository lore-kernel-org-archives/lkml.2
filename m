Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab2GIEpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:45:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44019 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2GIEpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:45:32 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA616B.4000608@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 13:43:23 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: return -EBUSY when oom-kill-disable modified
 and memcg use_hierarchy, has children
References: <1341485708-14221-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1341485708-14221-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/05 19:55), Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> When oom-kill-disable modified by the user and current memcg use_hierarchy,
> the change can occur, provided the current memcg has no children. If it
> has children, return -EBUSY is enough.
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

I'm sorry what is the point ? You think -EBUSY should be returned in this case 
rather than -EINVAl ? Then, why ?


> ---
>   mm/memcontrol.c |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 63e36e7..4b64fe0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4521,11 +4521,14 @@ static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
>   
>   	cgroup_lock();
>   	/* oom-kill-disable is a flag for subhierarchy. */
> -	if ((parent->use_hierarchy) ||
> -	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
> +	if (parent->use_hierarchy) {
>   		cgroup_unlock();
>   		return -EINVAL;
> +	} else if (memcg->use_hierarchy && !list_empty(&cgrp->children)) {
> +		cgroup_unlock();
> +		return -EBUSY;
>   	}
> +
>   	memcg->oom_kill_disable = val;
>   	if (!val)
>   		memcg_oom_recover(memcg);
> 



