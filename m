Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2LRMH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:07:58 -0500
Received: from service87.mimecast.com ([91.220.42.44]:42575 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2LRMHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:07:55 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, nico@linaro.org, will.deacon@arm.com,
        marc.zyngier@arm.com, john.stultz@linaro.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 3/5] ARM: Use generic timer broadcast receive
Date: Tue, 18 Dec 2012 12:06:56 +0000
Message-Id: <1355832418-31692-4-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
X-OriginalArrivalTime: 18 Dec 2012 12:07:51.0234 (UTC) FILETIME=[4D78FA20:01CDDD18]
X-MC-Unique: 112121812075224801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qBIC7xo3018313

Currently, the ARM backend must maintain a redundant list of timers for
the purpose of centralising timer broadcast functionality. This prevents
sharing timer drivers across architectures.

This patch moves the pain of dealing with timer broadcasts to the core
clockevents tick broadcast code, which already maintains its own list
of timers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm/kernel/smp.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 21954bc..59bf6d5 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -467,12 +467,6 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
  */
 static DEFINE_PER_CPU(struct clock_event_device, percpu_clockevent);
 
-static void ipi_timer(void)
-{
-	struct clock_event_device *evt = &__get_cpu_var(percpu_clockevent);
-	evt->event_handler(evt);
-}
-
 static void smp_timer_broadcast(const struct cpumask *mask)
 {
 	smp_cross_call(mask, IPI_TIMER);
@@ -586,7 +580,7 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 
 	case IPI_TIMER:
 		irq_enter();
-		ipi_timer();
+		tick_receive_broadcast();
 		irq_exit();
 		break;
 
-- 
1.7.0.4


