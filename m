Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1GUKIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:08:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:60100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1GUKIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:08:44 -0400
Date: Thu, 21 Jul 2011 10:08:22 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Message-ID: <tip-ac619f4eba45da10053fc991f8a5d47b3be79fa3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4E257AE7020000780004E2FF@nat28.tlf.novell.com>
References: <4E257AE7020000780004E2FF@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/rtc] x86: Serialize SMP bootup CMOS accesses on rtc_lock
Git-Commit-ID: ac619f4eba45da10053fc991f8a5d47b3be79fa3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:08:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac619f4eba45da10053fc991f8a5d47b3be79fa3
Gitweb:     http://git.kernel.org/tip/ac619f4eba45da10053fc991f8a5d47b3be79fa3
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 19 Jul 2011 11:39:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 09:20:59 +0200

x86: Serialize SMP bootup CMOS accesses on rtc_lock

With CPU hotplug, there is a theoretical race between other CMOS
(namely RTC) accesses and those done in the SMP secondary
processor bringup path.

I am unware of the problem having been noticed by anyone in practice,
but it would very likely be rather spurious and very hard to reproduce.
So to be on the safe side, acquire rtc_lock around those accesses.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/4E257AE7020000780004E2FF@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/smpboot_hooks.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 725b778..49adfd7 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -10,7 +10,11 @@ static inline void smpboot_clear_io_apic_irqs(void)
 
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
@@ -23,6 +27,8 @@ static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
 
 static inline void smpboot_restore_warm_reset_vector(void)
 {
+	unsigned long flags;
+
 	/*
 	 * Install writable page 0 entry to set BIOS data area.
 	 */
@@ -32,7 +38,9 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	 * Paranoid:  Set warm reset code and vector here back
 	 * to default values.
 	 */
+	spin_lock_irqsave(&rtc_lock, flags);
 	CMOS_WRITE(0, 0xf);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	*((volatile u32 *)phys_to_virt(apic->trampoline_phys_low)) = 0;
 }
