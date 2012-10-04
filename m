Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab2JDAHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:07:21 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64770 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038Ab2JDAHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:07:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121003234809.GG23473@ZenIV.linux.org.uk>
References: <506CBAFC.8010908@zankel.net>
	<20121003234809.GG23473@ZenIV.linux.org.uk>
Date: Thu, 4 Oct 2012 04:07:18 +0400
Message-ID: <CAMo8BfLbtCEEWUH0Nm-ust7nPYgs-AbHuVWhaiYHEQRhXjV43g@mail.gmail.com>
Subject: Re: [GIT PULL] xtensa patchset for 3.7
From: Max Filippov <jcmvbkbc@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Zankel <chris@zankel.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 3:48 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Oct 03, 2012 at 03:23:56PM -0700, Chris Zankel wrote:
>> Hi Linus,
>>
>> Please pull the changes for the Xtensa architecture for v3.7.
>>
>> Thanks,
>> -Chris
>
>         BTW, could you do an xtensa counterpart of the stuff in
> git.kernel.org/pub/scm/linux/kernel/git/viro/signal#experimental-kernel_thread?

I will try to do it, thanks for the outline.

> Basically,
>         * switch kernel_thread() away from "syscall in kernel" model;
> select GENERIC_KERNEL_THREAD in Kconfig and have copy_thread() check
> p->flags & PF_KTHREAD instead of user_mode(regs).  If it's true, set the
> child up so that it would wake up not in ret_from_fork() but in
> ret_from_kernel_thread(), the latter being
>         schedule_tail(last);
>         fn(arg);
>         sys_exit(0);
> where fn and arg would be picked from something set by copy_thread() - either
> pt_regs or callee-saved registers if your switch_to() deals with those (in
> the latter case you'll obviously have then already in place by the time your
> newborn kernel thread wakes up).  Have the same value for kernel stack pointer
> regardless of user_mode.  Use 'usp' for fn, 'unused' for arg and expect regs
> to be NULL.  Kill kernel_thread() in entry.S.
>         * add ret_from_kernel_execve() that would simply set sp to value
> normal for common_exception_return (i.e. what you used to set it when
> going into ret_from_kernel_thread()/ret_from_fork()) and branch to said
> common_exception_return().  Define __ARCH_WANT_KERNEL_EXECVE in unistd.h
> and kill kernel_execve() in entry.S.  ret_from_kernel_execve() will get as
> its argument task_pt_regs(current), which often spares us some calculations.
>         * define __ARCH_WANT_SYS_EXECVE in unistd.h, kill xtensa_execve();
> just use sys_execve instead.
>         * as an optimization, define current_pt_regs() as
> (struct pt_regs *)((unsigned long)current_thread_info() +
>  KERNEL_STACK_SIZE - (XCHAL_NUM_AREGS-16)*4) - 1).  I.e. an equivalent of
> task_pt_regs(current) without useless work - task_stack_page(current) is
> expanded to task_stack_page(current_thread_info()->task), which is
> equal to current_thread_info()...
>
> That would probably allow more glue removal - no more syscalls from the
> kernel, for one thing.  For another, xtensa_clone() won't need to locate
> struct pt_regs * - current_pt_regs() would work just as well and be faster
> anyway.  The same goes for xtensa_rt_sigreturn() and xtensa_sigaltstack()...

-- 
Thanks.
-- Max
