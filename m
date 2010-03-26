Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0CZGCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:02:41 -0400
Received: from ozlabs.org ([203.10.76.45]:41973 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab0CZGCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:02:39 -0400
Date: Fri, 26 Mar 2010 17:02:30 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Archs <linux-arch@vger.kernel.org>, "H . Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/7] perf updates and fixes
Message-ID: <20100326060229.GA5259@drongo>
References: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 02:52:35AM +0100, Frederic Weisbecker wrote:

> The series is not yet mergeable because it would break PowerPc
> (hot regs snapshot API has been changed, and I don't know how
> to update PowerPc for that).
> 
> But if you're fine with the ideas, I can integrate the necessary
> changes to fix this, and also separate fixes and updates.

The patch below adds the necessary stuff for powerpc.  You could fold
it into your "perf: Move perf_arch_fetch_caller_regs into a macro"
patch, or keep it as a separate patch in the series (though that would
make preserving bisectability more difficult).

There is a little difficulty in that you first create a 3-argument
form of perf_arch_fetch_caller_regs and then remove one argument in a
later patch, whereas my patch below just creates the 2-argument form.
I'm sure you can resolve that one way or another.

The patch to add the old-style perf_arch_fetch_caller_regs for powerpc
is sitting in the tip/perf/urgent branch but hasn't gone anywhere.
I suppose we need to get Ingo to pull that branch into tip/perf/core
and then include a revert patch in the series that switches to the new
interface.  Alternatively, if the urgent branch isn't append-only then
we could disappear it (the urgent branch would need to be rewound by
one commit).

Paul.
----------
[PATCH] perf/powerpc: Implement perf_arch_fetch_caller_regs for powerpc

This adds the ability to get a hot register snapshot for powerpc,
enabling us to get meaningful call chains for tracepoints and context
switch events.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/perf_event.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/powerpc/include/asm/perf_event.h b/arch/powerpc/include/asm/perf_event.h
index e6d4ce6..5c16b89 100644
--- a/arch/powerpc/include/asm/perf_event.h
+++ b/arch/powerpc/include/asm/perf_event.h
@@ -21,3 +21,15 @@
 #ifdef CONFIG_FSL_EMB_PERF_EVENT
 #include <asm/perf_event_fsl_emb.h>
 #endif
+
+#ifdef CONFIG_PERF_EVENTS
+#include <asm/ptrace.h>
+#include <asm/reg.h>
+
+#define perf_arch_fetch_caller_regs(regs, __ip)			\
+	do {							\
+		(regs)->nip = __ip;				\
+		(regs)->gpr[1] = *(unsigned long *)__get_SP();	\
+		asm volatile("mfmsr %0" : "=r" ((regs)->msr));	\
+	} while (0)
+#endif
