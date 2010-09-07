Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0IGJJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:09:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44385 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab0IGJJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:09:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 7 Sep 2010 18:03:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim\@gmail.com" <minchan.kim@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>,
        "kosaki.motohiro\@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] big continuous memory allocator v2
Message-Id: <20100907180354.a8dd5669.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100907104635.2a02a1ca@basil.nowhere.org>
References: <20100907114505.fc40ea3d.kamezawa.hiroyu@jp.fujitsu.com>
	<87occa9fla.fsf@basil.nowhere.org>
	<20100907172559.496554d8.kamezawa.hiroyu@jp.fujitsu.com>
	<20100907104635.2a02a1ca@basil.nowhere.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010 10:46:35 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, 7 Sep 2010 17:25:59 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Tue, 07 Sep 2010 09:29:21 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> > > 
> > > > This is a page allcoator based on memory migration/hotplug code.
> > > > passed some small tests, and maybe easier to read than previous
> > > > one.
> > > 
> > > Maybe I'm missing context here, but what is the use case for this?
> > > 
> > 
> > I hear some drivers want to allocate xxMB of continuous area.(camera?)
> > Maybe embeded guys can answer the question.
> 
> Ok what I wanted to say -- assuming you can make this work
> nicely, and the delays (swap storms?) likely caused by this are not
> too severe, it would be interesting for improving the 1GB pages on x86.
> 

Oh, I didn't consider that. Hmm. If x86 really wants to support 1GB page,
MAX_ORDER should be raised. (I'm sorry if it was already disccused.)


> This would be a major use case and probably be enough
> to keep the code around.
> 
> But it depends on how well it works.
> 
Sure.

> e.g. when the zone is already fully filled how long
> does the allocation of 1GB take?
> 
Maybe not very quick, even slow.

> How about when parallel programs are allocating/freeing
> in it too?
> 
This code doesn't assume that. I wonder I should add mutex because this code
generates IPI for draining some per-cpu lists.

I think 1GB pages should be preallocated as current hugepage does.


> What's the worst case delay under stress?
> 
memory offline itself is robust against stress because it make
pageblock ISOLATED. But memory allocation of 1GB is problem.
I have an idea (see below).

> Does it cause swap storms?
> 
Maybe same as allocating 1GB of memory when memory is full.
It's LRU matter.


> One issue is also that it would be good to be able to decide
> in advance if the OOM killer is likely triggered (and if yes
> reject the allocation in the first place). 
> 

Checking the amount of memory and swap before starts ? 
It sounds nice. I'd like to add something.

Or changing my patche's logic as..

  1. allocates required migration target pages (of 1GB)
  2. start migration to allocated pages.
  3. create a big page. 

Then, we can use some GFP_XXXX at (1) and can do some tuning as usual
vm codes.

Thanks,
-Kame

