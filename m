Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0GUUzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:55:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:37611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab0GUUzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:55:03 -0400
Date: Wed, 21 Jul 2010 20:54:45 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <E1ObLvt-0005UZ-Va@eag09.americas.sgi.com>
References: <E1ObLvt-0005UZ-Va@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Make kdump avoid stack dumps
Message-ID: <tip-5edd19af18a36a4e22c570b1b969179e0ca1fe4c@git.kernel.org>
Git-Commit-ID: 5edd19af18a36a4e22c570b1b969179e0ca1fe4c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 20:54:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5edd19af18a36a4e22c570b1b969179e0ca1fe4c
Gitweb:     http://git.kernel.org/tip/5edd19af18a36a4e22c570b1b969179e0ca1fe4c
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Tue, 20 Jul 2010 18:09:05 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 21 Jul 2010 11:33:27 -0700

x86, UV: Make kdump avoid stack dumps

UV NMI callback's should not write stack dumps when a kdump is to be written.

When invoking the crash kernel to write a dump, kdump_nmi_shootdown_cpus()
uses NMI's to get all the cpu's to save their register context and halt.

But the NMI interrupt handler runs a callback list.  This patch sets a flag
to prevent any of those callbacks from interfering with the halt of the cpu.

For UV, which currently has the only callback to which this is relevant, the
uv_handle_nmi() callback should not do dumping of stacks.

The 'in_crash_kexec' flag is defined as an extern in kdebug.h firstly
because x2apic_uv_x.c includes it.  Secondly because some future callback
might need the flag to know that it should not enter the debugger.
(Such a scenario was in fact present in the 2.6.32 kernel, SuSE distribution,
 where a call to kdb needed to be avoided.)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1ObLvt-0005UZ-Va@eag09.americas.sgi.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/kdebug.h      |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 ++++
 arch/x86/kernel/crash.c            |    3 +++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index fa7c0b9..7a2910b 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -33,5 +33,6 @@ extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
+extern int in_crash_kexec;
 
 #endif /* _ASM_X86_KDEBUG_H */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index e46f98f..7b598b8 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -604,6 +604,10 @@ int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 {
 	if (reason != DIE_NMI_IPI)
 		return NOTIFY_OK;
+
+	if (in_crash_kexec)
+		/* do nothing if entering the crash kernel */
+		return NOTIFY_OK;
 	/*
 	 * Use a lock so only one cpu prints at a time
 	 * to prevent intermixed output.
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index ebd4c51..764c7c2 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -28,6 +28,8 @@
 #include <asm/reboot.h>
 #include <asm/virtext.h>
 
+int in_crash_kexec;
+
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct die_args *args)
@@ -61,6 +63,7 @@ static void kdump_nmi_callback(int cpu, struct die_args *args)
 
 static void kdump_nmi_shootdown_cpus(void)
 {
+	in_crash_kexec = 1;
 	nmi_shootdown_cpus(kdump_nmi_callback);
 
 	disable_local_APIC();
