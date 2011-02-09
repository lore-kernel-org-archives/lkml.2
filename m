Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1BIWYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:24:42 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37795 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab1BIWYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=lRzloBX+NX/C1s0Q3XLoMbx9daEqJaj3wEwIH68Lee3xVW4IsEaZjm9P6fNxHPbtzf
         Ze6IitE45roQOoA13vgoP4Rf8A6j8SSwn6Wh6qxJMZo0UYelBnCpPBlVvLZZ939yq7bB
         +VK0cL0U5HNWnKQ1+USA4vXUbif+hve/PTZCA=
MIME-Version: 1.0
Date: Wed, 9 Feb 2011 17:24:39 -0500
Message-ID: <AANLkTikA3MT=eeMKg58HyYZRswUR+PMhYW978HEc0sst@mail.gmail.com>
Subject: Can anyone explain "movl %eax %eax"?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the kernel source, I see in a couple of places, there is "movl %eax
%eax". Is this used for alignment purpose?

For example, in the following piece of code we can see "movl %eax,%eax".

407 ENTRY(ia32_syscall)
408         CFI_STARTPROC32 simple
409         CFI_SIGNAL_FRAME
410         CFI_DEF_CFA     rsp,SS+8-RIP
411         /*CFI_REL_OFFSET        ss,SS-RIP*/
412         CFI_REL_OFFSET  rsp,RSP-RIP
413         /*CFI_REL_OFFSET        rflags,EFLAGS-RIP*/
414         /*CFI_REL_OFFSET        cs,CS-RIP*/
415         CFI_REL_OFFSET  rip,RIP-RIP
416         PARAVIRT_ADJUST_EXCEPTION_FRAME
417         SWAPGS
418         /*
419          * No need to follow this irqs on/off section: the syscall
420          * disabled irqs and here we enable it straight after entry:
421          */
422         ENABLE_INTERRUPTS(CLBR_NONE)
423         movl %eax,%eax
424         pushq %rax
425         CFI_ADJUST_CFA_OFFSET 8
426         cld
427         /* note the registers are not zero extended to the sf.
428            this could be a problem. */
429         SAVE_ARGS 0,0,1
430         GET_THREAD_INFO(%r10)
431         orl   $TS_COMPAT,TI_status(%r10)
432         testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
433         jnz ia32_tracesys
434         cmpq $(IA32_NR_syscalls-1),%rax
435         ja ia32_badsys
436 ia32_do_call:
437         IA32_ARG_FIXUP
438         call *ia32_sys_call_table(,%rax,8) # xxx: rip relative
439 ia32_sysret:
440         movq %rax,RAX-ARGOFFSET(%rsp)
441 ia32_ret_from_sys_call:
442         CLEAR_RREGS -ARGOFFSET
443         jmp int_ret_from_sys_call


Regards
Jidong
