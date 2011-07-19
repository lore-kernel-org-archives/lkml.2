Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1GSKjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 06:39:08 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:8681 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1GSKjH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 19 Jul 2011 06:39:07 -0400
Message-Id: <4E257AE7020000780004E2FF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 19 Jul 2011 11:39:03 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: serialize SMP boot's CMOS accesses on rtc_lock
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CPU hotplug, there is a theoretical race between other CMOS
(namely RTC) accesses and those done in the SMP secondary processor
bringup path. I am unware of the problem having been noticed by anyone
in practice, but it would very likely be rather spurious and very hard
to reproduce. So to be on the safe side, acquire rtc_lock around those
accesses.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/smpboot_hooks.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- 3.0-rc7/arch/x86/include/asm/smpboot_hooks.h
+++ 3.0-rc7-x86-rtc-lock-SMP/arch/x86/include/asm/smpboot_hooks.h
@@ -10,7 +10,11 @@ static inline void smpboot_clear_io_apic
 
 static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc_lock, flags);
 	CMOS_WRITE(0xa, 0xf);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 	local_flush_tlb();
 	pr_debug("1.\n");
 	*((volatile unsigned short *)phys_to_virt(apic->trampoline_phys_high)) =
@@ -23,6 +27,8 @@ static inline void smpboot_setup_warm_re
 
 static inline void smpboot_restore_warm_reset_vector(void)
 {
+	unsigned long flags;
+
 	/*
 	 * Install writable page 0 entry to set BIOS data area.
 	 */
@@ -32,7 +38,9 @@ static inline void smpboot_restore_warm_
 	 * Paranoid:  Set warm reset code and vector here back
 	 * to default values.
 	 */
+	spin_lock_irqsave(&rtc_lock, flags);
 	CMOS_WRITE(0, 0xf);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }



