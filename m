Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2B0EMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:12:12 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:36809 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644Ab2B0EMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:12:09 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>, <rui.zhang@intel.com>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <salvatore.dedominicis@st.com>, <linux-kernel@vger.kernel.org>,
        <len.brown@intel.com>
Subject: [PATCH 1/2] thermal/spear_thermal: Replace readl/writel with lighter _relaxed variants
Date: Mon, 27 Feb 2012 09:41:39 +0530
Message-ID: <963d5aaac84ad075c4cfbd2babc5d264e2157502.1330315545.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readl/writel versions for ARM contain memory barrier instruction for
synchronizing DMA buffers. These are not required atleast on this module. So use
lighter _relaxed variants.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
Hi Andrew,

These patches are rebased over all three patches you have applied on your tree.

 drivers/thermal/spear_thermal.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index 880bf28..be94413 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -46,7 +46,7 @@ static inline int thermal_get_temp(struct thermal_zone_device *thermal,
 	 * Data are ready to be read after 628 usec from POWERDOWN signal
 	 * (PDN) = 1
 	 */
-	*temp = (readl(stdev->thermal_base) & 0x7F) * MD_FACTOR;
+	*temp = (readl_relaxed(stdev->thermal_base) & 0x7F) * MD_FACTOR;
 	return 0;
 }
 
@@ -63,8 +63,8 @@ static int spear_thermal_suspend(struct device *dev)
 	unsigned int actual_mask = 0;
 
 	/* Disable SPEAr Thermal Sensor */
-	actual_mask = readl(stdev->thermal_base);
-	writel(actual_mask & ~stdev->flags, stdev->thermal_base);
+	actual_mask = readl_relaxed(stdev->thermal_base);
+	writel_relaxed(actual_mask & ~stdev->flags, stdev->thermal_base);
 
 	clk_disable(stdev->clk);
 	dev_info(dev, "Suspended.\n");
@@ -87,8 +87,8 @@ static int spear_thermal_resume(struct device *dev)
 	}
 
 	/* Enable SPEAr Thermal Sensor */
-	actual_mask = readl(stdev->thermal_base);
-	writel(actual_mask | stdev->flags, stdev->thermal_base);
+	actual_mask = readl_relaxed(stdev->thermal_base);
+	writel_relaxed(actual_mask | stdev->flags, stdev->thermal_base);
 
 	dev_info(dev, "Resumed.\n");
 
@@ -145,7 +145,7 @@ static int spear_thermal_probe(struct platform_device *pdev)
 	}
 
 	stdev->flags = pdata->thermal_flags;
-	writel(stdev->flags, stdev->thermal_base);
+	writel_relaxed(stdev->flags, stdev->thermal_base);
 
 	spear_thermal = thermal_zone_device_register("spear_thermal", 0,
 				stdev, &ops, 0, 0, 0, 0);
@@ -180,8 +180,8 @@ static int spear_thermal_exit(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 
 	/* Disable SPEAr Thermal Sensor */
-	actual_mask = readl(stdev->thermal_base);
-	writel(actual_mask & ~stdev->flags, stdev->thermal_base);
+	actual_mask = readl_relaxed(stdev->thermal_base);
+	writel_relaxed(actual_mask & ~stdev->flags, stdev->thermal_base);
 
 	clk_disable(stdev->clk);
 	clk_put(stdev->clk);
-- 
1.7.8.110.g4cb5d

