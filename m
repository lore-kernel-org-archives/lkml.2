Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993487Ab2KOQPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:15:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993458Ab2KOQPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:15:08 -0500
Date: Thu, 15 Nov 2012 17:15:04 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
Message-ID: <20121115161504.GF11990@dhcp22.suse.cz>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <1352820639-13521-3-git-send-email-mhocko@suse.cz>
 <20121113161442.GA18227@mtj.dyndns.org>
 <20121114085129.GC17111@dhcp22.suse.cz>
 <20121114185245.GF21185@mtj.dyndns.org>
 <20121115095103.GB11990@dhcp22.suse.cz>
 <20121115144732.GB7306@mtj.dyndns.org>
 <20121115151255.GE11990@dhcp22.suse.cz>
 <20121115153124.GD7306@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115153124.GD7306@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-11-12 07:31:24, Tejun Heo wrote:
> Hello, Michal.
> 
> On Thu, Nov 15, 2012 at 04:12:55PM +0100, Michal Hocko wrote:
> > > Because I'd like to consider the next functions as implementation
> > > detail, and having interations structred as loops tend to read better
> > > and less error-prone.  e.g. when you use next functions directly, it's
> > > way easier to circumvent locking requirements in a way which isn't
> > > very obvious. 
> > 
> > The whole point behind mem_cgroup_iter is to hide all the complexity
> > behind memcg iteration. Memcg code either use for_each_mem_cgroup_tree
> > for !reclaim case and mem_cgroup_iter otherwise.
> > 
> > > So, unless it messes up the code too much (and I can't see why it
> > > would), I'd much prefer if memcg used for_each_*() macros.
> > 
> > As I said this would mean that the current mem_cgroup_iter code would
> > have to be inverted which doesn't simplify the code much. I'd rather
> > hide all the grossy details inside the memcg iterator.
> > Or am I still missing your suggestion?
> 
> One way or the other, I don't think the code complexity would change
> much.  Again, I'd much *prefer* if memcg used what other controllers
> would be using, but that's a preference and if necessary we can keep
> the next functions as exposed APIs. 

Yes please.

> I think the issue I have is that I can't see much technical
> justification for that. If the code becomes much simpler by choosing
> one over the other, sure, but is that the case here?

Yes and I've tried to say that already. Memcg needs hierarchy, css
ref counting and concurrent reclaim (per-zone per-priority) aware
iteration. All of that is hidden in mem_cgroup_iter currently so the
caller doesn't have to care about it at all. Which makes shrink_zone
not care about memcg that much.

cgroup_for_each_descendant_pre is not suitable at least because it
doesn't provide a way to start a walk at a selected node (which is
shared per-zone per-priority in memcg case).
Even if cgroup_for_each_descendant_pre had start parameter there
is still a lot of house keeping that callers would have to handle
(css_tryget to start with, update of the cached possible not mentioning
use_hierarchy thingy or mem_cgroup_disabled).
We also try to not pollute mm/vmscan.c as much as possible so we
definitely do not want to bring all this into shrink_zone.

This all sounds like too much of a hassle if it is exposed so I would
really like to stay with mem_cgroup_iter and slowly simplify it until it
can go away (if that is possible at all).

> Isn't it mostly just about where to put the same things?

Unfortunately no. We wouldn't grow own iterator in such a case.

> If so, what would be the rationale for requiring a different
> interface?

Does the above explain it?

-- 
Michal Hocko
SUSE Labs
