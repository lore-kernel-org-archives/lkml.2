Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1JDMsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:48:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47065 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1JDMsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:48:45 -0400
Subject: Re: [PATCH v5 6/8] tcp buffer limitation: per-cgroup limit
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, avagin@parallels.com,
        devel@openvz.org
In-Reply-To: <1317730680-24352-7-git-send-email-glommer@parallels.com>
References: <1317730680-24352-1-git-send-email-glommer@parallels.com>
	 <1317730680-24352-7-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 14:48:55 +0200
Message-ID: <1317732535.2440.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 04 octobre 2011 à 16:17 +0400, Glauber Costa a écrit :
> This patch uses the "tcp_max_mem" field of the kmem_cgroup to
> effectively control the amount of kernel memory pinned by a cgroup.
> 
> We have to make sure that none of the memory pressure thresholds
> specified in the namespace are bigger than the current cgroup.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> ---


> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -256,6 +256,7 @@ extern int sysctl_tcp_thin_dupack;
>  struct mem_cgroup;
>  struct tcp_memcontrol {
>  	/* per-cgroup tcp memory pressure knobs */
> +	int tcp_max_memory;
>  	atomic_long_t tcp_memory_allocated;
>  	struct percpu_counter tcp_sockets_allocated;
>  	/* those two are read-mostly, leave them at the end */
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c

So tcp_max_memory is an "int".


> +static u64 tcp_read_limit(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> +	return memcg->tcp.tcp_max_memory << PAGE_SHIFT;
> +}

1) Typical integer overflow here.

You need :

return ((u64)memcg->tcp.tcp_max_memory) << PAGE_SHIFT;


2) Could you add const qualifiers when possible to your pointers ?



