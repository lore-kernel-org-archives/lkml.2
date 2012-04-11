Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab2DKP0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:26:50 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:9563 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753657Ab2DKP0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:26:48 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2BMWF-02-1RC-02
X-M-MSG: 
Date: Wed, 11 Apr 2012 17:26:40 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, amd: Re-enable CPU topology extensions in case BIOS has
 disabled it
Message-ID: <20120411152640.GC4794@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For detection of thread siblings we are relying on the topology
extension CPUID leafs. Thus we have to re-enable it in case BIOS tries
to hide the correpsonding CPUID feature flag.

Cc: stable@vger.kernel.org
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/amd.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0a44b90..56a694b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -579,6 +579,24 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
+	/* re-enable TopologyExtensions if switched off by BIOS */
+	if ((c->x86 == 0x15) &&
+	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
+	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
+		u64 val;
+
+		if (!rdmsrl_amd_safe(0xc0011005, &val)) {
+			val |= 1ULL << 54;
+			wrmsrl_amd_safe(0xc0011005, val);
+			rdmsrl(0xc0011005, val);
+			if (val & (1ULL << 54)) {
+				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
+				printk(KERN_INFO FW_INFO "CPU: Re-enabling "
+				  "disabled Topology Extensions Support\n");
+			}
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
-- 
1.7.5.rc3



