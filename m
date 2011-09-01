Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1IAGlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:41:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35461 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1IAGk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:40:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Sep 2011 15:31:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: skip scanning active lists based on individual
 size
Message-Id: <20110901153148.70452287.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110901061540.GA22561@redhat.com>
References: <20110831090850.GA27345@redhat.com>
	<CAEwNFnBSg71QoLZbOqZbXK3fGEGneituU3PmiYTAw1VM3KcwcQ@mail.gmail.com>
	<20110901090931.c0721216.kamezawa.hiroyu@jp.fujitsu.com>
	<20110901061540.GA22561@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011 08:15:40 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Thu, Sep 01, 2011 at 09:09:31AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 31 Aug 2011 19:13:34 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> > 
> > > On Wed, Aug 31, 2011 at 6:08 PM, Johannes Weiner <jweiner@redhat.com> wrote:
> > > > Reclaim decides to skip scanning an active list when the corresponding
> > > > inactive list is above a certain size in comparison to leave the
> > > > assumed working set alone while there are still enough reclaim
> > > > candidates around.
> > > >
> > > > The memcg implementation of comparing those lists instead reports
> > > > whether the whole memcg is low on the requested type of inactive
> > > > pages, considering all nodes and zones.
> > > >
> > > > This can lead to an oversized active list not being scanned because of
> > > > the state of the other lists in the memcg, as well as an active list
> > > > being scanned while its corresponding inactive list has enough pages.
> > > >
> > > > Not only is this wrong, it's also a scalability hazard, because the
> > > > global memory state over all nodes and zones has to be gathered for
> > > > each memcg and zone scanned.
> > > >
> > > > Make these calculations purely based on the size of the two LRU lists
> > > > that are actually affected by the outcome of the decision.
> > > >
> > > > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> > > > Cc: Rik van Riel <riel@redhat.com>
> > > > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > > Cc: Balbir Singh <bsingharora@gmail.com>
> > > 
> > > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> > > 
> > > I can't understand why memcg is designed for considering all nodes and zones.
> > > Is it a mistake or on purpose?
> > 
> > It's purpose. memcg just takes care of the amount of pages.
> 
> This mechanism isn't about memcg at all, it's an aging decision at a
> much lower level.  Can you tell me how the old implementation is
> supposed to work?
> 
Old implemenation was supporsed to make vmscan to see only memcg and
ignore zones. memcg doesn't take care of any zones. Then, it uses
global numbers rather than zones.

Assume a system with 2 nodes and the whole memcg's inactive/active ratio
is unbalaned. 

   Node      0     1
   Active   800M   30M
   Inactive 100M   200M

If we judge 'unbalance' based on zones, Node1's Active will not rotate
even if it's not accessed for a while.
If we judge unbalance based on total stat, Both of Node0 and Node 1
will be rotated.

Hmm, old one doesn't work as I expexted ?

But okay, as time goes, I think Node1's inactive will decreased
and then, rotate will happen even with zone based ones.



> > But, hmm, this change may be good for softlimit and your work.
> 
> Yes, I noticed those paths showing up in a profile with my patches.
> Lots of memcgs on a multi-node machine will trigger it too.  But it's
> secondary, my primary reasoning was: this does not make sense at all.
> 

your word sounds always too strong to me ;) please be soft.

> > I'll ack when you add performance numbers in changelog.
> 
> It's not exactly a performance optimization but I'll happily run some
> workloads.  Do you have suggestions what to test for?  I.e. where
> would you expect regressions?
> 
Some comparison about amount of swap-out before/after change will be good.

Hm. If I do...
  - set up x86-64 NUMA box. (fake numa is ok.)
  - create memcg with 500M limit.
  - running kernel make with make -j 6(or more)

see time of make and amount of swap-out.


Thanks,
-Kame

