Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab0DPOzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:55:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54043 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab0DPOzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:55:53 -0400
Date: Fri, 16 Apr 2010 15:55:34 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] vmscan: simplify shrink_inactive_list()
Message-ID: <20100416145534.GJ19264@csn.ul.ie>
References: <20100415085420.GT2493@dastard> <20100415185310.D1A1.A69D9226@jp.fujitsu.com> <20100415192140.D1A4.A69D9226@jp.fujitsu.com> <20100415131532.GD10966@csn.ul.ie> <87tyrc92un.fsf@basil.nowhere.org> <20100415154442.GG10966@csn.ul.ie> <20100415165416.GV18855@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100415165416.GV18855@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:54:16PM +0200, Andi Kleen wrote:
> > It's a buying-time venture, I'll agree but as both approaches are only
> > about reducing stack stack they wouldn't be long-term solutions by your
> > criteria. What do you suggest?
> 
> (from easy to more complicated):
> 
> - Disable direct reclaim with 4K stacks

Do not like. While I can see why 4K stacks are a serious problem, I'd
sooner see 4K stacks disabled than have the kernel behave so differently
for direct reclaim. It's be tricky to spot regressions in reclaim that
were due to this .config option

> - Do direct reclaim only on separate stacks

This is looking more and more attractive.

> - Add interrupt stacks to any 8K stack architectures.

This is a similar but separate problem. It's similar in that interrupt
stacks can splice subsystems together in terms of stack usage.

> - Get rid of 4K stacks completely

Why would we *not* do this? I can't remember the original reasoning
behind 4K stacks but am guessing it helped fork-orientated workloads in
startup times in the days before lumpy reclaim and better fragmentation
control.

Who typically enables this option?

> - Think about any other stackings that could give large scale recursion
> and find ways to run them on separate stacks too.

The patch series I threw up about reducing stack was a cut-down
approach. Instead of using separate stacks, keep the stack usage out of
the main caller path where possible.

> - Long term: maybe we need 16K stacks at some point, depending on how
> good the VM gets. Alternative would be to stop making Linux more complicated,
> but that's unlikely to happen.
> 

Make this Plan D if nothing else works out and we still hit a wall?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
