Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1BJJU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:20:57 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48931 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1BJJUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:20:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KdC431eXvTizs1LisUCqBCUcyg6peG7OAYD6sah7Xh++WCGZqYxR+LaWhqzzGA7EZT
         29Pu0fb/djKZnkdsT91jx67aBUjViSgcqTDIfLbgzSxS/IvUEnbr2JirHAd2jWHNOFdz
         bUEJdJTZNsF+960njsGGGFg/yu22GSBLMh6Ew=
Subject: [PXA] A question about PXA310 cpufreq for 806Mhz
From: Axel Lin <axel.lin@gmail.com>
To: linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
Content-Type: text/plain
Date: Thu, 10 Feb 2011 17:22:51 +0800
Message-Id: <1297329771.21848.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I have a device equipped with 806Mhz PXA310 cpu.
After bootup, the system shows it is running with 624Mhz.

# cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
624000
# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
624000

# cat /proc/cpuinfo
Processor       : XScale-V3 based processor rev 2 (v5l)
BogoMIPS        : 623.00
Features        : swp half thumb fastmult edsp iwmmxt 
CPU implementer : 0x69
CPU architecture: 5TE
CPU variant     : 0x0
CPU part        : 0x689
CPU revision    : 2

Hardware        : Getac PS236 Handheld Platform
Revision        : 0000
Serial          : 0000000000000000

I fix it by below patch and it looks ok on my device.
I'm not sure if this is a proper way to fix it, I appreciate to see your comments.

It is strange that I cannot find 806Mhz PXA31x CPU 
in the datasheet Section 6.1 PXA3XX Processor Differences.
But in Section 6.7, Table 55: PXA31x Core PLL, Turbo and Run Mode Output Frequencies,
I do see 806Mhz support on the table.

Regards,
Axel

diff --git a/arch/arm/mach-pxa/cpufreq-pxa3xx.c b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
index 88fbec0..abf7d7a 100644
--- a/arch/arm/mach-pxa/cpufreq-pxa3xx.c
+++ b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
@@ -210,15 +210,14 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 
 	/* set default policy and cpuinfo */
 	policy->cpuinfo.min_freq = 104000;
-	policy->cpuinfo.max_freq = (cpu_is_pxa320()) ? 806000 : 624000;
+	policy->cpuinfo.max_freq = (cpu_is_pxa300()) ? 624000 : 806000;
 	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
 	policy->max = pxa3xx_get_clk_frequency_khz(0);
 	policy->cur = policy->min = policy->max;
 
-	if (cpu_is_pxa300() || cpu_is_pxa310())
+	if (cpu_is_pxa300())
 		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa300_freqs));
-
-	if (cpu_is_pxa320())
+	else if (cpu_is_pxa310() || cpu_is_pxa320())
 		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa320_freqs));
 
 	if (ret) {



