Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0KEI6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 04:58:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64498 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0KEI6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 04:58:33 -0400
X-Nat-Received: from [202.181.97.72]:62999 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1288947487.11027
Message-Id: <201011050858.oA58w7Pl070809@www262.sakura.ne.jp>
Subject: [PATCH 2.6.37-rc1 x86] Build failure with old binutils.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: heukelum@fastmail.fm, mingo@elte.hu, jbeulich@novell.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Nov 2010 17:58:07 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 05112010 #4215335, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  AS      arch/x86/kernel/entry_32.o
arch/x86/kernel/entry_32.S: Assembler messages:
arch/x86/kernel/entry_32.S:398: Error: too many positional arguments
make[2]: *** [arch/x86/kernel/entry_32.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2

It seems that old binutils cannot deal

  pushl_cfi (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)

line. The pushl_cfi is a macro defined as:

  .macro pushl_cfi reg
  pushl \reg
  CFI_ADJUST_CFA_OFFSET 4
  .endm

$ as --version
GNU assembler 2.15

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 arch/x86/kernel/entry_32.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.37-rc1.orig/arch/x86/kernel/entry_32.S
+++ linux-2.6.37-rc1/arch/x86/kernel/entry_32.S
@@ -395,7 +395,8 @@ sysenter_past_esp:
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)
+	pushl (TI_sysenter_return-THREAD_SIZE_asm+8+4*4)(%esp)
+	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
