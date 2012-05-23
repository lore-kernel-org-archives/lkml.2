Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2EWEyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:54:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:2761 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab2EWEyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:54:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146589648"
Message-ID: <1337748897.14538.184.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, kunx.jiang@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 12:54:57 +0800
In-Reply-To: <1337747829.3361.1599.camel@edumazet-glaptop>
References: <4FBB6105.2060808@intel.com>
	 <20120522.151554.106838106733194160.davem@davemloft.net>
	 <1337742123.14538.175.camel@ymzhang.sh.intel.com>
	 <20120522.232310.911242148705021745.davem@davemloft.net>
	 <1337747829.3361.1599.camel@edumazet-glaptop>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 06:37 +0200, Eric Dumazet wrote:
> On Tue, 2012-05-22 at 23:23 -0400, David Miller wrote:
> > From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> > Date: Wed, 23 May 2012 11:02:03 +0800
> > 
> > > 1) Why does free_fib_info call call_rcu instead of releasing fi directly?
> > > I assume other cpu might be accessing it. nexthop_nh->nh_dev is in fi.
> > > If other cpu are accessing it, here resetting to NULL would cause other
> > > cpu panic.
> > 
> > Because fib trie lookups are done with RCU locking, therefore we must
> > use RCU freeing to release the object.
> > 
> > What I was trying to impart to you is that removing the NULL
> > assignment is wrong and that an alternative fix is warranted (hint:
> > consider moving something into the RCU release).
> > --
> 
> Its more than that I'm afraid.
> 
> fi->fib_dev (aka fib_nh[0].nh_dev) need full RCU protection.
The new patch posted at https://lkml.org/lkml/2012/5/22/558 does move the
resetting to RCU protection.

> 
> Also the "fib_info_cnt--;" must stay in free_fib_info() (so that it is
> protected by RTNL)
We would move "fib_info_cnt--;" back to free_fib_info.

Thanks,
Yanmin


