Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2CZQkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:40:04 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62751 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab2CZQkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:40:02 -0400
Message-ID: <4F709BC3.4070601@windriver.com>
Date: Mon, 26 Mar 2012 11:39:31 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>,
        <tim.bird@am.sony.com>
Subject: Re: [PATCH 2/2] kgdb,debug_core,kgdbts: End DEBUG_RODATA limitation
 using kprobe breakpoints
References: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com> <1332352536-29186-3-git-send-email-jason.wessel@windriver.com> <4F6A9444.4050603@hitachi.com> <4F6B13BC.2070406@windriver.com> <4F6C83C1.9050704@hitachi.com> <4F6C8AD9.40201@windriver.com> <4F703AE6.5020809@hitachi.com>
In-Reply-To: <4F703AE6.5020809@hitachi.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 04:46 AM, Masami Hiramatsu wrote:
> (2012/03/23 23:38), Jason Wessel wrote:
>> On 03/23/2012 09:08 AM, Masami Hiramatsu wrote:
>>> (2012/03/22 20:57), Jason Wessel wrote:
>>>> I will use the arch specific provision to override the
>>>> kgdb_arch_set_breakpoint() and use the text_poke() directly.
>>>
>>> Thanks! that's what I meant. You can use __weak attribute.
>>>
>>
>> I created and tested a patch yesterday which is show below.  I will
>> post a new series at some point soon which addresses this problem as
>> well as a number of problems found with the kgdb test suite.
> 
> Yeah, that's better.
> 
> BTW, I'm not sure the policy of kgdb about mutex, but it seems
> that you need to hold a text_mutex when you call the text_poke()
> since it uses a fixmap page-area for mapping read-only text page
> to writable page. So, without locking (at least ensuring no one
> using) text_mutex, it seems not be safe. (some other code may be
> trying to change the code by using same fixmap pages)

Thank you very much for the advice.  I had run the kgdb mutex
validation which checks for mutex's taken any time I change the kgdb
code and it passed.  However, this did not check for incorrect usage
where the debug core should really be taking a mutex to prevent
corruption.  The comments in the text_poke code clearly indicate a
caller must hold the text_mutex().

I started looking through all the code that uses text_mutex and what
it actually protects.  It looked like it is probably possible to make
things re-entrant in order to deal with the case where debugger changes
a location with a fixmap when kernel execution is stopped.  I am not
convinced this is a good idea, given complexity of the code, vs the
small number of users and the likely hood of interference being on the
low side.  For now, I am not going to pursue making any kind of
changes with fix map or the text_mutex protected regions.  Today there
are only 3 users of the text_mutex, SMP alternatives, jump labels
updates, and kprobes, so the risk for collision is fairly low.

At the point in time that the collisions become a real problem, such
as kgdb starting to use kprobes directly, changing some code for
special re-entrance considerations after using the kernel debugger
might get considered again.  Until then, I will use the simple
approach of checking the mutex and use text_poke() if it is not locked
when the normal kernel execution is stopped on all cores.

The delta to the previous patch is shown below.

Thanks,
Jason.


diff -u b/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
--- b/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -757,6 +757,12 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 #ifdef CONFIG_DEBUG_RODATA
 	if (!err)
 		return err;
+	/* 
+	 * It is safe to call text_poke() because normal kernel execution
+	 * is stopped on all cores, so long as the text_mutex is not locked.
+	 */
+	if (mutex_is_locked(&text_mutex)
+		return -EBUSY;
 	text_poke((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
 		  BREAK_INSTR_SIZE);
 	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
@@ -777,6 +783,12 @@ int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 
 	if (bpt->type != BP_POKE_BREAKPOINT)
 		goto knl_write;
+	/* 
+	 * It is safe to call text_poke() because normal kernel execution
+	 * is stopped on all cores, so long as the text_mutex is not locked.
+	 */
+	if (mutex_is_locked(&text_mutex)
+		goto knl_write;
 	text_poke((void *)bpt->bpt_addr, bpt->saved_instr, BREAK_INSTR_SIZE);
 	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
 	if (err || memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
