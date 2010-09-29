Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0I2RJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:09:41 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:16959
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461Ab0I2RJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:09:40 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h43h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0L9IQBM-02-8B9-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 19:09:24 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100929170924.GR13563@erda.amd.com>
References: <20100929125301.GG13563@erda.amd.com>
 <20100929125453.GH13563@erda.amd.com>
 <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
 <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
 <20100929150140.GK13563@erda.amd.com>
 <20100929151253.GL13563@erda.amd.com>
 <20100929152745.GC9440@lenovo>
 <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
 <20100929154528.GD9440@lenovo>
 <AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 12:00:35, Stephane Eranian wrote:
> But you cannot clear it in x86_pmu_stop() because otherwise it
> turns into active_mask[]. My understanding is that you need
> to remember this counter has been active at some point in the
> past.
> 
> My point is that you cannot keep this around forever. After a
> "while" it becomes stale and you have to remove it otherwise
> you may wrongly increment handled.

The mask is cleared with the next nmi.

> 
> Here is a scenario:
> 
> event A -> counter 0, cpuc->running = 0x1 active_mask = 0x1
> move A
> event A -> counter 1, cpuc->running = 0x3, active_mask = 0x2
> 
> No interrupt, we are just counting for a short period.
> Then, you get an NMI interrupt, suppose it is not generated
> by the PMU, it is destined for another handler.
> 
> For i=0, you have (active_mask & 0x1) == 0, but (running & 0x1) == 1,
> you mark the interrupt as handled, i.e., you swallow it, the actual
> handler never gets it.

Yes, then changing the counters you will get *one* nmi with 2 handled
counters. This is valid as the disabled counter could generate a
spurious interrupt. But you get (handled == 2) instead of (handled ==
1) which is not much impact. All following nmis have (handled == 1)
then again.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

