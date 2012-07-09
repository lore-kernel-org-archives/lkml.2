Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2GIAQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 20:16:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32587 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab2GIAQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 20:16:30 -0400
X-IronPort-AV: E=Sophos;i="4.77,549,1336320000"; 
   d="scan'208";a="5350121"
Message-ID: <4FFA22F3.9000704@cn.fujitsu.com>
Date: Mon, 09 Jul 2012 08:16:51 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, lizefan@huawei.com
Subject: Re: [PATCH v2] cgroup: fix panic in netprio_cgroup
References: <1341480520-25081-1-git-send-email-gaofeng@cn.fujitsu.com> <1341777043.3265.1786.camel@edumazet-glaptop>
In-Reply-To: <1341777043.3265.1786.camel@edumazet-glaptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/09 08:16:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/09 08:16:24
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月09日 03:50, Eric Dumazet 写道:
> On Thu, 2012-07-05 at 17:28 +0800, Gao feng wrote:
>> we set max_prioidx to the first zero bit index of prioidx_map in
>> function get_prioidx.
>>
>> So when we delete the low index netprio cgroup and adding a new
>> netprio cgroup again,the max_prioidx will be set to the low index.
>>
>> when we set the high index cgroup's net_prio.ifpriomap,the function
>> write_priomap will call update_netdev_tables to alloc memory which
>> size is sizeof(struct netprio_map) + sizeof(u32) * (max_prioidx + 1),
>> so the size of array that map->priomap point to is max_prioidx +1,
>> which is low than what we actually need.
>>
>> fix this by adding check in get_prioidx,only set max_prioidx when
>> max_prioidx low than the new prioidx.
>>
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  net/core/netprio_cgroup.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
>> index 5b8aa2f..aa907ed 100644
>> --- a/net/core/netprio_cgroup.c
>> +++ b/net/core/netprio_cgroup.c
>> @@ -49,8 +49,9 @@ static int get_prioidx(u32 *prio)
>>  		return -ENOSPC;
>>  	}
>>  	set_bit(prioidx, prioidx_map);
>> +	if (atomic_read(&max_prioidx) < prioidx)
>> +		atomic_set(&max_prioidx, prioidx);
>>  	spin_unlock_irqrestore(&prioidx_map_lock, flags);
>> -	atomic_set(&max_prioidx, prioidx);
>>  	*prio = prioidx;
>>  	return 0;
>>  }
> 
> This patch seems fine to me.
> 
> Acked-by: Eric Dumazet <edumazet@google.com>
> 
> Neil, looking at this file, I believe something is wrong.
> 
> dev->priomap is allocated by extend_netdev_table() called from
> update_netdev_tables(). And this is only called if write_priomap() is
> called.
> 
> But if write_priomap() is not called, it seems we can have out of bounds
> accesses in cgrp_destroy() and read_priomap()

Agree,and the function skb_update_prio has the same problem.
