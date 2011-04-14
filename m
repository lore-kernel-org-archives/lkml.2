Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab1DNRob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:44:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab1DNRoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:44:30 -0400
Date: Thu, 14 Apr 2011 19:44:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
Message-ID: <20110414174420.GA8950@elte.hu>
References: <4DA70950.3060102@openvz.org>
 <20110414174327.GA8863@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414174327.GA8863@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


below is the commit which needs to be fixed - note that i improved the 
changelog, please keep these fixes for future submissions.

Thanks,

	Ingo

------------------>
>From 1b6556e28ea29c2e7fe0eb710b100db035278c32 Mon Sep 17 00:00:00 2001
From: Don Zickus <dzickus@redhat.com>
Date: Thu, 14 Apr 2011 18:48:48 +0400
Subject: [PATCH] perf, x86: Fix spurious 'unknown NMI' messages on Pentium4 systems

When using perf on a Pentium4 box, lots of unknown NMIs are
generated. This is the result of a P4 quirk that is subtle.  The
P4 generates an NMI when the counter overflows and unlike other
models where the NMI is a one time event, the P4 continues to
assert its NMI until cleared by the OS.

As a side effect to this quirk, the NMI on the apic is masked
off to prevent a stream of NMIs until the overflow flag is
cleared.  During the perf re-design, this subtle-ness was
overlooked and the apic was unmasked _before_ the overflow flag
was cleared.  As a result, this generated an extra NMI on P4
machines.

The fix is trivial: wait until the NMI is properly handled
before un-masking the apic.

Tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
[ Added a comment into code itself as well. ]
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Link: http://lkml.kernel.org/r/4DA70950.3060102@openvz.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index eed3673a..d3a1902 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1370,9 +1370,16 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 	}
 
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	handled = x86_pmu.handle_irq(args->regs);
+
+	/*
+	 * Note the unmasking of LVTPC entry must be
+	 * done *after* counter oveflow flag is cleared
+	 * otherwise it might lead to double NMIs generation.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	if (!handled)
 		return NOTIFY_DONE;
 
