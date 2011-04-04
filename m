Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1DDMFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:05:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38186 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1DDMFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:05:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20110404001936.GL6957@dastard>
References: <20110403183229.AE4C.A69D9226@jp.fujitsu.com> <20110404001936.GL6957@dastard>
Message-Id: <20110404210523.DA69.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  4 Apr 2011 21:05:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Thanks long explanation.

> > Secondly, You misparsed "avoid direct reclaim" paragraph. We don't talk
> > about "avoid direct reclaim even if system memory is no enough", We talk
> > about "avoid direct reclaim by preparing before". 
> 
> I don't think I misparsed it. I am addressing the "avoid direct
> reclaim by preparing before" principle directly. The problem with it
> is that just enalrging the free memory pool doesn't guarantee future
> allocation success when there are other concurrent allocations
> occurring. IOWs, if you don't _reserve_ the free memory for the
> critical area in advance then there is no guarantee it will be
> available when needed by the critical section.

Right.

Then, I made per-task reserve memory code at very years ago when I'm
working for embedded. So, There are some design choice here. best effort
as Christoph described or per thread or RT thread specific reservation.


> A simple example: the radix tree node preallocation code to
> guarantee inserts succeed while holding a spinlock. If just relying
> on free memory was sufficient, then GFP_ATOMIC allocations are all
> that is necessary. However, even that isn't sufficient as even the
> GFP_ATOMIC reserved pool can be exhausted by other concurrent
> GFP_ATOMIC allocations. Hence preallocation is required before
> entering the critical section to guarantee success in all cases.
> 
> And to state the obvious: doing allocation before the critical
> section will trigger reclaim if necessary so there is no need to
> have the application trigger reclaim.

Yes and No.
Preallocation is core piece, yes. But Almost all syscall call 
kmalloc() implicitly. then mlock() is no sufficient preallocation.
Almost all application except HPC can't avoid syscall use. That's 
the reason why finance people repeatedly requirest us the feature,
I think.

Thanks!


