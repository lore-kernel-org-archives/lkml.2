Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0HCEmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:42:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59697 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab0HCEmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:42:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 3 Aug 2010 13:37:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/5] quick lookup memcg by ID
Message-Id: <20100803133723.bb6487a0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100803133109.c0e6f150.nishimura@mxp.nes.nec.co.jp>
References: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802191304.8e520808.kamezawa.hiroyu@jp.fujitsu.com>
	<20100803133109.c0e6f150.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 13:31:09 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi.
> 
> Thank you for all of your works.
> 
> Several comments are inlined.
> 
> On Mon, 2 Aug 2010 19:13:04 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, memory cgroup has an ID per cgroup and make use of it at
> >  - hierarchy walk,
> >  - swap recording.
> > 
> > This patch is for making more use of it. The final purpose is
> > to replace page_cgroup->mem_cgroup's pointer to an unsigned short.
> > 
> > This patch caches a pointer of memcg in an array. By this, we
> > don't have to call css_lookup() which requires radix-hash walk.
> > This saves some amount of memory footprint at lookup memcg via id.
> > 
> > Changelog: 20100730
> >  - fixed rcu_read_unlock() placement.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  init/Kconfig    |   11 +++++++++++
> >  mm/memcontrol.c |   48 ++++++++++++++++++++++++++++++++++--------------
> >  2 files changed, 45 insertions(+), 14 deletions(-)
> > 
> > Index: mmotm-0727/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-0727.orig/mm/memcontrol.c
> > +++ mmotm-0727/mm/memcontrol.c
> > @@ -292,6 +292,30 @@ static bool move_file(void)
> >  					&mc.to->move_charge_at_immigrate);
> >  }
> >  
> > +/* 0 is unused */
> > +static atomic_t mem_cgroup_num;
> > +#define NR_MEMCG_GROUPS (CONFIG_MEM_CGROUP_MAX_GROUPS + 1)
> > +static struct mem_cgroup *mem_cgroups[NR_MEMCG_GROUPS] __read_mostly;
> > +
> > +static struct mem_cgroup *id_to_memcg(unsigned short id)
> > +{
> > +	/*
> > +	 * This array is set to NULL when mem_cgroup is freed.
> > +	 * IOW, there are no more references && rcu_synchronized().
> > +	 * This lookup-caching is safe.
> > +	 */
> > +	if (unlikely(!mem_cgroups[id])) {
> > +		struct cgroup_subsys_state *css;
> > +
> > +		rcu_read_lock();
> > +		css = css_lookup(&mem_cgroup_subsys, id);
> > +		rcu_read_unlock();
> > +		if (!css)
> > +			return NULL;
> > +		mem_cgroups[id] = container_of(css, struct mem_cgroup, css);
> > +	}
> > +	return mem_cgroups[id];
> > +}
> id_to_memcg() seems to be called under rcu_read_lock() already, so I think
> rcu_read_lock()/unlock() would be unnecessary.
> 

Maybe. I thought about which is better to add

	VM_BUG_ON(!rcu_read_lock_held);
or
	rcu_read_lock()
	..
	rcu_read_unlock()

Do you like former ? If so, it's ok to remove rcu-read-lock.



> > Index: mmotm-0727/init/Kconfig
> > ===================================================================
> > --- mmotm-0727.orig/init/Kconfig
> > +++ mmotm-0727/init/Kconfig
> > @@ -594,6 +594,17 @@ config CGROUP_MEM_RES_CTLR_SWAP
> >  	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
> >  	  size is 4096bytes, 512k per 1Gbytes of swap.
> >  
> > +config MEM_CGROUP_MAX_GROUPS
> > +	int "Maximum number of memory cgroups on a system"
> > +	range 1 65535
> > +	default 8192 if 64BIT
> > +	default 2048 if 32BIT
> > +	help
> > +	  Memory cgroup has limitation of the number of groups created.
> > +	  Please select your favorite value. The more you allow, the more
> > +	  memory will be consumed. This consumes vmalloc() area, so,
> > +	  this should be small on 32bit arch.
> > +
> We don't use vmalloc() area in this version :)
> 
Oh. yes. thank you. I'll fix

Thanks,
-Kame


