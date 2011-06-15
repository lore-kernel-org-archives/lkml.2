Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1FOARS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:17:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59716 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1FOARR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:17:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 15 Jun 2011 09:09:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [BUGFIX][PATCH 5/5] memcg: fix percpu cached charge draining
 frequency
Message-Id: <20110615090935.d5789b58.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110613142501.15e14b2f.akpm@linux-foundation.org>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
	<20110613121648.3d28afcd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110613142501.15e14b2f.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011 14:25:01 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 13 Jun 2011 12:16:48 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > >From 18b12e53f1cdf6d7feed1f9226c189c34866338c Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Date: Mon, 13 Jun 2011 11:25:43 +0900
> > Subject: [PATCH 5/5] memcg: fix percpu cached charge draining frequency
> > 
> >  For performance, memory cgroup caches some "charge" from res_counter
> >  into per cpu cache. This works well but because it's cache,
> >  it needs to be flushed in some cases. Typical cases are
> >          1. when someone hit limit.
> >          2. when rmdir() is called and need to charges to be 0.
> > 
> > But "1" has problem.
> > 
> > Recently, with large SMP machines, we see many kworker runs because
> > of flushing memcg's cache. Bad things in implementation are
> > that even if a cpu contains a cache for memcg not related to
> > a memcg which hits limit, drain code is called.
> > 
> > This patch does
> > 	A) check percpu cache contains a useful data or not.
> > 	B) check other asynchronous percpu draining doesn't run.
> > 	C) don't call local cpu callback.
> > 	D) don't call at softlimit reclaim.
> > 
> >
> > ...
> >
> > +DEFINE_MUTEX(percpu_charge_mutex);
> 
> I made this static.  If we later wish to give it kernel-wide scope then
> "percpu_charge_mutex" will not be a good choice of name.

Thank you.
And, yes..... memcg_cached_charge_mutex ?

Thanks,
-Kame

