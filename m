Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1CIJvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:51:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36686 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab1CIJvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:51:16 -0500
MIME-Version: 1.0
In-Reply-To: <1299639325-10384-1-git-send-email-sjg@chromium.org>
References: <1299639325-10384-1-git-send-email-sjg@chromium.org>
Date: Wed, 9 Mar 2011 09:51:14 +0000
Message-ID: <AANLkTinTfHqrbVFh6Q68kP=UKJjye8J+iDhRHTcm8BPF@mail.gmail.com>
Subject: Re: [RFC PATCH V2] ARM: Use generic BUG() handler
From: Dave Martin <dave.martin@linaro.org>
To: Simon Glass <sjg@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        Mikael Pettersson <mikpe@it.uu.se>, Simon Glass <sjg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 2:55 AM, Simon Glass <sjg@chromium.org> wrote:
> From: Simon Glass <sjg@google.com>
>
> (I am looking for comments please on this patch. Thanks to those who respond
> last time. I have modified this to avoid using the %c asm() option.)
>
> ARM uses its own BUG() handler which makes its output slightly different
> from other archtectures.
>
> One of the problems is that the ARM implementation doesn't report the function
> with the BUG() in it, but always reports the PC being in __bug(). The generic
> implementation doesn't have this problem.
>
> Currently we get something like:
>
> kernel BUG at fs/proc/breakme.c:35!
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> ...
> PC is at __bug+0x20/0x2c
>
> With this patch it displays:
>
> kernel BUG at fs/proc/breakme.c:35!
> Internal error: Oops - undefined instruction: 0 [#1] PREEMPT SMP
> ...
> PC is at write_breakme+0xd0/0x1b4
>
> This implementation uses an undefined instruction to implement BUG, and sets up
> a bug table containing the relevant information.
>
> Also the backtrace the message now appears even when CONFIG_ARM_UNWIND is
> defined.
>
> Change-Id: I07d77c832e816f5ad2390e25f466ddf750adecf4
>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> ---
>  arch/arm/Kconfig              |    4 +++
>  arch/arm/include/asm/bug.h    |   57 +++++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/traps.c       |   21 +++++++++++++++
>  arch/arm/kernel/vmlinux.lds.S |   12 ++++++++
>  4 files changed, 94 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 166efa2..7c8f11c 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -191,6 +191,10 @@ config VECTORS_BASE
>        help
>          The base address of exception vectors.
>
> +config GENERIC_BUG
> +       def_bool y
> +       depends on BUG
> +
>  source "init/Kconfig"
>
>  source "kernel/Kconfig.freezer"
> diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
> index 4d88425..b589fa5 100644
> --- a/arch/arm/include/asm/bug.h
> +++ b/arch/arm/include/asm/bug.h
> @@ -3,6 +3,61 @@
>
>
>  #ifdef CONFIG_BUG
> +
> +#ifdef CONFIG_GENERIC_BUG
> +
> +/*
> + * Use a suitable undefined instruction to use for ARM/Thumb2 bug handling.
> + * We need to be careful not to conflict with those used by other modules and
> + * the register_undef_hook() system.
> + */
> +#ifdef CONFIG_THUMB2_KERNEL
> +#define BUG_INSTR_VALUE 0xf7f2

This isn't an undefined instruction... it's actually half of some
32-bit Thumb instruction. Did you mean 0xdexx instead?

> +#define BUG_INSTR_TYPE ".hword "
> +#else
> +#define BUG_INSTR_VALUE 0xe7f001f2
> +#define BUG_INSTR_TYPE ".word "
> +#endif
> +

This works, but do we really need to split the definition of the bug
instruction into two macros?

Unless you can see a use for calling _BUG() directly with a different
instruction value, of course...

> +
> +#define BUG() _BUG(__FILE__, __LINE__, BUG_INSTR_VALUE)
> +#define _BUG(file, line, value) __BUG(file, line, value)
> +
> +#ifdef CONFIG_DEBUG_BUGVERBOSE
> +
> +/*
> + * The extra indirection is to ensure that the __FILE__ string comes through
> + * OK. Many version of gcc do not support the asm %c parameter which would be
> + * preferable to this unpleasantness. We use mergeable string sections to
> + * avoid multiple copies of the string appearing in the kernel image.
> + */
> +
> +#define __BUG(__file, __line, __value)                         \
> +do {                                                           \
> +       BUILD_BUG_ON(sizeof(struct bug_entry) != 12);           \
> +       asm volatile("1:\t" BUG_INSTR_TYPE #__value "\n"        \
> +               ".pushsection .rodata.str, \"aMS\", 1\n"        \
> +               "2:\t.asciz " #__file "\n"                      \
> +               ".popsection\n"                                 \
> +               ".pushsection __bug_table,\"a\"\n"              \
> +               "3:\t.word 1b, 2b\n"                            \
> +               "\t.hword " #__line ", 0\n"                     \
> +               ".popsection");                                 \
> +       unreachable();                                          \
> +} while (0)
> +
> +#else  /* not CONFIG_DEBUG_BUGVERBOSE */
> +
> +#define __BUG(__file, __line, __value)                         \
> +do {                                                           \
> +       asm volatile(BUG_INSTR_TYPE #__value);                  \
> +       unreachable();                                          \
> +} while (0)
> +#endif  /* CONFIG_DEBUG_BUGVERBOSE */
> +
> +
> +#else  /* not CONFIG_GENERIC_BUG */
> +
>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>  extern void __bug(const char *file, int line) __attribute__((noreturn));
>
> @@ -16,6 +71,8 @@ extern void __bug(const char *file, int line) __attribute__((noreturn));
>
>  #endif
>
> +#endif  /* CONFIG_GENERIC_BUG */
> +
>  #define HAVE_ARCH_BUG
>  #endif
>
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index ee57640..9f8cd10 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -21,6 +21,7 @@
>  #include <linux/kdebug.h>
>  #include <linux/module.h>
>  #include <linux/kexec.h>
> +#include <linux/bug.h>
>  #include <linux/delay.h>
>  #include <linux/init.h>
>
> @@ -163,6 +164,7 @@ static void dump_instr(const char *lvl, struct pt_regs *regs)
>  #ifdef CONFIG_ARM_UNWIND
>  static inline void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
>  {
> +       printk("Backtrace: ");
>        unwind_backtrace(regs, tsk);
>  }
>  #else
> @@ -271,6 +273,8 @@ void die(const char *str, struct pt_regs *regs, int err)
>        spin_lock_irq(&die_lock);
>        console_verbose();
>        bust_spinlocks(1);
> +       if (!user_mode(regs))
> +               report_bug(regs->ARM_pc, regs);
>        ret = __die(str, err, thread, regs);
>
>        if (regs && kexec_should_crash(thread->task))
> @@ -302,6 +306,23 @@ void arm_notify_die(const char *str, struct pt_regs *regs,
>        }
>  }
>
> +int is_valid_bugaddr(unsigned long pc)
> +{
> +#ifdef CONFIG_THUMB2_KERNEL
> +       unsigned short bkpt;
> +#else
> +       unsigned long bkpt;
> +#endif
> +
> +       if (pc < PAGE_OFFSET)
> +               return 0;
> +       if (probe_kernel_address((unsigned *)pc, bkpt))
> +               return 0;
> +
> +       return bkpt == BUG_INSTR_VALUE;
> +}
> +
> +
>  static LIST_HEAD(undef_hook);
>  static DEFINE_SPINLOCK(undef_lock);
>
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index 6146279..4f22346 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -80,6 +80,18 @@ SECTIONS
>
>        PERCPU(PAGE_SIZE)
>
> +       /*
> +       * .exit.text is discarded at runtime, not link time, to deal with
> +       *  references from bug_table
> +       */
> +       .exit.text : AT(ADDR(.exit.text)) {
> +               EXIT_TEXT
> +       }
> +
> +       .exit.data : AT(ADDR(.exit.data)) {
> +               EXIT_DATA
> +       }

This is the same unfortunate hack we have to do for other fixups,
because there's no way to separate out some of these entries in such a
way that they can be discarded at link time...  I did have an idea for
an extention to gas which would allow fixups and similar data to be
emitted in separate ancillary sections which the linker can handle
sensibly, so that bug entries referencing .exit.text (for example) can
be discarded at link time.

See http://sourceware.org/ml/binutils/2011-02/msg00004.html

I haven't received any support for the idea so far though...

Cheers
---Dave
