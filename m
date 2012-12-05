Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2LEOSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:18:06 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:19698
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184Ab2LEOSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:18:04 -0500
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPV:NLI;H:oce-exbhcs03b.oce.net;RD:smtp02.oce.com;EFVD:NLI
X-SpamScore: 17
X-BigFish: VS17(zzzz1ce5h1202h1d1ah1cabh1d2ahzz8275bhz2ei87h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631hff4m129fs1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Bernd Faust <berndfaust@gmail.com>
To: <berndfaust@gmail.com>, <johnstul@us.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: [PATCH] Round the calculated scale factor in set_cyc2ns_scale()
Date: Wed, 5 Dec 2012 15:16:49 +0100
Message-ID: <1354717009-2687-1-git-send-email-berndfaust@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 05 Dec 2012 14:17:57.0562 (UTC) FILETIME=[530959A0:01CDD2F3]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: oce.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During some experiments with an external clock (in a FPGA), we saw that
the TSC clock drifted approx. 2.5ms per second.

This drift was caused by the current way of calculating the scale.
In our case cpu_khz had a value of 3292725. This resulted in a scale
value of 310. But when doing the calculation by hand it shows that the
actual value is 310.9886188491, so a value of 311 would be more precise.

With this change the value is rounded.

Signed-off-by: Bernd Faust <berndfaust@gmail.com>
---
 arch/x86/kernel/tsc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cfa5d4f..8ed0857 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -617,7 +617,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	ns_now = __cycles_2_ns(tsc_now);
 
 	if (cpu_khz) {
-		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+		*scale = ((NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR) +
+				cpu_khz / 2) / cpu_khz;
 		*offset = ns_now - mult_frac(tsc_now, *scale,
 					     (1UL << CYC2NS_SCALE_FACTOR));
 	}
-- 
1.7.9.5


