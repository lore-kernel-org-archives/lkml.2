Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0FNHgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:36:52 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44795 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0FNHgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:36:51 -0400
Date: Mon, 14 Jun 2010 13:06:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: kvm <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] Linux/Guest unmapped page cache control
Message-ID: <20100614073646.GS5191@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
 <20100608155146.3749.67837.sendpatchset@L34Z31A.ibm.com>
 <20100613183145.GM5191@balbir.in.ibm.com>
 <20100614092819.cb7515a5.kamezawa.hiroyu@jp.fujitsu.com>
 <20100614064955.GR5191@balbir.in.ibm.com>
 <20100614160021.7febbdb2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100614160021.7febbdb2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-06-14 16:00:21]:

> On Mon, 14 Jun 2010 12:19:55 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > - Why don't you believe LRU ? And if LRU doesn't work well, should it be
> > >   fixed by a knob rather than generic approach ?
> > > - No side effects ?
> > 
> > I believe in LRU, just that the problem I am trying to solve is of
> > using double the memory for caching the same data (consider kvm
> > running in cache=writethrough or writeback mode, both the hypervisor
> > and the guest OS maintain a page cache of the same data). As the VM's
> > grow the overhead is substantial. In my runs I found upto 60%
> > duplication in some cases.
> > 
> > 
> > - Linux vm guys tend to say, "free memory is bad memory". ok, for what
> >   free memory created by your patch is used ? IOW, I can't see the benefit.
> >   If free memory that your patch created will be used for another page-cache,
> >   it will be dropped soon by your patch itself.
> > 
> > Free memory is good for cases when you want to do more in the same
> > system. I agree that in a bare metail environment that might be
> > partially true. I don't have a problem with frequently used data being
> > cached, but I am targetting a consolidated environment at the moment.
> > Moreover, the administrator has control via a boot option, so it is
> > non-instrusive in many ways.
> 
> It sounds that what you want is to improve performance etc. but to make it
> easy sizing the system and to help admins. Right ?
>

Right, to allow freeing up of using double the memory to cache data.
 
> From performance perspective, I don't see any advantage to drop caches
> which can be dropped easily. I just use cpus for the purpose it may no
> be necessary.
> 

It is not that easy, in a virtualized environment, you do directly
reclaim, but use a mechanism like ballooning and that too requires a
smart software to decide where to balloon from. This patch (optionally
if enabled) optimizes that by

1. Reducing double caching
2. Not requiring newer smarts or a management software to monitor and
balloon
3. Allows better estimation of free memory by avoiding double caching
4. Allows immediate use of free memory for other applications or
startup of newer guest instances.

-- 
	Three Cheers,
	Balbir
