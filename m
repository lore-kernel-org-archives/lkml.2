Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2CSE2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:28:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35939 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2CSE2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:28:02 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F66B55A.8020307@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 13:26:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 06/10] cgroup: convert memcg controller to the new cftype
 interface
References: <1331940963-15756-1-git-send-email-tj@kernel.org> <1331940963-15756-7-git-send-email-tj@kernel.org>
In-Reply-To: <1331940963-15756-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/17 8:35), Tejun Heo wrote:

> Convert memcg to use the new cftype based interface. memcg is rather
> special in that
> 
> * memsw_cgroup_files creation is dependent on do_swap_account.
> 
> * ->populate() is abused for mem_cgroup_sockets_init().
> 
> memsw_cgroup_files is converted to use CGROUP_SUBSYS_CFTYPES_COND(),
> where the condition is really_do_swap_account.
> 
> ->populate() is preserved for register_kmem_files() invocation but I
> strongly urge moving the initialization to the tail of ->create().  If
> there's something which can't be done from ->create(), which isn't
> clear from the comment, please let me know.
> 

Okay, then, cgroup files are created in kernel/cgroup.c and memcg just
registers entries.



> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Greg Thelen <gthelen@google.com>
> ---
>  mm/memcontrol.c           |   31 ++++++-------------------------
>  net/ipv4/tcp_memcontrol.c |    8 ++++----
>  2 files changed, 10 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ae2f0a8..f2221ce 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4665,7 +4665,9 @@ static struct cftype mem_cgroup_files[] = {
>  		.mode = S_IRUGO,
>  	},
>  #endif
> +	{ },	/* terminate */
>  };
> +CGROUP_SUBSYS_CFTYPES(mem_cgroup_subsys, mem_cgroup_files);
>  
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  static struct cftype memsw_cgroup_files[] = {
> @@ -4694,20 +4696,10 @@ static struct cftype memsw_cgroup_files[] = {
>  		.trigger = mem_cgroup_reset,
>  		.read_u64 = mem_cgroup_read,
>  	},
> +	{ }	/* terminate */
>  };
> -
> -static int register_memsw_files(struct cgroup *cont, struct cgroup_subsys *ss)
> -{
> -	if (!do_swap_account)
> -		return 0;
> -	return cgroup_add_files(cont, ss, memsw_cgroup_files,
> -				ARRAY_SIZE(memsw_cgroup_files));
> -};
> -#else
> -static int register_memsw_files(struct cgroup *cont, struct cgroup_subsys *ss)
> -{
> -	return 0;
> -}
> +CGROUP_SUBSYS_CFTYPES_COND(mem_cgroup_subsys, memsw_cgroup_files,
> +			   really_do_swap_account);


I'm sorry but why you use really_do_swap_account instead of do_swap_account ?

Thanks,
-Kame

