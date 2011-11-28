Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1K1D0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 22:26:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50799 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab1K1D0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:26:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Nov 2011 12:24:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, paul@paulmenage.org, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH v6 06/10] tcp buffer limitation: per-cgroup limit
Message-Id: <20111128122452.734d93c0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322242696-27682-7-git-send-email-glommer@parallels.com>
References: <1322242696-27682-1-git-send-email-glommer@parallels.com>
	<1322242696-27682-7-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some comments.

On Fri, 25 Nov 2011 15:38:12 -0200
Glauber Costa <glommer@parallels.com> wrote:

> This patch uses the "tcp.limit_in_bytes" field of the kmem_cgroup to
> effectively control the amount of kernel memory pinned by a cgroup.
> 
> This value is ignored in the root cgroup, and in all others,
> caps the value specified by the admin in the net namespaces'
> view of tcp_sysctl_mem.
> 
> If namespaces are being used, the admin is allowed to set a
> value bigger than cgroup's maximum, the same way it is allowed
> to set pretty much unlimited values in a real box.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>

<snip>

>  EXPORT_SYMBOL(tcp_destroy_cgroup);
> +
> +int tcp_update_limit(struct mem_cgroup *memcg, u64 val)
> +{
> +	struct net *net = current->nsproxy->net_ns;
> +	struct tcp_memcontrol *tcp;
> +	struct cg_proto *cg_proto;
> +	int i;
> +	int ret;
> +
> +	cg_proto = tcp_prot.proto_cgroup(memcg);
> +	if (!cg_proto)
> +		return -EINVAL;
> +
> +	tcp = tcp_from_cgproto(cg_proto);
> +
> +	ret = res_counter_set_limit(&tcp->tcp_memory_allocated, val);

Here, you changed the limit.

> +	if (ret)
> +		return ret;
> +
> +	val >>= PAGE_SHIFT;

Here, you modifies 'val'

> +
> +	for (i = 0; i < 3; i++)
> +		tcp->tcp_prot_mem[i] = min_t(long, val,
> +					     net->ipv4.sysctl_tcp_mem[i]);
> +
> +	if (val == RESOURCE_MAX)
> +		jump_label_dec(&memcg_socket_limit_enabled);

the 'val' never be RESOUECE_MAX.


> +	else {
> +		u64 old_lim;
> +		old_lim = res_counter_read_u64(&tcp->tcp_memory_allocated,
> +					       RES_LIMIT);

old_lim is not already overwritten ?

> +		if (old_lim == RESOURCE_MAX)
> +			jump_label_inc(&memcg_socket_limit_enabled);
> +	}
> +	return 0;
> +}
> +

Thanks,
-Kame

