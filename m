Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0KHVUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:20:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48537 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0KHVUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:20:43 -0500
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org
Subject: [PATCH] x86: fix apic.h unused but set warnings v2
Date: Mon,  8 Nov 2010 22:20:29 +0100
Message-Id: <1289251229-19589-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fix

linux-2.6/arch/x86/include/asm/apic.h: In function 'native_apic_msr_read':
linux-2.6/arch/x86/include/asm/apic.h:144:11: warning: variable 'high' set but not used [-Wunused-but-set-variable]
linux-2.6/arch/x86/include/asm/apic.h: In function 'x2apic_enabled':
linux-2.6/arch/x86/include/asm/apic.h:184:11: warning: variable 'msr2' set but not used [-Wunused-but-set-variable]

which happen with a gcc 4.6 build

Since this is in a frequently included header these warnings are printed
very frequently and make a gcc 4.6 build very noisy.

v2: Add cast and change types based on review feedback.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/apic.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 286de34..e5472de 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -141,13 +141,13 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
 
 static inline u32 native_apic_msr_read(u32 reg)
 {
-	u32 low, high;
+	u32 low;
 
 	if (reg == APIC_DFR)
 		return -1;
 
-	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
-	return low;
+	rdmsrl(APIC_BASE_MSR + (reg >> 4), low);
+	return (u32)low;
 }
 
 static inline void native_x2apic_wait_icr_idle(void)
@@ -181,12 +181,12 @@ extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
 static inline int x2apic_enabled(void)
 {
-	int msr, msr2;
+	u32 msr;
 
 	if (!cpu_has_x2apic)
 		return 0;
 
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	rdmsrl(MSR_IA32_APICBASE, msr);
 	if (msr & X2APIC_ENABLE)
 		return 1;
 	return 0;
-- 
1.7.1

