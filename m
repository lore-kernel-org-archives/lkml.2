Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1FWG2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:28:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38230 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1FWG2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:28:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jun 2011 15:21:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/7] Fix mem_cgroup_hierarchical_reclaim() to do stable
 hierarchy walk.
Message-Id: <20110623152111.a491e954.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110622183249.GA27191@tiehlicka.suse.cz>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616125141.5fbd230f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110622151500.GF14343@tiehlicka.suse.cz>
	<20110622183249.GA27191@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 20:33:31 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Wed 22-06-11 17:15:00, Michal Hocko wrote:
> > On Thu 16-06-11 12:51:41, KAMEZAWA Hiroyuki wrote:
> > [...]
> > > @@ -1667,41 +1668,28 @@ static int mem_cgroup_hierarchical_recla
> > >  	if (!check_soft && root_mem->memsw_is_minimum)
> > >  		noswap = true;
> > >  
> > > -	while (1) {
> > > +again:
> > > +	if (!shrink) {
> > > +		visit = 0;
> > > +		for_each_mem_cgroup_tree(victim, root_mem)
> > > +			visit++;
> > > +	} else {
> > > +		/*
> > > +		 * At shrinking, we check the usage again in caller side.
> > > +		 * so, visit children one by one.
> > > +		 */
> > > +		visit = 1;
> > > +	}
> > > +	/*
> > > +	 * We are not draining per cpu cached charges during soft limit reclaim
> > > +	 * because global reclaim doesn't care about charges. It tries to free
> > > +	 * some memory and  charges will not give any.
> > > +	 */
> > > +	if (!check_soft)
> > > +		drain_all_stock_async(root_mem);
> > > +
> > > +	while (visit--) {
> > 
> > This is racy, isn't it? What prevents some groups to disapear in the
> > meantime? We would reclaim from those that are left more that we want.
> > 
> > Why cannot we simply do something like (totally untested):
> > 
> > Index: linus_tree/mm/memcontrol.c
> > ===================================================================
> > --- linus_tree.orig/mm/memcontrol.c	2011-06-22 17:11:54.000000000 +0200
> > +++ linus_tree/mm/memcontrol.c	2011-06-22 17:13:05.000000000 +0200
> > @@ -1652,7 +1652,7 @@ static int mem_cgroup_hierarchical_recla
> >  						unsigned long reclaim_options,
> >  						unsigned long *total_scanned)
> >  {
> > -	struct mem_cgroup *victim;
> > +	struct mem_cgroup *victim, *first_victim = NULL;
> >  	int ret, total = 0;
> >  	int loop = 0;
> >  	bool noswap = reclaim_options & MEM_CGROUP_RECLAIM_NOSWAP;
> > @@ -1669,6 +1669,11 @@ static int mem_cgroup_hierarchical_recla
> >  
> >  	while (1) {
> >  		victim = mem_cgroup_select_victim(root_mem);
> > +		if (!first_victim)
> > +			first_victim = victim;
> > +		else if (first_victim == victim)
> > +			break;
> 
> this will obviously need css_get and css_put to make sure that the group
> doesn't disappear in the meantime.
> 

I forgot why we didn't this. Hmm, ok, I'll use this style.

Thanks,
-Kame




