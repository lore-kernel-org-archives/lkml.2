Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1LSTvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:51:42 -0500
Received: from outmail009.snc4.facebook.com ([66.220.144.143]:46939 "EHLO
	intmgw003.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752909Ab1LSTvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:51:39 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/2] Extend VVAR support to multiple pages
Date: Mon, 19 Dec 2011 11:51:32 -0800
Message-Id: <1324324293-10390-2-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1324324293-10390-1-git-send-email-asharma@fb.com>
References: <1324324293-10390-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Kumar Sundararajan <kumar@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andy Lutomirski <luto@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/fixmap.h |    1 +
 arch/x86/include/asm/vvar.h   |    3 ++-
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 arch/x86/kernel/vsyscall_64.c |    1 +
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 460c74e..6441527 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -78,6 +78,7 @@ enum fixed_addresses {
 	VSYSCALL_LAST_PAGE,
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
+	VVAR_PAGE2,
 	VVAR_PAGE,
 	VSYSCALL_HPET,
 #endif
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index de656ac..0fd7a4a 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -17,7 +17,8 @@
  */
 
 /* Base address of vvars.  This is not ABI. */
-#define VVAR_ADDRESS (-10*1024*1024 - 4096)
+#define VVAR_NUM_PAGES 2
+#define VVAR_ADDRESS (-10*1024*1024 - VVAR_NUM_PAGES * 4096)
 
 #if defined(__VVAR_KERNEL_LDS)
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0f703f1..70c52de 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -171,7 +171,7 @@ SECTIONS
 
 	} :data
 
-       . = ALIGN(__vvar_page + PAGE_SIZE, PAGE_SIZE);
+       . = ALIGN(__vvar_page + VVAR_NUM_PAGES*PAGE_SIZE, PAGE_SIZE);
 
 #endif /* CONFIG_X86_64 */
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index e4d4a22..7960d3a 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -282,6 +282,7 @@ void __init map_vsyscall(void)
 		     (unsigned long)VSYSCALL_START);
 
 	__set_fixmap(VVAR_PAGE, physaddr_vvar_page, PAGE_KERNEL_VVAR);
+	__set_fixmap(VVAR_PAGE2, physaddr_vvar_page + PAGE_SIZE, PAGE_KERNEL_VVAR);
 	BUILD_BUG_ON((unsigned long)__fix_to_virt(VVAR_PAGE) !=
 		     (unsigned long)VVAR_ADDRESS);
 }
-- 
1.7.4

