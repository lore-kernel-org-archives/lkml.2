Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab2JCM7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:59:49 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41550 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197Ab2JCM7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:59:46 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg@redhat.com>, Jan Beulich <jbeulich@suse.com>,
        x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4meCarretero?= <cJ-ko@zougloub.eu>,
        Vasco Dias <rafa.vasco@gmail.com>
Subject: [PATCH 2/3] x86, efi: 1:1 pagetable mapping for virtual EFI calls
Date: Wed,  3 Oct 2012 13:59:16 +0100
Message-Id: <1349269157-25956-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Some firmware still needs a 1:1 (virt->phys) mapping even after we've
called SetVirtualAddressMap(). So install the mapping alongside our
existing kernel mapping whenever we make EFI calls in virtual mode.

This bug was discovered on ASUS machines where the firmware
implementation of GetTime() accesses the RTC device via physical
addresses, even though that's bogus per the UEFI spec since we've
informed the firmware via SetVirtualAddressMap() that the boottime
memory map is no longer valid.

This bug seems to be present in a lot of consumer devices, so there's
not a lot we can do about this spec violation apart from workaround
it.

Cc: JérômeCarretero <cJ-ko@zougloub.eu>
Cc: Vasco Dias <rafa.vasco@gmail.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/efi.h     | 28 +++++++++++++++++++++-------
 arch/x86/platform/efi/efi_64.c | 15 +++++++++++++++
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index c9dcc18..ae3bf3b 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -69,23 +69,37 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5), (u64)(a6))
 
+extern unsigned long efi_call_virt_prelog(void);
+extern void efi_call_virt_epilog(unsigned long);
+
+#define efi_callx(x, func, ...)					\
+	({							\
+		efi_status_t __status;				\
+		unsigned long __pgd;				\
+								\
+		__pgd = efi_call_virt_prelog();			\
+		__status = efi_call##x(func, __VA_ARGS__);	\
+		efi_call_virt_epilog(__pgd);			\
+		__status;					\
+	})
+
 #define efi_call_virt0(f)				\
-	efi_call0((void *)(efi.systab->runtime->f))
+	efi_callx(0, (void *)(efi.systab->runtime->f))
 #define efi_call_virt1(f, a1)					\
-	efi_call1((void *)(efi.systab->runtime->f), (u64)(a1))
+	efi_callx(1, (void *)(efi.systab->runtime->f), (u64)(a1))
 #define efi_call_virt2(f, a1, a2)					\
-	efi_call2((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
+	efi_callx(2, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
 #define efi_call_virt3(f, a1, a2, a3)					\
-	efi_call3((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(3, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3))
 #define efi_call_virt4(f, a1, a2, a3, a4)				\
-	efi_call4((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(4, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4))
 #define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(5, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5))
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_callx(6, (void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ac3aa54..ddb0174 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -58,6 +58,21 @@ static void __init early_code_mapping_set_exec(int executable)
 	}
 }
 
+unsigned long efi_call_virt_prelog(void)
+{
+	unsigned long saved;
+
+	saved = read_cr3();
+	write_cr3(real_mode_header->trampoline_pgd);
+
+	return saved;
+}
+
+void efi_call_virt_epilog(unsigned long saved)
+{
+	write_cr3(saved);
+}
+
 void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
-- 
1.7.11.4

