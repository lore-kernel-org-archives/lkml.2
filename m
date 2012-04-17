Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2DQSek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:34:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47977 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2DQSef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:34:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        ming.m.lin@intel.com, hpa@zytor.com, rjw@sisk.pl, x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] x86/acpi: Call acpi_enter_sleep_state via an asmlinkage C function from assembler.
Date: Tue, 17 Apr 2012 14:29:19 -0400
Message-Id: <1334687359-9970-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1334687359-9970-1-git-send-email-konrad.wilk@oracle.com>
References: <1334687359-9970-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F8DB7B0.0078,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/acpi/sleep.c     |    4 ++++
 arch/x86/kernel/acpi/sleep.h     |    2 ++
 arch/x86/kernel/acpi/wakeup_32.S |    3 +--
 arch/x86/kernel/acpi/wakeup_64.S |    3 +--
 4 files changed, 8 insertions(+), 4 deletions(-)

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
index 13ab720..d3a18a4 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -74,8 +74,7 @@ restore_registers:
 ENTRY(do_suspend_lowlevel)
 	call	save_processor_state
 	call	save_registers
-	pushl	$3
-	call	acpi_enter_sleep_state
+	call	acpi_enter_s3
 	addl	$4, %esp
 
 #	In case of S3 failure, we'll emerge here.  Jump
diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 8ea5164..fea733d 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -71,9 +71,8 @@ ENTRY(do_suspend_lowlevel)
 	movq	%rsi, saved_rsi
 
 	addq	$8, %rsp
-	movl	$3, %edi
 	xorl	%eax, %eax
-	call	acpi_enter_sleep_state
+	call	acpi_enter_s3
 	/* in case something went wrong, restore the machine status and go on */
 	jmp	resume_point
 
-- 
1.7.7.5

