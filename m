Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0H0AlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:41:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1448 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab0H0AlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:41:01 -0400
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
From: Joe Perches <joe@perches.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4C770299.6000708@cesarb.net>
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>
	 <4C770299.6000708@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 17:41:00 -0700
Message-ID: <1282869660.1836.5.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 21:11 -0300, Cesar Eduardo Barros wrote:
> Em 26-08-2010 20:33, Joe Perches escreveu:
> > On Thu, 26 Aug 2010, Cesar Eduardo Barros wrote:
> >> On my Dell Inspiron N4010, one of these messages is printed every five
> >> seconds. Change both to dev_dbg to quieten them even more.
> > I think you should instead fix your hardware or maybe change
> > your thermal throttling settings.

I was probably a bit hasty in writing that.

> Is there a way to know if all this is just an oddness of this model, or 
> if there is something which is not working quite right?
> 
> (All the output above is from 2.6.35.3; I am not running 2.3.36-rc2+ 
> right now because it hangs on resume, and I have not yet had the time to 
> look at it.)

Perhaps you might try this patch and get a bit more information.

It seems a sensible patch and perhaps should be applied anyway.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/intel_ips.c |   58 +++++++++++++++++++++++++++++--------
 1 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 9024480..73f9ad1 100644
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
 		dev_info(&ips->dev->dev,
-			 "MCP power or thermal limit exceeded\n");
+			 "MCP power limit %d exceeded: %d\n",
+			 mcp_power_limit,
+			 cpu_avg_power + mch_avg_power);
+		ret = true;
+	}
+	if (mcp_avg_temp > (mcp_temp_limit * 100)) {
+		dev_info(&ips->dev->dev,
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
+			 cpu_avg_power, core_power_limit * 100);
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


