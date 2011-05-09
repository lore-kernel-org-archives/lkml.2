Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1EIVRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:17:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab1EIVRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:17:04 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Cliff Wickman <cpw@sgi.com>
Subject: [PATCH] Revert "x86, UV: Make kdump avoid stack dumps"
Date: Mon,  9 May 2011 17:16:44 -0400
Message-Id: <1304975804-24443-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally these changes were added to hack around kdump calling into
the nmi handlers of the UV system and kdb.

However the true reason was the priorities were not setup correctly when
registering the nmi handlers.

During boot-up the UV system and kdb registered their nmi handlers without
any priority number assigned to it.  Therefore the die_notifier defaulted
to priority zero.  Later when kdump wanted to signal an NMI on all cpus to
shut them down, it had to register an nmi callback.  But it forgot to add
the priority.  Again the die_notifier used the default of zero.

When the die_register inserted kdump's nmi callback onto the die_chain, the
die_register noticed the other two nmi handlers with a priority zero and placed
kdump's nmi callback behind them.  So when an NMI came into the system, the
die_notifier called the UV and kdb handlers first, then kdumps.  This was
obviously not the intent when the kdump handler was written.

The fix is easy, increase the priority of the kdump handler.  This was already
done with commit 166d751479c6d4e5b17dfc1f204a9c4397c9b3f1.

I had George B. from SGI test this on a one-rack UV system with success.

This patch just cleans up the hack.  As long as the kdump NMI handler prioritizes
itself as the highest, we shouldin't run into the same problem as before.  Also
because most priorities are above zero, any handler that forgets to set their
priority winds up on the bottom of the queue instead of the top.

This reverts commit 1d6225e8cc5598f2bc5c992f9c88b1137763e8e1.
This reverts commit 5edd19af18a36a4e22c570b1b969179e0ca1fe4c.

Cc:  Cliff Wickman <cpw@sgi.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/kdebug.h      |    6 ------
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 ----
 arch/x86/kernel/crash.c            |    3 ---
 3 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index fe2cc6e..575f85b 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -31,11 +31,5 @@ extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
-#ifdef CONFIG_KEXEC
-extern int in_crash_kexec;
-#else
-/* no crash dump is ever in progress if no crash kernel can be kexec'd */
-#define in_crash_kexec 0
-#endif
 
 #endif /* _ASM_X86_KDEBUG_H */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 33b10a0..d026c99 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -644,10 +644,6 @@ int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 {
 	if (reason != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
-
-	if (in_crash_kexec)
-		/* do nothing if entering the crash kernel */
-		return NOTIFY_OK;
 	/*
 	 * Use a lock so only one cpu prints at a time
 	 * to prevent intermixed output.
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 764c7c2..ebd4c51 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -28,8 +28,6 @@
 #include <asm/reboot.h>
 #include <asm/virtext.h>
 
-int in_crash_kexec;
-
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct die_args *args)
@@ -63,7 +61,6 @@ static void kdump_nmi_callback(int cpu, struct die_args *args)
 
 static void kdump_nmi_shootdown_cpus(void)
 {
-	in_crash_kexec = 1;
 	nmi_shootdown_cpus(kdump_nmi_callback);
 
 	disable_local_APIC();
-- 
1.7.4.4

