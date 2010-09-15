Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0IORr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:47:59 -0400
Received: from mail.tpi.com ([70.99.223.143]:3245 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab0IORr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:47:58 -0400
Message-ID: <4C9106C1.4080505@canonical.com>
Date: Wed, 15 Sep 2010 11:47:45 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100826 Thunderbird/3.0.7
MIME-Version: 1.0
To: jbarnes@virtuousgeek.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: MCP limit log messages, 2.6.36-rc4
Content-Type: multipart/mixed;
 boundary="------------060604070902080400060307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060604070902080400060307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've been getting regular MCP limit log messages on a Dell Studio 1458 
(i5 CPU) with an A02 BIOS. With the attached debug hack it prints the 
following values:

[   33.605098] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
30123, limit 1023
[   38.597998] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
21697, limit 1023
[   43.590917] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
15390, limit 1023
[   48.583821] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
43370, limit 1023
[   53.576740] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
64728, limit 1023

This is an idle machine which starts printing these messages about 30 
seconds after boot. Any thoughts?

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------060604070902080400060307
Content-Type: text/x-patch;
 name="0001-intel_ips-Print-overage-values.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-intel_ips-Print-overage-values.patch"

>From 89d9d47cc85a7a692f7f5e56549438086c36cc98 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 15 Sep 2010 09:35:35 -0600
Subject: [PATCH] intel_ips: Print overage values

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/platform/x86/intel_ips.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 9024480..4b8e6e2 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -598,17 +598,31 @@ static bool mcp_exceeded(struct ips_driver *ips)
 {
 	unsigned long flags;
 	bool ret = false;
+	u32 temp_limit;
+	u32 avg_power;
+	const char *msg = "MCP limit exceeded: ";
 
 	spin_lock_irqsave(&ips->turbo_status_lock, flags);
-	if (ips->mcp_avg_temp > (ips->mcp_temp_limit * 100))
-		ret = true;
-	if (ips->cpu_avg_power + ips->mch_avg_power > ips->mcp_power_limit)
+
+	temp_limit = ips->mcp_temp_limit;
+	temp_limit *= 100;
+	if (ips->mcp_avg_temp > temp_limit) {
+		dev_info(&ips->dev->dev,
+			"%sAvg temp %u, limit %u\n", msg, ips->mcp_avg_temp,
+			temp_limit);
 		ret = true;
-	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
+	}
 
-	if (ret)
+	avg_power = ips->cpu_avg_power;
+	avg_power += ips->mch_avg_power;
+	if (avg_power > ips->mcp_power_limit) {
 		dev_info(&ips->dev->dev,
-			 "MCP power or thermal limit exceeded\n");
+			"%sAvg power %u, limit %u\n", msg, avg_power,
+			ips->mcp_power_limit);
+		ret = true;
+	}
+
+	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
 	return ret;
 }
-- 
1.7.0.4


--------------060604070902080400060307--
