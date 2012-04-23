Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab2DWVoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:44:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2DWVoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:44:11 -0400
Date: Mon, 23 Apr 2012 14:43:59 -0700
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Message-ID: <tip-cd74257b974d6d26442c97891c4d05772748b177@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1335150198-21899-3-git-send-email-konrad.wilk@oracle.com>
References: <1335150198-21899-3-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, acpi:
  Call acpi_enter_sleep_state via an asmlinkage C function from assembler
Git-Commit-ID: cd74257b974d6d26442c97891c4d05772748b177
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 23 Apr 2012 14:44:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd74257b974d6d26442c97891c4d05772748b177
Gitweb:     http://git.kernel.org/tip/cd74257b974d6d26442c97891c4d05772748b177
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Sun, 22 Apr 2012 23:03:18 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 23 Apr 2012 13:29:18 -0700

x86, acpi: Call acpi_enter_sleep_state via an asmlinkage C function from assembler

With commit a2ef5c4fd44ce3922435139393b89f2cce47f576
"ACPI: Move module parameter gts and bfs to sleep.c" the
wake_sleep_flags is required when calling acpi_enter_sleep_state.

The assembler code in wakeup_*.S did not do that. One solution
is to call it from assembler and stick the wake_sleep_flags on
the stack (for 32-bit) or in %esi (for 64-bit). hpa and rafael
both suggested however to create a wrapper function to call
acpi_enter_sleep_state and call said wrapper function
("acpi_enter_s3") from assembler.

For 32-bit, the acpi_enter_s3 ends up looking as so:

  push   %ebp
  mov    %esp,%ebp
  sub    $0x8,%esp
  movzbl 0xc1809314,%eax [wake_sleep_flags]
  movl   $0x3,(%esp)
  mov    %eax,0x4(%esp)
  call   0xc12d1fa0 <acpi_enter_sleep_state>
  leave
  ret

And 64-bit:

  movzbl 0x9afde1(%rip),%esi        [wake_sleep_flags]
  push   %rbp
  mov    $0x3,%edi
  mov    %rsp,%rbp
  callq  0xffffffff812e9800 <acpi_enter_sleep_state>
  leaveq
  retq

Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
[v2: Remove extra assembler operations, per hpa review]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1335150198-21899-3-git-send-email-konrad.wilk@oracle.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/acpi/sleep.c     |    4 ++++
 arch/x86/kernel/acpi/sleep.h     |    2 ++
 arch/x86/kernel/acpi/wakeup_32.S |    4 +---
 arch/x86/kernel/acpi/wakeup_64.S |    4 +---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 103b6ab..146a49c 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -24,6 +24,10 @@ unsigned long acpi_realmode_flags;
 static char temp_stack[4096];
 #endif
 
+asmlinkage void acpi_enter_s3(void)
+{
+	acpi_enter_sleep_state(3, wake_sleep_flags);
+}
 /**
  * acpi_suspend_lowlevel - save kernel state
  *
diff --git a/arch/x86/kernel/acpi/sleep.h b/arch/x86/kernel/acpi/sleep.h
index fe5fdda..d68677a 100644
--- a/arch/x86/kernel/acpi/sleep.h
+++ b/arch/x86/kernel/acpi/sleep.h
@@ -3,6 +3,7 @@
  */
 
 #include <asm/trampoline.h>
+#include <linux/linkage.h>
 
 extern unsigned long saved_video_mode;
 extern long saved_magic;
@@ -10,6 +11,7 @@ extern long saved_magic;
 extern int wakeup_pmode_return;
 
 extern u8 wake_sleep_flags;
+extern asmlinkage void acpi_enter_s3(void);
 
 extern unsigned long acpi_copy_wakeup_routine(unsigned long);
 extern void wakeup_long64(void);
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 13ab720..7261083 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -74,9 +74,7 @@ restore_registers:
 ENTRY(do_suspend_lowlevel)
 	call	save_processor_state
 	call	save_registers
-	pushl	$3
-	call	acpi_enter_sleep_state
-	addl	$4, %esp
+	call	acpi_enter_s3
 
 #	In case of S3 failure, we'll emerge here.  Jump
 # 	to ret_point to recover
diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 8ea5164..014d1d2 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -71,9 +71,7 @@ ENTRY(do_suspend_lowlevel)
 	movq	%rsi, saved_rsi
 
 	addq	$8, %rsp
-	movl	$3, %edi
-	xorl	%eax, %eax
-	call	acpi_enter_sleep_state
+	call	acpi_enter_s3
 	/* in case something went wrong, restore the machine status and go on */
 	jmp	resume_point
 
