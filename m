Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab0H0HjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:39:17 -0400
Received: from mail.perches.com ([173.55.12.10]:1451 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab0H0HjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:39:13 -0400
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
From: Joe Perches <joe@perches.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4C77171E.6060008@cesarb.net>
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>
	 <4C770299.6000708@cesarb.net> <1282869660.1836.5.camel@Joe-Laptop>
	 <4C77171E.6060008@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 00:39:11 -0700
Message-ID: <1282894751.1836.41.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 22:38 -0300, Cesar Eduardo Barros wrote:
> intel ips 0000:00:1f.6: CPU power limit 3863 exceeded: 0
> 
> I think you put the parameters in the wrong order on the dev_info() call 
> for the CPU power limit; it is the limit that is 0.

Yes. Fixed.

> Two bogus things I can see:
> 
> - The first "MCP power limit exceeded" seems very bogus.
> - What do you mean, core_power_limit is zero?

I added a logging message whenever the turbo limits change
and logging messages for power/temp on MCH for completeness.

Maybe this will show something useful like when/how
CPU power limit gets set to 0.

 drivers/platform/x86/intel_ips.c |  105 +++++++++++++++++++++++++++++++-------
 1 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 9024480..9c65e66 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -598,17 +598,36 @@ static bool mcp_exceeded(struct ips_driver *ips)
 {
 	unsigned long flags;
 	bool ret = false;
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
+	if ((cpu_avg_power + mch_avg_power) > mcp_power_limit) {
+		dev_info(&ips->dev->dev,
+			 "MCP power limit %u exceeded: cpu:%u + mch:%u\n",
+			 mcp_power_limit,
+			 cpu_avg_power, mch_avg_power);
+		ret = true;
+	}
+	if (mcp_avg_temp > (mcp_temp_limit * 100)) {
 		dev_info(&ips->dev->dev,
-			 "MCP power or thermal limit exceeded\n");
+			 "MCP thermal limit %d exceeded: %d\n",
+			 mcp_temp_limit * 100,
+			 mcp_avg_temp);
+		ret = true;
+	}
 
 	return ret;
 }
@@ -623,20 +642,33 @@ static bool mcp_exceeded(struct ips_driver *ips)
 static bool cpu_exceeded(struct ips_driver *ips, int cpu)
 {
 	unsigned long flags;
-	int avg;
 	bool ret = false;
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
+	if (cpu_avg_power > (core_power_limit * 100)) {
+		dev_info(&ips->dev->dev,
+			 "CPU power limit %d exceeded: %d\n",
+			 core_power_limit * 100, cpu_avg_power);
+		ret = true;
+	}
+	if (avg > (core_temp_limit * 100)) {
 		dev_info(&ips->dev->dev,
-			 "CPU power or thermal limit exceeded\n");
+			 "CPU thermal limit %d exceeded: %d\n",
+			 core_temp_limit * 100, avg);
+		ret = true;
+	}
 
 	return ret;
 }
@@ -652,13 +684,32 @@ static bool mch_exceeded(struct ips_driver *ips)
 	unsigned long flags;
 	bool ret = false;
 
+	u16 mch_avg_temp;
+	int mch_temp_limit;
+	u32 mch_avg_power;
+	u16 mch_power_limit;
+
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
 
+	if (mch_avg_power > mch_power_limit) {
+		dev_info(&ips->dev->dev,
+			 "MCH power limit %d exceeded: %d\n",
+			 mch_power_limit, mch_avg_power);
+		ret = true;
+	}
+	if (mch_avg_temp > (mch_temp_limit * 100)) {
+		dev_info(&ips->dev->dev,
+			 "MCH thermal limit %d exceeded: %d\n",
+			 mch_temp_limit * 100, mch_avg_temp);
+		ret = true;
+	}
 	return ret;
 }
 
@@ -689,6 +740,16 @@ static void update_turbo_limits(struct ips_driver *ips)
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
@@ -734,12 +795,18 @@ static int ips_adjust(void *data)
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
@@ -1158,6 +1225,8 @@ static irqreturn_t ips_irq_handler(int irq, void *arg)
 			spin_unlock(&ips->turbo_status_lock);
 
 			thm_writeb(THM_SEC, SEC_ACK);
+
+			show_turbo_limits(ips, __func__);
 		}
 		thm_writeb(THM_TES, tes);
 	}


