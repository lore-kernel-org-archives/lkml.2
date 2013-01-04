Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3ADAxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:53:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26884 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3ADAuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:50:08 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v7u1 16/31] x86, boot: move verify_cpu.S and no_longmode down
Date: Thu,  3 Jan 2013 16:48:36 -0800
Message-Id: <1357260531-11115-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to move some code to 32bit section in following patch:

   x86, boot: Move lldt/ltr out of 64bit code section

but that will push startup_64 down from 0x200.

According to hpa, we can not change startup_64 position and that
is an ABI.

We could move function verify_cpu and no_longmode down, because
verify_cpu is used via function call and no_longmode will not
return, then we don't need to add extra code for jumping back.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/head_64.S |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2c4b171..fb984c0 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -176,14 +176,6 @@ ENTRY(startup_32)
 	lret
 ENDPROC(startup_32)
 
-no_longmode:
-	/* This isn't an x86-64 CPU so hang */
-1:
-	hlt
-	jmp     1b
-
-#include "../../kernel/verify_cpu.S"
-
 	/*
 	 * Be careful here startup_64 needs to be at a predictable
 	 * address so I can export it in an ELF header.  Bootloaders
@@ -349,6 +341,15 @@ relocated:
  */
 	jmp	*%rbp
 
+	.code32
+no_longmode:
+	/* This isn't an x86-64 CPU so hang */
+1:
+	hlt
+	jmp     1b
+
+#include "../../kernel/verify_cpu.S"
+
 	.data
 gdt:
 	.word	gdt_end - gdt
-- 
1.7.10.4

