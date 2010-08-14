Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0HNCbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 22:31:08 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:30706 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab0HNCbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 22:31:06 -0400
X-SpamScore: 1
X-BigFish: VPS1(z3cfcs329eqz146fK1432N98dN936eMzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L74EXH-01-4PU-02
X-M-MSG: 
Date: Sat, 14 Aug 2010 04:29:40 +0200
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
Message-ID: <20100814022940.GE26154@erda.amd.com>
References: <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100810204856.GA16571@redhat.com>
 <20100811024451.GA26835@nowhere>
 <20100811111046.GQ26154@erda.amd.com>
 <20100813043746.GB9669@nowhere>
 <20100813082230.GZ26154@erda.amd.com>
 <20100814012804.GB5343@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100814012804.GB5343@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.08.10 21:28:07, Frederic Weisbecker wrote:

> > We cannot assume that all cpus have the same behavior here. Imagine a
> > cpu that handles 2 counters and *does not* trigger a back-to-back
> > nmi. With flags only implemented, the next unknown nmi will be dropped
> > anyway, no matter when it fires. We have to check the nmi sequence.
> 
> 
> 
> I'd expect it to be an ABI. NMIs can't nest, but if one triggers while
> servicing another, it should trigger right after (once we "iret", which
> reenables NMIs).
> 
> But I haven't checked intel or amd documentation about that.

Yes, nmis are nested and if there is another source firing it will be
retriggered. But the question is, if multiple counters trigger, does
this mean multiple nmis are fired, esp. if all counters were served in
the first run? This very much depends on the cpu implementation and it
will be hard to find documentation about this detail.

> > The next thing you have to be aware is, a registered nmi handler is
> > not called with every nmi. If there was another nmi source and a
> > handler with higher priority was returning a stop, when all other
> > subsequent handlers are not called. Esp. 'unknown nmi' is called only
> > in rare cases. So, a handler might not get noticed of an nmi. This
> > means, if a handler gets called a 2nd time, it must not necessarily
> > the next (2nd) nmi.
> 
> 
> Yeah, in this case we can just clear the __ger_cpu_var(next_nmi_skip)
> when another handler service the next NMI.

Yes, this might work too. But then you end up at the same complexity.
Even worse, you have to check and unset the flag with each perf nmi.
If you store the nmi number, it will only be read in then 'unknown'
nmi path again. And, you can't unset the flag for nmis by other
sources what do not pass the perf nmi handler.

So, overall, I don't see advantages in using a flag. The
implementation of storing the nmi number is simple and straight
forward with no or less impact on performance or memory usage.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

