Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab0HMEZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 00:25:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48424 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0HMEZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 00:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O9Wahr3qssldmF+Rd1/HOORkzicuDvmmaPRxW4Y+ApxDh8QSpNJ/Dyr8AHDFDINtko
         PcKLCKgLRy1SdXoK3B4BKWVmsE2GTCN2MamWwiVbv6LoDDOOAP4jqNWxj+pLW5SXvNFY
         344D4FM0WMBWx+FGp9zDgFX+/y1aHmQPYLrWs=
Date: Fri, 13 Aug 2010 06:25:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100813042533.GA9669@nowhere>
References: <20100804155002.GS3353@redhat.com> <20100804161046.GC5130@lenovo> <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100811220058.GT26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811220058.GT26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:00:58AM +0200, Robert Richter wrote:
> I was debuging this a little more, see version 2 below.
> 
> -Robert
> 
> --
> 
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
> cpu #6, nmi #32333, skip_nmi #32330, handled = 1, time = 1934364430
> cpu #6, nmi #32334, skip_nmi #32330, handled = 1, time = 1934704616
> cpu #6, nmi #32335, skip_nmi #32336, handled = 2, time = 1936032320
> cpu #6, nmi #32336, skip_nmi #32336, handled = 0, time = 1936034139
> cpu #6, nmi #32337, skip_nmi #32336, handled = 1, time = 1936120100
> cpu #6, nmi #32338, skip_nmi #32336, handled = 1, time = 1936404607
> cpu #6, nmi #32339, skip_nmi #32336, handled = 1, time = 1937983416
> cpu #6, nmi #32340, skip_nmi #32341, handled = 2, time = 1938201032
> cpu #6, nmi #32341, skip_nmi #32341, handled = 0, time = 1938202830
> cpu #6, nmi #32342, skip_nmi #32341, handled = 1, time = 1938443743
> cpu #6, nmi #32343, skip_nmi #32341, handled = 1, time = 1939956552
> cpu #6, nmi #32344, skip_nmi #32341, handled = 1, time = 1940073224
> cpu #6, nmi #32345, skip_nmi #32341, handled = 1, time = 1940485677
> cpu #6, nmi #32346, skip_nmi #32347, handled = 2, time = 1941947772
> cpu #6, nmi #32347, skip_nmi #32347, handled = 1, time = 1941949818
> cpu #6, nmi #32348, skip_nmi #32347, handled = 0, time = 1941951591
> Uhhuh. NMI received for unknown reason 00 on CPU 6.
> Do you have a strange power saving mode enabled?
> Dazed and confused, but trying to continue
> 
> Deltas:
> 
> nmi #32334 340186
> nmi #32335 1327704
> nmi #32336 1819      <<<< back-to-back nmi [1]
> nmi #32337 85961
> nmi #32338 284507
> nmi #32339 1578809
> nmi #32340 217616
> nmi #32341 1798      <<<< back-to-back nmi [2]
> nmi #32342 240913
> nmi #32343 1512809
> nmi #32344 116672
> nmi #32345 412453
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
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---



That time based thing looks a bit complicated.

I'm still not sure why you don't want to use a simple flag:

After handled a perf NMI:

	if (handled more than one counter)
		__get_cpu_var(skip_unknown) = 1;

While handling an unknown NMI:

	if (__get_cpu_var(skip_unknown)) {
		__get_cpu_var(skip_unknow) = 0;
		return NOTIFY_STOP;
	}

