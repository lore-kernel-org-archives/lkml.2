Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab1K3Ao1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 19:44:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60259 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab1K3AoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 19:44:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 30 Nov 2011 09:43:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        ebiederm@xmission.com, davem@davemloft.net, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH v7 02/10] foundations of per-cgroup memory pressure
 controlling.
Message-Id: <20111130094305.9c69ecd8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322611021-1730-3-git-send-email-glommer@parallels.com>
References: <1322611021-1730-1-git-send-email-glommer@parallels.com>
	<1322611021-1730-3-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 21:56:53 -0200
Glauber Costa <glommer@parallels.com> wrote:

> This patch replaces all uses of struct sock fields' memory_pressure,
> memory_allocated, sockets_allocated, and sysctl_mem to acessor
> macros. Those macros can either receive a socket argument, or a mem_cgroup
> argument, depending on the context they live in.
> 
> Since we're only doing a macro wrapping here, no performance impact at all is
> expected in the case where we don't have cgroups disabled.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
<snip>

> +static inline bool
> +memcg_memory_pressure(struct proto *prot, struct mem_cgroup *memcg)
> +{
> +	if (!prot->memory_pressure)
> +		return false;
> +	return !!prot->memory_pressure;
> +}

I think you should take a deep breath and write patech relaxedly, and do enough test.

This should be

	return !!*prot->memory_pressure;

BTW, I don't like to receive tons of everyday-update even if you're in hurry.





>  static void proto_seq_printf(struct seq_file *seq, struct proto *proto)
>  {
> +	struct mem_cgroup *memcg = mem_cgroup_from_task(current);
> +
>  	seq_printf(seq, "%-9s %4u %6d  %6ld   %-3s %6u   %-3s  %-10s "
>  			"%2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c %2c\n",
>  		   proto->name,
>  		   proto->obj_size,
>  		   sock_prot_inuse_get(seq_file_net(seq), proto),
> -		   proto->memory_allocated != NULL ? atomic_long_read(proto->memory_allocated) : -1L,
> -		   proto->memory_pressure != NULL ? *proto->memory_pressure ? "yes" : "no" : "NI",
> +		   sock_prot_memory_allocated(proto, memcg),
> +		   sock_prot_memory_pressure(proto, memcg),

I wonder I should say NO, here. (Networking guys are ok ??)

IIUC, this means there is no way to see aggregated sockstat of all system.
And the result depends on the cgroup which the caller is under control.

I think you should show aggregated sockstat(global + per-memcg) here and 
show per-memcg ones via /cgroup interface or add private_sockstat to show
per cgroup summary.

Thanks,
-Kame

