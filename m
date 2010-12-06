Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0LFVco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 16:32:44 -0500
Received: from www.tglx.de ([62.245.132.106]:34456 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab0LFVcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 16:32:43 -0500
Date: Mon, 6 Dec 2010 22:31:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Drake <dsd@laptop.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andres Salomon <dilinger@queued.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v5 resend] OLPC: Add XO-1 suspend/resume support
In-Reply-To: <20101203141828.33E8F9D401B@zog.reactivated.net>
Message-ID: <alpine.LFD.2.00.1012062119350.2653@localhost6.localdomain6>
References: <20101203141828.33E8F9D401B@zog.reactivated.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010, Daniel Drake wrote:

> Add code needed for basic suspend/resume of the XO-1 laptop.
> 
> As distro kernels would prefer to build XO-1 support modular, we have

And I would prefer to have a pony. 

> had to export suspend_set_ops() and create an exported function for
> reading the address of the initial page table.

This is nuts. We export stuff just to save 8k binary blob in the
kernel image of which at least 4k are wasted by completely unnecessary
alignment. The real code size of all this stuff (ignore the module
magic) is less than 1k.

> Andrew, this is the latest version of the patch causing the compilation
> failure detected through -mm inclusion (thanks). It also integrates new
> review comments from Thomas Gleixner, and has since passed another silent
> week without feedback from x86 hackers :(

It's been in my queue for review. I'm not a machine.
 
>  
> +pgd_t *get_initial_page_table(void)
> +{
> +	return initial_page_table;
> +}
> +EXPORT_SYMBOL_GPL(get_initial_page_table);

You export a function to get the address of initial_page_table?

Then you call that function from your wakeup context. Does that
context have a proper stack for calling a c-function? 

And you call it _BEFORE_ you restored the control registers. GDT et
al. are not restored at that point either.

Further this call might end up via mcount in the low level tracing
code or in the tracer itself. How's that supposed to work with wrong
crX/GDT... contents? Not at all.

> +ALIGN
> +	.align 4096

What's the reason for this alignment? Firmware stupidity? If yes, it
needs to be documented. If no, it needs to be removed.

> +wakeup_start:
> +	cli
> +	cld

That's silly. You clear the stuff below anyway.

> +	# Clear any dangerous flags
> +
> +	pushl $0
> +	popfl
> +
> +	writepost 0x31
> +
> +	# Set up %cr3
> +	call get_initial_page_table

See above.

> +	sub $__PAGE_OFFSET, %eax
> +	movl %eax, %cr3
> +
> +	movl saved_cr4, %eax
> +	movl %eax, %cr4
> +
> +	movl saved_cr0, %eax
> +	movl %eax, %cr0
> +
> +	jmp 1f

What's the point of this ? It's just wrong.

> +1:
> +	ljmpl $__KERNEL_CS,$wakeup_return

And this? This normalizes CS _BEFORE_ restoring GDT. How is that
supposed to work if GDT is not correct because it has not been
restored ?

> +
> +.org 0x1000

And this ? 

AFAICT it's useless waste of space. If not it's there for a completely
undocumented reason. Either way it needs documenting or fixing.

> +wakeup_return:
> +	movw    $__KERNEL_DS, %ax
> +	movw    %ax, %ss

> --- /dev/null
> +++ b/arch/x86/platform/olpc/xo1.c
> +
> +#define PMS_BAR                4
> +#define ACPI_BAR       5
> +
> +/* PMC registers (PMS block) */
> +#define PM_SCLK                0x10
> +#define PM_IN_SLPCTL   0x20
> +#define PM_WKXD                0x34
> +#define PM_WKD         0x30
> +#define PM_SSC         0x54
> +
> +/* PM registers (ACPI block) */
> +#define PM1_STS                0x00
> +#define PM1_CNT                0x08
> +#define PM_GPE0_STS    0x18
> +
> +#define CS5536_PM_PWRBTN (1 << 8)

Please move these to the header file(s) which contain(s) the other
OLPC/CS5536 defines?

> +
> +extern void do_olpc_suspend_lowlevel(void);

No externs in c files. Move that to the appropriate header please.

> +
> +	/*
> +	 * Take a reference on ourself to prevent module unloading. We can't
> +	 * safely unload after changing the suspend handlers.
> +	 */
> +	__module_get(THIS_MODULE);

Another good reason to avoid this module hackery alltogether.

> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 7335952..c320724 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -42,6 +42,7 @@ void suspend_set_ops(struct platform_suspend_ops *ops)
>  	suspend_ops = ops;
>  	mutex_unlock(&pm_mutex);
>  }
> +EXPORT_SYMBOL_GPL(suspend_set_ops);

Has this been acked by the PM folks ?

Thanks,

	tglx
