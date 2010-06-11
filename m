Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0FKFKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:10:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56288 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab0FKFKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:10:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Jun 2010 14:05:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Avi Kivity <avi@redhat.com>,
       kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page
 cache control
Message-Id: <20100611140553.956f31ab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100611044632.GD5191@balbir.in.ibm.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	<20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
	<4C10B3AF.7020908@redhat.com>
	<20100610142512.GB5191@balbir.in.ibm.com>
	<1276214852.6437.1427.camel@nimitz>
	<20100611105441.ee657515.kamezawa.hiroyu@jp.fujitsu.com>
	<20100611044632.GD5191@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 10:16:32 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-06-11 10:54:41]:
> 
> > On Thu, 10 Jun 2010 17:07:32 -0700
> > Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > 
> > > On Thu, 2010-06-10 at 19:55 +0530, Balbir Singh wrote:
> > > > > I'm not sure victimizing unmapped cache pages is a good idea.
> > > > > Shouldn't page selection use the LRU for recency information instead
> > > > > of the cost of guest reclaim?  Dropping a frequently used unmapped
> > > > > cache page can be more expensive than dropping an unused text page
> > > > > that was loaded as part of some executable's initialization and
> > > > > forgotten.
> > > > 
> > > > We victimize the unmapped cache only if it is unused (in LRU order).
> > > > We don't force the issue too much. We also have free slab cache to go
> > > > after.
> > > 
> > > Just to be clear, let's say we have a mapped page (say of /sbin/init)
> > > that's been unreferenced since _just_ after the system booted.  We also
> > > have an unmapped page cache page of a file often used at runtime, say
> > > one from /etc/resolv.conf or /etc/passwd.
> > > 
> > 
> > Hmm. I'm not fan of estimating working set size by calculation
> > based on some numbers without considering history or feedback.
> > 
> > Can't we use some kind of feedback algorithm as hi-low-watermark, random walk
> > or GA (or somehing more smart) to detect the size ?
> >
> 
> Could you please clarify at what level you are suggesting size
> detection? I assume it is outside the OS, right? 
> 
"OS" includes kernel and system programs ;)

I can think of both way in kernel and in user approarh and they should be
complement to each other.

An example of kernel-based approach is.
 1. add a shrinker callback(A) for balloon-driver-for-guest as guest kswapd.
 2. add a shrinker callback(B) for balloon-driver-for-host as host kswapd.
(I guess current balloon driver is only for host. Please imagine.)

(A) increases free memory in Guest.
(B) increases free memory in Host.

This is an example of feedback based memory resizing between host and guest.

I think (B) is necessary at least before considering complecated things.

To implement something clever,  (A) and (B) should take into account that
how frequently memory reclaim in guest (which requires some I/O) happens.

If doing outside kernel, I think using memcg is better than depends on
balloon driver. But co-operative balloon and memcg may show us something
good.

Thanks,
-Kame


