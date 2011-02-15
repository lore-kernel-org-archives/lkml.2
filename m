Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1BOQVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:21:00 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36620 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1BOQUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=HSPYSVyv05+AbtzAjNXnEHuhjp33Eon1plDiSSDt7s4zE/w8us9C29eVghz1nzTLUx
         b/K34rw6l+0J0pRCLBqS3S8pxAPiaEJ6C0dSGJBAhxdyb1FWTLuBBDzWI7GuZ4i2RVg3
         guONGIudqakX7azKhdpph18MCccXEqkGXCL2I=
Subject: [PATCH] ARM: pxa: support 806MHz operating points for PXA31x
 processors A2 stepping
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Igor Grinberg <grinberg@compulab.co.il>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 00:20:49 +0800
Message-ID: <1297786849.2596.13.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PXA3xx Specification Update document states that the 806MHz
operating points were added for PXA31x processors A2 stepping.

This patch adds 806MHz operating points support for PXA31x A2 stepping.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---

I cannot find any details for PXA31x stepping B1 and B2,
thus I made this patch for PXA31x stepping A2 only.

Axel

 arch/arm/mach-pxa/cpufreq-pxa3xx.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-pxa/cpufreq-pxa3xx.c b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
index 88fbec0..f4f0c2e 100644
--- a/arch/arm/mach-pxa/cpufreq-pxa3xx.c
+++ b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
@@ -210,15 +210,30 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 
 	/* set default policy and cpuinfo */
 	policy->cpuinfo.min_freq = 104000;
-	policy->cpuinfo.max_freq = (cpu_is_pxa320()) ? 806000 : 624000;
+
+	if (cpu_is_pxa300())
+		policy->cpuinfo.max_freq = 624000;
+	else if (cpu_is_pxa310())
+		policy->cpuinfo.max_freq = ((read_cpuid_id() & 0xf) == 0x2) ?
+						806000 : 624000;
+	else if (cpu_is_pxa320())
+		policy->cpuinfo.max_freq = 806000;
+
 	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
 	policy->max = pxa3xx_get_clk_frequency_khz(0);
 	policy->cur = policy->min = policy->max;
 
-	if (cpu_is_pxa300() || cpu_is_pxa310())
+	if (cpu_is_pxa300())
 		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa300_freqs));
-
-	if (cpu_is_pxa320())
+	else if (cpu_is_pxa310())
+		/* PXA310 A2 STEPPING supports 806Mhz operating points */
+		if ((read_cpuid_id() & 0xf) == 0x2)
+			ret = setup_freqs_table(policy,
+						ARRAY_AND_SIZE(pxa320_freqs));
+		else
+			ret = setup_freqs_table(policy,
+						ARRAY_AND_SIZE(pxa300_freqs));
+	else if (cpu_is_pxa320())
 		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa320_freqs));
 
 	if (ret) {
-- 
1.7.2



