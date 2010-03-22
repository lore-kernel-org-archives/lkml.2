Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0CVPVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:21:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35114 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0CVPVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:21:15 -0400
From: Colin King <colin.king@canonical.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Disable 4MB page tables for Atom, work around errata AAE44
Date: Mon, 22 Mar 2010 15:20:51 +0000
Message-Id: <1269271251-19775-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

BugLink: https://bugs.launchpad.net/bugs/523112
BugLink: https://bugs.launchpad.net/bugs/322867

This patch addresses Intel errata AAE44 by totally disabling 4MB
pages and thus avoiding avoiding large pages being split into
smaller 4K pages and thus never tripping this CPU issue.

The bug can manifests itself as instruction fetch oopses on seemingly
legitimate executable pages.

Errata AAE44 (http://download.intel.com/design/processor/specupdt/319536.pdf
page 33) states:

"If software clears the PS (page size) bit in a present PDE (page directory
entry), that will cause linear addresses mapped through this PDE to use
4-KByte pages instead of using a large page after old TLB entries are
invalidated. Due to this erratum, if a code fetch uses this PDE before the
TLB entry for the large page is invalidated then it may fetch from a different
physical address than specified by either the old large page translation or
the new 4-KByte page translation. This erratum may also cause speculative code
fetches from incorrect addresses."

Where as commit 211b3d03c7400f48a781977a50104c9d12f4e229 seems to workaround
errata AAH41 (mixed 4K TLBs) it reduces the window of opportunity for the
bug to occur and does not totally remove it.  This patch disables mixed
4K/4MB page tables totally avoiding the page splitting and not tripping
this processor issue.

Without this workaround, one particular Z530 system with a lot of
filesystem activity and low memory pressure would panic randomly after
a few days soak testing. With this patch, the system ran flawlessly.

Also, this fixes random boot crashes on an Acer Asprire One.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/kernel/cpu/bugs.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 01a2652..32e49f3 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -151,6 +151,20 @@ static void __init check_config(void)
 #endif
 }
 
+static void __init check_atom(void)
+{
+
+	/*
+	 *  Disable 4MB page tables to work around Intel errata AAE44 for
+	 *  Atom. We cannot guarantee stopping undefined processor behaviour
+	 *  when two pageing structure translations differ with respect to
+	 *  page frame sizes.  Hence, for Atoms we disable the PSE.
+	 */
+	if (boot_cpu_data.x86_model == 0x1c) {
+		clear_bit(X86_FEATURE_PSE, boot_cpu_data.x86_capability);
+		printk(KERN_INFO "Disabling 4MB page tables to avoid TLB bug\n");
+	}
+}
 
 void __init check_bugs(void)
 {
@@ -163,6 +177,7 @@ void __init check_bugs(void)
 	check_fpu();
 	check_hlt();
 	check_popad();
+	check_atom();
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
-- 
1.6.3.3

