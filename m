Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab0FNAcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 20:32:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56357 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0FNAcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 20:32:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 14 Jun 2010 09:28:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] Linux/Guest unmapped page cache control
Message-Id: <20100614092819.cb7515a5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100613183145.GM5191@balbir.in.ibm.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	<20100608155146.3749.67837.sendpatchset@L34Z31A.ibm.com>
	<20100613183145.GM5191@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 00:01:45 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Balbir Singh <balbir@linux.vnet.ibm.com> [2010-06-08 21:21:46]:
> 
> > Selectively control Unmapped Page Cache (nospam version)
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > This patch implements unmapped page cache control via preferred
> > page cache reclaim. The current patch hooks into kswapd and reclaims
> > page cache if the user has requested for unmapped page control.
> > This is useful in the following scenario
> > 
> > - In a virtualized environment with cache=writethrough, we see
> >   double caching - (one in the host and one in the guest). As
> >   we try to scale guests, cache usage across the system grows.
> >   The goal of this patch is to reclaim page cache when Linux is running
> >   as a guest and get the host to hold the page cache and manage it.
> >   There might be temporary duplication, but in the long run, memory
> >   in the guests would be used for mapped pages.
> > - The option is controlled via a boot option and the administrator
> >   can selectively turn it on, on a need to use basis.
> > 
> > A lot of the code is borrowed from zone_reclaim_mode logic for
> > __zone_reclaim(). One might argue that the with ballooning and
> > KSM this feature is not very useful, but even with ballooning,
> > we need extra logic to balloon multiple VM machines and it is hard
> > to figure out the correct amount of memory to balloon. With these
> > patches applied, each guest has a sufficient amount of free memory
> > available, that can be easily seen and reclaimed by the balloon driver.
> > The additional memory in the guest can be reused for additional
> > applications or used to start additional guests/balance memory in
> > the host.
> > 
> > KSM currently does not de-duplicate host and guest page cache. The goal
> > of this patch is to help automatically balance unmapped page cache when
> > instructed to do so.
> > 
> > There are some magic numbers in use in the code, UNMAPPED_PAGE_RATIO
> > and the number of pages to reclaim when unmapped_page_control argument
> > is supplied. These numbers were chosen to avoid aggressiveness in
> > reaping page cache ever so frequently, at the same time providing control.
> > 
> > The sysctl for min_unmapped_ratio provides further control from
> > within the guest on the amount of unmapped pages to reclaim.
> >
> 
> Are there any major objections to this patch?
>  

This kind of patch needs "how it works well" measurement.

- How did you measure the effect of the patch ? kernbench is not enough, of course.
- Why don't you believe LRU ? And if LRU doesn't work well, should it be
  fixed by a knob rather than generic approach ?
- No side effects ?

- Linux vm guys tend to say, "free memory is bad memory". ok, for what
  free memory created by your patch is used ? IOW, I can't see the benefit.
  If free memory that your patch created will be used for another page-cache,
  it will be dropped soon by your patch itself.

  If your patch just drops "duplicated, but no more necessary for other kvm",
  I agree your patch may increase available size of page-caches. But you just
  drops unmapped pages.
  Hmm.

Thanks,
-Kame
 

