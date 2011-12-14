Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab1LNBR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:17:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35641 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab1LNBRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:17:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Dec 2011 10:16:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hillf Danton <dhillf@gmail.com>,
        Hugh Dickins <hughd@google.com>, Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: clean up soft_limit_tree properly new
Message-Id: <20111214101636.e463405c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111213170012.8fe53c90.akpm@linux-foundation.org>
References: <CAJd=RBB_AoJmyPd7gfHn+Kk39cn-+Wn-pFvU0ZWRZhw2fxoihw@mail.gmail.com>
	<alpine.LSU.2.00.1112111520510.2297@eggly>
	<20111212131118.GA15249@tiehlicka.suse.cz>
	<CAJd=RBAZT0zVnMm7i7P4J9Qg+LvTYh25RwFP7JZnN9dxwWp55g@mail.gmail.com>
	<20111212140750.GE14720@tiehlicka.suse.cz>
	<20111212140935.GF14720@tiehlicka.suse.cz>
	<20111213170012.8fe53c90.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011 17:00:12 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 12 Dec 2011 15:09:35 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > And a follow up patch for the proper clean up:
> > ---
> > >From 4b9f5a1e88496af9f336d1ef37cfdf3754a3ba48 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Mon, 12 Dec 2011 15:04:18 +0100
> > Subject: [PATCH] memcg: clean up soft_limit_tree properly
> > 
> > If we are not able to allocate tree nodes for all NUMA nodes then we
> > should better clean up those that were allocated otherwise we will leak
> > a memory.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  mm/memcontrol.c |   12 +++++++++++-
> >  1 files changed, 11 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6aff93c..838d812 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4874,7 +4874,7 @@ static int mem_cgroup_soft_limit_tree_init(void)
> >  			tmp = -1;
> >  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
> >  		if (!rtpn)
> > -			return 1;
> > +			goto err_cleanup;
> >  
> >  		soft_limit_tree.rb_tree_per_node[node] = rtpn;
> >  
> > @@ -4885,6 +4885,16 @@ static int mem_cgroup_soft_limit_tree_init(void)
> >  		}
> >  	}
> >  	return 0;
> > +
> > +err_cleanup:
> > +	for_each_node_state(node, N_POSSIBLE) {
> > +		if (!soft_limit_tree.rb_tree_per_node[node])
> > +			break;
> > +		kfree(soft_limit_tree.rb_tree_per_node[node]);
> > +		soft_limit_tree.rb_tree_per_node[node] = NULL;
> > +	}
> > +	return 1;
> > +
> >  }
> 
> afacit the kernel never frees the soft_limit_tree.rb_tree_per_node[]
> entries on the mem_cgroup_destroy() path.  Bug?
> 

soft_limit_tree.rb_tree_per_node[] is a global object and allocated once
at creating root cgroup.

Nodes of rb_tree for a memcg are contained in struct mem_cgroup_per_zone
and it's freed at mem_cgroup_destroy().

Thanks,
-Kame




