Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab1F1IJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:09:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab1F1IIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:08:52 -0400
Date: Tue, 28 Jun 2011 10:08:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
        yinghan@google.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] memcg: fix direct softlimit reclaim to be called
 in limit path
Message-ID: <20110628080847.GA16518@tiehlicka.suse.cz>
References: <201106272318.p5RNICJW001465@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106272318.p5RNICJW001465@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am sorry, that I am answering that late but I didn't get to this
sooner.

On Mon 27-06-11 16:18:12, Andrew Morton wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> commit d149e3b ("memcg: add the soft_limit reclaim in global direct
> reclaim") adds a softlimit hook to shrink_zones().  By this, soft limit is
> called as
> 
>    try_to_free_pages()
>        do_try_to_free_pages()
>            shrink_zones()
>                mem_cgroup_soft_limit_reclaim()
> 
> Then, direct reclaim is memcg softlimit hint aware, now.
> 
> But, the memory cgroup's "limit" path can call softlimit shrinker.
> 
>    try_to_free_mem_cgroup_pages()
>        do_try_to_free_pages()
>            shrink_zones()
>                mem_cgroup_soft_limit_reclaim()
> 
> This will cause a global reclaim when a memcg hits limit.

Sorry, I do not get it. How does it cause the global reclaim? Did you
mean soft reclaim?

> 
> This is bug. soft_limit_reclaim() should be called when
> scanning_global_lru(sc) == true.

Agreed

> 
> And the commit adds a variable "total_scanned" for counting softlimit
> scanned pages....it's not "total".  This patch removes the variable and
> update sc->nr_scanned instead of it. This will affect shrink_slab()'s
> scan condition but, global LRU is scanned by softlimit and I think this
> change makes sense.

Yes, the previous semantic was really confusing (part of the scanned
accounting is returned by shrink_zones and the other part in sc). This
could be ideally a separate change because it fixes a different bug
(softlimit is not considered for slab srhinking)

> 
> TODO: avoid too much scanning of a zone when softlimit did enough work.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Ying Han <yinghan@google.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Just in case it is not late yet.
Reviewed-by: Michal Hocko <mhocko@suse.cz>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
