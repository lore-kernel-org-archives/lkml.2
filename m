Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0HCE47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:56:59 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:60370 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab0HCE46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:56:58 -0400
Date: Tue, 3 Aug 2010 13:51:29 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH -mm 1/5] quick lookup memcg by ID
Message-Id: <20100803135129.4316dfff.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100803133723.bb6487a0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802191304.8e520808.kamezawa.hiroyu@jp.fujitsu.com>
	<20100803133109.c0e6f150.nishimura@mxp.nes.nec.co.jp>
	<20100803133723.bb6487a0.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 13:37:23 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 3 Aug 2010 13:31:09 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
(snip)
> > > +/* 0 is unused */
> > > +static atomic_t mem_cgroup_num;
> > > +#define NR_MEMCG_GROUPS (CONFIG_MEM_CGROUP_MAX_GROUPS + 1)
> > > +static struct mem_cgroup *mem_cgroups[NR_MEMCG_GROUPS] __read_mostly;
> > > +
> > > +static struct mem_cgroup *id_to_memcg(unsigned short id)
> > > +{
> > > +	/*
> > > +	 * This array is set to NULL when mem_cgroup is freed.
> > > +	 * IOW, there are no more references && rcu_synchronized().
> > > +	 * This lookup-caching is safe.
> > > +	 */
> > > +	if (unlikely(!mem_cgroups[id])) {
> > > +		struct cgroup_subsys_state *css;
> > > +
> > > +		rcu_read_lock();
> > > +		css = css_lookup(&mem_cgroup_subsys, id);
> > > +		rcu_read_unlock();
> > > +		if (!css)
> > > +			return NULL;
> > > +		mem_cgroups[id] = container_of(css, struct mem_cgroup, css);
> > > +	}
> > > +	return mem_cgroups[id];
> > > +}
> > id_to_memcg() seems to be called under rcu_read_lock() already, so I think
> > rcu_read_lock()/unlock() would be unnecessary.
> > 
> 
> Maybe. I thought about which is better to add
> 
> 	VM_BUG_ON(!rcu_read_lock_held);
> or
> 	rcu_read_lock()
> 	..
> 	rcu_read_unlock()
> 
> Do you like former ? If so, it's ok to remove rcu-read-lock.
> 
Yes, I personally like the former.
