Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1E0EKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:10:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33108 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1E0EK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:10:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF2426.5050605@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:10:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 08/12] x86, mce: check the result of ancient_init()
References: <4DDF21DE.9040705@jp.fujitsu.com>
In-Reply-To: <4DDF21DE.9040705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because "ancient cpu" like p5 and winchip don't have X86_FEATURE_MCA
(I suppose so), mcheck_cpu_init() on such cpu will return at check
of mce_available() after __mcheck_cpu_ancient_init().

It is hard to know this implicit behavior without knowing cpus well.
So make it clear that we leave mcheck_cpu_init() when the cpu is
initialized in __mcheck_cpu_ancient_init().

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index dbdbd60..2628743 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1328,18 +1328,23 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 	return 0;
 }
 
-static void __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
+static int __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
 {
 	if (c->x86 != 5)
-		return;
+		return 0;
+
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		intel_p5_mcheck_init(c);
+		return 1;
 		break;
 	case X86_VENDOR_CENTAUR:
 		winchip_mcheck_init(c);
+		return 1;
 		break;
 	}
+
+	return 0;
 }
 
 static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
@@ -1393,7 +1398,8 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	if (mce_disabled)
 		return;
 
-	__mcheck_cpu_ancient_init(c);
+	if (__mcheck_cpu_ancient_init(c))
+		return;
 
 	if (!mce_available(c))
 		return;
-- 
1.7.1


