Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab0DAWQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:16:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059Ab0DAWQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:16:47 -0400
Date: Thu, 1 Apr 2010 15:16:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Message-Id: <20100401151639.a030fb10.akpm@linux-foundation.org>
In-Reply-To: <20100331145602.03A7.A69D9226@jp.fujitsu.com>
References: <20100331142708.039E.A69D9226@jp.fujitsu.com>
	<20100331055108.GA21963@localhost>
	<20100331145602.03A7.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 15:00:52 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > KOSAKI-san,
> > 
> > On Wed, Mar 31, 2010 at 01:38:12PM +0800, KOSAKI Motohiro wrote:
> > > > On Tue, Mar 30, 2010 at 02:08:53PM +0800, KOSAKI Motohiro wrote:
> > > > > Hi
> > > > > 
> > > > > > Commit 84b18490d1f1bc7ed5095c929f78bc002eb70f26 introduces a regression.
> > > > > > With it, our tmpfs test always oom. The test has a lot of rotated anon
> > > > > > pages and cause percent[0] zero. Actually the percent[0] is a very small
> > > > > > value, but our calculation round it to zero. The commit makes vmscan
> > > > > > completely skip anon pages and cause oops.
> > > > > > An option is if percent[x] is zero in get_scan_ratio(), forces it
> > > > > > to 1. See below patch.
> > > > > > But the offending commit still changes behavior. Without the commit, we scan
> > > > > > all pages if priority is zero, below patch doesn't fix this. Don't know if
> > > > > > It's required to fix this too.
> > > > > 
> > > > > Can you please post your /proc/meminfo and reproduce program? I'll digg it.
> > > > > 
> > > > > Very unfortunately, this patch isn't acceptable. In past time, vmscan 
> > > > > had similar logic, but 1% swap-out made lots bug reports. 
> > > > if 1% is still big, how about below patch?
> > > 
> > > This patch makes a lot of sense than previous. however I think <1% anon ratio
> > > shouldn't happen anyway because file lru doesn't have reclaimable pages.
> > > <1% seems no good reclaim rate.
> > > 
> > > perhaps I'll take your patch for stable tree. but we need to attack the root
> > > cause. iow, I guess we need to fix scan ratio equation itself.
> > 
> > I tend to regard this patch as a general improvement for both
> > .33-stable and .34. 
> > 
> > I do agree with you that it's desirable to do more test&analyze and
> > check further for possibly hidden problems.
> 
> Yeah, I don't want ignore .33-stable too. if I can't find the root cause
> in 2-3 days, I'll revert guilty patch anyway.
> 

It's a good idea to avoid fixing a bug one-way-in-stable,
other-way-in-mainline.  Because then we have new code in both trees
which is different.  And the -stable guys sensibly like to see code get
a bit of a shakedown in mainline before backporting it.

So it would be better to merge the "simple" patch into mainline, tagged
for -stable backporting.  Then we can later implement the larger fix in
mainline, perhaps starting by reverting the "simple" fix.
