Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2JPKUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:20:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40818 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab2JPKU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:20:26 -0400
Message-ID: <507D34E3.3040705@gmail.com>
Date: Tue, 16 Oct 2012 18:20:19 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        mhocko@suse.cz, linux-kernel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 06:12 PM, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
>
> Sysctl oom_kill_allocating_task enables or disables killing the OOM-triggering
> task in out-of-memory situations, but it only works on overall system-wide oom.
> But it's also a useful indication in memcg so we take it into consideration
> while oom happening in memcg. Other sysctl such as panic_on_oom has already
> been memcg-ware.

Is it the resend one or new version, could you add changelog if it is 
the last case?

>
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> ---
>   mm/memcontrol.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e4e9b18..c329940 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1486,6 +1486,15 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>   
>   	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
>   	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
> +	if (sysctl_oom_kill_allocating_task && current->mm &&
> +	    !oom_unkillable_task(current, memcg, NULL) &&
> +	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
> +		get_task_struct(current);
> +		oom_kill_process(current, gfp_mask, order, 0, totalpages, memcg, NULL,
> +				 "Memory cgroup out of memory (oom_kill_allocating_task)");
> +		return;
> +	}
> +
>   	for_each_mem_cgroup_tree(iter, memcg) {
>   		struct cgroup *cgroup = iter->css.cgroup;
>   		struct cgroup_iter it;

