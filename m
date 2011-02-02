Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1BBApM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:45:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:28733 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab1BBApH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418386"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: robert.richter@amd.com, ak@linux.intel.com,
        oprofile-list@lists.sourceforge.net, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, rjw@sisk.pl, error27@gmail.com,
        akpm@linux-foundation.org, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [117/139] arch/x86/oprofile/op_model_amd.c: Perform initialisation on a single CPU
Message-Id: <20110202004516.3BC7C3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Robert Richter <robert.richter@amd.com>

commit c7c25802b39c443b3745cfa973dc49a97a3491f8 upstream.

Disable preemption in init_ibs(). The function only checks the
ibs capabilities and sets up pci devices (if necessary). It runs
only on one cpu but operates with the local APIC and some MSRs,
thus it is better to disable preemption.

[    7.034377] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/483
[    7.034385] caller is setup_APIC_eilvt+0x155/0x180
[    7.034389] Pid: 483, comm: modprobe Not tainted 2.6.37-rc1-20101110+ #1
[    7.034392] Call Trace:
[    7.034400]  [<ffffffff812a2b72>] debug_smp_processor_id+0xd2/0xf0
[    7.034404]  [<ffffffff8101e985>] setup_APIC_eilvt+0x155/0x180
[ ... ]

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=22812

Reported-by: <atswartz@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: oprofile-list@lists.sourceforge.net <oprofile-list@lists.sourceforge.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110103111514.GM4739@erda.amd.com>
[ small cleanups ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/op_model_amd.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/arch/x86/oprofile/op_model_amd.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/oprofile/op_model_amd.c
+++ linux-2.6.35.y/arch/x86/oprofile/op_model_amd.c
@@ -484,21 +484,29 @@ static int __init_ibs_nmi(void)
 	return 0;
 }
 
-/* initialize the APIC for the IBS interrupts if available */
+/*
+ * check and reserve APIC extended interrupt LVT offset for IBS if
+ * available
+ *
+ * init_ibs() preforms implicitly cpu-local operations, so pin this
+ * thread to its current CPU
+ */
+
 static void init_ibs(void)
 {
-	ibs_caps = get_ibs_caps();
+	preempt_disable();
 
+	ibs_caps = get_ibs_caps();
 	if (!ibs_caps)
-		return;
+		goto out;
 
-	if (__init_ibs_nmi()) {
+	if (__init_ibs_nmi() < 0)
 		ibs_caps = 0;
-		return;
-	}
+	else
+		printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n", ibs_caps);
 
-	printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n",
-	       (unsigned)ibs_caps);
+out:
+	preempt_enable();
 }
 
 static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
