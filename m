Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982Ab1FWRnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:43:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:35634 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933842Ab1FWRim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 228/247] arch/x86/oprofile/op_model_amd.c: Perform initialisation on a single CPU
Date: Thu, 23 Jun 2011 13:34:56 -0400
Message-Id: <1308850515-15242-169-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Cc: oprofile-list@lists.sourceforge.net <oprofile-list@lists.sourceforge.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110103111514.GM4739@erda.amd.com>
[ small cleanups ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/oprofile/op_model_amd.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 090cbbe..c8f46aa 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -497,21 +497,29 @@ static void clear_ibs_nmi(void)
 		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
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
 static void ibs_init(void)
 {
-	ibs_caps = get_ibs_caps();
+	preempt_disable();
 
+	ibs_caps = get_ibs_caps();
 	if (!ibs_caps)
-		return;
+		goto out;
 
-	if (init_ibs_nmi()) {
+	if (init_ibs_nmi() < 0)
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
 
 static void ibs_exit(void)
-- 
1.7.4.4

