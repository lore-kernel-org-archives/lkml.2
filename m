Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0KZJns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:43:48 -0500
Received: from www.tglx.de ([62.245.132.106]:57745 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760Ab0KZJnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:43:46 -0500
Date: Fri, 26 Nov 2010 10:43:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Drake <dsd@laptop.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 resend] OLPC: Add XO-1 suspend/resume support
In-Reply-To: <20101118202837.B24899D401B@zog.reactivated.net>
Message-ID: <alpine.LFD.2.00.1011261037560.2900@localhost6.localdomain6>
References: <20101118202837.B24899D401B@zog.reactivated.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Daniel Drake wrote:
> Feedback after the first submission was quickly acted upon and I haven't been
> able to get a peep since.

Sorry, fell off the radar.

> +
> +wakeup_start:
> +#	jmp wakeup_start

  Debug leftover ?

> +asmlinkage int olpc_xo1_do_sleep(u8 sleep_state)
> +{
> +	void *pgd_addr = __va(read_cr3());
> +	printk(KERN_ERR "xo1_do_sleep!\n"); /* this needs to remain here so
> +					      * that gcc doesn't optimize
> +					      * away our __va! */
> +

  This looks suspect along with the __volatile__ magic below. Care to
  explain, what you fear that gcc is optimizing away ?

> +	/* Enable wakeup through power button */
> +	outl((CS5536_PM_PWRBTN << 16) | 0xFFFF, acpi_base + PM1_STS);
> +
> +	__asm__ __volatile__("movl %0,%%eax" : : "r" (pgd_addr));
> +	__asm__("call *(%%edi); cld"
> +		: : "D" (&ofw_bios_entry));
> +	__asm__ __volatile__("movb $0x34, %al\n\t"
> +			     "outb %al, $0x70\n\t"
> +			     "movb $0x30, %al\n\t"
> +			     "outb %al, $0x71\n\t");

Looks good otherwise.

Thanks,

	tglx
