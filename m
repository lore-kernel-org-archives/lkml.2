Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0GaQsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 12:48:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0GaQsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 12:48:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NG7+CGeDJ1nJ3D9vcUjM04Qarj/lxcvStQNpISCYmnvD7DURlkvSqkhMbnZgTEIEda
         Hj0v7vSihaW/4HGblj/Du2HZ5/V5ErMRcvkYYsovc2GFoDulJ8200sZv12AzZQco62Gn
         nZUJxvZxmrZwVXhnAfIBWUJmbcluWw65Hhroc=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86-32: Directly access per-cpu GDT
Date: Sat, 31 Jul 2010 12:48:23 -0400
Message-Id: <1280594903-6341-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280594903-6341-1-git-send-email-brgerst@gmail.com>
References: <1280594903-6341-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a direct per-cpu reference for the GDT instead of using a scratch
register.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
-- 
1.7.2

