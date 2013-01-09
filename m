Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab3AIOrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:47:11 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44573 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab3AIOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:47:08 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, tglx@linutronix.de, nico@linaro.org,
        will.deacon@arm.com, marc.zyngier@arm.com, john.stultz@linaro.org,
        mark.rutland@arm.com
Subject: [PATCHv2 2/4] arm: Use generic timer broadcast receiver
Date: Wed,  9 Jan 2013 14:46:08 +0000
Message-Id: <1357742770-15028-3-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com>
X-OriginalArrivalTime: 09 Jan 2013 14:47:06.0556 (UTC) FILETIME=[31F9E7C0:01CDEE78]
X-MC-Unique: 113010914470701801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r09ElE6u006480

Currently, the ARM backend must maintain a redundant list of timers for
the purpose of centralising timer broadcast functionality. This prevents
sharing timer drivers across architectures.

This patch moves the pain of dealing with timer broadcasts to the core
clockevents tick broadcast code, which already maintains its own list
of timers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/kernel/smp.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 84f4cbf..a9d7e70 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -475,12 +475,6 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
  */
 static DEFINE_PER_CPU(struct clock_event_device, percpu_clockevent);
 
-static void ipi_timer(void)
-{
-	struct clock_event_device *evt = &__get_cpu_var(percpu_clockevent);
-	evt->event_handler(evt);
-}
-
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 static void smp_timer_broadcast(const struct cpumask *mask)
 {
@@ -598,7 +592,7 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 
 	case IPI_TIMER:
 		irq_enter();
-		ipi_timer();
+		tick_receive_broadcast();
 		irq_exit();
 		break;
 
-- 
1.7.0.4


