Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0JRFFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:05:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52509 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0JRFFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:05:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Neil Brown <neilb@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Li Shaohua <shaohua.li@intel.com>
In-Reply-To: <20101018151459.2b443221@notabene>
References: <20100915184434.18e2d933@notabene> <20101018151459.2b443221@notabene>
Message-Id: <20101018140116.3AE8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Oct 2010 14:04:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 15 Sep 2010 18:44:34 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > On Wed, 15 Sep 2010 16:28:43 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > Neil,
> > > 
> > > Sorry for the rushed and imaginary ideas this morning..
> > > 
> > > > @@ -1101,6 +1101,12 @@ static unsigned long shrink_inactive_lis
> > > >  	int lumpy_reclaim = 0;
> > > >  
> > > >  	while (unlikely(too_many_isolated(zone, file, sc))) {
> > > > +		if ((sc->gfp_mask & GFP_IOFS) != GFP_IOFS)
> > > > +			/* Not allowed to do IO, so mustn't wait
> > > > +			 * on processes that might try to
> > > > +			 */
> > > > +			return SWAP_CLUSTER_MAX;
> > > > +
> > > 
> > > The above patch should behavior like this: it returns SWAP_CLUSTER_MAX
> > > to cheat all the way up to believe "enough pages have been reclaimed".
> > > So __alloc_pages_direct_reclaim() see non-zero *did_some_progress and
> > > go on to call get_page_from_freelist(). That normally fails because
> > > the task didn't really scanned the LRU lists. However it does have the
> > > possibility to succeed -- when so many processes are doing concurrent
> > > direct reclaims, it may luckily get one free page reclaimed by other
> > > tasks. What's more, if it does fail to get a free page, the upper
> > > layer __alloc_pages_slowpath() will be repeat recalling
> > > __alloc_pages_direct_reclaim(). So, sooner or later it will succeed in
> > > "stealing" a free page reclaimed by other tasks.
> > > 
> > > In summary, the patch behavior for !__GFP_IO/FS is
> > > - won't do any page reclaim
> > > - won't fail the page allocation (unexpected)
> > > - will wait and steal one free page from others (unreasonable)
> > > 
> > > So it will address the problem you encountered, however it sounds
> > > pretty unexpected and illogical behavior, right?
> > > 
> > > I believe this patch will address the problem equally well.
> > > What do you think?
> > 
> > Thank you for the detailed explanation.  Is agree with your reasoning and
> > now understand why your patch is sufficient.
> > 
> > I will get it tested and let you know how that goes.
> 
> (sorry this has taken a month to follow up).
> 
> Testing shows that this patch seems to work.
> The test load (essentially kernbench) doesn't deadlock any more, though it
> does get bogged down thrashing in swap so it doesn't make a lot more
> progress :-)  I guess that is to be expected.
> 
> One observation is that the kernbench generated 10%-20% more context switches
> with the patch than without.  Is that to be expected?
> 
> Do you have plans for sending this patch upstream?

Wow, I had thought this patch has been merged already. Wu, can you please
repost this one? and please add my and Neil's ack tag.

Thanks.



