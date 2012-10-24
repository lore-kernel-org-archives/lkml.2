Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab2JXHwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:52:42 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:13844
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757437Ab2JXHwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:52:41 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h1155h)
X-WSS-ID: 0MCE0JO-01-C6W-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <andreas.herrmann3@amd.com>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH] x86/amd: disable way access filter on affected CPUs
Date: Wed, 24 Oct 2012 09:56:17 +0200
Message-ID: <1351065377-1989-1-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.12.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WAF may hurt the performance of some workloads, caused by
aliasing issues in the L1 cache.
Disable it on the affected CPUs.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f7e98a2..1b7d165 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -631,6 +631,20 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
+	/*
+	 * The way access filter has a performance penalty on some workloads.
+	 * Disable it on the affected CPUs.
+	 */
+	if ((c->x86 == 0x15) &&
+	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
+		u64 val;
+
+		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
+			val |= 0x1E;
+			wrmsrl_safe(0xc0011021, val);
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
-- 
1.7.12.1


