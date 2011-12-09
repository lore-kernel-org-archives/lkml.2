Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1LICHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 21:07:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59641 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1LICHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:07:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Dec 2011 11:05:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, avagin@parallels.com,
        devel@openvz.org, eric.dumazet@gmail.com, cgroups@vger.kernel.org,
        hannes@cmpxchg.org, mhocko@suse.cz,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@fujtsu.com>
Subject: Re: [PATCH v8 3/9] socket: initial cgroup code.
Message-Id: <20111209110550.fc740b81.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1323120903-2831-4-git-send-email-glommer@parallels.com>
References: <1323120903-2831-1-git-send-email-glommer@parallels.com>
	<1323120903-2831-4-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Dec 2011 19:34:57 -0200
Glauber Costa <glommer@parallels.com> wrote:

> The goal of this work is to move the memory pressure tcp
> controls to a cgroup, instead of just relying on global
> conditions.
> 
> To avoid excessive overhead in the network fast paths,
> the code that accounts allocated memory to a cgroup is
> hidden inside a static_branch(). This branch is patched out
> until the first non-root cgroup is created. So when nobody
> is using cgroups, even if it is mounted, no significant performance
> penalty should be seen.
> 
> This patch handles the generic part of the code, and has nothing
> tcp-specific.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Kirill A. Shutemov <kirill@shutemov.name>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtsu.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>

I already replied Reviewed-by: but...


> +/* Writing them here to avoid exposing memcg's inner layout */
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +#ifdef CONFIG_INET
> +#include <net/sock.h>
> +
> +static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
> +void sock_update_memcg(struct sock *sk)
> +{
> +	/* A socket spends its whole life in the same cgroup */
> +	if (sk->sk_cgrp) {
> +		WARN_ON(1);
> +		return;
> +	}
> +	if (static_branch(&memcg_socket_limit_enabled)) {
> +		struct mem_cgroup *memcg;
> +
> +		BUG_ON(!sk->sk_prot->proto_cgroup);
> +
> +		rcu_read_lock();
> +		memcg = mem_cgroup_from_task(current);
> +		if (!mem_cgroup_is_root(memcg)) {
> +			mem_cgroup_get(memcg);
> +			sk->sk_cgrp = sk->sk_prot->proto_cgroup(memcg);
> +		}
> +		rcu_read_unlock();
> +	}
> +}

Here, you do mem_cgroup_get() if !mem_cgroup_is_root().


> +EXPORT_SYMBOL(sock_update_memcg);
> +
> +void sock_release_memcg(struct sock *sk)
> +{
> +	if (static_branch(&memcg_socket_limit_enabled) && sk->sk_cgrp) {
> +		struct mem_cgroup *memcg;
> +		WARN_ON(!sk->sk_cgrp->memcg);
> +		memcg = sk->sk_cgrp->memcg;
> +		mem_cgroup_put(memcg);
> +	}
> +}
>

You don't check !mem_cgroup_is_root(). Hm, root memcg will not be freed
by this ?

Thanks,
-Kame


