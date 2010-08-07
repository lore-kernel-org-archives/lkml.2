Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab0HGCSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:18:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37819 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762454Ab0HGCSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:18:11 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/10] x86: !find_smp_config path use smp_register_lapic_address
Date: Fri,  6 Aug 2010 19:15:41 -0700
Message-Id: <1281147343-18389-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
References: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so fixmap will be setup there.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/apic.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3d3d3da..2c9aa63 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1477,7 +1477,7 @@ static int __init detect_init_APIC(void)
 		return -1;
 	}
 
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+	smp_register_lapic_addr(APIC_DEFAULT_PHYS_BASE);
 	return 0;
 }
 #else
@@ -1487,6 +1487,7 @@ static int __init detect_init_APIC(void)
 static int __init detect_init_APIC(void)
 {
 	u32 h, l, features;
+	unsigned long lapic_addr;
 
 	/* Disabled by kernel option? */
 	if (disable_apic)
@@ -1541,13 +1542,14 @@ static int __init detect_init_APIC(void)
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
 
+	smp_register_lapic_address(lapic_addr)
 	pr_info("Found and enabled local APIC!\n");
 
 	apic_pm_activate();
-- 
1.6.4.2

