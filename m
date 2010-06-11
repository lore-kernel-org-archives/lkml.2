Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0FKHJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:09:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43330 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab0FKHJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:09:25 -0400
Date: Fri, 11 Jun 2010 11:44:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Avi Kivity <avi@redhat.com>,
       kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
Message-ID: <20100611061454.GG5191@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
 <4C10B3AF.7020908@redhat.com>
 <20100610142512.GB5191@balbir.in.ibm.com>
 <1276214852.6437.1427.camel@nimitz>
 <20100611105441.ee657515.kamezawa.hiroyu@jp.fujitsu.com>
 <20100611044632.GD5191@balbir.in.ibm.com>
 <20100611140553.956f31ab.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100611140553.956f31ab.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-06-11 14:05:53]:

> On Fri, 11 Jun 2010 10:16:32 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-06-11 10:54:41]:
> > 
> > > On Thu, 10 Jun 2010 17:07:32 -0700
> > > Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > > 
> > > > On Thu, 2010-06-10 at 19:55 +0530, Balbir Singh wrote:
> > > > > > I'm not sure victimizing unmapped cache pages is a good idea.
> > > > > > Shouldn't page selection use the LRU for recency information instead
> > > > > > of the cost of guest reclaim?  Dropping a frequently used unmapped
> > > > > > cache page can be more expensive than dropping an unused text page
> > > > > > that was loaded as part of some executable's initialization and
> > > > > > forgotten.
> > > > > 
> > > > > We victimize the unmapped cache only if it is unused (in LRU order).
> > > > > We don't force the issue too much. We also have free slab cache to go
> > > > > after.
> > > > 
> > > > Just to be clear, let's say we have a mapped page (say of /sbin/init)
> > > > that's been unreferenced since _just_ after the system booted.  We also
> > > > have an unmapped page cache page of a file often used at runtime, say
> > > > one from /etc/resolv.conf or /etc/passwd.
> > > > 
> > > 
> > > Hmm. I'm not fan of estimating working set size by calculation
> > > based on some numbers without considering history or feedback.
> > > 
> > > Can't we use some kind of feedback algorithm as hi-low-watermark, random walk
> > > or GA (or somehing more smart) to detect the size ?
> > >
> > 
> > Could you please clarify at what level you are suggesting size
> > detection? I assume it is outside the OS, right? 
> > 
> "OS" includes kernel and system programs ;)
> 
> I can think of both way in kernel and in user approarh and they should be
> complement to each other.
> 
> An example of kernel-based approach is.
>  1. add a shrinker callback(A) for balloon-driver-for-guest as guest kswapd.
>  2. add a shrinker callback(B) for balloon-driver-for-host as host kswapd.
> (I guess current balloon driver is only for host. Please imagine.)
> 
> (A) increases free memory in Guest.
> (B) increases free memory in Host.
> 
> This is an example of feedback based memory resizing between host and guest.
> 
> I think (B) is necessary at least before considering complecated things.

B is left to the hypervisor and the memory policy running on it. My
patches address Linux running as a guest, with a Linux hypervisor at
the moment, but that can be extended to other balloon drivers as well.

> 
> To implement something clever,  (A) and (B) should take into account that
> how frequently memory reclaim in guest (which requires some I/O) happens.
> 

Yes, I think the policy in the hypervisor needs to look at those
details as well.

> If doing outside kernel, I think using memcg is better than depends on
> balloon driver. But co-operative balloon and memcg may show us something
> good.
> 

Yes, agreed. Co-operative is better, if there is no co-operation than
memcg might be used for enforcement.

-- 
	Three Cheers,
	Balbir
