Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab1K3CBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:01:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52448 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab1K3CBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:01:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 30 Nov 2011 11:00:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        ebiederm@xmission.com, davem@davemloft.net, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH v7 06/10] tcp buffer limitation: per-cgroup limit
Message-Id: <20111130110029.c6a989af.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322611021-1730-7-git-send-email-glommer@parallels.com>
References: <1322611021-1730-1-git-send-email-glommer@parallels.com>
	<1322611021-1730-7-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 21:56:57 -0200
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

you need one more fix.
(please add changelog.)


> +static int tcp_update_limit(struct mem_cgroup *memcg, u64 val)
> +{
> +	struct net *net = current->nsproxy->net_ns;
> +	struct tcp_memcontrol *tcp;
> +	struct cg_proto *cg_proto;
> +	u64 old_lim;
> +	int i;
> +	int ret;
> +
> +	cg_proto = tcp_prot.proto_cgroup(memcg);
> +	if (!cg_proto)
> +		return -EINVAL;
> +
> +	tcp = tcp_from_cgproto(cg_proto);
> +
> +	old_lim = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_LIMIT);
> +	ret = res_counter_set_limit(&tcp->tcp_memory_allocated, val);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < 3; i++)
> +		tcp->tcp_prot_mem[i] = min_t(long, val >> PAGE_SHIFT,
> +					     net->ipv4.sysctl_tcp_mem[i]);
> +
> +	if (val == RESOURCE_MAX)
> +		jump_label_dec(&memcg_socket_limit_enabled);

if (val == RESOUCE_MAX && old_lim != RESOUCE_MAX)

Thanks,
-Kame

