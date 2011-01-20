Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1ATXrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:47:53 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48836 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1ATXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:47:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Jan 2011 08:41:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] memcg: fix rmdir, force_empty with THP
Message-Id: <20110121084151.4673c179.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110121083930.d803126f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110118113528.fd24928f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110118114348.9e1dba9b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110120134108.GO2232@cmpxchg.org>
	<20110121083930.d803126f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 08:39:30 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 20 Jan 2011 14:41:08 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > On Tue, Jan 18, 2011 at 11:43:48AM +0900, KAMEZAWA Hiroyuki wrote:
> > > 
> > > Now, when THP is enabled, memcg's rmdir() function is broken
> > > because move_account() for THP page is not supported.
> > > 
> > > This will cause account leak or -EBUSY issue at rmdir().
> > > This patch fixes the issue by supporting move_account() THP pages.
> > > 
> > > Changelog:
> > >  - style fix.
> > >  - add compound_lock for avoiding races.
> > > 
> > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > ---
> > >  mm/memcontrol.c |   37 ++++++++++++++++++++++++++-----------
> > >  1 file changed, 26 insertions(+), 11 deletions(-)
> > > 
> > > Index: mmotm-0107/mm/memcontrol.c
> > > ===================================================================
> > > --- mmotm-0107.orig/mm/memcontrol.c
> > > +++ mmotm-0107/mm/memcontrol.c
> > 
> > > @@ -2267,6 +2274,8 @@ static int mem_cgroup_move_parent(struct
> > >  	struct cgroup *cg = child->css.cgroup;
> > >  	struct cgroup *pcg = cg->parent;
> > >  	struct mem_cgroup *parent;
> > > +	int charge = PAGE_SIZE;
> > 
> > No need to initialize, you assign it unconditionally below.
> > 
> > It's also a bit unfortunate that the parameter/variable with this
> > meaning appears under a whole bunch of different names.  page_size,
> > charge_size, and now charge.  Could you stick with page_size?
> > 
> 
> charge_size != page_size.
> 
> Clean up as you like, later. I'll Ack.
> 
> > > @@ -2278,17 +2287,23 @@ static int mem_cgroup_move_parent(struct
> > >  		goto out;
> > >  	if (isolate_lru_page(page))
> > >  		goto put;
> > > +	/* The page is isolated from LRU and we have no race with splitting */
> > > +	charge = PAGE_SIZE << compound_order(page);
> > 
> > Why is LRU isolation preventing the splitting?
> > 
> 
> That's my mistake of comment, which was in the older patch.
> I use compound_lock now. I'll post clean up.
> 
It seems patches are sent to Linus's tree.

I'll post some clean up patches for memcontrol.c.
I hope that will not break other guy's works.

Thanks,
-kame


