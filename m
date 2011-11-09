Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1KIQWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:22:47 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:22129
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479Ab1KIQWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:22:45 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzz8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LUEITF-02-AIV-02
X-M-MSG: 
Date: Wed, 9 Nov 2011 17:22:25 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf, x86: Force IBS LVT offset assignment for family 10h
Message-ID: <20111109162225.GO12451@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

now that IBS initialization is in perf, the firmware bug message
becomes more visible and confuses users. This should be for
tip/perf/urgent, if you are fine with it.

Thanks,

-Robert


>From cc0be1dc123a7a0d9a2afa19d69ea9ac5e3029de Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Tue, 8 Nov 2011 19:20:44 +0100
Subject: [PATCH] perf, x86: Force IBS LVT offset assignment for family 10h

On AMD family 10h we see firmware bug messages like the following:

 [Firmware Bug]: cpu 6, try to use APIC500 (LVT offset 0) for vector 0x10400, but the register is already in use for vector 0xf9 on another cpu
 [Firmware Bug]: cpu 6, IBS interrupt offset 0 not available (MSRC001103A=0x0000000000000100)
 [Firmware Bug]: using offset 1 for IBS interrupts
 [Firmware Bug]: workaround enabled for IBS LVT offset
 perf: AMD IBS detected (0x00000007)

We always see this, since the offsets are not assigned by the BIOS for
this family. Force LVT offset assignment in this case. If the OS
assignment fails, fallback to BIOS settings and try to setup this.

The fallback to BIOS settings weakens the family check since
force_ibs_eilvt_setup() may fail e.g. in case of virtual machines.
But setup may still succeed if BIOS offsets are correct.

Other families don't have a workaround implemented that assigns LVT
offsets. It's ok, to drop calling force_ibs_eilvt_setup() for that
families.

With the patch the [Firmware Bug] messages vanish. We see now:

 IBS: LVT offset 1 assigned
 perf: AMD IBS detected (0x00000007)

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index ab6343d..3b8a2d3 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -199,8 +199,7 @@ static int force_ibs_eilvt_setup(void)
 		goto out;
 	}
 
-	pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
-	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
+	pr_info("IBS: LVT offset %d assigned\n", offset);
 
 	return 0;
 out:
@@ -265,19 +264,23 @@ perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *h
 static __init int amd_ibs_init(void)
 {
 	u32 caps;
-	int ret;
+	int ret = -EINVAL;
 
 	caps = __get_ibs_caps();
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	if (!ibs_eilvt_valid()) {
-		ret = force_ibs_eilvt_setup();
-		if (ret) {
-			pr_err("Failed to setup IBS, %d\n", ret);
-			return ret;
-		}
-	}
+	/*
+	 * Force LVT offset assignment for family 10h: The offsets are
+	 * not assigned by the BIOS for this family, so the OS is
+	 * responsible for doing it. If the OS assignment fails, fall
+	 * back to BIOS settings and try to setup this.
+	 */
+	if (boot_cpu_data.x86 == 0x10)
+		force_ibs_eilvt_setup();
+
+	if (!ibs_eilvt_valid())
+		goto out;
 
 	get_online_cpus();
 	ibs_caps = caps;
@@ -287,7 +290,11 @@ static __init int amd_ibs_init(void)
 	smp_call_function(setup_APIC_ibs, NULL, 1);
 	put_online_cpus();
 
-	return perf_event_ibs_init();
+	ret = perf_event_ibs_init();
+out:
+	if (ret)
+		pr_err("Failed to setup IBS, %d\n", ret);
+	return ret;
 }
 
 /* Since we need the pci subsystem to init ibs we can't do this earlier: */
-- 
1.7.7


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

