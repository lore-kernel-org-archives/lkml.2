Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab0JXBET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:04:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48094 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab0JXBES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:04:18 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/15] x86: on !find_smp_config path use smp_register_lapic_address
Date: Sat, 23 Oct 2010 18:02:23 -0700
Message-Id: <1287882149-29275-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So fixmap will be setup there.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/apic.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a5ce130..3a4e770 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1527,7 +1527,7 @@ static int __init detect_init_APIC(void)
 		return -1;
 	}
 
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+	smp_register_lapic_address(APIC_DEFAULT_PHYS_BASE);
 	return 0;
 }
 #else
@@ -1535,6 +1535,7 @@ static int __init detect_init_APIC(void)
 static int apic_verify(void)
 {
 	u32 features, h, l;
+	unsigned long lapic_addr;
 
 	/*
 	 * The APIC feature bit should now be enabled
@@ -1546,13 +1547,14 @@ static int apic_verify(void)
 		return -1;
 	}
 	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+	lapic_addr = APIC_DEFAULT_PHYS_BASE;
 
 	/* The BIOS may have set up the APIC at some other address */
 	rdmsr(MSR_IA32_APICBASE, l, h);
 	if (l & MSR_IA32_APICBASE_ENABLE)
-		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
+		lapic_addr = l & MSR_IA32_APICBASE_BASE;
 
+	smp_register_lapic_address(lapic_addr);
 	pr_info("Found and enabled local APIC!\n");
 	return 0;
 }
-- 
1.7.1

