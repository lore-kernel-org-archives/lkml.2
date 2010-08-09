Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0HIPzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:55:54 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:36134 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756603Ab0HIPzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:55:52 -0400
X-Greylist: delayed 1565 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Aug 2010 11:55:50 EDT
Message-ID: <4C601ECD.2070503@st.com>
Date: Mon, 9 Aug 2010 16:29:17 +0100
From: Stuart Menefy <stuart.menefy@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh: remove RELOC_HIDE on exception handlers and syscall
 routines
References: <1281300825-3327-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281300825-3327-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately these are necessary, although it is nothing to do with linker
relocation. These functions take a struct pt_regs as a parameter (not a
pointer), and modify some of the fields of that structure. We needed a way
to ensure that gcc didn't optimise away those assignments - to gcc
they appear to be assignments to a local variable, so quite legitimately
get optimised away. So we used RELOC_HIDE() as a way of doing that.

A clearer way to do this would be to pass in a struct pt_regs pointer,
but that would require going via a stub function which loads up the
pointer.

Stuart

On 08/08/10 21:53, Namhyung Kim wrote:
> remove unneccessary use of RELOC_HIDE(). It does simple addition of ptr and
> offset and in this case (offset 0) does practically nothing. It does NOT do
> anything with linker relocation.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  arch/sh/include/asm/system.h |    2 +-
>  arch/sh/kernel/process_32.c  |    8 ++++----
>  arch/sh/kernel/signal_32.c   |    6 +++---
>  arch/sh/kernel/sys_sh32.c    |    2 +-
>  arch/sh/kernel/traps_32.c    |    6 +++---
>  5 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/sh/include/asm/system.h b/arch/sh/include/asm/system.h
> index 0bd7a17..8125c6c 100644
> --- a/arch/sh/include/asm/system.h
> +++ b/arch/sh/include/asm/system.h
> @@ -154,7 +154,7 @@ asmlinkage void name##_trap_handler(unsigned long r4, unsigned long r5,	\
>  				    struct pt_regs __regs)
>  
>  #define TRAP_HANDLER_DECL				\
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);	\
> +	struct pt_regs *regs = &__regs;			\
>  	unsigned int vec = regs->tra;			\
>  	(void)vec;
>  #else
> diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
> index 0529819..95c9de1 100644
> --- a/arch/sh/kernel/process_32.c
> +++ b/arch/sh/kernel/process_32.c
> @@ -253,7 +253,7 @@ asmlinkage int sys_fork(unsigned long r4, unsigned long r5,
>  			struct pt_regs __regs)
>  {
>  #ifdef CONFIG_MMU
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	return do_fork(SIGCHLD, regs->regs[15], regs, 0, NULL, NULL);
>  #else
>  	/* fork almost works, enough to trick you into looking elsewhere :-( */
> @@ -266,7 +266,7 @@ asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
>  			 unsigned long child_tidptr,
>  			 struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	if (!newsp)
>  		newsp = regs->regs[15];
>  	return do_fork(clone_flags, newsp, regs, 0,
> @@ -288,7 +288,7 @@ asmlinkage int sys_vfork(unsigned long r4, unsigned long r5,
>  			 unsigned long r6, unsigned long r7,
>  			 struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->regs[15], regs,
>  		       0, NULL, NULL);
>  }
> @@ -300,7 +300,7 @@ asmlinkage int sys_execve(char __user *ufilename, char __user * __user *uargv,
>  			  char __user * __user *uenvp, unsigned long r7,
>  			  struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	int error;
>  	char *filename;
>  
> diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
> index 579cd2c..76843cb 100644
> --- a/arch/sh/kernel/signal_32.c
> +++ b/arch/sh/kernel/signal_32.c
> @@ -109,7 +109,7 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
>  		unsigned long r6, unsigned long r7,
>  		struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  
>  	return do_sigaltstack(uss, uoss, regs->regs[15]);
>  }
> @@ -222,7 +222,7 @@ asmlinkage int sys_sigreturn(unsigned long r4, unsigned long r5,
>  			     unsigned long r6, unsigned long r7,
>  			     struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	struct sigframe __user *frame = (struct sigframe __user *)regs->regs[15];
>  	sigset_t set;
>  	int r0;
> @@ -259,7 +259,7 @@ asmlinkage int sys_rt_sigreturn(unsigned long r4, unsigned long r5,
>  				unsigned long r6, unsigned long r7,
>  				struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	struct rt_sigframe __user *frame = (struct rt_sigframe __user *)regs->regs[15];
>  	sigset_t set;
>  	int r0;
> diff --git a/arch/sh/kernel/sys_sh32.c b/arch/sh/kernel/sys_sh32.c
> index eb68bfd..1d96ad2 100644
> --- a/arch/sh/kernel/sys_sh32.c
> +++ b/arch/sh/kernel/sys_sh32.c
> @@ -25,7 +25,7 @@ asmlinkage int sys_sh_pipe(unsigned long r4, unsigned long r5,
>  	unsigned long r6, unsigned long r7,
>  	struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	int fd[2];
>  	int error;
>  
> diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
> index c3d86fa..107cccb 100644
> --- a/arch/sh/kernel/traps_32.c
> +++ b/arch/sh/kernel/traps_32.c
> @@ -666,7 +666,7 @@ asmlinkage void do_reserved_inst(unsigned long r4, unsigned long r5,
>  				unsigned long r6, unsigned long r7,
>  				struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	unsigned long error_code;
>  	struct task_struct *tsk = current;
>  
> @@ -754,7 +754,7 @@ asmlinkage void do_illegal_slot_inst(unsigned long r4, unsigned long r5,
>  				unsigned long r6, unsigned long r7,
>  				struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	unsigned long inst;
>  	struct task_struct *tsk = current;
>  
> @@ -783,7 +783,7 @@ asmlinkage void do_exception_error(unsigned long r4, unsigned long r5,
>  				   unsigned long r6, unsigned long r7,
>  				   struct pt_regs __regs)
>  {
> -	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
> +	struct pt_regs *regs = &__regs;
>  	long ex;
>  
>  	ex = lookup_exception_vector();

