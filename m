Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab0H1CVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 22:21:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1458 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab0H1CVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 22:21:46 -0400
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
From: Joe Perches <joe@perches.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4C784650.2030200@cesarb.net>
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>
	 <4C770299.6000708@cesarb.net> <1282869660.1836.5.camel@Joe-Laptop>
	 <4C77171E.6060008@cesarb.net> <1282894751.1836.41.camel@Joe-Laptop>
	 <4C784650.2030200@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 19:21:44 -0700
Message-ID: <1282962104.1946.179.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 20:12 -0300, Cesar Eduardo Barros wrote:
> Em 27-08-2010 04:39, Joe Perches escreveu:
> > On Thu, 2010-08-26 at 22:38 -0300, Cesar Eduardo Barros wrote:
> >> - The first "MCP power limit exceeded" seems very bogus.
> >> - What do you mean, core_power_limit is zero?
> > I added a logging message whenever the turbo limits change
> > and logging messages for power/temp on MCH for completeness.
> > Maybe this will show something useful like when/how
> > CPU power limit gets set to 0.

> Running with it right now, did not help much:
> 
> $ dmesg | fgrep 'intel ips'
> intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value 
> (found 25, expected 35)
> intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
> intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:8058 + 
> mch:23392829
> intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5675
> intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6369

I believe all these limits should always have non-zero values.
So I still think you've hardware problems, but I suppose it
could be the driver not reading the right registers or some
such.  It seems odd that the driver never printed a logging
message for either of the polling or irq methods to read the
device cpu and thermal limits.

Jesse or any Intel folk, can you verify or suggest anything
better?

If cpu_power_limit, or any _limit, is not set perhaps changing
the test style to verify limit and adding a printed_once alert
for each 0 value limit.  At least that'd shut up the continuous
logging but at least give a notification message.

if (limit) {
	if (measured_val > limit)
		dev_info(foo)
} else
	dev_alert_once()

Maybe something like this:

 drivers/platform/x86/intel_ips.c |  160 +++++++++++++++++++++++++++++++++-----
 1 files changed, 140 insertions(+), 20 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 9024480..10eba04 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -598,17 +598,53 @@ static bool mcp_exceeded(struct ips_driver *ips)
 {
 	unsigned long flags;
 	bool ret = false;
+	static bool printed_zero_mcp_power_limit;
+	static bool printed_zero_mcp_temp_limit;
+	u16 mcp_avg_temp;
+	u16 mcp_temp_limit;
+	u16 mcp_power_limit;
+	u32 cpu_avg_power;
+	u32 mch_avg_power;
 
 	spin_lock_irqsave(&ips->turbo_status_lock, flags);
-	if (ips->mcp_avg_temp > (ips->mcp_temp_limit * 100))
-		ret = true;
-	if (ips->cpu_avg_power + ips->mch_avg_power > ips->mcp_power_limit)
-		ret = true;
+
+	mcp_avg_temp = ips->mcp_avg_temp;
+	mcp_temp_limit = ips->mcp_temp_limit;
+	mcp_power_limit = ips->mcp_power_limit;
+	cpu_avg_power = ips->cpu_avg_power;
+	mch_avg_power = ips->mch_avg_power;
+
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
-	if (ret)
-		dev_info(&ips->dev->dev,
-			 "MCP power or thermal limit exceeded\n");
+	if (mcp_power_limit) {
+		if ((cpu_avg_power + mch_avg_power) > mcp_power_limit) {
+			dev_info(&ips->dev->dev,
+				 "MCP power limit %u exceeded: cpu:%u+mch:%u\n",
+				 mcp_power_limit,
+				 cpu_avg_power, mch_avg_power);
+			ret = true;
+		}
+	} else {
+		if (!printed_zero_mcp_power_limit) {
+			printed_zero_mcp_power_limit = true;
+			dev_alert(&ips->dev->dev, "MCP power limit is 0!\n");
+		}
+	}
+
+	if (mcp_temp_limit) {
+		if (mcp_avg_temp > (mcp_temp_limit * 100)) {
+			dev_info(&ips->dev->dev,
+				 "MCP thermal limit %d exceeded: %d\n",
+				 mcp_temp_limit * 100,
+				 mcp_avg_temp);
+			ret = true;
+		}
+	} else {
+		if (!printed_zero_mcp_temp_limit) {
+			printed_zero_mcp_temp_limit = true;
+			dev_alert(&ips->dev->dev, "MCP thermal limit is 0!\n");
+		}
+	}
 
 	return ret;
 }
@@ -623,20 +659,50 @@ static bool mcp_exceeded(struct ips_driver *ips)
 static bool cpu_exceeded(struct ips_driver *ips, int cpu)
 {
 	unsigned long flags;
-	int avg;
 	bool ret = false;
+	static bool printed_zero_core_power_limit;
+	static bool printed_zero_core_temp_limit;
+	int avg;
+	int core_temp_limit;
+	u16 core_power_limit;
+	u32 cpu_avg_power;
 
 	spin_lock_irqsave(&ips->turbo_status_lock, flags);
+
 	avg = cpu ? ips->ctv2_avg_temp : ips->ctv1_avg_temp;
-	if (avg > (ips->limits->core_temp_limit * 100))
-		ret = true;
-	if (ips->cpu_avg_power > ips->core_power_limit * 100)
-		ret = true;
+	core_temp_limit = ips->limits->core_temp_limit;
+	core_power_limit = ips->core_power_limit;
+	cpu_avg_power = ips->cpu_avg_power;
+
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
-	if (ret)
-		dev_info(&ips->dev->dev,
-			 "CPU power or thermal limit exceeded\n");
+	if (core_power_limit) {
+		if (cpu_avg_power > (core_power_limit * 100)) {
+			dev_info(&ips->dev->dev,
+				 "CPU power limit %d exceeded: %d\n",
+				 core_power_limit * 100, cpu_avg_power);
+			ret = true;
+		}
+	} else {
+		if (!printed_zero_core_power_limit) {
+			printed_zero_core_power_limit = true;
+			dev_alert(&ips->dev->dev, "CPU power limit is 0!\n");
+		}
+	}
+
+	if (core_temp_limit) {
+		if (avg > (core_temp_limit * 100)) {
+			dev_info(&ips->dev->dev,
+				 "CPU thermal limit %d exceeded: %d\n",
+				 core_temp_limit * 100, avg);
+			ret = true;
+		}
+	} else {
+		if (!printed_zero_core_temp_limit) {
+			printed_zero_core_temp_limit = true;
+			dev_alert(&ips->dev->dev, "CPU thermal limit is 0!\n");
+		}
+	}
 
 	return ret;
 }
@@ -651,14 +717,50 @@ static bool mch_exceeded(struct ips_driver *ips)
 {
 	unsigned long flags;
 	bool ret = false;
+	static bool printed_zero_mch_power_limit;
+	static bool printed_zero_mch_temp_limit;
+	u16 mch_avg_temp;
+	int mch_temp_limit;
+	u32 mch_avg_power;
+	u16 mch_power_limit;
 
 	spin_lock_irqsave(&ips->turbo_status_lock, flags);
-	if (ips->mch_avg_temp > (ips->limits->mch_temp_limit * 100))
-		ret = true;
-	if (ips->mch_avg_power > ips->mch_power_limit)
-		ret = true;
+
+	mch_avg_temp = ips->mch_avg_temp;
+	mch_temp_limit = ips->limits->mch_temp_limit;
+	mch_avg_power = ips->mch_avg_power;
+	mch_power_limit = ips->mch_power_limit;
+
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
+	if (mch_power_limit) {
+		if (mch_avg_power > mch_power_limit) {
+			dev_info(&ips->dev->dev,
+				 "MCH power limit %d exceeded: %d\n",
+				 mch_power_limit, mch_avg_power);
+			ret = true;
+		}
+	} else {
+		if (!printed_zero_mch_power_limit) {
+			printed_zero_mch_power_limit = true;
+			dev_alert(&ips->dev->dev, "MCH power limit is 0!\n");
+		}
+	}
+
+	if (mch_temp_limit) {
+		if (mch_avg_temp > (mch_temp_limit * 100)) {
+			dev_info(&ips->dev->dev,
+				 "MCH thermal limit %d exceeded: %d\n",
+				 mch_temp_limit * 100, mch_avg_temp);
+			ret = true;
+		}
+	} else {
+		if (!printed_zero_mch_temp_limit) {
+			printed_zero_mch_temp_limit = true;
+			dev_alert(&ips->dev->dev, "MCH thermal limit is 0!\n");
+		}
+	}
+
 	return ret;
 }
 
@@ -689,6 +791,16 @@ static void update_turbo_limits(struct ips_driver *ips)
 	/* Ignore BIOS CPU vs GPU pref */
 }
 
+static void show_turbo_limits(const struct ips_driver *ips, const char *caller)
+{
+	dev_info(&ips->dev->dev,
+		 "%s:%s cte:%u gte:%u cpt:%u mpl:%u mtl:%u mpl:%u\n",
+		 __func__, caller,
+		 ips->cpu_turbo_enabled, ips->gpu_turbo_enabled,
+		 ips->core_power_limit, ips->mch_power_limit,
+		 ips->mcp_temp_limit, ips->mcp_power_limit);
+}
+
 /**
  * ips_adjust - adjust power clamp based on thermal state
  * @data: ips driver structure
@@ -734,12 +846,18 @@ static int ips_adjust(void *data)
 	do {
 		bool cpu_busy = ips_cpu_busy(ips);
 		bool gpu_busy = ips_gpu_busy(ips);
+		bool updated = false;
 
 		spin_lock_irqsave(&ips->turbo_status_lock, flags);
-		if (ips->poll_turbo_status)
+		if (ips->poll_turbo_status) {
 			update_turbo_limits(ips);
+			updated = true;
+		}
 		spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
+		if (updated)
+			show_turbo_limits(ips, __func__);
+
 		/* Update turbo status if necessary */
 		if (ips->cpu_turbo_enabled)
 			ips_enable_cpu_turbo(ips);
@@ -1158,6 +1276,8 @@ static irqreturn_t ips_irq_handler(int irq, void *arg)
 			spin_unlock(&ips->turbo_status_lock);
 
 			thm_writeb(THM_SEC, SEC_ACK);
+
+			show_turbo_limits(ips, __func__);
 		}
 		thm_writeb(THM_TES, tes);
 	}


