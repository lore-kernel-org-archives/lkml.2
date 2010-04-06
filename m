Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0DFLMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 07:12:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:53291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0DFLMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 07:12:07 -0400
Subject: [RFC][PATCH] lockdep: WARN about local_irq_{en,dis}able in NMI
 context
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       paulus@samba.org
In-Reply-To: <20100406.025049.267615796.davem@davemloft.net>
References: <20100405065701.GC5127@nowhere>
	 <20100405.122233.188421941.davem@davemloft.net>
	 <20100405194055.GA5265@nowhere>
	 <20100406.025049.267615796.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 13:12:01 +0200
Message-ID: <1270552321.1595.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 02:50 -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 5 Apr 2010 21:40:58 +0200
> 
> > It happens without CONFIG_FUNCTION_TRACER as well (but it happens
> > when the function tracer runs). And I hadn't your
> > perf_arch_save_caller_regs() when I triggered this.
> 
> I figured out the problem, it's NMIs.  As soon as I disable all of the
> NMI watchdog code, the problem goes away.
> 
> This is because some parts of the NMI interrupt handling path are not
> marked with "notrace" and the various tracer code paths use
> local_irq_disable() (either directly or indirectly) which doesn't work
> with sparc64's NMI scheme.  These essentially turn NMIs back on in the
> NMI handler before the NMI condition has been cleared, and thus we can
> re-enter with another NMI interrupt.
> 
> We went through this for perf events, and we just made sure that
> local_irq_{enable,disable}() never occurs in any of the code paths in
> perf events that can be reached via the NMI interrupt handler.  (the
> only one we had was sched_clock() and that was easily fixed)

One thing we can do is make the code WARN about this, how about
something like the below

---
Subject: lockdep: WARN about local_irq_{en,dis}able in NMI context

Some architectures implement NMIs by using IRQ priority levels and
mixing local_irq_{en,dis}able() with NMIs will give unexpected results.

Hence disallow this in general and WARN about it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 08e6f76..06ec1c7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2341,6 +2341,11 @@ EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
 void trace_hardirqs_on(void)
 {
+	/*
+	 * Some architectures can't deal with local_irq_{enable,disable}
+	 * from NMI context (SPARC), enforce this.
+	 */
+	WARN_ON_ONCE(in_nmi());
 	trace_hardirqs_on_caller(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_on);
@@ -2375,6 +2380,11 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller);
 
 void trace_hardirqs_off(void)
 {
+	/*
+	 * Some architectures can't deal with local_irq_{enable,disable}
+	 * from NMI context (SPARC), enforce this.
+	 */
+	WARN_ON_ONCE(in_nmi());
 	trace_hardirqs_off_caller(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_off);


