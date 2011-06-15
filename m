Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1FOBTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:19:02 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47473 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1FOBTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:19:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 15 Jun 2011 10:12:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Ying Han <yinghan@google.com>
Subject: Re: [BUGFIX][PATCH 5/5] memcg: fix percpu cached charge draining
 frequency
Message-Id: <20110615101202.fa8e9f76.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110615091245.e3267a6b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
	<20110613121648.3d28afcd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110614073651.GA21197@tiehlicka.suse.cz>
	<20110615091245.e3267a6b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 09:12:45 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 14 Jun 2011 09:36:51 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Mon 13-06-11 12:16:48, KAMEZAWA Hiroyuki wrote:
> > > From 18b12e53f1cdf6d7feed1f9226c189c34866338c Mon Sep 17 00:00:00 2001
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > Date: Mon, 13 Jun 2011 11:25:43 +0900
> > > Subject: [PATCH 5/5] memcg: fix percpu cached charge draining frequency
> > > 
> > >  For performance, memory cgroup caches some "charge" from res_counter
> > >  into per cpu cache. This works well but because it's cache,
> > >  it needs to be flushed in some cases. Typical cases are
> > >          1. when someone hit limit.
> > >          2. when rmdir() is called and need to charges to be 0.
> > > 
> > > But "1" has problem.
> > > 
> > > Recently, with large SMP machines, we see many kworker runs because
> > > of flushing memcg's cache. Bad things in implementation are
> > > that even if a cpu contains a cache for memcg not related to
> > > a memcg which hits limit, drain code is called.
> > > 
> > > This patch does
> > > 	D) don't call at softlimit reclaim.
> > 
> > I think this needs some justification. The decision is not that
> > obvious IMO. I would say that this is a good decision because cached
> > charges will not help to free any memory (at least not directly) during
> > background reclaim. What about something like:
> > "
> > We are not draining per cpu cached charges during soft limit reclaim 
> > because background reclaim doesn't care about charges. It tries to free
> > some memory and charges will not give any.
> > Cached charges might influence only selection of the biggest soft limit
> > offender but as the call is done only after the selection has been
> > already done it makes no change.
> > "
> > 
> > Anyway, wouldn't it be better to have this change separate from the
> > async draining logic change?
> 
> Hmm. I think calling "draining" at softlimit is just a bug.
> 
I'll divide patches.

Thanks,
-kame

