Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0EGRrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:47:19 -0400
Received: from mga10.intel.com ([192.55.52.92]:58103 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756703Ab0EGRrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:47:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,349,1270450800"; 
   d="scan'208";a="796418387"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Pan <jacob.jun.pan@intel.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 1/8] x86: avoid check hlt if no timer interrupts
Date: Fri,  7 May 2010 10:41:41 -0700
Message-Id: <1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@intel.com>

check hlt requires external timer interrupt to wake up the
cpu. for platforms equipped with only per cpu timers, we don't
have external interrupts during check hlt.
this patch checks such condition to avoid kernel hang at hlt.
it also saves boot time in that hlt four times in the current code
requires four ticks to break out of them.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/bugs.h |    1 +
 arch/x86/kernel/cpu/bugs.c  |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/bugs.h b/arch/x86/include/asm/bugs.h
index 08abf63..1e0cef8 100644
--- a/arch/x86/include/asm/bugs.h
+++ b/arch/x86/include/asm/bugs.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_BUGS_H
 
 extern void check_bugs(void);
+extern struct clock_event_device *global_clock_event;
 
 #if defined(CONFIG_CPU_SUP_INTEL) && defined(CONFIG_X86_32)
 int ppro_with_ram_bug(void);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 01a2652..c0d9688 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -90,6 +90,10 @@ static void __init check_hlt(void)
 		return;
 
 	printk(KERN_INFO "Checking 'hlt' instruction... ");
+	if (!global_clock_event) {
+		printk(KERN_CONT "no clockevent to wake up, skipped.\n");
+		return;
+	}
 	if (!boot_cpu_data.hlt_works_ok) {
 		printk("disabled\n");
 		return;
-- 
1.6.3.3

