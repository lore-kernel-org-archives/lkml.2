Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0I1Qe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:34:27 -0400
Received: from mail.tpi.com ([70.99.223.143]:4525 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab0I1Qe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:34:26 -0400
Message-ID: <4CA2190D.4010205@canonical.com>
Date: Tue, 28 Sep 2010 10:34:21 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MCP limit log messages, 2.6.36-rc4
References: <4C9106C1.4080505@canonical.com>	<20100923134816.57e932fc@jbarnes-desktop>	<20100923145428.4805adcb@jbarnes-desktop>	<4C9BD8D5.7080201@canonical.com> <20100924091820.4f649786@jbarnes-desktop>
In-Reply-To: <20100924091820.4f649786@jbarnes-desktop>
Content-Type: multipart/mixed;
 boundary="------------040007050102040803000702"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040007050102040803000702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/24/2010 10:18 AM, Jesse Barnes wrote:
> On Fri, 24 Sep 2010 06:46:45 +0800
> Tim Gardner<tim.gardner@canonical.com>  wrote:
>> Its just a debug hack which I wrote (that I mentioned in the first
>> email) so I could figure out why the driver was complaining.
>
> Oh sorry, missed that.  An upstream patch for that would be welcome as
> well.
>
>> I'll be back from Asia by Monday and will give these patches a try.
>
> Great, as I said you may still see spurious "over power" conditions,
> but that's due to a bug in the i915 driver.
>

With these 3 patches applied the MCP log message noise goes away. The 
4th patch (also applied) is the debug patch mentioned in my first email 
(if you're still interested in it). This is on top of Linus tree at 
830c55a673537ca33ef4689fb5f20c2d66d98519 (plus some Ubuntu cruft).

The only 'intel ips' messages left in the log are these:

intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value 
(found 25, expected 35)
intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 95

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------040007050102040803000702
Content-Type: text/x-patch;
 name="0001-drm-i915-fix-GMCH-power-reporting.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-drm-i915-fix-GMCH-power-reporting.patch"

>From 64a794b2a2249ce87bc700ff041f1bcfa72d3a11 Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 27 Sep 2010 10:35:44 -0700
Subject: [PATCH 1/4] drm/i915: fix GMCH power reporting

The IPS driver needs to know the current power consumption of the GMCH
in order to make decisions about when to increase or decrease the CPU
and/or GPU power envelope.  So fix up the divisions to save the results
so the numbers are actually correct (contrary to some earlier comments
and code, these functions do not modify the first argument and use it
for the result).

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/i915_dma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 9d67b48..c74e4e8 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1787,9 +1787,9 @@ unsigned long i915_chipset_val(struct drm_i915_private *dev_priv)
 		}
 	}
 
-	div_u64(diff, diff1);
+	diff = div_u64(diff, diff1);
 	ret = ((m * diff) + c);
-	div_u64(ret, 10);
+	ret = div_u64(ret, 10);
 
 	dev_priv->last_count1 = total_count;
 	dev_priv->last_time1 = now;
@@ -1858,7 +1858,7 @@ void i915_update_gfx_val(struct drm_i915_private *dev_priv)
 
 	/* More magic constants... */
 	diff = diff * 1181;
-	div_u64(diff, diffms * 10);
+	diff = div_u64(diff, diffms * 10);
 	dev_priv->gfx_power = diff;
 }
 
-- 
1.7.0.4


--------------040007050102040803000702
Content-Type: text/x-patch;
 name="0002-IPS-driver-don-t-toggle-CPU-turbo-on-unsupported-CPU.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-IPS-driver-don-t-toggle-CPU-turbo-on-unsupported-CPU.pa";
 filename*1="tch"

>From 9e473da5e1cad8891bcf718060552767d8173090 Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Thu, 23 Sep 2010 23:03:03 +0200
Subject: [PATCH 2/4] IPS driver: don't toggle CPU turbo on unsupported CPUs

If the CPU doesn't support turbo, don't try to enable/disable it.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/platform/x86/intel_ips.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 9024480..06136f5 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -51,7 +51,6 @@
  * TODO:
  *   - handle CPU hotplug
  *   - provide turbo enable/disable api
- *   - make sure we can write turbo enable/disable reg based on MISC_EN
  *
  * Related documents:
  *   - CDI 403777, 403778 - Auburndale EDS vol 1 & 2
@@ -325,6 +324,7 @@ struct ips_driver {
 	bool gpu_preferred;
 	bool poll_turbo_status;
 	bool second_cpu;
+	bool turbo_toggle_allowed;
 	struct ips_mcp_limits *limits;
 
 	/* Optional MCH interfaces for if i915 is in use */
@@ -461,7 +461,8 @@ static void ips_enable_cpu_turbo(struct ips_driver *ips)
 	if (ips->__cpu_turbo_on)
 		return;
 
-	on_each_cpu(do_enable_cpu_turbo, ips, 1);
+	if (ips->turbo_toggle_allowed)
+		on_each_cpu(do_enable_cpu_turbo, ips, 1);
 
 	ips->__cpu_turbo_on = true;
 }
@@ -498,7 +499,8 @@ static void ips_disable_cpu_turbo(struct ips_driver *ips)
 	if (!ips->__cpu_turbo_on)
 		return;
 
-	on_each_cpu(do_disable_cpu_turbo, ips, 1);
+	if (ips->turbo_toggle_allowed)
+		on_each_cpu(do_disable_cpu_turbo, ips, 1);
 
 	ips->__cpu_turbo_on = false;
 }
@@ -1333,8 +1335,10 @@ static struct ips_mcp_limits *ips_detect_cpu(struct ips_driver *ips)
 	 * turbo manually or we'll get an illegal MSR access, even though
 	 * turbo will still be available.
 	 */
-	if (!(misc_en & IA32_MISC_TURBO_EN))
-		; /* add turbo MSR write allowed flag if necessary */
+	if (misc_en & IA32_MISC_TURBO_EN)
+		ips->turbo_toggle_allowed = true;
+	else
+		ips->turbo_toggle_allowed = false;
 
 	if (strstr(boot_cpu_data.x86_model_id, "CPU       M"))
 		limits = &ips_sv_limits;
-- 
1.7.0.4


--------------040007050102040803000702
Content-Type: text/x-patch;
 name="0003-IPS-driver-verify-BIOS-provided-limits.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-IPS-driver-verify-BIOS-provided-limits.patch"

>From edf5aff209bcf4a6d8ddaca2ebe6252b783c78d0 Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Thu, 23 Sep 2010 23:29:06 +0200
Subject: [PATCH 3/4] IPS driver: verify BIOS provided limits

They're optional.  If not present or sane, we should use the CPU
defaults.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/platform/x86/intel_ips.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 06136f5..308c7f5 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -665,6 +665,27 @@ static bool mch_exceeded(struct ips_driver *ips)
 }
 
 /**
+ * verify_limits - verify BIOS provided limits
+ * @ips: IPS structure
+ *
+ * BIOS can optionally provide non-default limits for power and temp.  Check
+ * them here and use the defaults if the BIOS values are not provided or
+ * are otherwise unusable.
+ */
+static void verify_limits(struct ips_driver *ips)
+{
+	if (ips->mcp_power_limit < ips->limits->mcp_power_limit ||
+	    ips->mcp_power_limit > 35000)
+		ips->mcp_power_limit = ips->limits->mcp_power_limit;
+
+	if (ips->mcp_temp_limit < ips->limits->core_temp_limit ||
+	    ips->mcp_temp_limit < ips->limits->mch_temp_limit ||
+	    ips->mcp_temp_limit > 150)
+		ips->mcp_temp_limit = min(ips->limits->core_temp_limit,
+					  ips->limits->mch_temp_limit);
+}
+
+/**
  * update_turbo_limits - get various limits & settings from regs
  * @ips: IPS driver struct
  *
@@ -688,6 +709,7 @@ static void update_turbo_limits(struct ips_driver *ips)
 	ips->mcp_temp_limit = thm_readw(THM_PTL);
 	ips->mcp_power_limit = thm_readw(THM_MPPC);
 
+	verify_limits(ips);
 	/* Ignore BIOS CPU vs GPU pref */
 }
 
@@ -1157,6 +1179,7 @@ static irqreturn_t ips_irq_handler(int irq, void *arg)
 				STS_PTL_SHIFT;
 			ips->mcp_power_limit = (tc1 & STS_PPL_MASK) >>
 				STS_PPL_SHIFT;
+			verify_limits(ips);
 			spin_unlock(&ips->turbo_status_lock);
 
 			thm_writeb(THM_SEC, SEC_ACK);
-- 
1.7.0.4


--------------040007050102040803000702
Content-Type: text/x-patch;
 name="0004-intel_ips-Print-overage-values.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0004-intel_ips-Print-overage-values.patch"

>From 2e5b2a568595db18f189a8dec1ba6e92c913e2e4 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 15 Sep 2010 09:35:35 -0600
Subject: [PATCH 4/4] intel_ips: Print overage values

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/platform/x86/intel_ips.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 308c7f5..10930b7 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -600,17 +600,31 @@ static bool mcp_exceeded(struct ips_driver *ips)
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


--------------040007050102040803000702--
