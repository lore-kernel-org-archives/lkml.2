Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab1BPL5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 06:57:08 -0500
Received: from science.horizon.com ([71.41.210.146]:44288 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932151Ab1BPL5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 06:57:06 -0500
Date: 16 Feb 2011 06:57:01 -0500
Message-ID: <20110216115701.3956.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: airlied@gmail.com, gorcunov@gmail.com
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Cc: a.p.zijlstra@chello.nl, dzickus@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, linux@horizon.com, ming.m.lin@intel.com,
        mingo@elte.hu
In-Reply-To: <AANLkTikLVMNQzmugH-ORc89_ZouX6zWvG-tHSf1QoVf3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ping on this problem, still seeing
> 
> Uhhuh. NMI received for unknown reason 3c on CPU 0.
> Do you have a strange power saving mode enabled?
> Dazed and confused, but trying to continue
> 
> on my Pentium-D system here with latest Linus head.
> 
> its sometimes 3c, sometimes 3d, I'm going to bisect and push for
> reverts if nobody still has any clue about how to fix this.

The second patch (not the one you quote) fixed it for me.  Almost 8 days
of uptime and no log spam.

It's appended below for your convenience.  Are you using this
unsuccessfully?


From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test

A couple of people have reported an unknown NMI issue on p4 pmu.
This patch should fix it.

Reported-by: George Spelvin <linux@horizon.com>
Reported-by: Meelis Roos <mroos@linux.ee>
Reported-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/perf_event_p4.h |    1 +
 arch/x86/kernel/cpu/perf_event_p4.c  |   11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.tip/arch/x86/include/asm/perf_event_p4.h
===================================================================
--- linux-2.6.tip.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.tip/arch/x86/include/asm/perf_event_p4.h
@@ -22,6 +22,7 @@
 
 #define ARCH_P4_CNTRVAL_BITS	(40)
 #define ARCH_P4_CNTRVAL_MASK	((1ULL << ARCH_P4_CNTRVAL_BITS) - 1)
+#define ARCH_P4_UNFLAGGED_BIT	((1ULL) << (ARCH_P4_CNTRVAL_BITS - 1))
 
 #define P4_ESCR_EVENT_MASK	0x7e000000U
 #define P4_ESCR_EVENT_SHIFT	25
Index: linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
@@ -770,9 +770,14 @@ static inline int p4_pmu_clear_cccr_ovf(
 		return 1;
 	}
 
-	/* it might be unflagged overflow */
-	rdmsrl(hwc->event_base + hwc->idx, v);
-	if (!(v & ARCH_P4_CNTRVAL_MASK))
+	/*
+	 * at some circumstances the overflow might issue NMI but did
+	 * not set P4_CCCR_OVF bit so since a counter holds a negative value
+	 * we simply check for high bit being set, if it's cleared it means
+	 * the counter has reached zero value and continued counting before
+	 * real NMI signal was received
+	 */
+	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;
 
 	return 0;
