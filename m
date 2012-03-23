Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2CWOij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:38:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62084 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab2CWOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:38:37 -0400
Message-ID: <4F6C8AD9.40201@windriver.com>
Date: Fri, 23 Mar 2012 09:38:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>,
        <tim.bird@am.sony.com>
Subject: Re: [PATCH 2/2] kgdb,debug_core,kgdbts: End DEBUG_RODATA limitation
 using kprobe breakpoints
References: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com> <1332352536-29186-3-git-send-email-jason.wessel@windriver.com> <4F6A9444.4050603@hitachi.com> <4F6B13BC.2070406@windriver.com> <4F6C83C1.9050704@hitachi.com>
In-Reply-To: <4F6C83C1.9050704@hitachi.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 09:08 AM, Masami Hiramatsu wrote:
> (2012/03/22 20:57), Jason Wessel wrote:
>> I will use the arch specific provision to override the
>> kgdb_arch_set_breakpoint() and use the text_poke() directly.
> 
> Thanks! that's what I meant. You can use __weak attribute.
> 

I created and tested a patch yesterday which is show below.  I will
post a new series at some point soon which addresses this problem as
well as a number of problems found with the kgdb test suite.

Cheers,
Jason.


Subject: [PATCH] x86,kgdb: End DEBUG_RODATA limitation using text_poke()

There has long been a limitation using software breakpoints with a
kernel compiled with CONFIG_DEBUG_RODATA.  The kprobes code has long
used the text_poke() function which accommodates writing a breakpoint
into a read-only page.  The x86 arch can override the default
breakpoint install remove routines and make use of the text_poke()
code that comes from the x86 alternatives.

The x86 arch will first attempt to use the traditional
probe_kernel_write(), and next try using a the text_poke() function.
The break point install method is tracked such that the correct break
point removal routine will get called later on.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kgdb.h   |    3 ++-
 2 files changed, 48 insertions(+), 1 deletion(-)

--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -63,7 +63,8 @@ enum kgdb_bptype {
 	BP_HARDWARE_BREAKPOINT,
 	BP_WRITE_WATCHPOINT,
 	BP_READ_WATCHPOINT,
-	BP_ACCESS_WATCHPOINT
+	BP_ACCESS_WATCHPOINT,
+	BP_POKE_BREAKPOINT,
 };
 
 enum kgdb_bpstate {
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -742,6 +742,52 @@ void kgdb_arch_set_pc(struct pt_regs *re
 	regs->ip = ip;
 }
 
+int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
+{
+	int err;
+	char opc[BREAK_INSTR_SIZE];
+
+	bpt->type = BP_BREAKPOINT;
+	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
+				BREAK_INSTR_SIZE);
+	if (err)
+		return err;
+	err = probe_kernel_write((char *)bpt->bpt_addr,
+				 arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE);
+#ifdef CONFIG_DEBUG_RODATA
+	if (!err)
+		return err;
+	text_poke((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
+		  BREAK_INSTR_SIZE);
+	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
+	if (err)
+		return err;
+	if (memcmp(opc, arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE))
+		return -EINVAL;
+	bpt->type = BP_POKE_BREAKPOINT;
+#endif /* CONFIG_DEBUG_RODATA */
+	return err;
+}
+
+int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
+{
+#ifdef CONFIG_DEBUG_RODATA
+	int err;
+	char opc[BREAK_INSTR_SIZE];
+
+	if (bpt->type != BP_POKE_BREAKPOINT)
+		goto knl_write;
+	text_poke((void *)bpt->bpt_addr, bpt->saved_instr, BREAK_INSTR_SIZE);
+	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
+	if (err || memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
+		goto knl_write;
+	return err;
+knl_write:
+#endif /* CONFIG_DEBUG_RODATA */
+	return probe_kernel_write((char *)bpt->bpt_addr,
+				  (char *)bpt->saved_instr, BREAK_INSTR_SIZE);
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: */
 	.gdb_bpt_instr		= { 0xcc },

