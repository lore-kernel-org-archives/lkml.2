Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2EPUho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:37:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2EPUhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:37:42 -0400
Date: Wed, 16 May 2012 13:37:13 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-796038799a72adb279d785c9154df6eeb98b6e8d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de, bp@alien8.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com, hpa@linux.intel.com,
        bp@alien8.de
In-Reply-To: <1336501366-28617-24-git-send-email-jarkko.sakkinen@intel.com>
References: <1336501366-28617-24-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode: Mask out EFER.
 LMA when saving trampoline EFER
Git-Commit-ID: 796038799a72adb279d785c9154df6eeb98b6e8d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 16 May 2012 13:37:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  796038799a72adb279d785c9154df6eeb98b6e8d
Gitweb:     http://git.kernel.org/tip/796038799a72adb279d785c9154df6eeb98b6e8d
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 16 May 2012 13:22:41 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 May 2012 13:22:41 -0700

x86, realmode: Mask out EFER.LMA when saving trampoline EFER

Some AMD processors apparently #GP(0) if EFER.LMA is set in WRMSR,
rather than ignoring it.  Thus, we need to mask it out.

Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Borislav Petkov <bp@alien8.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336501366-28617-24-git-send-email-jarkko.sakkinen@intel.com
---
 arch/x86/kernel/realmode.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/realmode.c b/arch/x86/kernel/realmode.c
index 66ac276..0992779 100644
--- a/arch/x86/kernel/realmode.c
+++ b/arch/x86/kernel/realmode.c
@@ -22,6 +22,7 @@ void __init setup_real_mode(void)
 	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
 #ifdef CONFIG_X86_64
 	u64 *trampoline_pgd;
+	u32 efer_low, efer_high;
 #endif
 
 	/* Has to be in very low memory so we can execute real-mode AP code. */
@@ -65,9 +66,13 @@ void __init setup_real_mode(void)
 	trampoline_header->gdt_limit = __BOOT_DS + 7;
 	trampoline_header->gdt_base = __pa(boot_gdt);
 #else
-	if (rdmsr_safe(MSR_EFER, &trampoline_header->efer_low,
-		       &trampoline_header->efer_high))
-		BUG();
+	/*
+	 * Some AMD processors will #GP(0) if EFER.LMA is set in WRMSR
+	 * so we need to mask it out.
+	 */
+	rdmsr(MSR_EFER, efer_low, efer_high);
+	trampoline_header->efer_low  = efer_low & ~EFER_LMA;
+	trampoline_header->efer_high = efer_high;
 
 	trampoline_header->start = (u64) secondary_startup_64;
 	trampoline_cr4_features = &trampoline_header->cr4;
