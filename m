Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0LQAyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:54:17 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12572 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0LQAuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="66953206"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 09/22] msm: clock: Remove references to clk_ops_pcom
Date: Thu, 16 Dec 2010 16:49:53 -0800
Message-Id: <1292547006-19741-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all devices use proc_comm. The soc_clk_set_ops() function was
unused. Determining if a clock is local vs. remote is fragile
when done by comparing clk_ops pointers. Instead, implement an
is_local() function for all clk_ops to determine if the clock is
local. Once we do this we can compile clock.c with
CONFIG_MSM_PROC_COMM=n.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-7x30.c  |    1 +
 arch/arm/mach-msm/clock-8x60.c  |    1 +
 arch/arm/mach-msm/clock-debug.c |    3 +--
 arch/arm/mach-msm/clock-local.c |    5 +++++
 arch/arm/mach-msm/clock-local.h |    1 +
 arch/arm/mach-msm/clock-pcom.c  |    6 ++++++
 arch/arm/mach-msm/clock.c       |    5 -----
 arch/arm/mach-msm/clock.h       |    1 +
 8 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index 0637bee..994104f 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -1071,4 +1071,5 @@ struct clk_ops soc_clk_ops_7x30 = {
 	.round_rate = local_clk_round_rate,
 	.reset = pc_clk_reset,
 	.set_flags = soc_clk_set_flags,
+	.is_local = local_clk_is_local,
 };
diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index 5bbc8bb..e1f3c6f 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -1799,4 +1799,5 @@ struct clk_ops soc_clk_ops_8x60 = {
 	.round_rate = local_clk_round_rate,
 	.reset = soc_clk_reset,
 	.set_flags = soc_clk_set_flags,
+	.is_local = local_clk_is_local,
 };
diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index b67b9e82..4886404 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -19,7 +19,6 @@
 #include <linux/debugfs.h>
 #include <linux/clk.h>
 #include "clock.h"
-#include "clock-pcom.h"
 
 static int clock_debug_rate_set(void *data, u64 val)
 {
@@ -79,7 +78,7 @@ static int clock_debug_local_get(void *data, u64 *val)
 {
 	struct clk *clock = data;
 
-	*val = clock->ops != &clk_ops_pcom;
+	*val = clock->ops->is_local(clock->id);
 
 	return 0;
 }
diff --git a/arch/arm/mach-msm/clock-local.c b/arch/arm/mach-msm/clock-local.c
index d6eb6c6..44e0778 100644
--- a/arch/arm/mach-msm/clock-local.c
+++ b/arch/arm/mach-msm/clock-local.c
@@ -677,3 +677,8 @@ long local_clk_round_rate(unsigned id, unsigned rate)
 
 	return -EPERM;
 }
+
+bool local_clk_is_local(unsigned id)
+{
+	return true;
+}
diff --git a/arch/arm/mach-msm/clock-local.h b/arch/arm/mach-msm/clock-local.h
index c168985..3083369 100644
--- a/arch/arm/mach-msm/clock-local.h
+++ b/arch/arm/mach-msm/clock-local.h
@@ -211,6 +211,7 @@ int local_clk_set_max_rate(unsigned id, unsigned rate);
 unsigned local_clk_get_rate(unsigned id);
 unsigned local_clk_is_enabled(unsigned id);
 long local_clk_round_rate(unsigned id, unsigned rate);
+bool local_clk_is_local(unsigned id);
 
 /*
  * Required SoC-specific functions, implemented for every supported SoC
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index 8c4e867..63b7113 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -117,6 +117,11 @@ long pc_clk_round_rate(unsigned id, unsigned rate)
 	return rate;
 }
 
+static bool pc_clk_is_local(unsigned id)
+{
+	return false;
+}
+
 struct clk_ops clk_ops_pcom = {
 	.enable = pc_clk_enable,
 	.disable = pc_clk_disable,
@@ -129,4 +134,5 @@ struct clk_ops clk_ops_pcom = {
 	.get_rate = pc_clk_get_rate,
 	.is_enabled = pc_clk_is_enabled,
 	.round_rate = pc_clk_round_rate,
+	.is_local = pc_clk_is_local,
 };
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 56c7549..06cd313 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -21,9 +21,6 @@
 #include <linux/pm_qos_params.h>
 
 #include "clock.h"
-#include "proc_comm.h"
-#include "clock-7x30.h"
-#include "clock-pcom.h"
 
 static DEFINE_MUTEX(clocks_mutex);
 static DEFINE_SPINLOCK(clocks_lock);
@@ -84,8 +81,6 @@ EXPORT_SYMBOL(clk_disable);
 
 int clk_reset(struct clk *clk, enum clk_reset_action action)
 {
-	if (!clk->ops->reset)
-		clk->ops->reset = &pc_clk_reset;
 	return clk->ops->reset(clk->remote_id, action);
 }
 EXPORT_SYMBOL(clk_reset);
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 44a6dd6..b74ba3e 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -43,6 +43,7 @@ struct clk_ops {
 	unsigned (*get_rate)(unsigned id);
 	unsigned (*is_enabled)(unsigned id);
 	long (*round_rate)(unsigned id, unsigned rate);
+	bool (*is_local)(unsigned id);
 };
 
 struct clk {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

