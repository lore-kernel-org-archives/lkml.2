Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462Ab2B1BTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:19:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50099 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965179Ab2B1BTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.74.74 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010431.091217704@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Pitre <nico@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rabin Vincent <rabin@rab.in>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 19/72] ARM: 7325/1: fix v7 boot with lockdep enabled
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin@rab.in>

commit 8e43a905dd574f54c5715d978318290ceafbe275 upstream.

Bootup with lockdep enabled has been broken on v7 since b46c0f74657d
("ARM: 7321/1: cache-v7: Disable preemption when reading CCSIDR").

This is because v7_setup (which is called very early during boot) calls
v7_flush_dcache_all, and the save_and_disable_irqs added by that patch
ends up attempting to call into lockdep C code (trace_hardirqs_off())
when we are in no position to execute it (no stack, MMU off).

Fix this by using a notrace variant of save_and_disable_irqs.  The code
already uses the notrace variant of restore_irqs.

Reviewed-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/assembler.h |    5 +++++
 arch/arm/mm/cache-v7.S           |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -137,6 +137,11 @@
 	disable_irq
 	.endm
 
+	.macro	save_and_disable_irqs_notrace, oldcpsr
+	mrs	\oldcpsr, cpsr
+	disable_irq_notrace
+	.endm
+
 /*
  * Restore interrupt state previously stored in a register.  We don't
  * guarantee that this will preserve the flags.
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -55,7 +55,7 @@ loop1:
 	cmp	r1, #2				@ see what cache we have at this level
 	blt	skip				@ skip if no cache, or just i-cache
 #ifdef CONFIG_PREEMPT
-	save_and_disable_irqs r9		@ make cssr&csidr read atomic
+	save_and_disable_irqs_notrace r9	@ make cssr&csidr read atomic
 #endif
 	mcr	p15, 2, r10, c0, c0, 0		@ select current cache level in cssr
 	isb					@ isb to sych the new cssr&csidr


