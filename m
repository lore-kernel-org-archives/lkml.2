Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab0LBCo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:44:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37436 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab0LBCo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:44:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: Free memory never fully used, swapping
Cc: kosaki.motohiro@jp.fujitsu.com, Simon Kirby <sim@hostway.ca>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1012010910450.2989@router.home>
References: <20101201114226.ABAB.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1012010910450.2989@router.home>
Message-Id: <20101202093337.1573.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  2 Dec 2010 11:44:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 1 Dec 2010, KOSAKI Motohiro wrote:
> 
> > > Specifying a parameter to temporarily override to see if this has the
> > > effect is ok. But this has worked for years now. There must be something
> > > else going with with reclaim that causes these issues now.
> >
> > I don't think this has worked. Simon have found the corner case recently,
> > but it is not new.
> 
> What has worked? If the reduction of the maximum allocation order did not
> have the expected effect of fixing things here then the issue is not
> related to the higher allocations from slub.
> 
> Higher order allocations are not only a slub issue but a general issue for
> various subsystem that require higher order pages. This ranges from jumbo
> frames, to particular needs for certain device drivers, to huge pages.

Sure yes. However One big difference is there. Other user certinally need
such high order, but slub are using high order for only performance. but its
stragegy often shoot our own foot. It often makes worse than low order. IOW,
slub isn't always win against slab. 


> > So I hope you realize that high order allocation is no free lunch. __GFP_NORETRY
> > makes no sense really. Even though we have compaction, high order reclaim is still
> > costly operation.
> 
> Sure. There is a tradeoff between reclaim effort and the benefit of higher
> allocations. The costliness of reclaim may have increased with the recent
> changes to the reclaim logic. In fact reclaim gets more and more complex
> over time and there may be subtle bugs in there given the recent flurry of
> changes.

I can't insist reclaim is really complex. So maybe one of problem is now
reclaim can't know the request is must necessary or optimistic try. And,
allocation failure often makes disaster then we were working on fixint it.
But increasing high order allocation successful ratio sadly can makes slub
unhappy. umm..

So I think we have multiple option

1) reduce slub_max_order and slub only use safely order
2) slub don't invoke reclaim when high order tryal allocation 
   (ie turn off GFP_WAIT and turn on GFP_NOKSWAPD)
3) slub pass new hint to reclaim and reclaim don't work so aggressively if
   such hint is passwd.


So I have one question. I thought (2) is most nature. but now slub doesn't.
Why don't you do that? As far as I know, reclaim haven't been lighweight 
operation since linux was born. I'm curious your assumed cost threshold for
slub high order allocation.



> > I don't think SLUB's high order allocation trying is bad idea. but now It
> > does more costly trying. that's bad. Also I'm worry about SLUB assume too
> > higher end machine. Now Both SLES and RHEL decided to don't use SLUB,
> > instead use SLAB. Now linux community is fragmented. If you are still
> > interesting SL*B unification, can you please consider to join corner
> > case smashing activity?
> 
> The problems with higher order reclaim get more difficult with small
> memory sizes yes. We could reduce the maximum order automatically if memory
> is too tight. There is nothing hindering us from tuning the max order
> behavior of slub in a similar way that we now tune the thresholds of the
> vm statistics.

Sound like really good idea. :)



> But for that to be done we first need to have some feedback if the changes
> to max order have indeed the desired effect in this corner case.





