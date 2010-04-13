Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab0DMHzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 03:55:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48648 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0DMHzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 03:55:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4BC3DA2B.3070605@redhat.com>
References: <20100413102641.4A18.A69D9226@jp.fujitsu.com> <4BC3DA2B.3070605@redhat.com>
Message-Id: <20100413144519.D107.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Apr 2010 16:55:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 04/12/2010 09:30 PM, KOSAKI Motohiro wrote:
> >> On 04/09/2010 05:20 PM, Andrew Morton wrote:
> >>
> >>> Come to that, it's not obvious that we need this in 2.6.34 either.  What
> >>> is the user-visible impact here?
> >>
> >> I suspect very little impact, especially during workloads
> >> where we can just reclaim clean page cache at DEF_PRIORITY.
> >> FWIW, the patch looks good to me, so:
> >>
> >> Acked-by: Rik van Riel<riel@redhat.com>
> >>
> >
> > I'm surprised this ack a bit. Rik, do you have any improvement plan about
> > streaming io detection logic?
> > I think the patch have a slightly marginal benefit, it help to<1% scan
> > ratio case. but it have big regression, it cause streaming io (e.g. backup
> > operation) makes tons swap.
> 
> How?  From the description I believe it took 16GB in
> a zone before we start scanning anon pages when
> reclaiming at DEF_PRIORITY?
> 
> Would that casue a problem?

Please remember, 2.6.27 has following +1 scanning modifier.

  zone->nr_scan_active += (zone_page_state(zone, NR_ACTIVE) >> priority) + 1;
                                                                         ^^^^

and, early (ano not yet merged) SplitLRU VM has similar +1. likes

         scan = zone_nr_lru_pages(zone, sc, l);
         scan >>= priority;
         scan = (scan * percent[file]) / 100 + 1;
                                             ^^^

We didn't think only one page scanning is not big matter. but it was not
correct. we got streaming io bug report. the above +1 makes annoying swap
io. because some server need big backup operation rather much much than
physical memory size.

example, If vm are dropping 1TB use once pages, 0.1% anon scanning makes
1GB scan. and almost server only have some gigabyte swap although it
has >1TB memory.

If my memory is not correct, please correct me.

My point is, greater or smaller than 16GB isn't essential. all patches 
should have big worth than the downside. The description said "the impact 
sounds not a big deal", nobody disagree it. but it's worth is more little.
I don't imagine this patch improve anything.


> 
> > So, I thought we sould do either,
> > 1) drop this one
> > 2) merge to change stream io detection logic improvement at first, and
> >     merge this one at second.
> 
> We may need better streaming IO detection, anyway.

agreed. that's no doubt.


> I have noticed that while heavy sequential reads are fine,
> the virtual machines on my desktop system do a lot of whole
> block writes.  Presumably, a lot of those writes are to the
> same blocks, over and over again.
> 
> This causes the blocks to be promoted to the active file
> list, which ends up growing the active file list to the
> point where things from the working set get evicted.
> 
> All for file pages that may only get WRITTEN to by the
> guests, because the guests cache their own copy whenever
> they need to read them!
> 
> I'll have to check the page cache code to see if it
> keeps frequently written pages as accessed.  We may be
> better off evicting frequently written pages, and
> keeping our cache space for data that is read...

One question, In such case your guest don't use DirectIO?
Or do you talk about guest VM behabior?

I guess inactive_file_is_low_global() can be improvement a lot.
but I'm not sure.




