Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2JRFj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 01:39:26 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46565 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2JRFjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 01:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <87ipa8o4mn.fsf@rustcorp.com.au>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
 <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com>
 <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com>
 <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au>
 <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com> <87ipa8o4mn.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 18 Oct 2012 02:39:04 -0300
Message-ID: <CAMOw1v4j5UVtneBTx1-FteEP53QqeMdH9GKnKs3OcybAceQxtg@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mtk.manpages@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        jonathon@jonmasters.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:12 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> Sure. But my point that started this subthread was: should we take the
>> opportunity now to add a 'flags' argument to the new finit_module()
>> system call, so as to allow flexibility in extending the behavior in
>> future? There have been so many cases of revised system calls in the
>> past few years that replaced calls without a 'flags' argument that it
>> seems worth at least some thought before the API is cast in stone.
>
> (CC's trimmed, Lucas & Jon added; please include them in module
> discussions!)
>
> So I tried to think of why we'd want flags; if I could think of a
> plausible reason, obviously we should do it now.
>
> I think it would be neat for the force flags (eg. ignoring modversions
> or ignoring kernel version).  These are the only cases where libkmod
> needs to mangle the module.

Maybe we should put this back into kernel. With an fd we can't mangle
the module anymore to ignore modversions or kernel version.

So yes, I think a 'flags' param is indeed needed.

Side note:  force won't work anymore by using init_module() and signed modules.

>
> So here's the patch which adds the flags field, but nothing in there
> yet.  I'll add the remove flags soon, so libkmod can assume that if the
> syscall exists, those flags will work.
>
> Thoughts?
> Rusty.
>
> FIX: add flags arg to sys_finit_module()
>
> Thanks to Michael Kerrisk for keeping us honest.
>
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 32bc035..8cf7b50 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -868,5 +868,5 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
>
>  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
>                          unsigned long idx1, unsigned long idx2);
> -asmlinkage long sys_finit_module(int fd, const char __user *uargs);
> +asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
>  #endif
> diff --git a/kernel/module.c b/kernel/module.c
> index 261bf82..8b8d986 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3260,7 +3260,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
>         return load_module(&info, uargs);
>  }
>
> -SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)
> +SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs, int, flags)
>  {
>         int err;
>         struct load_info info = { };
> @@ -3269,7 +3269,11 @@ SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)
>         if (err)
>                 return err;
>
> -       pr_debug("finit_module: fd=%d, uargs=%p\n", fd, uargs);
> +       pr_debug("finit_module: fd=%d, uargs=%p, flags=%i\n", fd, uargs, flags);
> +
> +       /* Coming RSN... */
> +       if (flags)
> +               return -EINVAL;
>
>         err = copy_module_from_fd(fd, &info);
>         if (err)


Ack.

Lucas De Marchi
