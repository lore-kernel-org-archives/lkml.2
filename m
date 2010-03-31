Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0CaMdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:33:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41108 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839Ab0CaMdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:33:23 -0400
Message-ID: <4BB34110.6000607@canonical.com>
Date: Wed, 31 Mar 2010 14:33:20 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [77/89] x86: get rid of the insane TIF_ABI_PENDING bit
References: <20100330225856.509858139@linux.site>
In-Reply-To: <20100330225856.509858139@linux.site>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------000307010207020804080200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000307010207020804080200
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 

This one had a follow up later (patch attached)

Stefan
> ------------------
> 
> From: H. Peter Anvin <hpa@zytor.com>
> 
> commit 05d43ed8a89c159ff641d472f970e3f1baa66318 upstream.
> 
> Now that the previous commit made it possible to do the personality
> setting at the point of no return, we do just that for ELF binaries.
> And suddenly all the reasons for that insane TIF_ABI_PENDING bit go
> away, and we can just make SET_PERSONALITY() just do the obvious thing
> for a 32-bit compat process.
> 
> Everything becomes much more straightforward this way.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> 
> ---
>  arch/x86/ia32/ia32_aout.c          |    1 -
>  arch/x86/include/asm/elf.h         |   10 ++--------
>  arch/x86/include/asm/thread_info.h |    2 --
>  arch/x86/kernel/process.c          |   12 ------------
>  arch/x86/kernel/process_64.c       |   11 +++++++++++
>  5 files changed, 13 insertions(+), 23 deletions(-)
> 
> --- a/arch/x86/ia32/ia32_aout.c
> +++ b/arch/x86/ia32/ia32_aout.c
> @@ -311,7 +311,6 @@ static int load_aout_binary(struct linux
>  	/* OK, This is the point of no return */
>  	set_personality(PER_LINUX);
>  	set_thread_flag(TIF_IA32);
> -	clear_thread_flag(TIF_ABI_PENDING);
>  
>  	setup_new_exec(bprm);
>  
> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -197,14 +197,8 @@ do {							\
>  	set_fs(USER_DS);				\
>  } while (0)
>  
> -#define COMPAT_SET_PERSONALITY(ex)			\
> -do {							\
> -	if (test_thread_flag(TIF_IA32))			\
> -		clear_thread_flag(TIF_ABI_PENDING);	\
> -	else						\
> -		set_thread_flag(TIF_ABI_PENDING);	\
> -	current->personality |= force_personality32;	\
> -} while (0)
> +void set_personality_ia32(void);
> +#define COMPAT_SET_PERSONALITY(ex) set_personality_ia32()
>  
>  #define COMPAT_ELF_PLATFORM			("i686")
>  
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -86,7 +86,6 @@ struct thread_info {
>  #define TIF_NOTSC		16	/* TSC is not accessible in userland */
>  #define TIF_IA32		17	/* 32bit process */
>  #define TIF_FORK		18	/* ret_from_fork */
> -#define TIF_ABI_PENDING		19
>  #define TIF_MEMDIE		20
>  #define TIF_DEBUG		21	/* uses debug registers */
>  #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
> @@ -110,7 +109,6 @@ struct thread_info {
>  #define _TIF_NOTSC		(1 << TIF_NOTSC)
>  #define _TIF_IA32		(1 << TIF_IA32)
>  #define _TIF_FORK		(1 << TIF_FORK)
> -#define _TIF_ABI_PENDING	(1 << TIF_ABI_PENDING)
>  #define _TIF_DEBUG		(1 << TIF_DEBUG)
>  #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
>  #define _TIF_FREEZE		(1 << TIF_FREEZE)
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -94,18 +94,6 @@ void flush_thread(void)
>  {
>  	struct task_struct *tsk = current;
>  
> -#ifdef CONFIG_X86_64
> -	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
> -		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
> -		if (test_tsk_thread_flag(tsk, TIF_IA32)) {
> -			clear_tsk_thread_flag(tsk, TIF_IA32);
> -		} else {
> -			set_tsk_thread_flag(tsk, TIF_IA32);
> -			current_thread_info()->status |= TS_COMPAT;
> -		}
> -	}
> -#endif
> -
>  	clear_tsk_thread_flag(tsk, TIF_DEBUG);
>  
>  	tsk->thread.debugreg0 = 0;
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -534,6 +534,17 @@ sys_clone(unsigned long clone_flags, uns
>  	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
>  }
>  
> +void set_personality_ia32(void)
> +{
> +	/* inherit personality from parent */
> +
> +	/* Make sure to be in 32bit mode */
> +	set_thread_flag(TIF_IA32);
> +
> +	/* Prepare the first "return" to user space */
> +	current_thread_info()->status |= TS_COMPAT;
> +}
> +
>  unsigned long get_wchan(struct task_struct *p)
>  {
>  	unsigned long stack;
> 
> 


--------------000307010207020804080200
Content-Type: text/x-diff;
 name="0006-x86-set_personality_ia32-misses-force_personality32.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0006-x86-set_personality_ia32-misses-force_personality32.pat";
 filename*1="ch"

>From 27567323dbf8d04f6b9be03190e8745f7b43df48 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 16 Feb 2010 15:02:13 +0100
Subject: [PATCH 6/6] x86: set_personality_ia32() misses force_personality32

commit 1252f238db48ec419f40c1bdf30fda649860eed9 upstream

05d43ed8a "x86: get rid of the insane TIF_ABI_PENDING bit" forgot about
force_personality32.  Fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/x86/kernel/process_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 80c2372..6553691 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -540,6 +540,7 @@ void set_personality_ia32(void)
 
 	/* Make sure to be in 32bit mode */
 	set_thread_flag(TIF_IA32);
+	current->personality |= force_personality32;
 
 	/* Prepare the first "return" to user space */
 	current_thread_info()->status |= TS_COMPAT;
-- 
1.6.3.3


--------------000307010207020804080200--
