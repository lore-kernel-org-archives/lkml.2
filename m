Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1HCPrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 11:47:43 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:57257 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634Ab1HCPr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:47:28 -0400
X-AuditID: 12074422-b7ba7ae000000a14-44-4e396d7aadf0
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/2] x86: Enable fast strings on Intel if BIOS hasn't already
Date: Wed,  3 Aug 2011 11:47:16 -0400
Message-Id: <add0a25293cd8bea549e6aea4f38ccc279a64556.1312386029.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312386029.git.luto@mit.edu>
References: <cover.1312386029.git.luto@mit.edu>
In-Reply-To: <cover.1312386029.git.luto@mit.edu>
References: <cover.1312386029.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsUixCmqrVuda+lncLuPw6LvylF2i7ZpjhaX
	d81hs/ix4TGrA4vHzll32T0W73nJ5LFpVSebx+dNcgEsUVw2Kak5mWWpRfp2CVwZ/xc+Yik4
	KVBxc0crYwPjWd4uRk4OCQETiWdLWtggbDGJC/fWA9lcHEIC+xglHh2dyAzhrGeUWHrmJCuE
	85RJom/rNnaQFjYBFYmOpQ+YQGwRAQOJLStfsILYzAKuEge2PWUEsYUFfCV6rt1kBrFZBFQl
	Vuw5B1bPKxAkcWFaKxPEajmJI5efg9mcQHOOty4Es4UE9CX+/l3Aikt8AqPAAkaGVYyyKblV
	urmJmTnFqcm6xcmJeXmpRbqmermZJXqpKaWbGEFhyO6itIPx50GlQ4wCHIxKPLyFSZZ+QqyJ
	ZcWVuYcYJTmYlER592UDhfiS8lMqMxKLM+KLSnNSiw8xSnAwK4nwtvMC5XhTEiurUovyYVLS
	HCxK4rwl3v99hQTSE0tSs1NTC1KLYLIyHBxKErybcoAaBYtS01Mr0jJzShDSTBycIMN5gIaD
	1fAWFyTmFmemQ+RPMSpKifNOAkkIgCQySvPgemFp4hWjONArwryd8UBVPMAUA9f9CmgwE9Dg
	/+8tQAaXJCKkpBoYI046LxN96HLgrs+9gjtvWP8cPNdUccvN5SZrv3Tks50CMXpreWIDHLzq
	bpu3p1Xn/tE8ozTx/umYIIszHic2vPj2U9No2/yu/S1h/x3tq+6XzjBw0bty5MyUX9PKnqtt
	viK47e/h7/MPfDWbMFn88fvf/a6/XTdwHoi65xYUaNfcYivbsaUxRYmlOCPRUIu5qDgRAL+o
	u6ruAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have two Sandy Bridge systems and neither one enables fast strings
in BIOS.  I can't find anything in the manual that says that only
BIOS should enable or disable the feature, so try to enable it at
bootup.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/cpu/intel.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ed6086e..6b20fef 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -30,6 +30,7 @@
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
+	bool allow_fast_string = true;
 
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
@@ -118,10 +119,11 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * (model 2) with the same problem.
 	 */
 	if (c->x86 == 15) {
-		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		allow_fast_string = false;
+		printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
 
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
-			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
 
 			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
 			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
@@ -135,6 +137,17 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+
+		if (allow_fast_string &&
+		    !(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
+			misc_enable |= MSR_IA32_MISC_ENABLE_FAST_STRING;
+			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+			printk(KERN_INFO "Enabled fast string operations\n");
+
+			/* Re-read to make sure it stuck. */
+			rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		}
+
 		if (!(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
 			printk(KERN_INFO "Disabled fast string operations\n");
 			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
-- 
1.7.6

