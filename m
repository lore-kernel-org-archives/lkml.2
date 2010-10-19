Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab0JSDN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:13:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57406 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0JSDNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:13:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <AANLkTinvcGjF2-dvu8kpDY4V7kGkRJjHTWDtQPNRKMU_@mail.gmail.com>
References: <20101019030515.GB11924@localhost> <AANLkTinvcGjF2-dvu8kpDY4V7kGkRJjHTWDtQPNRKMU_@mail.gmail.com>
Message-Id: <20101019121321.A1E1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 12:13:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 19, 2010 at 12:05 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On Tue, Oct 19, 2010 at 10:52:47AM +0800, Minchan Kim wrote:
> >> Hi Wu,
> >>
> >> On Tue, Oct 19, 2010 at 11:35 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> >> >> @@ -2054,10 +2069,11 @@ rebalance:
> >> >>                 goto got_pg;
> >> >>
> >> >>         /*
> >> >> -        * If we failed to make any progress reclaiming, then we are
> >> >> -        * running out of options and have to consider going OOM
> >> >> +        * If we failed to make any progress reclaiming and there aren't
> >> >> +        * many parallel reclaiming, then we are unning out of options and
> >> >> +        * have to consider going OOM
> >> >>          */
> >> >> -       if (!did_some_progress) {
> >> >> +       if (!did_some_progress && !too_many_isolated_zone(preferred_zone)) {
> >> >>                 if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> >> >>                         if (oom_killer_disabled)
> >> >>                                 goto nopage;
> >> >
> >> > This is simply wrong.
> >> >
> >> > It disabled this block for 99% system because there won't be enough
> >> > tasks to make (!too_many_isolated_zone == true). As a result the LRU
> >> > will be scanned like mad and no task get OOMed when it should be.
> >>
> >> If !too_many_isolated_zone is false, it means there are already many
> >> direct reclaiming tasks.
> >> So they could exit reclaim path and !too_many_isolated_zone will be true.
> >> What am I missing now?
> >
> > Ah sorry, my brain get short circuited.. but I still feel uneasy with
> > this change. It's not fixing the root cause and won't prevent too many
> > LRU pages be isolated. It's too late to test too_many_isolated_zone()
> > after direct reclaim returns (after sleeping for a long time).
> >
> 
> Intend to agree.
> I think root cause is a infinite looping in too_many_isolated holding FS lock.
> Would it be simple that too_many_isolated would be bail out after some try?

How?
A lot of caller don't have good recover logic when memory allocation fail occur.



