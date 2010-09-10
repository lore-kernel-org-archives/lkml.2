Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0IJPUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:20:15 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:15197 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab0IJPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:20:13 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2cK936eK1432N98dNzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L8JEHB-01-6MY-02
X-M-MSG: 
Date: Fri, 10 Sep 2010 17:17:35 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
Message-ID: <20100910151735.GC13563@erda.amd.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
 <1284118900.402.35.camel@laptop>
 <20100910132741.GB4879@redhat.com>
 <20100910144634.GA1060@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100910144634.GA1060@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.09.10 10:46:34, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > On Fri, Sep 10, 2010 at 01:41:40PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2010-09-02 at 15:07 -0400, Don Zickus wrote:
> > > > Fixes to allow unknown nmis to pass through the perf nmi handler instead
> > > > of being swallowed.  Contains patches that are already in Ingo's tree.  Added
> > > > here for completeness.  Based on ingo/tip
> > > > 
> > > > Tested on intel/amd
> > > > 
> > > > v2: patch cleanups and consolidation, no code changes
> > > > 
> > > > Don Zickus (1):
> > > >   perf, x86: Fix accidentally ack'ing a second event on intel perf
> > > >     counter
> > > > 
> > > > Peter Zijlstra (1):
> > > >   perf, x86: Fix handle_irq return values
> > > > 
> > > > Robert Richter (1):
> > > >   perf, x86: Try to handle unknown nmis with an enabled PMU
> > > > 
> > > >  arch/x86/kernel/cpu/perf_event.c       |   59 +++++++++++++++++++++++++-------
> > > >  arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++---
> > > >  arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
> > > >  3 files changed, 56 insertions(+), 20 deletions(-)
> > > 
> > > Both Ingo and I are getting Dazed and confused on our AMD machines, it
> > > started before yesterday (that is, after backing out all my recent
> > > changes it still gets dazed), so I suspect this set.
> > > 
> > > I'll look at getting a trace of the thing, but if any of you has a
> > > bright idea...
> > 
> > What are you running to create the problem?  I can try and duplicate 
> > it here.
> 
> It happens easily here - just running something like:
> 
>    perf record -g ./hackbench 10

I try to reproduce it, which systems are affected?

> 
> a couple of times triggers it. Note, unlike with the earlier bug, the 
> NMIs are not permanently 'stuck' - and everything continues working. 
> Obviously the messages are nasty looking so this is a regression we need 
> to fix.

The patch below adds ratelimits.

-Robert

--

>From 1747710d684302b806b145e5acb590ab2088e5ca Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Thu, 5 Aug 2010 18:04:31 +0200
Subject: [PATCH] x86: ratelimit NMI messages

In case of a storm of unknown NMIs the cpu get stucked. This patch
adds ratelimits to avoid this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/traps.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 60788de..97a492d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -366,15 +366,17 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 		return;
 	}
 #endif
-	printk(KERN_EMERG
-		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
-			reason, smp_processor_id());
-
-	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
+	if (printk_ratelimit()) {
+		printk(KERN_EMERG "Uhhuh. NMI received for unknown reason"
+		       " %02x on CPU %d.\n", reason, smp_processor_id());
+		printk(KERN_EMERG
+		       "Do you have a strange power saving mode enabled?\n");
+	}
 	if (panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
-
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
+	if (printk_ratelimit())
+		printk(KERN_EMERG
+		       "Dazed and confused, but trying to continue\n");
 }
 
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
-- 
1.7.1.1



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

