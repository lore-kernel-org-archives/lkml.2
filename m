Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1IZK75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:59:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43366 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1IZK7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:59:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Sep 2011 19:59:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        ebiederm@xmission.com, davem@davemloft.net, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name
Subject: Re: [PATCH v3 4/7] per-cgroup tcp buffers control
Message-Id: <20110926195906.f1f5831c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1316393805-3005-5-git-send-email-glommer@parallels.com>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com>
	<1316393805-3005-5-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Sep 2011 21:56:42 -0300
Glauber Costa <glommer@parallels.com> wrote:

> With all the infrastructure in place, this patch implements
> per-cgroup control for tcp memory pressure handling.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>

a comment below.

> +int tcp_init_cgroup(struct proto *prot, struct cgroup *cgrp,
> +		    struct cgroup_subsys *ss)
> +{
> +	struct mem_cgroup *cg = mem_cgroup_from_cont(cgrp);
> +	unsigned long limit;
> +
> +	cg->tcp_memory_pressure = 0;
> +	atomic_long_set(&cg->tcp_memory_allocated, 0);
> +	percpu_counter_init(&cg->tcp_sockets_allocated, 0);
> +
> +	limit = nr_free_buffer_pages() / 8;
> +	limit = max(limit, 128UL);
> +
> +	cg->tcp_prot_mem[0] = sysctl_tcp_mem[0];
> +	cg->tcp_prot_mem[1] = sysctl_tcp_mem[1];
> +	cg->tcp_prot_mem[2] = sysctl_tcp_mem[2];
> +

Then, the parameter doesn't inherit parent's one ?

I think sockets_populate should pass 'parent' and


I think you should have a function 

    mem_cgroup_should_inherit_parent_settings(parent)

(This is because you made this feature as a part of memcg.
 please provide expected behavior.)

Thanks,
-Kame


