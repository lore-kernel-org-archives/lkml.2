Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2K0PEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:04:40 -0500
Received: from smtp201.dfw.emailsrvr.com ([67.192.241.201]:51347 "EHLO
	smtp201.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2K0PEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:04:36 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/6 v5] arm: use devicetree to get smp_twd clock
Date: Tue, 27 Nov 2012 09:04:29 -0600
Message-Id: <1354028674-23685-2-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354028674-23685-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354028674-23685-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
Changes from v4
	None.
Changes from v3
        No longer setting *clk to NULL in twd_get_clock().
Changes from v2
        Turned the check for the node pointer into an if-then-else statement.
        Removed the second, redundant clk_get_rate.
Changes from v1
        None.

 arch/arm/kernel/smp_twd.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index b22d700..af46b80 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -237,12 +237,15 @@ static irqreturn_t twd_handler(int irq, void *dev_id)
 	return IRQ_NONE;
 }
 
-static struct clk *twd_get_clock(void)
+static struct clk *twd_get_clock(struct device_node *np)
 {
 	struct clk *clk;
 	int err;
 
-	clk = clk_get_sys("smp_twd", NULL);
+	if (np)
+		clk = of_clk_get(np, 0);
+	else
+		clk = clk_get_sys("smp_twd", NULL);
 	if (IS_ERR(clk)) {
 		pr_err("smp_twd: clock not found: %d\n", (int)PTR_ERR(clk));
 		return clk;
@@ -263,6 +266,7 @@ static struct clk *twd_get_clock(void)
 		return ERR_PTR(err);
 	}
 
+	twd_timer_rate = clk_get_rate(clk);
 	return clk;
 }
 
@@ -273,12 +277,7 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 {
 	struct clock_event_device **this_cpu_clk;
 
-	if (!twd_clk)
-		twd_clk = twd_get_clock();
-
-	if (!IS_ERR_OR_NULL(twd_clk))
-		twd_timer_rate = clk_get_rate(twd_clk);
-	else
+	if (IS_ERR_OR_NULL(twd_clk))
 		twd_calibrate_rate();
 
 	__raw_writel(0, twd_base + TWD_TIMER_CONTROL);
@@ -349,6 +348,8 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
 	if (!twd_base)
 		return -ENOMEM;
 
+	twd_clk = twd_get_clock(NULL);
+
 	return twd_local_timer_common_register();
 }
 
@@ -383,6 +384,8 @@ void __init twd_local_timer_of_register(void)
 		goto out;
 	}
 
+	twd_clk = twd_get_clock(np);
+
 	err = twd_local_timer_common_register();
 
 out:
-- 
1.7.11.7

