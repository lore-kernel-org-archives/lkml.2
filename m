Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab0DOGfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:35:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50093 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0DOGfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:35:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415062055.GQ2493@dastard>
References: <20100415130212.D16E.A69D9226@jp.fujitsu.com> <20100415062055.GQ2493@dastard>
Message-Id: <20100415152816.D18C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 15:35:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 15, 2010 at 01:09:01PM +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > How about this? For now, we stop direct reclaim from doing writeback
> > > only on order zero allocations, but allow it for higher order
> > > allocations. That will prevent the majority of situations where
> > > direct reclaim blows the stack and interferes with background
> > > writeout, but won't cause lumpy reclaim to change behaviour.
> > > This reduces the scope of impact and hence testing and validation
> > > the needs to be done.
> > 
> > Tend to agree. but I would proposed slightly different algorithm for
> > avoind incorrect oom.
> > 
> > for high order allocation
> > 	allow to use lumpy reclaim and pageout() for both kswapd and direct reclaim
> 
> SO same as current.

Yes. as same as you propsed.

> 
> > for low order allocation
> > 	- kswapd:          always delegate io to flusher thread
> > 	- direct reclaim:  delegate io to flusher thread only if vm pressure is low
> 
> IMO, this really doesn't fix either of the problems - the bad IO
> patterns nor the stack usage. All it will take is a bit more memory
> pressure to trigger stack and IO problems, and the user reporting the
> problems is generating an awful lot of memory pressure...

This patch doesn't care stack usage. because
  - again, I think all stack eater shold be diet.
  - under allowing lumpy reclaim world, only deny low order reclaim
    doesn't solve anything.

Please don't forget priority=0 recliam failure incvoke OOM-killer.
I don't imagine anyone want it.

And, Which IO workload trigger <6 priority vmscan?



