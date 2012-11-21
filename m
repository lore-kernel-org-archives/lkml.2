Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2KUHSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:18:11 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42609 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2KUHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:16:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Zachary Amsden <zamsden@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v3 02/12] x86, boot: Move lldt/ltr out of 64bit code section
Date: Tue, 20 Nov 2012 23:16:00 -0800
Message-Id: <1353482170-10160-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 08da5a2ca

    x86_64: Early segment setup for VT

add lldt/ltr to clean more segments.

Those code are put in code64, and it is using gdt that is only
loaded from code32 path.

That breaks booting with 64bit bootloader that does not go through
code32 path, and get at startup_64 directly, so they have different
gdt.

Move those lines into code32 after their gdt is loaded.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Zachary Amsden <zamsden@gmail.com>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_64.S |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2c3cee4..375af23 100644
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
@@ -245,9 +251,6 @@ preferred_addr:
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

