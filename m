Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab0CaFxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 01:53:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35240 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab0CaFxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 01:53:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Shaohua Li <shaohua.li@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
In-Reply-To: <20100331142708.039E.A69D9226@jp.fujitsu.com>
References: <20100331045348.GA3396@sli10-desk.sh.intel.com> <20100331142708.039E.A69D9226@jp.fujitsu.com>
Message-Id: <20100331145030.03A1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 31 Mar 2010 14:53:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, Mar 30, 2010 at 02:08:53PM +0800, KOSAKI Motohiro wrote:
> > > Hi
> > > 
> > > > Commit 84b18490d1f1bc7ed5095c929f78bc002eb70f26 introduces a regression.
> > > > With it, our tmpfs test always oom. The test has a lot of rotated anon
> > > > pages and cause percent[0] zero. Actually the percent[0] is a very small
> > > > value, but our calculation round it to zero. The commit makes vmscan
> > > > completely skip anon pages and cause oops.
> > > > An option is if percent[x] is zero in get_scan_ratio(), forces it
> > > > to 1. See below patch.
> > > > But the offending commit still changes behavior. Without the commit, we scan
> > > > all pages if priority is zero, below patch doesn't fix this. Don't know if
> > > > It's required to fix this too.
> > > 
> > > Can you please post your /proc/meminfo and reproduce program? I'll digg it.
> > > 
> > > Very unfortunately, this patch isn't acceptable. In past time, vmscan 
> > > had similar logic, but 1% swap-out made lots bug reports. 
> > if 1% is still big, how about below patch?
> 
> This patch makes a lot of sense than previous. however I think <1% anon ratio
> shouldn't happen anyway because file lru doesn't have reclaimable pages.
> <1% seems no good reclaim rate.

Oops, the above mention is wrong. sorry. only 1 page is still too big.
because under streaming io workload, the number of scanning anon pages should
be zero. this is very strong requirement. if not, backup operation will makes
a lot of swapping out.

Anyway, I'm digging this issue.


> 
> perhaps I'll take your patch for stable tree. but we need to attack the root
> cause. iow, I guess we need to fix scan ratio equation itself.



