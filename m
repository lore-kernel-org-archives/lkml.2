Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1IZOkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:40:33 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7396 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab1IZOkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:40:31 -0400
Message-ID: <4E808EA6.4000301@gmail.com>
Date: Mon, 26 Sep 2011 18:39:34 +0400
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name
Subject: Re: [PATCH v3 4/7] per-cgroup tcp buffers control
References: <1316393805-3005-1-git-send-email-glommer@parallels.com> <1316393805-3005-5-git-send-email-glommer@parallels.com>
In-Reply-To: <1316393805-3005-5-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't change net.ipv4.tcp_mem if a cgroup with memory controller 
isn't mounted.

[root@dhcp-10-30-20-19 ~]# sysctl -w net.ipv4.tcp_mem="3 2 3"
error: "Invalid argument" setting key "net.ipv4.tcp_mem"

It's because tcp_max_memory is initialized in mem_cgroup_populate:

mem_cgroup_populate->register_kmem_files->sockets_populate->tcp_init_cgroup

> +int sockets_populate(struct cgroup *cgrp, struct cgroup_subsys *ss)
> +{
> +	struct proto *proto;
> +	int ret = 0;
> +
> +	read_lock(&proto_list_lock);
> +	list_for_each_entry(proto,&proto_list, node) {
> +		if (proto->init_cgroup)
> +			ret |= proto->init_cgroup(proto, cgrp, ss);
> +	}
> +	if (!ret)
> +		goto out;
> +
> +	list_for_each_entry_continue_reverse(proto,&proto_list, node)
> +		if (proto->destroy_cgroup)
> +			proto->destroy_cgroup(proto, cgrp, ss);
> +
> +out:
> +	read_unlock(&proto_list_lock);
> +	return ret;
> +}

> @@ -198,6 +203,21 @@ static int ipv4_tcp_mem(ctl_table *ctl, int write,
>   	if (ret)
>   		return ret;
>
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +	rcu_read_lock();
> +	cg = mem_cgroup_from_task(current);
> +	for (i = 0; i<  3; i++)
> +		if (vec[i]>  tcp_max_memory(cg)) {
> +			rcu_read_unlock();
> +			return -EINVAL;
> +		}

