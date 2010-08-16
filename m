Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0HPOsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:48:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:47443 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab0HPOsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:48:51 -0400
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100811220058.GT26154@erda.amd.com>
References: <20100804151858.GB5130@lenovo>
	 <20100804155002.GS3353@redhat.com> <20100804161046.GC5130@lenovo>
	 <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo>
	 <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo>
	 <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com>
	 <20100809194829.GB26154@erda.amd.com> <20100811220058.GT26154@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 16:48:36 +0200
Message-ID: <1281970116.1926.1495.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 00:00 +0200, Robert Richter wrote:
> From 8bb831af56d118b85fc38e0ddc2e516f7504b9fb Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Thu, 5 Aug 2010 16:19:59 +0200
> Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs
> 
> When perfctrs are running it is valid to have unhandled nmis, two
> events could trigger 'simultaneously' raising two back-to-back
> NMIs. If the first NMI handles both, the latter will be empty and daze
> the CPU.
> 
> The solution to avoid an 'unknown nmi' massage in this case was simply
> to stop the nmi handler chain when perfctrs are runnning by stating
> the nmi was handled. This has the drawback that a) we can not detect
> unknown nmis anymore, and b) subsequent nmi handlers are not called.
> 
> This patch addresses this. Now, we check this unknown NMI if it could
> be a perfctr back-to-back NMI. Otherwise we pass it and let the kernel
> handle the unknown nmi.
> 
> This is a debug log:

> 
> Deltas:
> 

> nmi #32346 1462095   <<<< 1st nmi (standard) handling 2 counters
> nmi #32347 2046      <<<< 2nd nmi (back-to-back) handling one counter
> nmi #32348 1773      <<<< 3rd nmi (back-to-back) handling no counter! [3]
> 
> For  back-to-back nmi detection there are the following rules:
> 
> The perfctr nmi handler was handling more than one counter and no
> counter was handled in the subsequent nmi (see [1] and [2] above).
> 
> There is another case if there are two subsequent back-to-back nmis
> [3]. In this case we measure the time between the first and the
> 2nd. The 2nd is detected as back-to-back because the first handled
> more than one counter. The time between the 1st and the 2nd is used to
> calculate a range for which we assume a back-to-back nmi. Now, the 3rd
> nmi triggers, we measure again the time delta and compare it with the
> first delta from which we know it was a back-to-back nmi. If the 3rd
> nmi is within the range, it is also a back-to-back nmi and we drop it. 

I liked the one without funny timestamps in better, the whole timestamps
thing just feels too fragile.

Relying on handled > 1 to arm the back-to-back filter seems doable.

(Also, you didn't deal with the TSC going backwards..)
