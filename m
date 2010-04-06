Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab0DFC6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 22:58:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59847 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab0DFC6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 22:58:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20100406023043.GA12420@localhost>
References: <20100406105324.7E30.A69D9226@jp.fujitsu.com> <20100406023043.GA12420@localhost>
Message-Id: <20100406115543.7E39.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Apr 2010 11:58:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 06, 2010 at 10:06:19AM +0800, KOSAKI Motohiro wrote:
> > > On Tue, Apr 06, 2010 at 09:25:36AM +0800, Li, Shaohua wrote:
> > > > On Sun, Apr 04, 2010 at 10:19:06PM +0800, KOSAKI Motohiro wrote:
> > > > > > On Fri, Apr 02, 2010 at 05:14:38PM +0800, KOSAKI Motohiro wrote:
> > > > > > > > > > This patch makes a lot of sense than previous. however I think <1% anon ratio
> > > > > > > > > > shouldn't happen anyway because file lru doesn't have reclaimable pages.
> > > > > > > > > > <1% seems no good reclaim rate.
> > > > > > > > > 
> > > > > > > > > Oops, the above mention is wrong. sorry. only 1 page is still too big.
> > > > > > > > > because under streaming io workload, the number of scanning anon pages should
> > > > > > > > > be zero. this is very strong requirement. if not, backup operation will makes
> > > > > > > > > a lot of swapping out.
> > > > > > > > Sounds there is no big impact for the workload which you mentioned with the patch.
> > > > > > > > please see below descriptions.
> > > > > > > > I updated the description of the patch as fengguang suggested.
> > > > > > > 
> > > > > > > Umm.. sorry, no.
> > > > > > > 
> > > > > > > "one fix but introduce another one bug" is not good deal. instead, 
> > > > > > > I'll revert the guilty commit at first as akpm mentioned.
> > > > > > Even we revert the commit, the patch still has its benefit, as it increases
> > > > > > calculation precision, right?
> > > > > 
> > > > > no, you shouldn't ignore the regression case.
> > > 
> > > > I don't think this is serious. In my calculation, there is only 1 page swapped out
> > > > for 6G anonmous memory. 1 page should haven't any performance impact.
> > > 
> > > 1 anon page scanned for every N file pages scanned?
> > > 
> > > Is N a _huge_ enough ratio so that the anon list will be very light scanned?
> > > 
> > > Rik: here is a little background.
> > 
> > The problem is, the VM are couteniously discarding no longer used file
> > cache. if we are scan extra anon 1 page, we will observe tons swap usage
> > after few days.
> > 
> > please don't only think benchmark.
> 
> OK the days-of-streaming-io typically happen in file servers.  Suppose
> a file server with 16GB memory, 1GB of which is consumed by anonymous
> pages, others are for page cache.
> 
> Assume that the exact file:anon ratio computed by the get_scan_ratio()
> algorithm is 1000:1. In that case percent[0]=0.1 and is rounded down
> to 0, which keeps the anon pages in memory for the few days.
> 
> Now with Shaohua's patch, nr[0] = (262144/4096)/1000 = 0.06 will also
> be rounded down to 0. It only becomes >=1 when
> - reclaim runs into trouble and priority goes low
> - anon list goes huge
> 
> So I guess Shaohua's patch still has reasonable "underflow" threshold :)

Again, I didn't said his patch is no worth. I only said we don't have to
ignore the downside. 

