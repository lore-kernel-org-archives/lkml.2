Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab1F3HSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:18:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58375 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1F3HSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:18:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 30 Jun 2011 16:10:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>
Subject: Re: [PATCH] [Cleanup] memcg: export memory cgroup's swappiness v2
Message-Id: <20110630161039.604f91b9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110630063231.GA12342@tiehlicka.suse.cz>
References: <20110629190325.28aa2dc6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110629130043.4dc47249.akpm@linux-foundation.org>
	<20110630123229.37424449.kamezawa.hiroyu@jp.fujitsu.com>
	<20110630063231.GA12342@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 08:32:32 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 30-06-11 12:32:29, KAMEZAWA Hiroyuki wrote:
> > On Wed, 29 Jun 2011 13:00:43 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 29 Jun 2011 19:03:25 +0900
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > 
> > > > Each memory cgroup has 'swappiness' value and it can be accessed by
> > > > get_swappiness(memcg). The major user is try_to_free_mem_cgroup_pages()
> > > > and swappiness is passed by argument. It's propagated by scan_control.
> > > > 
> > > > get_swappiness is static function but some planned updates will need to
> > > > get swappiness from files other than memcontrol.c
> > > > This patch exports get_swappiness() as mem_cgroup_swappiness().
> > > > By this, we can remove the argument of swapiness from try_to_free...
> > > > and drop swappiness from scan_control. only memcg uses it.
> > > > 
> > > 
> > > > +extern unsigned int mem_cgroup_swappiness(struct mem_cgroup *mem);
> > > > +unsigned int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> > > > +static int vmscan_swappiness(struct scan_control *sc)
> > > 
> > > The patch seems a bit confused about the signedness of swappiness.
> > > 
> > 
> > ok, v3 here. Now, memcg's one use "int" because vm_swapiness is "int".
> > ==
> > 
> > From af1bae8f2c6a8dbff048222bb45c7162b505f38b Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Wed, 29 Jun 2011 18:24:49 +0900
> > Subject: [PATCH] export memory cgroup's swappines by mem_cgroup_swappiness()
> > 
> > Each memory cgroup has 'swappiness' value and it can be accessed by
> > get_swappiness(memcg). The major user is try_to_free_mem_cgroup_pages()
> > and swappiness is passed by argument. It's propagated by scan_control.
> > 
> > get_swappiness is static function but some planned updates will need to
> > get swappiness from files other than memcontrol.c
> > This patch exports get_swappiness() as mem_cgroup_swappiness().
> > By this, we can remove the argument of swapiness from try_to_free...
> > and drop swappiness from scan_control. only memcg uses it.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 
> > 
> > Changelog:
> >   - adjusted signedness to vm_swappiness.
> >   - drop swappiness from scan_control
> > ---
> >  include/linux/swap.h |   10 +++++++---
> >  mm/memcontrol.c      |   15 +++++++--------
> >  mm/vmscan.c          |   23 ++++++++++-------------
> >  3 files changed, 24 insertions(+), 24 deletions(-)
> > 
> [...]
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 3e7d5e6..db70176 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> [...]
> > @@ -4288,7 +4287,7 @@ static u64 mem_cgroup_swappiness_read(struct cgroup *cgrp, struct cftype *cft)
> >  {
> >  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> >  
> > -	return get_swappiness(memcg);
> > +	return mem_cgroup_swappiness(memcg);
> >  }
> 
> If you want to be type clean you should change this one as well. I
> think it is worth it, though. The function is called only to return the
> current value to userspace and mem_cgroup_swappiness_write guaranties
> that it falls down into <0,100> interval. Additionally, cftype doesn't
> have any read specialization for int values so you would need to use a
> generic one. Finally if you changed read part you should change also
> write part and add > 0 check which is a lot of code for not that good
> reason.

I don't want to make this type-clean. Should I add type casting as
==
 return (u64) mem_cgroup_swappiness(memcg);
==
?

Thanks,
-Kame


