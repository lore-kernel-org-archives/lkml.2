Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2DPNkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:40:42 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:4418
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368Ab2DPNkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:40:41 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2KRBK-01-02J-02
X-M-MSG: 
Date: Mon, 16 Apr 2012 15:40:28 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] x86, amd: Re-enable CPU topology extensions in case BIOS
 has disabled it
Message-ID: <20120416134028.GA25712@alberich.amd.com>
References: <20120411152640.GC4794@alberich.amd.com>
 <20120416065249.GA5292@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20120416065249.GA5292@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2da973d9e096cea39a3bd397c1449a821b76d816 Mon Sep 17 00:00:00 2001
From: Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Tue, 3 Apr 2012 12:13:07 +0200
Subject: [PATCH] x86, amd: Re-enable CPU topology extensions in case BIOS has
 disabled it

BIOS will switch off the corresponding feature flag on family 15h
models 10h-1fh non-desktop CPUs.

The topology extension CPUID leafs are required to detect which cores
belong to the same compute unit. (thread siblings mask is set
accordingly and also correct information about L1i and L2 cache
sharing depends on this).

W/o this patch we wouldn't see which cores belong to the same compute
unit and also cache sharing information for L1i and L2 would be
incorrect on such systems.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/amd.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)


Hi Ingo,

Hope this new commit messages answers your questions.

Of course this patch is more a workaround for "suboptimal BIOS
settings" and thus not strictly stable material. (BTW, no there is no
way to change the BIOS setting here.) But as a whole bunch of systems
will be affected it might also be reasonable to add this patch to
stable Linux versions.


Regards,
Andreas

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 1248f9c..0ae388d 100644
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
1.7.8.5


