Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2HAWDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 18:03:17 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab2HAWDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 18:03:16 -0400
Message-ID: <5019A79B.3040600@nod.at>
Date: Thu, 02 Aug 2012 00:03:07 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Meredydd Luff <meredydd@senatehouse.org>
CC: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jeff Dike <jdike@addtoit.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RFC] syscalls,x86: Add execveat() system call
References: <1343857476-3073-1-git-send-email-meredydd@senatehouse.org>
In-Reply-To: <1343857476-3073-1-git-send-email-meredydd@senatehouse.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.08.2012 23:44, Meredydd Luff wrote:
> HPA is already on record calling for an execveat() which also does
> fexecve()'s job: https://lkml.org/lkml/2006/7/11/556.
> And the current glibc hack for fexecve() is already causing problems
> in the wild. Eg: https://bugzilla.redhat.com/show_bug.cgi?id=241609,
> https://lkml.org/lkml/2006/12/27/123, and as recounted at
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=514043.
>
> So here's an attempt at just that:
>
> ----------------------------------------------------------------------
>
> This patch adds a new system call, execveat(2). execveat() is to
> execve() as openat() is to open(): it takes file descriptor that
> refers to a directory, and resolves the filename relative to that.
>
> In addition, if the filename is NULL, execveat() executes the file
> to which the file descriptor refers. This replicates the functionality
> of fexecve(), which is a system call in other UNIXen, but in Linux
> glibc v2.16 it's a gross hack that depends on /proc being mounted.
> That hack does not work in chrooted sandboxes, or stripped-down
> systems without /proc mounted. execveat() does.
>
> Only x86-64 and i386 ABIs are supported in this patch. User-Mode Linux
> is also supported.
>
> Signed-off-by: Meredydd Luff <meredydd@senatehouse.org>
> ---
>   CREDITS                           |    5 +++
>   arch/alpha/kernel/binfmt_loader.c |    2 +-
>   arch/um/kernel/exec.c             |   36 ++++++++++++++++----
>   arch/x86/ia32/ia32entry.S         |    1 +
>   arch/x86/ia32/sys_ia32.c          |   20 +++++++++++
>   arch/x86/include/asm/sys_ia32.h   |    3 ++
>   arch/x86/kernel/entry_32.S        |   17 ++++++++++
>   arch/x86/kernel/entry_64.S        |   15 ++++++++
>   arch/x86/kernel/process.c         |   27 +++++++++++++++
>   arch/x86/syscalls/syscall_32.tbl  |    1 +
>   arch/x86/syscalls/syscall_64.tbl  |    1 +
>   arch/x86/um/sys_call_table_32.c   |    1 +
>   arch/x86/um/sys_call_table_64.c   |    1 +
>   fs/binfmt_elf.c                   |    2 +-
>   fs/binfmt_elf_fdpic.c             |    2 +-
>   fs/binfmt_em86.c                  |    2 +-
>   fs/binfmt_flat.c                  |    2 +-
>   fs/binfmt_misc.c                  |    2 +-
>   fs/binfmt_script.c                |    2 +-
>   fs/exec.c                         |   65 ++++++++++++++++++++++++++++++------
>   include/asm-generic/syscalls.h    |    7 ++++
>   include/linux/compat.h            |    2 +
>   include/linux/fs.h                |    2 +-
>   include/linux/sched.h             |    3 ++
>   24 files changed, 195 insertions(+), 26 deletions(-)
>
> diff --git a/CREDITS b/CREDITS
> index d8fe12a..859b40b 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -2177,6 +2177,11 @@ S: Asterisk Ltd.
>   S: Auckland
>   S: New Zealand
>
> +N: Meredydd Luff
> +E: meredydd@senatehouse.org
> +W: http://www.senatehouse.org/
> +D: execveat() system call
> +

CREDITS is no longer used.
git log is the new CREDITS file. :-)

>   N: Tuomas J. Lukka
>   E: Tuomas.Lukka@Helsinki.FI
>   D: Original dual-monitor patches
> diff --git a/arch/alpha/kernel/binfmt_loader.c b/arch/alpha/kernel/binfmt_loader.c
> index d1f474d..7968491 100644
> --- a/arch/alpha/kernel/binfmt_loader.c
> +++ b/arch/alpha/kernel/binfmt_loader.c
> @@ -24,7 +24,7 @@ static int load_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>
>   	loader = bprm->vma->vm_end - sizeof(void *);
>
> -	file = open_exec("/sbin/loader");
> +	file = open_exec(AT_FDCWD, "/sbin/loader");
>   	retval = PTR_ERR(file);
>   	if (IS_ERR(file))
>   		return retval;
> diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
> index 6cade93..cd7b2a9 100644
> --- a/arch/um/kernel/exec.c
> +++ b/arch/um/kernel/exec.c
> @@ -5,6 +5,7 @@
>
>   #include <linux/stddef.h>
>   #include <linux/module.h>
> +#include <linux/fcntl.h>
>   #include <linux/fs.h>
>   #include <linux/ptrace.h>
>   #include <linux/sched.h>
> @@ -44,13 +45,13 @@ void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
>   }
>   EXPORT_SYMBOL(start_thread);
>
> -static long execve1(const char *file,
> -		    const char __user *const __user *argv,
> -		    const char __user *const __user *env)
> +static long execveat1(int dfd, const char *file,
> +		      const char __user *const __user *argv,
> +		      const char __user *const __user *env)
>   {
>   	long error;
>
> -	error = do_execve(file, argv, env, &current->thread.regs);
> +	error = do_execveat(dfd, file, argv, env, &current->thread.regs);
>   	if (error == 0) {
>   		task_lock(current);
>   		current->ptrace &= ~PT_DTRACE;
> @@ -66,7 +67,7 @@ long um_execve(const char *file, const char __user *const __user *argv, const ch
>   {
>   	long err;
>
> -	err = execve1(file, argv, env);
> +	err = execveat1(AT_FDCWD, file, argv, env);
>   	if (!err)
>   		UML_LONGJMP(current->thread.exec_buf, 1);
>   	return err;
> @@ -80,9 +81,30 @@ long sys_execve(const char __user *file, const char __user *const __user *argv,
>
>   	filename = getname(file);
>   	error = PTR_ERR(filename);
> -	if (IS_ERR(filename)) goto out;
> -	error = execve1(filename, argv, env);
> +	if (IS_ERR(filename))
> +		goto out;

Please send this coding style fix as separate patch.

Thanks,
//richard
