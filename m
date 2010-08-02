Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0HBPQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:16:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:53977 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab0HBPQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:16:28 -0400
Date: Mon, 2 Aug 2010 15:16:13 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1280594903-6341-2-git-send-email-brgerst@gmail.com>
References: <1280594903-6341-2-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-32, asm: Directly access per-cpu GDT
Message-ID: <tip-72c511dd596cff88d6523f231a0fbb8f73006d51@git.kernel.org>
Git-Commit-ID: 72c511dd596cff88d6523f231a0fbb8f73006d51
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 15:16:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72c511dd596cff88d6523f231a0fbb8f73006d51
Gitweb:     http://git.kernel.org/tip/72c511dd596cff88d6523f231a0fbb8f73006d51
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Sat, 31 Jul 2010 12:48:23 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 1 Aug 2010 16:05:23 -0700

x86-32, asm: Directly access per-cpu GDT

Use a direct per-cpu reference for the GDT instead of using a scratch
register.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1280594903-6341-2-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_32.S |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index cd49141..233c582 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -611,14 +611,14 @@ ldt_ss:
  * compensating for the offset by changing to the ESPFIX segment with
  * a base address that matches for the difference.
  */
+#define GDT_ESPFIX_SS PER_CPU_VAR(gdt_page) + (GDT_ENTRY_ESPFIX_SS * 8)
 	mov %esp, %edx			/* load kernel esp */
 	mov PT_OLDESP(%esp), %eax	/* load userspace esp */
 	mov %dx, %ax			/* eax: new kernel esp */
 	sub %eax, %edx			/* offset (low word is 0) */
-	PER_CPU(gdt_page, %ebx)
 	shr $16, %edx
-	mov %dl, GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx) /* bits 16..23 */
-	mov %dh, GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx) /* bits 24..31 */
+	mov %dl, GDT_ESPFIX_SS + 4 /* bits 16..23 */
+	mov %dh, GDT_ESPFIX_SS + 7 /* bits 24..31 */
 	pushl $__ESPFIX_SS
 	CFI_ADJUST_CFA_OFFSET 4
 	push %eax			/* new kernel esp */
@@ -791,9 +791,8 @@ ptregs_clone:
  * normal stack and adjusts ESP with the matching offset.
  */
 	/* fixup the stack */
-	PER_CPU(gdt_page, %ebx)
-	mov GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx), %al /* bits 16..23 */
-	mov GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx), %ah /* bits 24..31 */
+	mov GDT_ESPFIX_SS + 4, %al /* bits 16..23 */
+	mov GDT_ESPFIX_SS + 7, %ah /* bits 24..31 */
 	shl $16, %eax
 	addl %esp, %eax			/* the adjusted stack pointer */
 	pushl $__KERNEL_DS
