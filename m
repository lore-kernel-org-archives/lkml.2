Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1HaOFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:05:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1HaOFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:05:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 18/35] Hexagon: Add time and timer functions
Date: Wed, 31 Aug 2011 16:04:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190801.448257740@codeaurora.org>
In-Reply-To: <20110830190801.448257740@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311604.52634.arnd@arndb.de>
X-Provags-ID: V02:K0:zbaVbxWPgii8igB8PQRzYzDIvMSjA1BVFZhz29jb7qr
 RxlT6RuRJacnOz4f9Kr3SV4TRcgYv7vIFhz9Y3s0coumgHqg6b
 jKp01JVj8Nw+9X0I8UkVBT4fQ/xpyaq1ZDcqKIPpz86dZO/Llm
 zqUJjyH8B7CpqrNqMhYAscJLXvQsVbwG4Xx159DBdCCn28HWVQ
 rNvLDyZ17J4BhrUUEgc3nIgHVB8mTN12Vaym0vVNhQjFcXzGOv
 +8thJgnjHLshEUaLTmzYoZa4+3up5jdJ7OrEvdTf+bEEFnzJsA
 E188qFL89/0tDYDUQ6E3luLSAJHcEXK2NQfFX0RQGloUMmQ9Yc
 GqDkYeTihHOMaBQe/Fto=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

> +#ifdef CONFIG_SMP
> +void setup_percpu_clockdev(void);
> +void ipi_timer(void);
> +#endif

You should never need to wrap declarations with #ifdef like this.

> +
> +#ifndef _ASM_TIMER_REGS_H
> +#define _ASM_TIMER_REGS_H
> +
> +/*  This stuff should go into a platform specific file  */
> +#define TCX0_CLK_RATE		19200
> +#define TIMER_ENABLE		0
> +#define TIMER_CLR_ON_MATCH	1

Same comment as for NR_IRQS. If this is platform specific, it should
not be a compile-time constant.


>+/*
>+ * For now, hard wire the simulated CPU/pcycle frequency.
>+ * XXX TODO fish it out of device tree!
>+ */
>+#define CPU_MHZ 600
>+
>+static struct resource rtos_timer_resources[] = {
>+       {
>+               .start  = RTOS_TIMER_REGS_ADDR,
>+               .end    = RTOS_TIMER_REGS_ADDR+PAGE_SIZE-1,
>+               .flags  = IORESOURCE_MEM,
>+       },
>+};

Yes, please do get it out of the device tree before merging the driver
upstream.

> +/*  A lot of this stuff should move into a platform specific section.  */
> +struct adsp_hw_timer_struct {
> +	unsigned int match;   /*  Match value  */
> +	unsigned int count;
> +	unsigned int enable;  /*  [1] - CLR_ON_MATCH_EN, [0] - EN  */
> +	unsigned int clear;   /*  one-shot register that clears the count  */
> +};
> +
> +/*  Look for "TCX0" for related constants.  */
> +static volatile struct adsp_hw_timer_struct *rtos_timer = (void *) 0x0;

There are multiple things wrong with this:

* No need to initialize static variables to zero

* This is an MMIO register, so the pointer must be "__iomem", not "volatile",
  see Documentation/volatile-considered-harmful.txt

* You should have found this when building with 'make C=1' using sparse.
  I would hope that all your code was compiled this way to find common
  errors. If not, please do so now.

* Use u32 instead of unsigned int when describing hardware structures.
  They are always identical, but u32 is more descriptive. Alternatively,
  use no structure at all but constant register numbers.

> +static struct clock_event_device hexagon_clockevent_dev = {
> +	.name		= "clockevent",
> +	.features	= CLOCK_EVT_FEAT_ONESHOT,
> +	.rating		= 400,
> +	.shift		= 32,
> +	.irq		= RTOS_TIMER_INT,
> +	.set_next_event = set_next_event,
> +	.set_mode	= set_mode,
> +#ifdef CONFIG_SMP
> +	.broadcast	= broadcast
> +#endif
> +};

Always put a comma at the last entry, to allow adding more members
as necessary.

> +/*
> + * time_init_deferred - called by start_kernel to set up timer/clock source
> + *
> + * Install the IRQ handler for the clock, setup timers.
> + * This is done late, as that way, we can use ioremap().
> + *
> + * This runs just before the delay loop is calibrated, and
> + * is used for delay calibration.
> + */
> +void __init time_init_deferred(void)
> +{
> +	struct resource *resource = NULL;
> +	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
> +	struct device_node *dn;
> +	struct resource r;
> +	int err;
> +
> +#ifdef CONFIG_SMP
> +	ce_dev->cpumask = cpu_all_mask;
> +#else
> +	ce_dev->cpumask = cpumask_of(0);
> +#endif

No need for the #ifdef AFAICT, because the two cases are the same.

> +	if (!resource)
> +		resource = rtos_timer_device.resource;
> +
> +	/*  ioremap here means this has to run later, after paging init  */
> +	rtos_timer = ioremap(resource->start, resource->end
> +		- resource->start + 1);

When the device is in the device tree, you can simplify this a lot
by using of_iomap().

> +void __udelay(unsigned long usecs)
> +{
> +	unsigned long long start = __vmgettime();
> +	unsigned long long finish = (CPU_MHZ * usecs) - fudgefactor;
> +
> +	while ((__vmgettime() - start) < finish)
> +		; /*  not sure how this improves readability  */
> +}

Better use cpu_relax() or a direct hypervisor yield call here instead of
the ';'. It should improve both readability and power consumption during
long delays.

	Arnd
