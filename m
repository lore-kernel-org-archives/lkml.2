Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1H3KqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:46:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58044 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1H3KqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:46:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 30 Aug 2011 19:38:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Brestic <abrestic@google.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Revert "memcg: add memory.vmscan_stat"
Message-Id: <20110830193839.cf0fc597.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110830101726.GD13061@redhat.com>
References: <20110722171540.74eb9aa7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110808124333.GA31739@redhat.com>
	<20110809083345.46cbc8de.kamezawa.hiroyu@jp.fujitsu.com>
	<20110829155113.GA21661@redhat.com>
	<20110830101233.ae416284.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830070424.GA13061@redhat.com>
	<20110830162050.f6c13c0c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830084245.GC13061@redhat.com>
	<20110830175609.4977ef7a.kamezawa.hiroyu@jp.fujitsu.com>
	<20110830101726.GD13061@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 12:17:26 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Tue, Aug 30, 2011 at 05:56:09PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 30 Aug 2011 10:42:45 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:
 
> > > > Assume 3 cgroups in a hierarchy.
> > > > 
> > > > 	A
> > > >        /
> > > >       B
> > > >      /
> > > >     C
> > > > 
> > > > C's scan contains 3 causes.
> > > > 	C's scan caused by limit of A.
> > > > 	C's scan caused by limit of B.
> > > > 	C's scan caused by limit of C.
> > > >
> > > > If we make hierarchy sum at read, we think
> > > > 	B's scan_stat = B's scan_stat + C's scan_stat
> > > > But in precice, this is
> > > > 
> > > > 	B's scan_stat = B's scan_stat caused by B +
> > > > 			B's scan_stat caused by A +
> > > > 			C's scan_stat caused by C +
> > > > 			C's scan_stat caused by B +
> > > > 			C's scan_stat caused by A.
> > > > 
> > > > In orignal version.
> > > > 	B's scan_stat = B's scan_stat caused by B +
> > > > 			C's scan_stat caused by B +
> > > > 
> > > > After this patch,
> > > > 	B's scan_stat = B's scan_stat caused by B +
> > > > 			B's scan_stat caused by A +
> > > > 			C's scan_stat caused by C +
> > > > 			C's scan_stat caused by B +
> > > > 			C's scan_stat caused by A.
> > > > 
> > > > Hmm...removing hierarchy part completely seems fine to me.
> > > 
> > > I see.
> > > 
> > > You want to look at A and see whether its limit was responsible for
> > > reclaim scans in any children.  IMO, that is asking the question
> > > backwards.  Instead, there is a cgroup under reclaim and one wants to
> > > find out the cause for that.  Not the other way round.
> > > 
> > > In my original proposal I suggested differentiating reclaim caused by
> > > internal pressure (due to own limit) and reclaim caused by
> > > external/hierarchical pressure (due to limits from parents).
> > > 
> > > If you want to find out why C is under reclaim, look at its reclaim
> > > statistics.  If the _limit numbers are high, C's limit is the problem.
> > > If the _hierarchical numbers are high, the problem is B, A, or
> > > physical memory, so you check B for _limit and _hierarchical as well,
> > > then move on to A.
> > > 
> > > Implementing this would be as easy as passing not only the memcg to
> > > scan (victim) to the reclaim code, but also the memcg /causing/ the
> > > reclaim (root_mem):
> > > 
> > > 	root_mem == victim -> account to victim as _limit
> > > 	root_mem != victim -> account to victim as _hierarchical
> > > 
> > > This would make things much simpler and more natural, both the code
> > > and the way of tracking down a problem, IMO.
> > 
> > hmm. I have no strong opinion.
> 
> I do :-)
> 
BTW,  how to calculate C's lru scan caused by A finally ?

            A
           /
          B
         /
        C

At scanning LRU of C because of A's limit, where stats are recorded ?

If we record it in C, we lose where the memory pressure comes from.
If we record it in A, we lose where scan happens.
I'm sorry I'm a little confused.

Thanks,
-Kame





