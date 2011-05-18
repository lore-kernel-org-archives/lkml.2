Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1ERLc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:32:59 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:55422 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932873Ab1ERLc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:32:56 -0400
Message-ID: <4DD3AE5D.8040501@ti.com>
Date: Wed, 18 May 2011 17:02:45 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-arm-kernel@lists-infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: smp_twd: Reconfigure clockevents after cpufreq change
References: <1305588114-23728-1-git-send-email-ccross@android.com>	<4DD27F7D.2070305@ti.com> <BANLkTinUxn_szHVHSKOZ1WJAckmo9mSudA@mail.gmail.com>
In-Reply-To: <BANLkTinUxn_szHVHSKOZ1WJAckmo9mSudA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060809020102030908080805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060809020102030908080805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/2011 10:36 PM, Colin Cross wrote:
> On Tue, May 17, 2011 at 7:00 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com>  wrote:
>> Colin,
>>
>> On 5/17/2011 4:51 AM, Colin Cross wrote:
>>>
>>> The localtimer's clock changes with the cpu clock.  After a
>>> cpufreq transition, update the clockevent's frequency and
>>> reprogram the next clock event.
>>>
>>> Adds a clock called "smp_twd" that is used to determine the
>>> twd frequency, which can also be used at init time to
>>> avoid calibrating the twd frequency.
>>>
>>> Signed-off-by: Colin Cross<ccross@android.com>
>>> Cc: Thomas Gleixner<tglx@linutronix.de>
>>> Cc: Russell King<linux@arm.linux.org.uk>
>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>> Cc: Rob Herring<robherring2@gmail.com>
>>> ---
>>>   arch/arm/kernel/smp_twd.c |   69
>>> +++++++++++++++++++++++++++++++++++++++++++--
>>>   1 files changed, 66 insertions(+), 3 deletions(-)
>>>
>>> This patch depends on Thomas Gleixner's patch to add
>>> clockevents_reconfigure
>>> See: https://lkml.org/lkml/2011/5/13/122
>>>
>>> This patch adds a clock that can be used to skip calibration as well
>>> as update the frequency.  A later patch (or a later version of this patch)
>>> will drop twd_calibrate_rate once all platforms provide the necessary
>>> smp_twd clock.
>>>
>>
>> Since the "smp_twd" clock node will not have a clk_set_rate()
>> associated with it, will the clk_get_rate() gives you real
>> rate. May be we can associate this node as a child of
>> CPU clock node and use the fixed divider based on peripheral
>> ratio. Is that the idea here to realize it ?
>
> Yes, the idea is that it will be a fixed divider off the cpu clock,
> which will have been updated by cpufreq.
Ok.
Below patch for OMAP twd clock node. Also
attached in case mailer eats tabs.

Regards
Santosh

 From 8a3e307c1a610a24f78d575c0ac04a7bbe1d39b8 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Wed, 18 May 2011 16:27:41 +0530
Subject: [PATCH] OMAP4: clock: Add CPU local timer clock node.

Local timer clock is sourced from the CPU clock and hence changes
along with CPU clock. These per CPU local timers are used as
clock-events, so they need to be reconfigured on CPU frequency
as part of CPUfreq governor.

Newly introduced clockevents_reconfigure() needs to know the
TWD clock-rate. Provide a clock-node to make clk_get_rate() work
for TWD.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
  arch/arm/mach-omap2/clock44xx_data.c |    9 +++++++++
  1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock44xx_data.c 
b/arch/arm/mach-omap2/clock44xx_data.c
index 8c96567..5477f4b 100644
--- a/arch/arm/mach-omap2/clock44xx_data.c
+++ b/arch/arm/mach-omap2/clock44xx_data.c
@@ -3010,6 +3010,14 @@ static struct clk auxclkreq5_ck = {
  	.recalc		= &omap2_clksel_recalc,
  };

+static struct clk smp_twd = {
+	.name		= "smp_twd",
+	.parent		= &dpll_mpu_ck,
+	.ops		= &clkops_null,
+	.fixed_div	= 2,
+	.recalc		= &omap_fixed_divisor_recalc,
+};
+
  /*
   * clkdev
   */
@@ -3283,6 +3291,7 @@ static struct omap_clk omap44xx_clks[] = {
  	CLK(NULL,	"auxclkreq3_ck",		&auxclkreq3_ck,	CK_443X),
  	CLK(NULL,	"auxclkreq4_ck",		&auxclkreq4_ck,	CK_443X),
  	CLK(NULL,	"auxclkreq5_ck",		&auxclkreq5_ck,	CK_443X),
+	CLK(NULL,	"smp_twd",		&smp_twd,	CK_443X),
  };

  int __init omap4xxx_clk_init(void)
-- 
1.6.0.4





--------------060809020102030908080805
Content-Type: text/plain;
 name="0001-OMAP4-clock-Add-CPU-local-timer-clock-node.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-OMAP4-clock-Add-CPU-local-timer-clock-node.patch"

>From 8a3e307c1a610a24f78d575c0ac04a7bbe1d39b8 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Wed, 18 May 2011 16:27:41 +0530
Subject: [PATCH] OMAP4: clock: Add CPU local timer clock node.

Local timer clock is sourced from the CPU clock and hence changes
along with CPU clock. These per CPU local timers are used as
clock-events, so they need to be reconfigured on CPU frequency
as part of CPUfreq governor.

Newly introduced clockevents_reconfigure() needs to know the
TWD clock-rate. Provide a clock-node to make clk_get_rate() work
for TWD.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-omap2/clock44xx_data.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock44xx_data.c b/arch/arm/mach-omap2/clock44xx_data.c
index 8c96567..5477f4b 100644
--- a/arch/arm/mach-omap2/clock44xx_data.c
+++ b/arch/arm/mach-omap2/clock44xx_data.c
@@ -3010,6 +3010,14 @@ static struct clk auxclkreq5_ck = {
 	.recalc		= &omap2_clksel_recalc,
 };
 
+static struct clk smp_twd = {
+	.name		= "smp_twd",
+	.parent		= &dpll_mpu_ck,
+	.ops		= &clkops_null,
+	.fixed_div	= 2,
+	.recalc		= &omap_fixed_divisor_recalc,
+};
+
 /*
  * clkdev
  */
@@ -3283,6 +3291,7 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"auxclkreq3_ck",		&auxclkreq3_ck,	CK_443X),
 	CLK(NULL,	"auxclkreq4_ck",		&auxclkreq4_ck,	CK_443X),
 	CLK(NULL,	"auxclkreq5_ck",		&auxclkreq5_ck,	CK_443X),
+	CLK(NULL,	"smp_twd",		&smp_twd,	CK_443X),
 };
 
 int __init omap4xxx_clk_init(void)
-- 
1.6.0.4


--------------060809020102030908080805--
