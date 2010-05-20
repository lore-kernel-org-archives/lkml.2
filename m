Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0ETV3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:29:00 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:42057 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754546Ab0ETV26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:28:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BNo6CwJpJBNea/t1gEAPr30F2d0vcmCi+9PVl8IEMXCly+uPyTH7RHHcJn9ZUx8G3y7vx/qTuJjQYiNdxD38P0UafzNZoAGoqXDfrYe/+i7HNGGLSEkaoM10aiJPnyhR;
Date: Thu, 20 May 2010 14:27:23 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>, eric@anholt.net
Subject: [PATCH 1/2] IPS driver: add GPU busy and turbo checking
Message-ID: <20100520142723.01c217d0@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Be sure to enable GPU turbo by default at load time and check GPU busy
and MCP exceeded status correctly.  Also fix up CPU power comparison and
work around buggy MCH temp reporting.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/platform/x86/intel_ips.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index c675bf2..62b1e41 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -515,7 +515,10 @@ static void ips_disable_cpu_turbo(struct ips_driver *ips)
  */
 static bool ips_gpu_busy(struct ips_driver *ips)
 {
-	return false;
+	if (!ips->gpu_turbo_enabled)
+		return false;
+
+	return ips->gpu_busy();
 }
 
 /**
@@ -627,7 +630,7 @@ static bool cpu_exceeded(struct ips_driver *ips, int cpu)
 	avg = cpu ? ips->ctv2_avg_temp : ips->ctv1_avg_temp;
 	if (avg > (ips->limits->core_temp_limit * 100))
 		ret = true;
-	if (ips->cpu_avg_power > ips->core_power_limit)
+	if (ips->cpu_avg_power > ips->core_power_limit * 100)
 		ret = true;
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
@@ -652,6 +655,8 @@ static bool mch_exceeded(struct ips_driver *ips)
 	spin_lock_irqsave(&ips->turbo_status_lock, flags);
 	if (ips->mch_avg_temp > (ips->limits->mch_temp_limit * 100))
 		ret = true;
+	if (ips->mch_avg_power > ips->mch_power_limit)
+		ret = true;
 	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
 
 	return ret;
@@ -747,7 +752,7 @@ static int ips_adjust(void *data)
 			ips_disable_gpu_turbo(ips);
 
 		/* We're outside our comfort zone, crank them down */
-		if (!mcp_exceeded(ips)) {
+		if (mcp_exceeded(ips)) {
 			ips_cpu_lower(ips);
 			ips_gpu_lower(ips);
 			goto sleep;
@@ -808,8 +813,7 @@ static u16 read_mgtv(struct ips_driver *ips)
 
 	ret = ((val * slope + 0x40) >> 7) + offset;
 
-
-	return ret;
+	return 0; /* MCH temp reporting buggy */
 }
 
 static u16 read_ptv(struct ips_driver *ips)
@@ -1471,14 +1475,6 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (trc & TRC_CORE2_EN)
 		ips->second_cpu = true;
 
-	if (!ips_get_i915_syms(ips)) {
-		dev_err(&dev->dev, "failed to get i915 symbols, graphics turbo disabled\n");
-		ips->gpu_turbo_enabled = false;
-	} else {
-		dev_dbg(&dev->dev, "graphics turbo enabled\n");
-		ips->gpu_turbo_enabled = true;
-	}
-
 	update_turbo_limits(ips);
 	dev_dbg(&dev->dev, "max cpu power clamp: %dW\n",
 		ips->mcp_power_limit / 10);
@@ -1488,6 +1484,14 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (thm_readl(THM_PSC) & PSP_PBRT)
 		ips->poll_turbo_status = true;
 
+	if (!ips_get_i915_syms(ips)) {
+		dev_err(&dev->dev, "failed to get i915 symbols, graphics turbo disabled\n");
+		ips->gpu_turbo_enabled = false;
+	} else {
+		dev_dbg(&dev->dev, "graphics turbo enabled\n");
+		ips->gpu_turbo_enabled = true;
+	}
+
 	/*
 	 * Check PLATFORM_INFO MSR to make sure this chip is
 	 * turbo capable.
-- 
1.7.0.1

