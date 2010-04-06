Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab0DFCG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 22:06:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45358 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab0DFCGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 22:06:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20100406015045.GA7870@localhost>
References: <20100406012536.GB18672@sli10-desk.sh.intel.com> <20100406015045.GA7870@localhost>
Message-Id: <20100406105324.7E30.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Apr 2010 11:06:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 06, 2010 at 09:25:36AM +0800, Li, Shaohua wrote:
> > On Sun, Apr 04, 2010 at 10:19:06PM +0800, KOSAKI Motohiro wrote:
> > > > On Fri, Apr 02, 2010 at 05:14:38PM +0800, KOSAKI Motohiro wrote:
> > > > > > > > This patch makes a lot of sense than previous. however I think <1% anon ratio
> > > > > > > > shouldn't happen anyway because file lru doesn't have reclaimable pages.
> > > > > > > > <1% seems no good reclaim rate.
> > > > > > > 
> > > > > > > Oops, the above mention is wrong. sorry. only 1 page is still too big.
> > > > > > > because under streaming io workload, the number of scanning anon pages should
> > > > > > > be zero. this is very strong requirement. if not, backup operation will makes
> > > > > > > a lot of swapping out.
> > > > > > Sounds there is no big impact for the workload which you mentioned with the patch.
> > > > > > please see below descriptions.
> > > > > > I updated the description of the patch as fengguang suggested.
> > > > > 
> > > > > Umm.. sorry, no.
> > > > > 
> > > > > "one fix but introduce another one bug" is not good deal. instead, 
> > > > > I'll revert the guilty commit at first as akpm mentioned.
> > > > Even we revert the commit, the patch still has its benefit, as it increases
> > > > calculation precision, right?
> > > 
> > > no, you shouldn't ignore the regression case.
> 
> > I don't think this is serious. In my calculation, there is only 1 page swapped out
> > for 6G anonmous memory. 1 page should haven't any performance impact.
> 
> 1 anon page scanned for every N file pages scanned?
> 
> Is N a _huge_ enough ratio so that the anon list will be very light scanned?
> 
> Rik: here is a little background.

The problem is, the VM are couteniously discarding no longer used file
cache. if we are scan extra anon 1 page, we will observe tons swap usage
after few days.

please don't only think benchmark.


> Under streaming IO, the current get_scan_ratio() will get a percent[0]
> that is (much) less than 1, so underflows to 0.
> 
> It has the bad effect of completely disabling the scan of anon list,
> which leads to OOM in Shaohua's test case. OTOH, it also has the good
> side effect of keeping anon pages in memory and totally prevent swap
> IO.
> 
> Shaohua's patch improves the computation precision by computing nr[]
> directly in get_scan_ratio(). This is good in general, however will
> enable light scan of the anon list on streaming IO.

In such case, percent[0] should be big. I think underflowing is not point.
His test case is merely streaming io copy, why can't we drop tmpfs cached
page? his /proc/meminfo describe his machine didn't have droppable file cache.
so, big percent[1] value seems makes no sense. no?

I'm not sure we need either below detection. I need more investigate.
 1) detect no discardable file cache
 2) detect streaming io on tmpfs (as regular file)




