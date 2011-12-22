Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab1LVVKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:10:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1LVVKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:10:49 -0500
Date: Thu, 22 Dec 2011 16:10:29 -0500
From: Jason Baron <jbaron@redhat.com>
To: Glauber Costa <glommer@parallels.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, paul@paulmenage.org,
        lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        ebiederm@xmission.com, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, avagin@parallels.com,
        devel@openvz.org, eric.dumazet@gmail.com, cgroups@vger.kernel.org
Subject: Re: [PATCH v9 3/9] socket: initial cgroup code.
Message-ID: <20111222211028.GB3916@redhat.com>
References: <1323676029-5890-1-git-send-email-glommer@parallels.com>
 <1323676029-5890-4-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323676029-5890-4-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 11:47:03AM +0400, Glauber Costa wrote:
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

Hi Glauber,

I think for 'sock_release_memcg()', you want:

static inline sock_release_memcg(sk)
{
	if (static_branch())
		__sock_release_memcg();
}

And then re-define the current sock_release_memcg -> __sock_release_memcg().
In that way the straight line path is a single no-op. As currently
written, there is function call and then an immediate return.

Thanks,

-Jason



