Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0D1Vuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:50:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:36319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab0D1Vua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:50:30 -0400
Date: Wed, 28 Apr 2010 21:50:07 GMT
Message-Id: <201004282150.o3SLo7dG007962@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>, Colin Ian King <colin.king@canonical.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Samuel Thibault <samuel.thibault@inria.fr>
Subject: [GIT PULL] x86 fixes for 2.6.34-rc6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Apr 2010 21:50:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 05ce7bfe547c9fa967d9cab6c37867a9cb6fb3fa:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../jack/linux-fs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git x86-fixes-for-linus

H. Peter Anvin (2):
      x86-64: Clear a 64-bit FS/GS base on fork if selector is nonzero
      x86: Disable large pages on CPUs with Atom erratum AAE44

Jacob Pan (1):
      x86, mrst: Conditionally register cpu hotplug notifier for apbt

Note: expect another drop as soon as we have integrated and tested the
currently pending patches, including Thomas' HPET patch and Bjorn's
PCI patch.

	-hpa


 arch/x86/kernel/apb_timer.c  |    2 +-
 arch/x86/kernel/cpu/intel.c  |   21 +++++++++++++++++++++
 arch/x86/kernel/process_64.c |    4 ++--
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index ff469e4..a353475 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -429,7 +429,7 @@ static int apbt_cpuhp_notify(struct notifier_block *n,
 
 static __init int apbt_late_init(void)
 {
-	if (disable_apbt_percpu)
+	if (disable_apbt_percpu || !apb_timer_block_enabled)
 		return 0;
 	/* This notifier should be called after workqueue is ready */
 	hotcpu_notifier(apbt_cpuhp_notify, -20);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7e1cca1..1366c7c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -47,6 +47,27 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
+	/*
+	 * Atom erratum AAE44/AAF40/AAG38/AAH41:
+	 *
+	 * A race condition between speculative fetches and invalidating
+	 * a large page.  This is worked around in microcode, but we
+	 * need the microcode to have already been loaded... so if it is
+	 * not, recommend a BIOS update and disable large pages.
+	 */
+	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2) {
+		u32 ucode, junk;
+
+		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+		sync_core();
+		rdmsr(MSR_IA32_UCODE_REV, junk, ucode);
+
+		if (ucode < 0x20e) {
+			printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
+			clear_cpu_cap(c, X86_FEATURE_PSE);
+		}
+	}
+
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
 #else
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index dc9690b..17cb329 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -276,12 +276,12 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
 	set_tsk_thread_flag(p, TIF_FORK);
 
-	p->thread.fs = me->thread.fs;
-	p->thread.gs = me->thread.gs;
 	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
+	p->thread.gs = p->thread.gsindex ? 0 : me->thread.gs;
 	savesegment(fs, p->thread.fsindex);
+	p->thread.fs = p->thread.fsindex ? 0 : me->thread.fs;
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 
