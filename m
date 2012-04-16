Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab2DPCVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 22:21:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49298 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2DPCVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 22:21:37 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 1/2] Introduce crash ipi helpers to wait for APs to stop
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, vgoyal@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp
Date: Mon, 16 Apr 2012 11:21:33 +0900
Message-ID: <20120416022133.9303.41287.stgit@localhost6.localdomain6>
In-Reply-To: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce crash ipi helpers to use them from BSP and AP sides in
common.

There's no logical change in this patch.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 arch/x86/include/asm/reboot.h |    4 +++
 arch/x86/kernel/reboot.c      |   53 ++++++++++++++++++++++++++++++++---------
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 92f29706..2f8e9e7 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -26,4 +26,8 @@ void machine_real_restart(unsigned int type);
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
 
+void crash_ipi_init(void);
+void crash_ipi_dec_and_halt(void);
+void crash_ipi_wait_for_APs(void);
+
 #endif /* _ASM_X86_REBOOT_H */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..6dd77a8 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -769,6 +769,31 @@ static nmi_shootdown_cb shootdown_callback;
 
 static atomic_t waiting_for_crash_ipi;
 
+void crash_ipi_init(void)
+{
+	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
+}
+
+void crash_ipi_dec_and_halt(void)
+{
+	atomic_dec(&waiting_for_crash_ipi);
+	/* Assume hlt works */
+	halt();
+	for (;;)
+		cpu_relax();
+}
+
+void crash_ipi_wait_for_APs(void)
+{
+	unsigned long msecs;
+
+	msecs = 1000; /* Wait at most a second for the other cpus to stop */
+	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
+		mdelay(1);
+		msecs--;
+	}
+}
+
 static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 {
 	int cpu;
@@ -785,11 +810,7 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 
 	shootdown_callback(cpu, regs);
 
-	atomic_dec(&waiting_for_crash_ipi);
-	/* Assume hlt works */
-	halt();
-	for (;;)
-		cpu_relax();
+	crash_ipi_dec_and_halt();
 
 	return NMI_HANDLED;
 }
@@ -807,7 +828,6 @@ static void smp_send_nmi_allbutself(void)
  */
 void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 {
-	unsigned long msecs;
 	local_irq_disable();
 
 	/* Make a note of crashing cpu. Will be used in NMI callback.*/
@@ -815,7 +835,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 	shootdown_callback = callback;
 
-	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
+	crash_ipi_init();
+
 	/* Would it be better to replace the trap vector here? */
 	if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
 				 NMI_FLAG_FIRST, "crash"))
@@ -827,11 +848,7 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 
 	smp_send_nmi_allbutself();
 
-	msecs = 1000; /* Wait at most a second for the other cpus to stop */
-	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
-		mdelay(1);
-		msecs--;
-	}
+	crash_ipi_wait_for_APs();
 
 	/* Leave the nmi callback set */
 }
@@ -840,4 +857,16 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 {
 	/* No other CPUs to shoot down */
 }
+
+void crash_ipi_init(void)
+{
+}
+
+void crash_ipi_dec_and_halt(void)
+{
+}
+
+void crash_ipi_wait_for_APs(void)
+{
+}
 #endif

