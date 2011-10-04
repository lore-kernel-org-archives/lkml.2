Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1JDA6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:58:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41882 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab1JDA6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:58:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 4 Oct 2011 09:57:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        ebiederm@xmission.com, davem@davemloft.net, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com
Subject: Re: [PATCH v4 3/8] foundations of per-cgroup memory pressure
 controlling.
Message-Id: <20111004095715.479da44d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317637123-18306-4-git-send-email-glommer@parallels.com>
References: <1317637123-18306-1-git-send-email-glommer@parallels.com>
	<1317637123-18306-4-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Oct 2011 14:18:38 +0400
Glauber Costa <glommer@parallels.com> wrote:

> This patch converts struct sock fields memory_pressure,
> memory_allocated, sockets_allocated, and sysctl_mem (now prot_mem)
> to function pointers, receiving a struct mem_cgroup parameter.
> 
> enter_memory_pressure is kept the same, since all its callers
> have socket a context, and the kmem_cgroup can be derived from
> the socket itself.
> 
> To keep things working, the patch convert all users of those fields
> to use acessor functions.
> 
> In my benchmarks I didn't see a significant performance difference
> with this patch applied compared to a baseline (around 1 % diff, thus
> inside error margin).
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>

A nitpick.

 
>  #ifdef CONFIG_INET
>  struct sock;
> +struct proto;
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>  void sock_update_memcg(struct sock *sk);
>  void sock_release_memcg(struct sock *sk);
> -
> +void memcg_sock_mem_alloc(struct mem_cgroup *mem, struct proto *prot,
> +			  int amt, int *parent_failure);
> +void memcg_sock_mem_free(struct mem_cgroup *mem, struct proto *prot, int amt);
> +void memcg_sockets_allocated_dec(struct mem_cgroup *mem, struct proto *prot);
> +void memcg_sockets_allocated_inc(struct mem_cgroup *mem, struct proto *prot);
>  #else
> +/* memcontrol includes sockets.h, that includes memcontrol.h ... */
> +static inline void memcg_sock_mem_alloc(struct mem_cgroup *mem,
> +					struct proto *prot, int amt,
> +					int *parent_failure)
> +{
> +}

In these days, at naming memory cgroup pointers, we use "memcg" instead of
"mem". So, could you use "memcg" for represeinting memory cgroup ?


> +
> +void memcg_sock_mem_alloc(struct mem_cgroup *mem, struct proto *prot,
> +			  int amt, int *parent_failure)
> +{
> +	mem = parent_mem_cgroup(mem);
> +	for (; mem != NULL; mem = parent_mem_cgroup(mem)) {
> +		long alloc;
> +		long *prot_mem = prot->prot_mem(mem);
> +		/*
> +		 * Large nestings are not the common case, and stopping in the
> +		 * middle would be complicated enough, that we bill it all the
> +		 * way through the root, and if needed, unbill everything later
> +		 */
> +		alloc = atomic_long_add_return(amt,
> +					       prot->memory_allocated(mem));
> +		*parent_failure |= (alloc > prot_mem[2]);
> +	}
> +}
> +EXPORT_SYMBOL(memcg_sock_mem_alloc);

Hmm. why not using res_counter ? for reusing 'unbill' code ?

Thanks,
-Kame

