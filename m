Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab0HMIXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 04:23:00 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:2743 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab0HMIWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 04:22:55 -0400
X-SpamScore: 1
X-BigFish: VPS1(z3cfcs329eqz146fK1432N98dN936eMzz1202hzzz32i2a8h64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0L730LH-01-C1D-02
X-M-MSG: 
Date: Fri, 13 Aug 2010 10:22:30 +0200
From: Robert Richter <robert.richter@amd.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100813082230.GZ26154@erda.amd.com>
References: <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100810204856.GA16571@redhat.com>
 <20100811024451.GA26835@nowhere>
 <20100811111046.GQ26154@erda.amd.com>
 <20100813043746.GB9669@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100813043746.GB9669@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.08.10 00:37:48, Frederic Weisbecker wrote:

> > 
> > ... but this will not work. You have to mark the *absolute* nmi number
> > here. If you only raise a flag, the next unknown nmi will be dropped,
> > every.
> 
> 
> 
> Isn't it what we want? Only the next unknown nmi gets dropped.
> 
> 
> 
> 
> > Because, in between there could have been other nmis that
> > stopped the chain and thus the 'unknown' path is not executed.
> 
> 
> 
> I'm not sure what you mean here. Are you thinking about a third
> NMI source that triggers while we are still handling the first
> NMI in the back to back sequence?
> 
> 
> 
> > The trick in my patch is that you *know*, which nmi you want to skip.
> 
> 
> Well with the flag you also know which nmi you want to skip.

We cannot assume that all cpus have the same behavior here. Imagine a
cpu that handles 2 counters and *does not* trigger a back-to-back
nmi. With flags only implemented, the next unknown nmi will be dropped
anyway, no matter when it fires. We have to check the nmi sequence.

The next thing you have to be aware is, a registered nmi handler is
not called with every nmi. If there was another nmi source and a
handler with higher priority was returning a stop, when all other
subsequent handlers are not called. Esp. 'unknown nmi' is called only
in rare cases. So, a handler might not get noticed of an nmi. This
means, if a handler gets called a 2nd time, it must not necessarily
the next (2nd) nmi.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

