Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1GUXvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:51:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45310 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1GUXvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:51:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 22 Jul 2011 08:44:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] memcg: do not try to drain per-cpu caches without
 pages
Message-Id: <20110722084413.9dd4b880.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110721113606.GA27855@tiehlicka.suse.cz>
References: <cover.1311241300.git.mhocko@suse.cz>
	<113c4affc2f0938b7b22d43c88d2b0a623de9a6b.1311241300.git.mhocko@suse.cz>
	<20110721191250.1c945740.kamezawa.hiroyu@jp.fujitsu.com>
	<20110721113606.GA27855@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 13:36:06 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 21-07-11 19:12:50, KAMEZAWA Hiroyuki wrote:
> > On Thu, 21 Jul 2011 09:38:00 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > drain_all_stock_async tries to optimize a work to be done on the work
> > > queue by excluding any work for the current CPU because it assumes that
> > > the context we are called from already tried to charge from that cache
> > > and it's failed so it must be empty already.
> > > While the assumption is correct we can do it by checking the current
> > > number of pages in the cache. This will also reduce a work on other CPUs
> > > with an empty stock.
> > > 
> > > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > 
> > 
> > At the first look, when a charge against TransParentHugepage() goes
> > into the reclaim routine, stock->nr_pages != 0 and this will
> > call additional kworker.
> 
> True. We will drain a charge which could be used by other allocations
> in the meantime so we have a good chance to reclaim less. But how big
> problem is that?
> I mean I can add a new parameter that would force checking the current
> cpu but it doesn't look nice. I cannot add that condition
> unconditionally because the code will be shared with the sync path in
> the next patch and that one needs to drain _all_ cpus.
> 
> What would you suggest?
By 2 methods

 - just check nr_pages. 
 - drain "local stock" without calling schedule_work(). It's fast.

Thanks,
-Kame


