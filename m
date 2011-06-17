Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab1FQIrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:47:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41077 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab1FQIrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:47:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFB1476.40804@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 17:46:46 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH 6/8] x86, mce: introduce mce_memory_failure_process()
References: <4DFB1242.90404@jp.fujitsu.com>
In-Reply-To: <4DFB1242.90404@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And relocate related functions to near by mce_ring* routines.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0424299..a118496 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -395,6 +395,8 @@ static inline void mce_gather_info(struct mce *m, struct pt_regs *regs)
 }
 
 /*
+ * mce_ring, mce_memory_failure: Support for Memory errors
+ *
  * Simple lockless ring to communicate PFNs from the exception handler with the
  * process context work function. This is vastly simplified because there's
  * only a single reader and a single writer.
@@ -449,6 +451,20 @@ static int mce_ring_add(unsigned long pfn)
 	return 0;
 }
 
+/* dummy to break dependency. actual code is in mm/memory-failure.c */
+void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
+{
+	pr_err("Action optional memory failure at %lx ignored\n", pfn);
+}
+
+static inline void mce_memory_failure_process(void)
+{
+	unsigned long pfn;
+
+	while (mce_ring_get(&pfn))
+		memory_failure(pfn, MCE_VECTOR);
+}
+
 static int mce_available(struct cpuinfo_x86 *c)
 {
 	if (mce_disabled)
@@ -1049,12 +1065,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
 
-/* dummy to break dependency. actual code is in mm/memory-failure.c */
-void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
-{
-	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
-}
-
 /*
  * Called after mce notification in process context. This code
  * is allowed to sleep. Call the high level VM handler to process
@@ -1068,10 +1078,8 @@ void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
  */
 void mce_notify_process(void)
 {
-	unsigned long pfn;
 	mce_notify_irq();
-	while (mce_ring_get(&pfn))
-		memory_failure(pfn, MCE_VECTOR);
+	mce_memory_failure_process();
 }
 
 static void mce_process_work(struct work_struct *dummy)
-- 
1.7.1


