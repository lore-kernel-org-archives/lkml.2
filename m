Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab1CJOhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:37:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab1CJOhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:37:47 -0500
Date: Thu, 10 Mar 2011 15:28:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: + x86-mm-handle-mm_fault_error-in-kernel-space.patch added to
	-mm tree
Message-ID: <20110310142812.GA25224@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add cc's)

> Subject: x86/mm: handle mm_fault_error() in kernel space
> From: Andrey Vagin <avagin@openvz.org>
>
> mm_fault_error() should not execute oom-killer, if page fault occurs in
> kernel space.  E.g.  in copy_from_user/copy_to_user.

Why? I don't understand this part.

> This would happen if we find ourselves in OOM on a copy_to_user(), or a
> copy_from_user() which faults.
>
> Without this patch, the kernels hangs up in copy_from_user, because OOM
> killer sends SIG_KILL to current process,

This depends. OOM can choose another victim, and if it does we shouldn't
return -EFAULT.

> but it can't handle a signal
> while in syscall, then the kernel returns to copy_from_user, reexcute
> current command and provokes page_fault again.

Yes. This is buggy.

> --- a/arch/x86/mm/fault.c~x86-mm-handle-mm_fault_error-in-kernel-space
> +++ a/arch/x86/mm/fault.c
> @@ -827,6 +827,13 @@ mm_fault_error(struct pt_regs *regs, uns
>  	       unsigned long address, unsigned int fault)
>  {
>  	if (fault & VM_FAULT_OOM) {
> +		/* Kernel mode? Handle exceptions or die: */
> +		if (!(error_code & PF_USER)) {
> +			up_read(&current->mm->mmap_sem);
> +			no_context(regs, error_code, address);
> +			return;
> +		}
> +

At first glance, this is not optimal...

Perhaps I missed something, but afaics it is better to call
out_of_memory() first, then check if current was killed. In this case
no_context() is fine, we are not going to return to the user-mode.

IOW, what do you think about the (untested/uncompiled) patch below?

Oleg.

--- x/arch/x86/mm/fault.c
+++ x/arch/x86/mm/fault.c
@@ -829,6 +829,11 @@ mm_fault_error(struct pt_regs *regs, uns
 {
 	if (fault & VM_FAULT_OOM) {
 		out_of_memory(regs, error_code, address);
+
+		if (!(error_code & PF_USER) && fatal_signal_pending(current)) {
+			no_context(regs, error_code, address);
+			return;
+		}
 	} else {
 		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
 			     VM_FAULT_HWPOISON_LARGE))

