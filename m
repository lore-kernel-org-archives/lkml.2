Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2LRQr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:47:56 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:45189 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab2LRQrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:47:55 -0500
Date: Tue, 18 Dec 2012 08:47:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: don't register hotcpu notifier from ->css_alloc()
Message-ID: <20121218164747.GJ1844@htj.dyndns.org>
References: <20121214012436.GA25481@localhost>
 <20121218154030.GC10220@mtj.dyndns.org>
 <20121218164022.GB25208@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218164022.GB25208@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Tue, Dec 18, 2012 at 05:40:22PM +0100, Michal Hocko wrote:
> > +/*
> > + * The rest of init is performed during ->css_alloc() for root css which
> > + * happens before initcalls.  hotcpu_notifier() can't be done together as
> > + * it would introduce circular locking by adding cgroup_lock -> cpu hotplug
> > + * dependency.  Do it from a subsys_initcall().
> > + */
> > +static int __init mem_cgroup_init(void)
> > +{
> > +	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
> 
> Hmm, we can move enable_swap_cgroup() and per-cpu memcg_stock
> initialization here as well to make the css_alloc a bit cleaner.
> mem_cgroup_soft_limit_tree_init with a trivial BUG_ON() on allocation
> failure can go there as well. 
> 
> I will do it.

The thing was that cgroup_init() happens before any initcalls so
you'll end up with root css being set up before other stuff gets
initialized, which could be okay but a bit nasty.  I'm wondering why
cgroup_init() has to happen so early.  The cpu one is already taking
an early init path, but the rest doesn't seem to need such early init.

Anyways, yeap, no objection to cleaning up anyway which fits memcg.
We can deal with the whole init order thing later.

Thanks.

-- 
tejun
