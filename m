Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1AUHTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:19:19 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52785 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1AUHTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:19:17 -0500
Date: Fri, 21 Jan 2011 12:49:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [REPOST] [PATCH 1/3] Move zone_reclaim() outside of
 CONFIG_NUMA (v3)
Message-ID: <20110121071911.GJ2897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110120123039.30481.81151.stgit@localhost6.localdomain6>
 <20110120123608.30481.63446.stgit@localhost6.localdomain6>
 <alpine.DEB.2.00.1101200847350.10695@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101200847350.10695@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux.com> [2011-01-20 08:49:27]:

> On Thu, 20 Jan 2011, Balbir Singh wrote:
> 
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -253,11 +253,11 @@ extern int vm_swappiness;
> >  extern int remove_mapping(struct address_space *mapping, struct page *page);
> >  extern long vm_total_pages;
> >
> > +extern int sysctl_min_unmapped_ratio;
> > +extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
> >  #ifdef CONFIG_NUMA
> >  extern int zone_reclaim_mode;
> > -extern int sysctl_min_unmapped_ratio;
> >  extern int sysctl_min_slab_ratio;
> > -extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
> >  #else
> >  #define zone_reclaim_mode 0
> 
> So the end result of this patch is that zone reclaim is compiled
> into vmscan.o even on !NUMA configurations but since zone_reclaim_mode ==
> 0 noone can ever call that code?
>

The third patch, fixes this with the introduction of a config
(cut-copy-paste below). If someone were to bisect to this point, what
you say is correct.

+#if defined(CONFIG_UNMAPPED_PAGECACHE_CONTROL) ||
defined(CONFIG_NUMA)
 extern int sysctl_min_unmapped_ratio;
 extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
-#ifdef CONFIG_NUMA
-extern int zone_reclaim_mode;
-extern int sysctl_min_slab_ratio;
 #else
-#define zone_reclaim_mode 0
 static inline int zone_reclaim(struct zone *z, gfp_t mask, unsigned
int order)
 {
        return 0;
 }
 #endif

Thanks for the review! 

-- 
	Three Cheers,
	Balbir
