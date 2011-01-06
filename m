Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1AFPXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:23:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:6871 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab1AFPXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:23:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,283,1291622400"; 
   d="scan'208";a="370953357"
From: Pierre Tardy <pierre.tardy@intel.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Pierre Tardy <pierre.tardy@intel.com>,
        Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
        Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        john stultz <johnstul@us.ibm.com>,
        Roman Zippel <zippel@linux-m68k.org>, Andi Kleen <ak@suse.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] lapic-timer: increase the max_delta to 31 bits
Date: Thu,  6 Jan 2011 16:23:29 +0100
Message-Id: <1294327409-19426-1-git-send-email-pierre.tardy@intel.com>
X-Mailer: git-send-email 1.7.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest atom socs(penwell) does not have hpet timer.

As their local APIC timer is clocked at 400KHZ, and the current code
limit their Initial Counter register to 23 bits, they cannot sleep
more than 1.34 seconds which leads to ~2 spurious wakeup per second (1 per thread)

These SOCs support 32bit timer so we change the max_delta to at least 31bits.
So we can at least sleep for 300 seconds.

We could not find any previous chip errata where lapic would only have 23 bit precision
As powertop is suggesting to activate HPET to "sleep longer", this could mean this problem is
already known.

Problem is here since very first implementation of lapic timer as a clock event
e9e2cdb [PATCH] clockevents: i386 drivers
cc contributors of the first patch and x86 maintainers

CC: Arjan van de Ven <arjan@infradead.org>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@osdl.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: H. Peter Anvin <hpa@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
TO: Thomas Gleixner <tglx@linutronix.de>
TO: Ingo Molnar <mingo@redhat.com>
TO: "H. Peter Anvin" <hpa@zytor.com>
TO: x86@kernel.org
TO: Suresh Siddha <suresh.b.siddha@intel.com>
TO: Yinghai Lu <yinghai@kernel.org>
TO: Robert Richter <robert.richter@amd.com>

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7821813..c031f1d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -684,7 +684,7 @@ static int __init calibrate_APIC_clock(void)
 	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
 				       lapic_clockevent.shift);
 	lapic_clockevent.max_delta_ns =
-		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+		clockevent_delta2ns(0x7FFFFFFF, &lapic_clockevent);
 	lapic_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &lapic_clockevent);
 
-- 
1.7.0.4

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

