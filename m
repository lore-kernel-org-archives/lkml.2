Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1AFAbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:31 -0500
Received: from kroah.org ([198.145.64.141]:36040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab1AFAb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:28 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:08 2011
Message-Id: <20110106002308.521042829@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Dan Carpenter <error27@gmail.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [125/152] arch/x86/oprofile/op_model_amd.c: Perform initialisation on a single CPU
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
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


