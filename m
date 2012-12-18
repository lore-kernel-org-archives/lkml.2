Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2LRMIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:08:45 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47175 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2LRMIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:08:43 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, nico@linaro.org, will.deacon@arm.com,
        marc.zyngier@arm.com, john.stultz@linaro.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 5/5] ARM: Add generic timer broadcast support
Date: Tue, 18 Dec 2012 12:06:58 +0000
Message-Id: <1355832418-31692-6-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
X-OriginalArrivalTime: 18 Dec 2012 12:08:23.0437 (UTC) FILETIME=[60AAC3D0:01CDDD18]
X-MC-Unique: 112121812082500401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qBIC8lX2018321

Implement timer_broadcast for the arm architecture, allowing for the use
of clock_event_device_drivers decoupled from the timer tick broadcast
mechanism.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm/Kconfig      |    1 +
 arch/arm/kernel/smp.c |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9759fec..d28a899 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -4,6 +4,7 @@ config ARM
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAVE_CUSTOM_GPIO_H
+	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select DCACHE_WORD_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && !CPU_BIG_ENDIAN
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 59bf6d5..ba1dc4a 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -467,7 +467,7 @@ u64 smp_irq_stat_cpu(unsigned int cpu)
  */
 static DEFINE_PER_CPU(struct clock_event_device, percpu_clockevent);
 
-static void smp_timer_broadcast(const struct cpumask *mask)
+void tick_broadcast(const struct cpumask *mask)
 {
 	smp_cross_call(mask, IPI_TIMER);
 }
@@ -512,7 +512,6 @@ static void __cpuinit percpu_timer_setup(void)
 	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
 
 	evt->cpumask = cpumask_of(cpu);
-	evt->broadcast = smp_timer_broadcast;
 
 	if (!lt_ops || lt_ops->setup(evt))
 		broadcast_timer_setup(evt);
-- 
1.7.0.4


