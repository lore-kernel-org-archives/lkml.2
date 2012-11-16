Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab2KPIxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:53:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22819 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2KPIxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:53:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Zachary Amsden <zach@vmware.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 1/9] x86, boot: Move lldt/ltr out of 64bit only path
Date: Fri, 16 Nov 2012 00:53:01 -0800
Message-Id: <1353055989-31939-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 08da5a2ca

    x86_64: Early segment setup for VT

add lldt/ltr to clean more segments.

but those code are put in code64, and it is using gdt that is only loaded
from code32 path.

that breaks booting with 64bit bootloader that does not go that
code32 path, because they have different gdt.

Move those lines into code32 after their gdt is loaded.

Also it push down startup_64 to 0x208.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_64.S |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2c4b171..4c8af67 100644
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
@@ -191,7 +197,7 @@ no_longmode:
 	 * it may change in the future.
 	 */
 	.code64
-	.org 0x200
+	.org 0x208
 ENTRY(startup_64)
 	/*
 	 * We come here either from startup_32 or directly from a
@@ -247,9 +253,6 @@ preferred_addr:
 	movl	%eax, %ss
 	movl	%eax, %fs
 	movl	%eax, %gs
-	lldt	%ax
-	movl    $0x20, %eax
-	ltr	%ax
 
 	/*
 	 * Compute the decompressed kernel start address.  It is where
-- 
1.7.7

