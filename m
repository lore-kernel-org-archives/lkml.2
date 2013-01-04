Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3ADQgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:36:19 -0500
Received: from smtp131.dfw.emailsrvr.com ([67.192.241.131]:36426 "EHLO
	smtp131.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab3ADQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:35:25 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/4 v10] arm: use devicetree to get smp_twd clock
Date: Fri,  4 Jan 2013 10:35:43 -0600
Message-Id: <1357317346-1120-2-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357317346-1120-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1357317346-1120-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
Changes from v9
	Updated to work with 3.8 kernel.
Changes from v4, v5, v6, v7, v8
        None.
Changes from v3
        No longer setting *clk to NULL in twd_get_clock().
Changes from v2
        Turned the check for the node pointer into an if-then-else statement.
        Removed the second, redundant clk_get_rate.
Changes from v1
        None.

 arch/arm/kernel/smp_twd.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 49f335d..dad2d81 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -239,12 +239,15 @@ static irqreturn_t twd_handler(int irq, void *dev_id)
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
@@ -257,6 +260,7 @@ static struct clk *twd_get_clock(void)
 		return ERR_PTR(err);
 	}
 
+	twd_timer_rate = clk_get_rate(clk);
 	return clk;
 }
 
@@ -285,7 +289,7 @@ static int __cpuinit twd_timer_setup(struct clock_event_device *clk)
 	 * during the runtime of the system.
 	 */
 	if (!common_setup_called) {
-		twd_clk = twd_get_clock();
+		twd_clk = twd_get_clock(NULL);
 
 		/*
 		 * We use IS_ERR_OR_NULL() here, because if the clock stubs
@@ -373,6 +377,8 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
 	if (!twd_base)
 		return -ENOMEM;
 
+	twd_clk = twd_get_clock(NULL);
+
 	return twd_local_timer_common_register();
 }
 
@@ -405,6 +411,8 @@ void __init twd_local_timer_of_register(void)
 		goto out;
 	}
 
+	twd_clk = twd_get_clock(np);
+
 	err = twd_local_timer_common_register();
 
 out:
-- 
1.8.0.2

