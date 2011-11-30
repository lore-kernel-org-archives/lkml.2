Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1K3CX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:23:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32961 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab1K3CXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:23:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 30 Nov 2011 11:22:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        ebiederm@xmission.com, davem@davemloft.net, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH v7 10/10] Disable task moving when using kernel memory
 accounting
Message-Id: <20111130112210.1d979512.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322611021-1730-11-git-send-email-glommer@parallels.com>
References: <1322611021-1730-1-git-send-email-glommer@parallels.com>
	<1322611021-1730-11-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 21:57:01 -0200
Glauber Costa <glommer@parallels.com> wrote:

> Since this code is still experimental, we are leaving the exact
> details of how to move tasks between cgroups when kernel memory
> accounting is used as future work.
> 
> For now, we simply disallow movement if there are any pending
> accounted memory.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   23 ++++++++++++++++++++++-
>  1 files changed, 22 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a31a278..dd9a6d9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5453,10 +5453,19 @@ static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
>  {
>  	int ret = 0;
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
> +	struct mem_cgroup *from = mem_cgroup_from_task(p);
> +
> +#if defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM) && defined(CONFIG_INET)
> +	if (from != memcg && !mem_cgroup_is_root(from) &&
> +	    res_counter_read_u64(&from->tcp_mem.tcp_memory_allocated, RES_USAGE)) {
> +		printk(KERN_WARNING "Can't move tasks between cgroups: "
> +			"Kernel memory held.\n");
> +		return 1;
> +	}
> +#endif

I wonder....reading all codes again, this is incorrect check.

Hm, let me cralify. IIUC, in old code, "prevent moving" is because you hold
reference count of cgroup, which can cause trouble at rmdir() as leaking refcnt.

BTW, because socket is a shared resource between cgroup, changes in mm->owner
may cause task cgroup moving implicitly. So, if you allow leak of resource
here, I guess... you can take mem_cgroup_get() refcnt which is memcg-local and
allow rmdir(). Then, this limitation may disappear.

Then, users will be happy but admins will have unseen kernel resource usage in
not populated(by rmdir) memcg. Hm, big trouble ?

Thanks,
-Kame

