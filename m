Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3ADAuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:50:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30407 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab3ADAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:50:14 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Zachary Amsden <zamsden@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v7u1 17/31] x86, boot: Move lldt/ltr out of 64bit code section
Date: Thu,  3 Jan 2013 16:48:37 -0800
Message-Id: <1357260531-11115-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 08da5a2ca

    x86_64: Early segment setup for VT

sets up LDT and TR into a valid state in order to speed up boot
decompression under VT.

Those code are put in code64, and it is using GDT that is only
loaded from code32 path.

That breaks booting with 64bit bootloader that does not go through
code32 path and jump to startup_64 directly, and it has different
GDT.

Move those lines into code32 after their GDT is loaded.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Zachary Amsden <zamsden@gmail.com>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_64.S |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index fb984c0..5c80b94 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -154,6 +154,12 @@ ENTRY(startup_32)
 	btsl	$_EFER_LME, %eax
 	wrmsr
 
+	/* After gdt is loaded */
+	xorl	%eax, %eax
+	lldt	%ax
+	movl    $0x20, %eax
+	ltr	%ax
+
 	/*
 	 * Setup for the jump to 64bit mode
 	 *
@@ -239,9 +245,6 @@ preferred_addr:
 	movl	%eax, %ss
 	movl	%eax, %fs
 	movl	%eax, %gs
-	lldt	%ax
-	movl    $0x20, %eax
-	ltr	%ax
 
 	/*
 	 * Compute the decompressed kernel start address.  It is where
-- 
1.7.10.4

