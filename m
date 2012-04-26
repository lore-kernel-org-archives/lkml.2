Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2DZSfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:35:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab2DZSfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:35:10 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=AGHt8YwReDUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=w5VV8SvDmR3sKYw9RUYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426183509.157684433@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 26 Apr 2012 14:31:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3/3][RFC] ftrace/ppc: Use patch_instruction instead of probe_kernel_write()
References: <20120426183116.857877522@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-ppc-Use-patch_instruction-instead-of-probe_ke.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The patch_instruction() interface is made to modify kernel text. It is
safer to use that then the probe_kernel_write() when modifying kernel
code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/kernel/ftrace.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 84a5ddd..4e376bc 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -63,11 +63,9 @@ ftrace_modify_code(unsigned long ip, unsigned int old, unsigned int new)
 		return -EINVAL;
 
 	/* replace the text with the new text */
-	if (probe_kernel_write((void *)ip, &new, MCOUNT_INSN_SIZE))
+	if (patch_instruction((unsigned int *)ip, new))
 		return -EPERM;
 
-	flush_icache_range(ip, ip + 8);
-
 	return 0;
 }
 
@@ -212,12 +210,9 @@ __ftrace_make_nop(struct module *mod,
 	 */
 	op = 0x48000008;	/* b +8 */
 
-	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
+	if (patch_instruction((unsigned int *)ip, op))
 		return -EPERM;
 
-
-	flush_icache_range(ip, ip + 8);
-
 	return 0;
 }
 
@@ -286,11 +281,9 @@ __ftrace_make_nop(struct module *mod,
 
 	op = PPC_INST_NOP;
 
-	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
+	if (patch_instruction((unsigned int *)ip, op))
 		return -EPERM;
 
-	flush_icache_range(ip, ip + 8);
-
 	return 0;
 }
 #endif /* PPC64 */
@@ -426,11 +419,9 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 	pr_devel("write to %lx\n", rec->ip);
 
-	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
+	if (patch_instruction((unsigned int *)ip, op))
 		return -EPERM;
 
-	flush_icache_range(ip, ip + 8);
-
 	return 0;
 }
 #endif /* CONFIG_PPC64 */
-- 
1.7.9.5


