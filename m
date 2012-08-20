Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab2HTRsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:48:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49495 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2HTRsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:48:14 -0400
MIME-Version: 1.0
In-Reply-To: <1345345030-22211-55-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-55-git-send-email-andi@firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 20 Aug 2012 10:47:53 -0700
X-Google-Sender-Auth: 8rxkNDPwBNKTOfu0YYLvXGEEk-c
Message-ID: <CAObL_7GdYZ=DePjZJc6Oz0Pt3Q5PawWByFnjSd+j4Cd3w-mfzg@mail.gmail.com>
Subject: Re: [PATCH 54/74] x86, lto, vdso: Don't duplicate vvar address variables
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 7:56 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Every includer of vvar.h currently gets own static variables
> for all the vvar addresses. Generate just one set each for the
> main kernel and for the vdso. This saves some data space.
>
> Cc: Andy Lutomirski <luto@mit.edu>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

[This doesn't apply to -linus or to 3.5, so I haven't actually tested it.]

NACK, without significant further evidence that this is a good idea.

On input like this:

static const int * const vvaraddr_test = 0xffffffffff601000;

int func(void)
{
        return *vvaraddr_test;
}

gcc -O2 generates:

	.file	"constptr.c"
	.text
	.p2align 4,,15
	.globl	func
	.type	func, @function
func:
.LFB0:
	.cfi_startproc
	movl	-10481664, %eax
	ret
	.cfi_endproc
.LFE0:
	.size	func, .-func
	.ident	"GCC: (GNU) 4.6.3 20120306 (Red Hat 4.6.3-2)"
	.section	.note.GNU-stack,"",@progbits

Note, in particular, that (a) the load from the vvar uses an immediate
memory operand (this avoids a cacheline access, which is a measureable
speedup) and (b) vvaraddr_test was not emitted as data at all.

Your code will force each vvar address to be emitted as data and will
cause each reference to reference it as data.  Barring cleverness (and
I don't remember whether the vdso build is currently clever), this
could result in double-indirect access via the GOT from the vdso.

This kind of change IMO needs actual size measurements, benchmarks,
and some evidence that duplicate .data/.rodata things were emitted.

--Andy

> ---
>  arch/x86/include/asm/vvar.h    |   27 +++++++++++++++++----------
>  arch/x86/vdso/vclock_gettime.c |    1 +
>  arch/x86/vdso/vma.c            |    1 +
>  3 files changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
> index d76ac40..1fd06a8 100644
> --- a/arch/x86/include/asm/vvar.h
> +++ b/arch/x86/include/asm/vvar.h
> @@ -24,27 +24,34 @@
>  /* The kernel linker script defines its own magic to put vvars in the
>   * right place.
>   */
> -#define DECLARE_VVAR(offset, type, name) \
> -       EMIT_VVAR(name, offset)
> +#define DECLARE_VVAR(type, name) \
> +       EMIT_VVAR(name, VVAR_OFFSET_ ## name)
> +
> +#elif defined(__VVAR_ADDR)
> +
> +#define DECLARE_VVAR(type, name)                                       \
> +       type const * const vvaraddr_ ## name =                          \
> +       (void *)(VVAR_ADDRESS + (VVAR_OFFSET_ ## name));
>
>  #else
>
> -#define DECLARE_VVAR(offset, type, name)                               \
> -       static type const * const vvaraddr_ ## name =                   \
> -               (void *)(VVAR_ADDRESS + (offset));
> +#define DECLARE_VVAR(type, name)                                       \
> +       extern type const * const vvaraddr_ ## name;
>
>  #define DEFINE_VVAR(type, name)                                                \
>         type name                                                       \
>         __attribute__((section(".vvar_" #name), aligned(16))) __visible
> +#endif
>
>  #define VVAR(name) (*vvaraddr_ ## name)
>
> -#endif
> -
>  /* DECLARE_VVAR(offset, type, name) */
>
> -DECLARE_VVAR(0, volatile unsigned long, jiffies)
> -DECLARE_VVAR(16, int, vgetcpu_mode)
> -DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
> +#define VVAR_OFFSET_jiffies 0
> +DECLARE_VVAR(volatile unsigned long, jiffies)
> +#define VVAR_OFFSET_vgetcpu_mode 16
> +DECLARE_VVAR(int, vgetcpu_mode)
> +#define VVAR_OFFSET_vsyscall_gtod_data 128
> +DECLARE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data)
>
>  #undef DECLARE_VVAR
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index 885eff4..007eac4 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -10,6 +10,7 @@
>
>  /* Disable profiling for userspace code: */
>  #define DISABLE_BRANCH_PROFILING
> +#define __VVAR_ADDR 1
>
>  #include <linux/kernel.h>
>  #include <linux/posix-timers.h>
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index fe08e2b..4432cfc 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -3,6 +3,7 @@
>   * Copyright 2007 Andi Kleen, SUSE Labs.
>   * Subject to the GPL, v.2
>   */
> +#define __VVAR_ADDR 1
>  #include <linux/mm.h>
>  #include <linux/err.h>
>  #include <linux/sched.h>
> --
> 1.7.7.6
>
