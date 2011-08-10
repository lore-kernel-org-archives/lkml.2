Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1HJA3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 20:29:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54728 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1HJA3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 20:29:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 10 Aug 2011 09:22:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] memcg: make oom_lock 0 and 1 based rather than
 coutner
Message-Id: <20110810092224.7085ca7f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110809153732.GC13411@redhat.com>
References: <cover.1310732789.git.mhocko@suse.cz>
	<44ec61829ed8a83b55dc90a7aebffdd82fe0e102.1310732789.git.mhocko@suse.cz>
	<20110809140312.GA2265@redhat.com>
	<20110809152218.GK7463@tiehlicka.suse.cz>
	<20110809153732.GC13411@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011 17:37:32 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Tue, Aug 09, 2011 at 05:22:18PM +0200, Michal Hocko wrote:
> > On Tue 09-08-11 16:03:12, Johannes Weiner wrote:
> > >  	struct mem_cgroup *iter, *failed = NULL;
> > >  	bool cond = true;
> > >  
> > >  	for_each_mem_cgroup_tree_cond(iter, mem, cond) {
> > > -		bool locked = iter->oom_lock;
> > > -
> > > -		iter->oom_lock = true;
> > > -		if (lock_count == -1)
> > > -			lock_count = iter->oom_lock;
> > > -		else if (lock_count != locked) {
> > > +		if (iter->oom_lock) {
> > >  			/*
> > >  			 * this subtree of our hierarchy is already locked
> > >  			 * so we cannot give a lock.
> > >  			 */
> > > -			lock_count = 0;
> > >  			failed = iter;
> > >  			cond = false;
> > > -		}
> > > +		} else
> > > +			iter->oom_lock = true;
> > >  	}
> > >  
> > >  	if (!failed)
> > 
> > We can return here and get rid of done label.
> 
> Ah, right you are.  Here is an update.
> 
> ---
> From 86b36904033e6c6a1af4716e9deef13ebd31e64c Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <jweiner@redhat.com>
> Date: Tue, 9 Aug 2011 15:31:30 +0200
> Subject: [patch] memcg: fix hierarchical oom locking
> 
> Commit "79dfdac memcg: make oom_lock 0 and 1 based rather than
> counter" tried to oom lock the hierarchy and roll back upon
> encountering an already locked memcg.
> 
> The code is confused when it comes to detecting a locked memcg,
> though, so it would fail and rollback after locking one memcg and
> encountering an unlocked second one.
> 
> The result is that oom-locking hierarchies fails unconditionally and
> that every oom killer invocation simply goes to sleep on the oom
> waitqueue forever.  The tasks practically hang forever without anyone
> intervening, possibly holding locks that trip up unrelated tasks, too.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


