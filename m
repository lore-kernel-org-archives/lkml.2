Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0JAC3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:29:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54972 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0JAC3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 22:29:06 -0400
X-Nat-Received: from [202.181.97.72]:63455 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1285900143.27405
Message-Id: <201010010229.o912T3rT089958@www262.sakura.ne.jp>
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Oct 2010 11:29:03 +0900
References: <201009302207.IJB81715.tFSLFHFOVJOOMQ@I-love.SAKURA.ne.jp>
In-Reply-To: <201009302207.IJB81715.tFSLFHFOVJOOMQ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 30092010 #4259328, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Is it legal to return positive value when do_execve() succeeds?

It seems to me that do_execve() should not return positive return code because
some callers are expecting do_execve() to return 0 on success.

linux-2.6.36-rc6/arch/x86/kernel/process.c:
304 long sys_execve(const char __user *name,
305                 const char __user *const __user *argv,
306                 const char __user *const __user *envp, struct pt_regs *regs)
307 {
308         long error;
309         char *filename;
310 
311         filename = getname(name);
312         error = PTR_ERR(filename);
313         if (IS_ERR(filename))
314                 return error;
315         error = do_execve(filename, argv, envp, regs);
316 
317 #ifdef CONFIG_X86_32
318         if (error == 0) {
319                 /* Make sure we don't return using sysenter.. */
320                 set_thread_flag(TIF_IRET);
321         }
322 #endif
323 
324         putname(filename);
325         return error;
326 }

But there are several "struct linux_binfmt"->load_binary() users who return
positive return code for error paths.

  load_elf_binary() will return positive return code if set_brk() returned
  positive return code.

  load_aout_binary() will return positive return code if do_brk() or
  do_mmap() returned unwanted result.

Are we using positive return code for telling unrecoverable errors?

send_sig(SIGKILL, current, 0) is used when execve() failed after reaching
"the point of no return", isn't it? But set_thread_flag(TIF_IRET) will not be
called if execve() failed after "the point of no return".

Is this no problem as the current task will be SIGKILL'ed as soon as returning
using sysenter()?

Regards.
