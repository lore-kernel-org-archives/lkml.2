Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1FNCv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 22:51:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44847 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1FNCv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 22:51:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF6CCB2.6060805@jp.fujitsu.com>
Date: Tue, 14 Jun 2011 11:51:30 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Avi Kivity <avi@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: [PATCH 1/2] x86, mce: introduce mce_memory_failure_process
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>	<4df13cea27302b7ccf@agluck-desktop.sc.intel.com>	<20110612223840.GA23218@aftab>	<BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>	<4DF5C36A.1040707@redhat.com>	<20110613095521.GA26316@aftab>	<4DF5F729.4060609@redhat.com>	<20110613124003.GA27918@aftab>	<4DF606C9.90308@redhat.com>	<20110613151208.GA29045@aftab>	<4DF63B7A.1030805@redhat.com> <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com> <4DF6CC58.8050601@jp.fujitsu.com>
In-Reply-To: <4DF6CC58.8050601@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
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
index 08363b0..26d7994 100644
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
 int mce_available(struct cpuinfo_x86 *c)
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


