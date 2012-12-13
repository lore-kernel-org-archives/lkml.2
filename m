Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2LMWDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:03:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50561 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2LMWDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:03:02 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 27/27] x86: Merge early kernel reserve for 32bit and 64bit
Date: Thu, 13 Dec 2012 14:02:21 -0800
Message-Id: <1355436141-8668-28-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the same, could move them out from head32/64.c to setup.c.

We are using memblock, and it could handle overlapping properly, so
we don't need to reserve some at first to hold the location, and just
need to make sure we reserve them before we are using memblock to find
free mem to use.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/head32.c |    9 ---------
 arch/x86/kernel/head64.c |    3 ---
 arch/x86/kernel/setup.c  |    9 +++++++++
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 4c52efc..17f7792 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -30,9 +30,6 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
-	memblock_reserve(__pa_symbol(&_text),
-			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
-
 	/* Call the subarch specific early setup function */
 	switch (boot_params.hdr.hardware_subarch) {
 	case X86_SUBARCH_MRST:
@@ -46,11 +43,5 @@ void __init i386_start_kernel(void)
 		break;
 	}
 
-	/*
-	 * At this point everything still needed from the boot loader
-	 * or BIOS or kernel text should be early reserved or marked not
-	 * RAM in e820. All other memory is free game.
-	 */
-
 	start_kernel();
 }
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 17978b2..934b122 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -136,9 +136,6 @@ void __init x86_64_start_reservations(char *real_mode_data)
 		copy_bootdata(real_mode_data);
 	}
 
-	memblock_reserve(__pa_symbol(&_text),
-			 __pa_symbol(&__bss_stop) - __pa_symbol(&_text));
-
 	reserve_ebda_region();
 
 	/*
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d62069b..fcfcaef 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -727,8 +727,17 @@ static __init void print_init_mem_mapped(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	memblock_reserve(__pa_symbol(_text),
+			 (unsigned long)__bss_stop - (unsigned long)_text);
+
 	early_reserve_initrd();
 
+	/*
+	 * At this point everything still needed from the boot loader
+	 * or BIOS or kernel text should be early reserved or marked not
+	 * RAM in e820. All other memory is free game.
+	 */
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
-- 
1.7.10.4

