Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab0JZOCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:02:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47291 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0JZOCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:02:22 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>, Suresh.b.siddha@intel.com
Subject: [PATCH] Fix written but not read warnings for x2apic.h
Date: Tue, 26 Oct 2010 16:02:10 +0200
Message-Id: <1288101730-14989-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

A current linus master build with x2apic and a gcc 4.6 snapshot is very noisy,
because of a lot of

arch/x86/include/asm/apic.h:184:11: warning: variable 'msr2' set but not used [-Wunused-but-set-variable]
In file included from /home/lsrc/git/linux-2.6/arch/x86/include/asm/smp.h:13:0,
                 from /home/lsrc/git/linux-2.6/arch/x86/include/asm/mmzone_64.h:12,
                 from /home/lsrc/git/linux-2.6/arch/x86/include/asm/mmzone.h:4,
                 from /home/lsrc/git/linux-2.6/include/linux/mmzone.h:784,
                 from /home/lsrc/git/linux-2.6/include/linux/gfp.h:4,
                 from /home/lsrc/git/linux-2.6/include/linux/mm.h:8,
                 from /home/lsrc/git/linux-2.6/mm/page_io.c:13:
/home/lsrc/git/linux-2.6/arch/x86/include/asm/apic.h: In function 'native_apic_msr_read':
/home/lsrc/git/linux-2.6/arch/x86/include/asm/apic.h:144:11: warning: variable 'high' set but not used [-Wunused-but-set-variable]
/home/lsrc/git/linux-2.6/arch/x86/include/asm/apic.h: In function 'x2apic_enabled':
/home/lsrc/git/linux-2.6/arch/x86/include/asm/apic.h:184:11: warning: variable 'msr2' set but not used [-Wunused-but-set-variable]

in the x2apic code. Use rdmsrl to avoid this warning. This actually
avoids some code because rdmsr is just a wrapper around rdmsrl.

Cc: Suresh.b.siddha@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/apic.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 286de34..9c4e06b 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -141,12 +141,12 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
 
 static inline u32 native_apic_msr_read(u32 reg)
 {
-	u32 low, high;
+	u32 low;
 
 	if (reg == APIC_DFR)
 		return -1;
 
-	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
+	rdmsrl(APIC_BASE_MSR + (reg >> 4), low);
 	return low;
 }
 
@@ -181,12 +181,12 @@ extern void enable_x2apic(void);
 extern void x2apic_icr_write(u32 low, u32 id);
 static inline int x2apic_enabled(void)
 {
-	int msr, msr2;
+	int msr;
 
 	if (!cpu_has_x2apic)
 		return 0;
 
-	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	rdmsrl(MSR_IA32_APICBASE, msr);
 	if (msr & X2APIC_ENABLE)
 		return 1;
 	return 0;
-- 
1.7.1

