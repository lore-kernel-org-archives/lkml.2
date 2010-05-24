Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab0EXXHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:07:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:55309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758367Ab0EXXHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:07:12 -0400
Date: Mon, 24 May 2010 23:06:48 GMT
From: tip-bot for Kerstin Jonsson <kerstin.jonsson@ericsson.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jbohac@novell.com, kerstin.jonsson@ericsson.com,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       suresh.b.siddha@intel.com, trenn@suse.de, tglx@linutronix.de,
       hpa@linux.intel.com, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbohac@novell.com, yinghai@kernel.org, kerstin.jonsson@ericsson.com,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       suresh.b.siddha@intel.com, trenn@suse.de, tglx@linutronix.de,
       hpa@linux.intel.com, avi@redhat.com
In-Reply-To: <201005241913.o4OJDGWM010865@imap1.linux-foundation.org>
References: <201005241913.o4OJDGWM010865@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic: ack all pending irqs when crashed/on kexec
Message-ID: <tip-8c3ba8d049247dc06b6dcee1711a11b26647aa44@git.kernel.org>
Git-Commit-ID: 8c3ba8d049247dc06b6dcee1711a11b26647aa44
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 24 May 2010 23:06:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c3ba8d049247dc06b6dcee1711a11b26647aa44
Gitweb:     http://git.kernel.org/tip/8c3ba8d049247dc06b6dcee1711a11b26647aa44
Author:     Kerstin Jonsson <kerstin.jonsson@ericsson.com>
AuthorDate: Mon, 24 May 2010 12:13:15 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 24 May 2010 13:31:35 -0700

x86, apic: ack all pending irqs when crashed/on kexec

When the SMP kernel decides to crash_kexec() the local APICs may have
pending interrupts in their vector tables.

The setup routine for the local APIC has a deficient mechanism for
clearing these interrupts, it only handles interrupts that has already
been dispatched to the local core for servicing (the ISR register) safely,
it doesn't consider lower prioritized queued interrupts stored in the IRR
register.

If you have more than one pending interrupt within the same 32 bit word in
the LAPIC vector table registers you may find yourself entering the IO
APIC setup with pending interrupts left in the LAPIC.  This is a situation
for wich the IO APIC setup is not prepared.  Depending of what/which
interrupt vector/vectors are stuck in the APIC tables your system may show
various degrees of malfunctioning.  That was the reason why the
check_timer() failed in our system, the timer interrupts was blocked by
pending interrupts from the old kernel when routed trough the IO APIC.

Additional comment from Jiri Bohac:
==============
If this should go into stable release,
I'd add some kind of limit on the number of iterations, just to be safe from
hard to debug lock-ups:

+if (loops++  > MAX_LOOPS) {
+        printk("LAPIC pending clean-up")
+        break;
+}
 while (queued);

with MAX_LOOPS something like 1E9 this would leave plenty of time for the
pending IRQs to be cleared and would and still cause at most a second of delay
if the loop were to lock-up for whatever reason.

[trenn@suse.de:

V2: Use tsc if avail to bail out after 1 sec due to possible virtual
    apic_read calls which may take rather long (suggested by: Avi Kivity
    <avi@redhat.com>) If no tsc is available bail out quickly after
    cpu_khz, if we broke out too early and still have irqs pending (which
    should never happen?) we still get a WARN_ON...

V3: - Fixed indentation -> checkpatch clean
    - max_loops must be signed

V4: - Fix typo, mixed up tsc and ntsc in first rdtscll() call

V5: Adjust WARN_ON() condition to also catch error in cpu_has_tsc case]

Cc: <jbohac@novell.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
LKML-Reference: <201005241913.o4OJDGWM010865@imap1.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c |   41 +++++++++++++++++++++++++++++++++--------
 1 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e5a4a1e..c02cc69 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -51,6 +51,7 @@
 #include <asm/smp.h>
 #include <asm/mce.h>
 #include <asm/kvm_para.h>
+#include <asm/tsc.h>
 
 unsigned int num_processors;
 
@@ -1151,8 +1152,13 @@ static void __cpuinit lapic_setup_esr(void)
  */
 void __cpuinit setup_local_APIC(void)
 {
-	unsigned int value;
-	int i, j;
+	unsigned int value, queued;
+	int i, j, acked = 0;
+	unsigned long long tsc = 0, ntsc;
+	long long max_loops = cpu_khz;
+
+	if (cpu_has_tsc)
+		rdtscll(tsc);
 
 	if (disable_apic) {
 		arch_disable_smp_support();
@@ -1204,13 +1210,32 @@ void __cpuinit setup_local_APIC(void)
 	 * the interrupt. Hence a vector might get locked. It was noticed
 	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
 	 */
-	for (i = APIC_ISR_NR - 1; i >= 0; i--) {
-		value = apic_read(APIC_ISR + i*0x10);
-		for (j = 31; j >= 0; j--) {
-			if (value & (1<<j))
-				ack_APIC_irq();
+	do {
+		queued = 0;
+		for (i = APIC_ISR_NR - 1; i >= 0; i--)
+			queued |= apic_read(APIC_IRR + i*0x10);
+
+		for (i = APIC_ISR_NR - 1; i >= 0; i--) {
+			value = apic_read(APIC_ISR + i*0x10);
+			for (j = 31; j >= 0; j--) {
+				if (value & (1<<j)) {
+					ack_APIC_irq();
+					acked++;
+				}
+			}
 		}
-	}
+		if (acked > 256) {
+			printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
+			       acked);
+			break;
+		}
+		if (cpu_has_tsc) {
+			rdtscll(ntsc);
+			max_loops = (cpu_khz << 10) - (ntsc - tsc);
+		} else
+			max_loops--;
+	} while (queued && max_loops > 0);
+	WARN_ON(max_loops <= 0);
 
 	/*
 	 * Now that we are all set up, enable the APIC
