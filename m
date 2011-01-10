Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1AJIm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:42:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:50547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab1AJImX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:42:23 -0500
Date: Mon, 10 Jan 2011 08:39:50 GMT
From: tip-bot for Pierre Tardy <pierre.tardy@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, bunk@stusta.de, pierre.tardy@intel.com,
        arjan@infradead.org, suresh.b.siddha@intel.com, zippel@linux-m68k.org,
        tglx@linutronix.de, ak@suse.de, hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bunk@stusta.de, johnstul@us.ibm.com, pierre.tardy@intel.com,
        arjan@infradead.org, suresh.b.siddha@intel.com, zippel@linux-m68k.org,
        tglx@linutronix.de, hpa@linux.intel.com, ak@suse.de, mingo@elte.hu
In-Reply-To: <1294327409-19426-1-git-send-email-pierre.tardy@intel.com>
References: <1294327409-19426-1-git-send-email-pierre.tardy@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, lapic-timer: Increase the max_delta to 31 bits
Message-ID: <tip-4aed89d6b515b9185351706ca95cd712c9d8d6a3@git.kernel.org>
Git-Commit-ID: 4aed89d6b515b9185351706ca95cd712c9d8d6a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 Jan 2011 08:39:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4aed89d6b515b9185351706ca95cd712c9d8d6a3
Gitweb:     http://git.kernel.org/tip/4aed89d6b515b9185351706ca95cd712c9d8d6a3
Author:     Pierre Tardy <pierre.tardy@intel.com>
AuthorDate: Thu, 6 Jan 2011 16:23:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Jan 2011 09:36:49 +0100

x86, lapic-timer: Increase the max_delta to 31 bits

Latest atom socs(penwell) does not have hpet timer.

As their local APIC timer is clocked at 400KHZ, and the current
code limit their Initial Counter register to 23 bits, they
cannot sleep more than 1.34 seconds which leads to ~2 spurious
wakeup per second (1 per thread)

These SOCs support 32bit timer so we change the max_delta to at
least 31bits. So we can at least sleep for 300 seconds.

We could not find any previous chip errata where lapic would
only have 23 bit precision As powertop is suggesting to activate
HPET to "sleep longer", this could mean this problem is already
known.

Problem is here since very first implementation of lapic timer
as a clock event e9e2cdb [PATCH] clockevents: i386 drivers.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
LKML-Reference: <1294327409-19426-1-git-send-email-pierre.tardy@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ce65d44..1efd378 100644
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
 
