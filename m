Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1IFJln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 05:41:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39718 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab1IFJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 05:41:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 6 Sep 2011 18:33:58 +0900
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
Message-Id: <20110906183358.0a305900.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110905182514.GA20793@redhat.com>
References: <20110831090850.GA27345@redhat.com>
	<CAEwNFnBSg71QoLZbOqZbXK3fGEGneituU3PmiYTAw1VM3KcwcQ@mail.gmail.com>
	<20110901090931.c0721216.kamezawa.hiroyu@jp.fujitsu.com>
	<20110901061540.GA22561@redhat.com>
	<20110901153148.70452287.kamezawa.hiroyu@jp.fujitsu.com>
	<20110905182514.GA20793@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011 20:25:14 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Thu, Sep 01, 2011 at 03:31:48PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 1 Sep 2011 08:15:40 +0200
> > Johannes Weiner <jweiner@redhat.com> wrote:
> > Old implemenation was supporsed to make vmscan to see only memcg and
> > ignore zones. memcg doesn't take care of any zones. Then, it uses
> > global numbers rather than zones.
> > 
> > Assume a system with 2 nodes and the whole memcg's inactive/active ratio
> > is unbalaned. 
> > 
> >    Node      0     1
> >    Active   800M   30M
> >    Inactive 100M   200M
> > 
> > If we judge 'unbalance' based on zones, Node1's Active will not rotate
> > even if it's not accessed for a while.
> > If we judge unbalance based on total stat, Both of Node0 and Node 1
> > will be rotated.
> 
> But why should we deactivate on Node 1?  We have good reasons not to
> on the global level, why should memcgs silently behave differently?
> 

One reason was I thought that memcg should behave as to have one LRU list,
which is not devided by zones and wanted to ignore zones as much
as possible. Second reason was that I don't want to increase swap-out
caused by memcg limit.


> I mostly don't understand it on a semantic level.  vmscan needs to
> know whether a certain inactive LRU list has enough reclaim candidates
> to skip scanning its corresponding active list.  The global state is
> not useful to find out if a single inactive list has enough pages.
> 

Ok, I agree to this. I should add other logic to do what I want.
In my series,
  - passing nodemask
  - avoid overscan
  - calculating node weight
These will allow me to see what I want.

> > Hmm, old one doesn't work as I expexted ?
> > 
> > But okay, as time goes, I think Node1's inactive will decreased
> > and then, rotate will happen even with zone based ones.
> 
> Yes, that's how the mechanism is intended to work: with a constant
> influx of used-once pages, we don't want to touch the active list.
> But when the workload changes and inactive pages get either activated
> or all reclaimed, the ratio changes and eventually we fall back to
> deactivating pages again.
> 
> That's reclaim behaviour that has been around for a while and it
> shouldn't make a difference if your workload is running in
> root_mem_cgroup or another memcg.
> 

ok.


> > > > But, hmm, this change may be good for softlimit and your work.
> > > 
> > > Yes, I noticed those paths showing up in a profile with my patches.
> > > Lots of memcgs on a multi-node machine will trigger it too.  But it's
> > > secondary, my primary reasoning was: this does not make sense at all.
> > 
> > your word sounds always too strong to me ;) please be soft.
> 
> Sorry, I'll try to be less harsh.  Please don't take it personally :)
> 
> What I meant was that the computational overhead was not the primary
> reason for this patch.  Although a reduction there is very welcome,
> it's that deciding to skip the list based on the list size seems more
> correct than deciding based on the overall state of the memcg, which
> can only by accident show the same proportion of inactive/active.
> 
> It's a correctness fix for existing code, not an optimization or
> preparation for future changes.
> 
ok.


> > > > I'll ack when you add performance numbers in changelog.
> > > 
> > > It's not exactly a performance optimization but I'll happily run some
> > > workloads.  Do you have suggestions what to test for?  I.e. where
> > > would you expect regressions?
> > > 
> > Some comparison about amount of swap-out before/after change will be good.
> > 
> > Hm. If I do...
> >   - set up x86-64 NUMA box. (fake numa is ok.)
> >   - create memcg with 500M limit.
> >   - running kernel make with make -j 6(or more)
> > 
> > see time of make and amount of swap-out.
> 
> 4G ram, 500M swap on SSD, numa=fake=16, 10 runs of make -j11 in 500M
> memcg, standard deviation in parens:
> 
> 		seconds		pswpin			pswpout
> vanilla:	175.359(0.106)	6906.900(1779.135)	8913.200(1917.369)
> patched:	176.144(0.243)	8581.500(1833.432)	10872.400(2124.104)
> 

Hmm. swapin/out seems increased. But hmm...stddev is large.
Is this expected ? reason ?

Anyway, I don't want to disturb you more. Thanks.

-Kame

