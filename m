Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2KBPOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:14:16 -0400
Received: from www.meduna.org ([92.240.244.38]:33115 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922Ab2KBPOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:14:12 -0400
X-Greylist: delayed 2630 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2012 11:14:11 EDT
Message-ID: <5093D8DE.70505@meduna.org>
Date: Fri, 02 Nov 2012 15:29:50 +0100
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
CC: shawn.guo@linaro.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Wakeup latency measured with SCHED_TRACER depends on HZ
References: <50919AFF.3060602@meduna.org>
In-Reply-To: <50919AFF.3060602@meduna.org>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/mixed;
 boundary="------------060407010504090007010905"
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 12-May-2011 18:13:45)
X-Date: 2012-11-02 15:30:15
X-Connected-IP: 95.105.165.4:50589
X-Message-Linecount: 106
X-Body-Linecount: 91
X-Message-Size: 3262
X-Body-Size: 2621
X-Received-Count: 1
X-Recipient-Count: 4
X-Local-Recipient-Count: 4
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060407010504090007010905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 31.10.2012 22:41, Stanislav Meduna wrote:

> on an embedded platform using a Freescale i.MX28 ARM processor
> I am experiencing a strange phenomenon - the latencies reported
> are dependent of HZ

OK, the problem is that the MXS platform does not setup
the scheduler clock so the scheduler only sees the HZ one.

The patch in attach fixes this. I can only test the MX28 part -
I don't have any timrot_is_v1() (MX23) hardware and I don't
know whether a source that wraps after ~2 seconds is OK at all.

Please Cc: when replying, I am not subscribed to linux-kernel
(only to linux-rt-users).

Regards
-- 
                                      Stano


--------------060407010504090007010905
Content-Type: text/plain; charset=windows-1252;
 name="0001-Setup-scheduler-clock-for-MXS.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Setup-scheduler-clock-for-MXS.patch"

>From ddeed3c83d48e8ce33b36bd964572756354e7feb Mon Sep 17 00:00:00 2001
From: Stanislav Meduna <stano@meduna.org>
Date: Fri, 2 Nov 2012 15:00:44 +0100
Subject: [PATCH] Setup scheduler clock for MXS

---
 arch/arm/mach-mxs/timer.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mxs/timer.c b/arch/arm/mach-mxs/timer.c
index 564a632..0ab86a2 100644
--- a/arch/arm/mach-mxs/timer.c
+++ b/arch/arm/mach-mxs/timer.c
@@ -26,6 +26,7 @@
 #include <linux/clk.h>
 
 #include <asm/mach/time.h>
+#include <asm/sched_clock.h>
 #include <mach/mxs.h>
 #include <mach/common.h>
 
@@ -243,6 +244,16 @@ static int __init mxs_clocksource_init(struct clk *timer_clk)
 	return 0;
 }
 
+static u32 notrace mxs_read_sched_clock_v1(void)
+{
+	return timrotv1_get_cycles(&clocksource_mxs);
+}
+
+static u32 notrace mxs_read_sched_clock_v2(void)
+{
+	return ~readl_relaxed(mxs_timrot_base + HW_TIMROT_RUNNING_COUNTn(1));
+}
+
 void __init mxs_timer_init(struct clk *timer_clk, int irq)
 {
 	clk_prepare_enable(timer_clk);
@@ -285,6 +296,14 @@ void __init mxs_timer_init(struct clk *timer_clk, int irq)
 	mxs_clocksource_init(timer_clk);
 	mxs_clockevent_init(timer_clk);
 
+	/* Register scheduler clocksource */
+	if (timrot_is_v1())
+		setup_sched_clock(mxs_read_sched_clock_v1,
+			16, clk_get_rate(timer_clk));
+	else
+		setup_sched_clock(mxs_read_sched_clock_v2,
+			32, clk_get_rate(timer_clk));
+
 	/* Make irqs happen */
 	setup_irq(irq, &mxs_timer_irq);
 }
-- 
1.7.0.4


--------------060407010504090007010905--
