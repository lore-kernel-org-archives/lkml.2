Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1G3NGB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 09:06:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42611 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1G3NF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 09:05:57 -0400
Date: Sat, 30 Jul 2011 14:05:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: pratyush.anand@st.com, rajeev-dlh.kumar@st.com, armando.visconti@st.com,
        bhupesh.sharma@st.com, vinod.koul@intel.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
        amit.virdi@st.com, vipulkumar.samar@st.com, viresh.linux@gmail.com,
        deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/18] dmaengine/amba-pl08x: Enable/Disable amba_pclk
	with channel requests
Message-ID: <20110730130537.GB15791@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <96781d46e41fa6ffc04b88527a25d73f5a59eda8.1311936524.git.viresh.kumar@st.com> <20110730120740.GA15791@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110730120740.GA15791@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 01:07:40PM +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 29, 2011 at 04:19:17PM +0530, Viresh Kumar wrote:
> > Amba devices have interface clocks attached as adev->pclk. This is the only
> > clock associated with DMAC and it can be disabled when DMAC is not in use. This
> > patch adds support to enable/disable this clk as and when channels are requested
> > and freed. Also it disables this clock at the end of probe.
> 
> It may make better sense to convert this to runtime PM.  I suspect
> that there's core support which the amba/bus.c can do to help in that
> respect (eg, managing the apb pclk itself) so that we don't have to
> add the same code to every primecell driver.

Something like this for the bus driver (untested):

 drivers/amba/bus.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index d74926e..9e93f34 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -365,6 +365,40 @@ static int amba_pm_restore_noirq(struct device *dev)
 
 #endif /* !CONFIG_HIBERNATE_CALLBACKS */
 
+#ifdef CONFIG_PM_RUNTIME
+/*
+ * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
+ * enable/disable the bus clock at runtime PM suspend/resume as this
+ * does not result in loss of context.  However, disabling vcore power
+ * would do, so we leave that to the driver.
+ */
+static int amba_pm_runtime_suspend(struct device *dev)
+{
+	struct amba_device *pcdev = to_amba_device(dev);
+	int ret = pm_generic_runtime_suspend(dev);
+
+	if (ret == 0 && dev->driver)
+		clk_disable(pcdev->pclk);
+
+	return ret;
+}
+
+static int amba_pm_runtime_resume(struct device *dev)
+{
+	struct amba_device *pcdev = to_amba_device(dev);
+	int ret;
+
+	if (dev->driver) {
+		ret = clk_enable(pcdev->pclk);
+		/* Failure is probably fatal to the system, but... */
+		if (ret)
+			return ret;
+	}
+
+	return pm_generic_runtime_resume(dev);
+}
+#endif
+
 #ifdef CONFIG_PM
 
 static const struct dev_pm_ops amba_pm = {
@@ -383,8 +417,8 @@ static const struct dev_pm_ops amba_pm = {
 	.poweroff_noirq	= amba_pm_poweroff_noirq,
 	.restore_noirq	= amba_pm_restore_noirq,
 	SET_RUNTIME_PM_OPS(
-		pm_generic_runtime_suspend,
-		pm_generic_runtime_resume,
+		amba_pm_runtime_suspend,
+		amba_pm_runtime_resume,
 		pm_generic_runtime_idle
 	)
 };
