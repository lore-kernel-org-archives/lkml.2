Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1FHB65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:58:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49836 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1FHB64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:58:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DEED74B.20502@jp.fujitsu.com>
Date: Wed, 08 Jun 2011 10:58:35 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@gmail.com>
Subject: [PATCH 08/12] x86, mce: check the result of ancient_init()
References: <4DEED509.1040504@jp.fujitsu.com>
In-Reply-To: <4DEED509.1040504@jp.fujitsu.com>
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
index a182875..2cc98d5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1332,18 +1332,23 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
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
@@ -1397,7 +1402,8 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	if (mce_disabled)
 		return;
 
-	__mcheck_cpu_ancient_init(c);
+	if (__mcheck_cpu_ancient_init(c))
+		return;
 
 	if (!mce_available(c))
 		return;
-- 
1.7.1


