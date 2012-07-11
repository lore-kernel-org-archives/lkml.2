Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2GKMLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:11:22 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52960 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2GKMLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:11:20 -0400
Date: Wed, 11 Jul 2012 08:11:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v3] net: cgroup: fix access the unallocated memory in
 netprio cgroup
Message-ID: <20120711121102.GB26643@hmsreliant.think-freely.org>
References: <1341995406-12719-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341995406-12719-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 04:30:06PM +0800, Gao feng wrote:
> there are some out of bound accesses in netprio cgroup.
> 
> now before accessing the dev->priomap.priomap array,we only check
> if the dev->priomap exist.and because we don't want to see
> additional bound checkings in fast path, so we should make sure
> that dev->priomap is null or array size of dev->priomap.priomap
> is equal to max_prioidx + 1;
> 
> and it's not needed to call extend_netdev_tabel in write_priomap,
> we can only allocate the net device's priomap which we change through
> net_prio.ifpriomap.
> 
> this patch add a return value for update_netdev_tables & extend_netdev_table,
> so when new_priomap is allocated failed,write_priomap will stop to access
> the priomap,and return -ENOMEM back to the userspace to tell the user
> what happend.
> 
> Change From v2:
> 1. protect extend_netdev_table by RTNL.
> 2. when extend_netdev_table failed,call dev_put to reduce device's refcount.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
>  net/core/netprio_cgroup.c |   54 ++++++++++++++++++++++++++++++++------------
>  1 files changed, 39 insertions(+), 15 deletions(-)
> 
I still think the use of max_priomap in write_priomap is racy (please see my
previous note).

Neil

