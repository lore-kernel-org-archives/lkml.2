Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2EWHrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:47:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:2426 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2EWHrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:47:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146644228"
Message-ID: <1337759279.14538.201.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, kunx.jiang@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 15:47:59 +0800
In-Reply-To: <1337758775.3361.2056.camel@edumazet-glaptop>
References: <4FBB6105.2060808@intel.com>
	 <20120522.151554.106838106733194160.davem@davemloft.net>
	 <1337742123.14538.175.camel@ymzhang.sh.intel.com>
	 <20120522.232310.911242148705021745.davem@davemloft.net>
	 <1337747829.3361.1599.camel@edumazet-glaptop>
	 <1337748897.14538.184.camel@ymzhang.sh.intel.com>
	 <1337749339.3361.1655.camel@edumazet-glaptop>
	 <1337753757.14538.190.camel@ymzhang.sh.intel.com>
	 <1337754459.3361.1850.camel@edumazet-glaptop>
	 <1337755623.14538.194.camel@ymzhang.sh.intel.com>
	 <1337756138.3361.1922.camel@edumazet-glaptop>
	 <1337757238.3361.1965.camel@edumazet-glaptop>
	 <1337757862.14538.199.camel@ymzhang.sh.intel.com>
	 <1337758775.3361.2056.camel@edumazet-glaptop>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 09:39 +0200, Eric Dumazet wrote:
> On Wed, 2012-05-23 at 15:24 +0800, Yanmin Zhang wrote:
> > On Wed, 2012-05-23 at 09:13 +0200, Eric Dumazet wrote:
> > > On Wed, 2012-05-23 at 08:55 +0200, Eric Dumazet wrote:
> > > 
> > > > Please hold on, I'll send a v2
> > > 
> > > I believe your patch should be fine, if you move back the
> > > fib_info_cnt--;
> > > 
> > > So only do the dev_put() in free_fib_info_rcu().
> > We would do so in a new patch.
> > 
> > > 
> > > No need to clear nh_dev to NULL since we are freeing fi at the end of
> > > function.
> > David suggests to reset it to NULL to detect other potential
> > race conditions.
> > 
> 
> Yes but no.
> 
> Users are in a RCU read lock and we should not change nh_dev to NULL
> while they are running.
> 
> Thats what I tried to do (David message gave me this wrong hint) but it
> came to a dead issue.
> 
> Only after a grace period we can :
> 	dev_put() all involved net_devices
> 	kfree(fi)
> 
> > Besides above suggestions, how do you think about:
> > 
> > fib_create_info=>fib_find_info, but fib_find_info is not protected by
> > fib_info_lock. See the codes:
> > 
> > fib_create_info()
> > {
> > 	...
> > link_it:
> >         ofi = fib_find_info(fi);
> >         if (ofi) {
> >                 fi->fib_dead = 1;
> >                 free_fib_info(fi);
> >                 ofi->fib_treeref++;
> >                 return ofi;
> >         }
> >         fi->fib_treeref++;
> >         atomic_inc(&fi->fib_clntref);
> >         spin_lock_bh(&fib_info_lock);
> > 
> > 	...
> > }
> > 
> > I plan to change it to hold fib_info_lock before calling fib_find_info. Is
> > it ok for you?
> 
> Its not needed we hold RTNL mutex.
Thanks. We would work out a new patch and post it here after running MTBF
testing.


