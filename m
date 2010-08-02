Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0HBSJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:09:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53854 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0HBSJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:09:16 -0400
Date: Mon, 2 Aug 2010 23:39:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 7/7][memcg] use spin lock instead of bit_spin_lock
 in page_cgroup
Message-ID: <20100802180911.GZ3863@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
 <20100727170225.64f78b15.kamezawa.hiroyu@jp.fujitsu.com>
 <xr93bp9sm8q1.fsf@ninji.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <xr93bp9sm8q1.fsf@ninji.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Thelen <gthelen@google.com> [2010-07-27 23:16:54]:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > This patch replaces page_cgroup's bit_spinlock with spinlock. In general,
> > spinlock has good implementation than bit_spin_lock and we should use
> > it if we have a room for it. In 64bit arch, we have extra 4bytes.
> > Let's use it.
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > --
> > Index: mmotm-0719/include/linux/page_cgroup.h
> > ===================================================================
> > --- mmotm-0719.orig/include/linux/page_cgroup.h
> > +++ mmotm-0719/include/linux/page_cgroup.h
> > @@ -10,8 +10,14 @@
> >   * All page cgroups are allocated at boot or memory hotplug event,
> >   * then the page cgroup for pfn always exists.
> >   */
> > +#ifdef CONFIG_64BIT
> > +#define PCG_HAS_SPINLOCK
> > +#endif
> >  struct page_cgroup {
> >  	unsigned long flags;
> > +#ifdef PCG_HAS_SPINLOCK
> > +	spinlock_t	lock;
> > +#endif
> >  	unsigned short mem_cgroup;	/* ID of assigned memory cgroup */
> >  	unsigned short blk_cgroup;	/* Not Used..but will be. */
> >  	struct page *page;
> > @@ -90,6 +96,16 @@ static inline enum zone_type page_cgroup
> >  	return page_zonenum(pc->page);
> >  }
> >  
> > +#ifdef PCG_HAS_SPINLOCK
> > +static inline void lock_page_cgroup(struct page_cgroup *pc)
> > +{
> > +	spin_lock(&pc->lock);
> > +}
> 
> This is minor issue, but this patch breaks usage of PageCgroupLocked().
> Example from __mem_cgroup_move_account() cases panic:
> 	VM_BUG_ON(!PageCgroupLocked(pc));
> 
> I assume that this patch should also delete the following:
> - PCG_LOCK definition from page_cgroup.h
> - TESTPCGFLAG(Locked, LOCK) from page_cgroup.h
> - PCGF_LOCK from memcontrol.c
>


Good catch! But from my understanding of the code we use spinlock_t
only for 64 bit systems, so we still need the PCG* and TESTPGFLAGS.
 
> > +static inline void unlock_page_cgroup(struct page_cgroup *pc)
> > +{
> > +	spin_unlock(&pc->lock);
> > +}
> > +#else
> >  static inline void lock_page_cgroup(struct page_cgroup *pc)
> >  {
> >  	bit_spin_lock(PCG_LOCK, &pc->flags);
> > @@ -99,6 +115,7 @@ static inline void unlock_page_cgroup(st
> >  {
> >  	bit_spin_unlock(PCG_LOCK, &pc->flags);
> >  }
> > +#endif
> >  
> >  static inline void SetPCGFileFlag(struct page_cgroup *pc, int idx)
> >  {
> > Index: mmotm-0719/mm/page_cgroup.c
> > ===================================================================
> > --- mmotm-0719.orig/mm/page_cgroup.c
> > +++ mmotm-0719/mm/page_cgroup.c
> > @@ -17,6 +17,9 @@ __init_page_cgroup(struct page_cgroup *p
> >  	pc->mem_cgroup = 0;
> >  	pc->page = pfn_to_page(pfn);
> >  	INIT_LIST_HEAD(&pc->lru);
> > +#ifdef PCG_HAS_SPINLOCK
> > +	spin_lock_init(&pc->lock);
> > +#endif
> >  }
> >  static unsigned long total_usage;
> >  

-- 
	Three Cheers,
	Balbir
