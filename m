Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab2GJEOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 00:14:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40969 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2GJEOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 00:14:16 -0400
Subject: Re: [PATCH] net: cgroup: fix access the unallocated memory in
 netprio cgroup
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        Eric Dumazet <edumazet@google.com>
In-Reply-To: <1341887508-20302-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1341837625.3265.2748.camel@edumazet-glaptop>
	 <1341887508-20302-1-git-send-email-gaofeng@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jul 2012 06:14:10 +0200
Message-ID: <1341893650.3265.3974.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 10:31 +0800, Gao feng wrote:
> there are some out of bound accesses in netprio cgroup.
> when creating a new netprio cgroup,we only set a prioidx for
> the new cgroup,without allocate memory for dev->priomap.
> 
> because we don't want to see additional bound checkings in
> fast path, so I think the best way is to allocate memory when we
> creating a new netprio cgroup.
> 
> and because netdev can be created or registered after cgroup being
> created, so extend_netdev_table is also needed in write_priomap.
> 
> this patch add a return value for update_netdev_tables & extend_netdev_table,
> so when new_priomap is allocated failed,write_priomap will stop to access
> the priomap,and return -ENOMEM back to the userspace to tell the user
> what happend.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---

>  static void cgrp_destroy(struct cgroup *cgrp)
> @@ -221,7 +233,10 @@ static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
>  	if (!dev)
>  		goto out_free_devname;
>  
> -	update_netdev_tables();
> +	ret = update_netdev_tables();
> +	if (ret < 0)
> +		goto out_free_devname;
> +
>  	ret = 0;
>  	rcu_read_lock();
>  	map = rcu_dereference(dev->priomap);

Hi Gao

Is it still needed to call update_netdev_tables() from write_priomap() ?



