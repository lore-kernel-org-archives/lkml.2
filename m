Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab0LTVsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:48:32 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:42328 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0LTVsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:48:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ILdMtH4MCC9xcAxud0O8bNA6/RT7vayammUtak5H/yOgoG70hFnLBOQa8mf8eW5StR
         GSjlXE/hE4rNZLLXkGWjVVe5BLRR9eJmWXxSSiiXBwqnNlxEwhHvRouUi3CKvILbTR1n
         UZ9V/bP/b00pK6h+nItacqSbWvR6KrN2qmYhg=
MIME-Version: 1.0
In-Reply-To: <4D0FC1AE.2050708@bluewatersys.com>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<20101107165745.GB1759@n2100.arm.linux.org.uk>
	<AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com>
	<20101107171726.GF1759@n2100.arm.linux.org.uk>
	<20101108171930.GA1471@alchark-u3s.lan>
	<20101111212322.GA15533@alchark-u3s.lan>
	<20101111234957.GA28735@n2100.arm.linux.org.uk>
	<20101219174017.GA31832@alchark-u3s>
	<20101220191549.GH28157@n2100.arm.linux.org.uk>
	<20101220195423.GA14509@alchark-u3s>
	<4D0FC1AE.2050708@bluewatersys.com>
Date: Tue, 21 Dec 2010 00:48:28 +0300
Message-ID: <AANLkTin4XqbGwznp56Xjt_zest6rxNmir0QDJWTySY4+@mail.gmail.com>
Subject: Re: [PATCH 1/6 v9] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
From: Alexey Charkov <alchark@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/20 Ryan Mallon <ryan@bluewatersys.com>:
> On 12/21/2010 08:54 AM, Alexey Charkov wrote:
>> This adds support for the family of Systems-on-Chip produced initially
>> by VIA and now its subsidiary WonderMedia that have recently become
>> widespread in lower-end Chinese ARM-based tablets and netbooks.
>>
>> Support is included for both VT8500 and WM8505, selectable by a
>> configuration switch at kernel build time.
>>
>> Included are basic machine initialization files, register and
>> interrupt definitions, support for the on-chip interrupt controller,
>> high-precision OS timer, GPIO lines, necessary macros for early debug,
>> pulse-width-modulated outputs control, as well as platform device
>> configurations for the specific drivers implemented elsewhere.
>>
>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>
> Hi Alexey,
>
> Quick review below.
>
> ~Ryan
>

<snip>

>> +static int __init panel_setup(char *str)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < ARRAY_SIZE(panels); i++) {
>> +             int len = strlen(panels[i].mode.name);
>> +
>> +             if (memcmp(panels[i].mode.name, str, len) == 0) {
>
> Should be strcmp. If the length of str is less than panels[i].mode.name
> then you will buffer overrun.
>

Ok, will change this.

>> +                     current_panel_idx = i;
>> +                     break;
>> +             }
>> +     }
>> +     return 0;
>> +}
>> +
>> +early_param("panel", panel_setup);
>> +
>> +static inline void preallocate_fb(struct vt8500fb_platform_data *p,
>> +                               unsigned long align) {
>> +     p->video_mem_len = (p->xres_virtual * p->yres_virtual * 4) >>
>> +                     (p->bpp > 16 ? 0 : (p->bpp > 8 ? 1 :
>> +                                     (8 / p->bpp) + 1));
>> +     p->video_mem_phys = (unsigned long)memblock_alloc(p->video_mem_len,
>> +                                                       align);
>> +     p->video_mem_virt = phys_to_virt(p->video_mem_phys);
>> +}
>> +
>> +static struct resource resources_uart0[] = {
>> +     [0] = {
>> +             .flags  = IORESOURCE_MEM,
>> +     },
>> +     [1] = {
>> +             .flags  = IORESOURCE_IRQ,
>> +     },
>> +};
>
> What's happening here? Does something else fill these in? If so, there
> should be a comment to that effect.
>

Ok, will add a comment.

<snip>
>> +void __init wmt_set_resources(void)
>> +{
>> +     resources_lcdc[0].start = wmt_current_regs->lcdc;
>> +     resources_lcdc[0].end = wmt_current_regs->lcdc + SZ_1K - 1;
>> +     resources_lcdc[1].start = wmt_current_irqs->lcdc;
>> +     resources_lcdc[1].end = wmt_current_irqs->lcdc;
>
> Ah, this makes more sense. But why have all the indirection? The
> wmt_regmaps table could just be replaced with #defines and then have
> separate device files for the VT8500 and the WM8505. This would also
> make clearer which variants have which peripherals.
>

This was the way I implemented it originally. However, Arnd made quite
a valid suggestion to allow runtime selection of the chip variant,
thus registers and interrupts need to be held in an indexed data type
instead of just compile-time macros. In addition, there is now some
overall movement towards unification of binary kernel images for
different ARM variants (as far as I can see), so this would be
required in any case.

Furthermore, as with many unbranded Chinese products, it's somewhat
difficult to reliably determine the exact chip version used in your
netbook without disassembling it. Reading a hardware register for
identification is easier :)

>> +     resources_wm8505_fb[0].start = wmt_current_regs->govr;
>> +     resources_wm8505_fb[0].end = wmt_current_regs->govr + 512 - 1;
>> +
>> +     resources_uart0[0].start = wmt_current_regs->uart0;
>> +     resources_uart0[0].end = wmt_current_regs->uart0 + 0x103f;
>> +     resources_uart0[1].start = wmt_current_irqs->uart0;
>> +     resources_uart0[1].end = wmt_current_irqs->uart0;
>> +     resources_uart1[0].start = wmt_current_regs->uart1;
>> +     resources_uart1[0].end = wmt_current_regs->uart1 + 0x103f;
>> +     resources_uart1[1].start = wmt_current_irqs->uart1;
>> +     resources_uart1[1].end = wmt_current_irqs->uart1;
>> +     resources_uart2[0].start = wmt_current_regs->uart2;
>> +     resources_uart2[0].end = wmt_current_regs->uart2 + 0x103f;
>> +     resources_uart2[1].start = wmt_current_irqs->uart2;
>> +     resources_uart2[1].end = wmt_current_irqs->uart2;
>> +     resources_uart3[0].start = wmt_current_regs->uart3;
>> +     resources_uart3[0].end = wmt_current_regs->uart3 + 0x103f;
>> +     resources_uart3[1].start = wmt_current_irqs->uart3;
>> +     resources_uart3[1].end = wmt_current_irqs->uart3;
>> +     resources_uart4[0].start = wmt_current_regs->uart4;
>> +     resources_uart4[0].end = wmt_current_regs->uart4 + 0x103f;
>> +     resources_uart4[1].start = wmt_current_irqs->uart4;
>> +     resources_uart4[1].end = wmt_current_irqs->uart4;
>> +     resources_uart5[0].start = wmt_current_regs->uart5;
>> +     resources_uart5[0].end = wmt_current_regs->uart5 + 0x103f;
>> +     resources_uart5[1].start = wmt_current_irqs->uart5;
>> +     resources_uart5[1].end = wmt_current_irqs->uart5;
>> +
>> +     resources_ehci[0].start = wmt_current_regs->ehci;
>> +     resources_ehci[0].end = wmt_current_regs->ehci + 512 - 1;
>> +     resources_ehci[1].start = wmt_current_irqs->ehci;
>> +     resources_ehci[1].end = wmt_current_irqs->ehci;
>
> There is a mix of hex and decimal constants here and exact sizes and
> sizes with 1 subtracted. Please be consistent.
>

Ok, will convert to hex with exact sizes.

>> +     resources_ge_rops[0].start = wmt_current_regs->ge;
>> +     resources_ge_rops[0].end = wmt_current_regs->ge + 0xff;
>> +
>> +     resources_pwm[0].start = wmt_current_regs->pwm;
>> +     resources_pwm[0].end = wmt_current_regs->pwm + 0x43;
>> +
>> +     resources_rtc[0].start = wmt_current_regs->rtc;
>> +     resources_rtc[0].end = wmt_current_regs->rtc + 0x2c - 1;
>> +     resources_rtc[1].start = wmt_current_irqs->rtc;
>> +     resources_rtc[1].end = wmt_current_irqs->rtc;
>> +     resources_rtc[2].start = wmt_current_irqs->rtc_hz;
>> +     resources_rtc[2].end = wmt_current_irqs->rtc_hz;
>> +}
>> +
>> +void __init vt8500_map_io(void)
>> +{
>> +     wmt_current_regs = &wmt_regmaps[VT8500_INDEX];
>> +     wmt_current_irqs = &wmt_irqs[VT8500_INDEX];
>> +
>> +     vt8500_io_desc[0].virtual = wmt_current_regs->mmio_regs_virt;
>> +     vt8500_io_desc[0].pfn =
>> +                     __phys_to_pfn(wmt_current_regs->mmio_regs_start);
>> +     vt8500_io_desc[0].length = wmt_current_regs->mmio_regs_length;
>> +
>> +     iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
>> +}
>> +
>> +void __init wm8505_map_io(void)
>> +{
>> +     wmt_current_regs = &wmt_regmaps[WM8505_INDEX];
>> +     wmt_current_irqs = &wmt_irqs[WM8505_INDEX];
>> +
>> +     vt8500_io_desc[0].virtual = wmt_current_regs->mmio_regs_virt;
>> +     vt8500_io_desc[0].pfn =
>> +                     __phys_to_pfn(wmt_current_regs->mmio_regs_start);
>> +     vt8500_io_desc[0].length = wmt_current_regs->mmio_regs_length;
>> +
>> +     iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
>> +}
>
> Separate files. If more variants get added, this file will become
> unwieldy very quickly.
>

Is it really worthwhile to create separate files for single 12-line
functions? After all, WonderMedia does not release new chips every now
and then :)

>> +
>> +void __init vt8500_reserve_mem(void)
>> +{
>> +#ifdef CONFIG_FB_VT8500
>> +     panels[current_panel_idx].bpp = 16; /* Always use RGB565 */
>> +     preallocate_fb(&panels[current_panel_idx], SZ_4M);
>> +     vt8500_device_lcdc.dev.platform_data = &panels[current_panel_idx];
>> +#endif
>> +}
>
> Not sure if this should exist in the platform code or the framebuffer
> driver. In the latter case it would automatically be CONFIG_FB_VT8500
> and the platform_data can still be set in the platform code. Is there a
> reason for this not to be in the framebuffer driver?
>

I can't reserve memory via memblock from the driver, and usual runtime
allocation functions can't handle it (need alignment to 4 megabytes in
8500, framebuffer sizes exceed 4 megabytes in 8505).

<snip>

>> +static int vt8500_muxed_gpio_request(struct gpio_chip *chip,
>> +                                  unsigned offset)
>> +{
>> +     struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
>> +
>> +     writel(readl(regbase + vt8500_chip->regoff) |
>> +             (1 << vt8500_chip->shift << offset),
>> +             regbase + vt8500_chip->regoff);
>
> This would be more readable as:
>
>        unsigned val;
>
>        val  = readl(regbase + vt8500_chop->regoff);
>        val |= 1 << vt8500_chop->shift << offset;
>        writel(val, regbase + vt8500_chip->regoff);
>
> It's much clearer what is actually being done. Same goes for other
> functions in this file.
>

Ok.

<snip>

>> +static struct vt8500_gpio_chip vt8500_muxed_gpios[] = {
>> +     VT8500_GPIO_BANK("uart0", 0, 0x0, 8, 4),
>> +     VT8500_GPIO_BANK("uart1", 4, 0x0, 12, 4),
>> +     VT8500_GPIO_BANK("spi0", 8, 0x0, 16, 4),
>> +     VT8500_GPIO_BANK("spi1", 12, 0x0, 20, 4),
>> +     VT8500_GPIO_BANK("spi2", 16, 0x0, 24, 4),
>> +     VT8500_GPIO_BANK("pwmout", 24, 0x0, 28, 2),
>
> Nitpick: Line up the columns to make these mpore readable.
>

That's true, will use tabs instead.

<snip>

>> diff --git a/arch/arm/mach-vt8500/include/mach/io.h b/arch/arm/mach-vt8500/include/mach/io.h
>> new file mode 100644
>> index 0000000..8dd55c8
>> --- /dev/null
>> +++ b/arch/arm/mach-vt8500/include/mach/io.h
>> @@ -0,0 +1,28 @@
>> +/*
>> + *  arch/arm/mach-vt8500/include/mach/io.h
>> + *
>> + *  Copyright (C) 2010 Alexey Charkov
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + */
>> +#ifndef __ASM_ARM_ARCH_IO_H
>> +#define __ASM_ARM_ARCH_IO_H
>> +
>> +#define IO_SPACE_LIMIT 0xffff
>> +
>> +#define __io(a)              ((void __iomem *)((a) + 0xf0000000))
>
> Should use __typesafe_io.
>

Ok.

<snip>

>> diff --git a/arch/arm/mach-vt8500/include/mach/memory.h b/arch/arm/mach-vt8500/include/mach/memory.h
>> new file mode 100644
>> index 0000000..175f914
>> --- /dev/null
>> +++ b/arch/arm/mach-vt8500/include/mach/memory.h
>> @@ -0,0 +1,28 @@
>> +/*
>> + *  arch/arm/mach-vt8500/include/mach/memory.h
>> + *
>> + *  Copyright (C) 2003 ARM Limited
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + */
>> +#ifndef __ASM_ARCH_MEMORY_H
>> +#define __ASM_ARCH_MEMORY_H
>> +
>> +/*
>> + * Physical DRAM offset.
>> + */
>> +#define PHYS_OFFSET  UL(0x00000000)
>
> If you renamed this to PHYS_DRAM_OFFSET you wouldn't need the comment :-).
>

I'm not the one who chooses :)

<snip>

>> diff --git a/arch/arm/mach-vt8500/include/mach/vt8500fb.h b/arch/arm/mach-vt8500/include/mach/vt8500fb.h
>> new file mode 100644
>> index 0000000..cc7f25e
>> --- /dev/null
>> +++ b/arch/arm/mach-vt8500/include/mach/vt8500fb.h
>> @@ -0,0 +1,31 @@
>> +/*
>> + *  VT8500/WM8505 Frame Buffer platform data definitions
>> + *
>> + *  Copyright (C) 2010 Ed Spiridonov <edo.rus@gmail.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _VT8500FB_H
>> +#define _VT8500FB_H
>> +
>> +#include <linux/fb.h>
>> +
>> +struct vt8500fb_platform_data {
>> +     struct fb_videomode     mode;
>> +     __u32                   xres_virtual;
>> +     __u32                   yres_virtual;
>> +     __u32                   bpp;
>
> Is this struct exported to user space? If not, use u32 rather than __u32.
>

No it's not, will change.

>> +     unsigned long           video_mem_phys;
>> +     void                    *video_mem_virt;
>> +     unsigned long           video_mem_len;
>> +};
>> +
>> +#endif /* _VT8500FB_H */
>> diff --git a/arch/arm/mach-vt8500/irq.c b/arch/arm/mach-vt8500/irq.c
>> new file mode 100644
>> index 0000000..c042e85
>> --- /dev/null
>> +++ b/arch/arm/mach-vt8500/irq.c
>> @@ -0,0 +1,179 @@
>> +/*
>> + *  arch/arm/mach-vt8500/irq.c
>> + *
>> + *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + */
>> +
>> +#include <linux/io.h>
>> +#include <linux/irq.h>
>> +#include <linux/interrupt.h>
>> +
>> +#include <asm/irq.h>
>> +
>> +#include <mach/mmio_regs.h>
>> +#include <mach/irq_defs.h>
>> +
>> +#define VT8500_IC_DCTR               0x40            /* Destination control
>> +                                             register, 64*u8 */
>> +#define VT8500_INT_ENABLE    (1 << 3)
>> +#define VT8500_TRIGGER_HIGH  (0 << 4)
>> +#define VT8500_TRIGGER_RISING        (1 << 4)
>> +#define VT8500_TRIGGER_FALLING       (2 << 4)
>> +#define VT8500_IC_STATUS     0x80            /* Interrupt status, 2*u32 */
>> +
>> +static void __iomem *ic_regbase;
>> +static void __iomem *sic_regbase;
>> +
>> +static void vt8500_irq_mask(unsigned int irq)
>> +{
>> +     void __iomem *base = ic_regbase;
>> +     u8 edge;
>
> Nitpick: blank line between variable declarations and code.
>

Ok.

>> +     if (irq >= 64) {
>> +             base = sic_regbase;
>> +             irq -= 64;
>> +     }
>> +     edge = readb(base + VT8500_IC_DCTR + irq) & (3 << 4);
>
> What is (3 << 4)? Replace with a #define.
>
>> +     if (edge)
>> +             writel(readl(base
>> +                     + VT8500_IC_STATUS + (irq < 32 ? 0 : 4))
>> +                     | (1 << (irq & 0x1f)), base
>> +                     + VT8500_IC_STATUS + (irq & 0x20 ? 4 : 0));
>
> More unexplained magic numbers.
>

Ok, will add macros.

>> +     else
>> +             writeb(readb(base
>> +                     + VT8500_IC_DCTR + irq) & ~VT8500_INT_ENABLE,
>> +                     base + VT8500_IC_DCTR + irq);
>> +}
>> +
>> +static void vt8500_irq_unmask(unsigned int irq)
>> +{
>> +     void __iomem *base = ic_regbase;
>> +     if (irq >= 64) {
>> +             base = sic_regbase;
>> +             irq -= 64;
>> +     }
>> +     writeb(readb(base
>> +             + VT8500_IC_DCTR + irq) | VT8500_INT_ENABLE,
>> +             base + VT8500_IC_DCTR + irq);
>> +}
>> +
>> +static int vt8500_irq_set_wake(unsigned int irq, unsigned int on)
>> +{
>> +     return -EINVAL;
>> +}
>
> You don't have to provide this function.
>

In fact, there is some wakeup functionality, but it's not yet
implemented. I could re-add the functions when some useful code
appears, though.

>> +static int vt8500_irq_set_type(unsigned int irq, unsigned int flow_type)
>> +{
>> +     void __iomem *base = ic_regbase;
>> +     unsigned int orig_irq = irq;
>> +     if (irq >= 64) {
>> +             base = sic_regbase;
>> +             irq -= 64;
>> +     }
>> +     switch (flow_type) {
>> +     case IRQF_TRIGGER_LOW:
>> +             return -EINVAL;
>> +     case IRQF_TRIGGER_HIGH:
>> +             writeb((readb(base
>> +                     + VT8500_IC_DCTR + irq) & ~(3 << 4))
>> +                     | VT8500_TRIGGER_HIGH, base
>> +                     + VT8500_IC_DCTR + irq);
>> +             irq_desc[orig_irq].handle_irq = handle_level_irq;
>> +             break;
>> +     case IRQF_TRIGGER_FALLING:
>> +             writeb((readb(base
>> +                     + VT8500_IC_DCTR + irq) & ~(3 << 4))
>> +                     | VT8500_TRIGGER_FALLING, base
>> +                     + VT8500_IC_DCTR + irq);
>> +             irq_desc[orig_irq].handle_irq = handle_edge_irq;
>> +             break;
>> +     case IRQF_TRIGGER_RISING:
>> +             writeb((readb(base
>> +                     + VT8500_IC_DCTR + irq) & ~(3 << 4))
>> +                     | VT8500_TRIGGER_RISING, base
>> +                     + VT8500_IC_DCTR + irq);
>> +             irq_desc[orig_irq].handle_irq = handle_edge_irq;
>> +             break;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static struct irq_chip vt8500_irq_chip = {
>> +     .name      = "vt8500",
>> +     .ack       = vt8500_irq_mask,
>> +     .mask      = vt8500_irq_mask,
>> +     .unmask    = vt8500_irq_unmask,
>> +     .set_wake  = vt8500_irq_set_wake,
>
> Remove .set_wake.
>

Ok.

>> +     .set_type  = vt8500_irq_set_type,
>> +};
>> +
>> +void __init vt8500_init_irq(void)
>> +{
>> +     unsigned int i;
>> +
>> +     ic_regbase = ioremap(wmt_current_regs->ic0, SZ_64K);
>> +
>> +     if (ic_regbase) {
>> +             /* Enable rotating priority for IRQ */
>> +             writel((1 << 6), ic_regbase + 0x20);
>> +             writel(0, ic_regbase + 0x24);
>> +
>> +             for (i = 0; i < wmt_current_irqs->nr_irqs; i++) {
>> +                     /* Disable all interrupts and route them to IRQ */
>> +                     writeb(0x00, ic_regbase + VT8500_IC_DCTR + i);
>> +
>> +                     set_irq_chip(i, &vt8500_irq_chip);
>> +                     set_irq_handler(i, handle_level_irq);
>> +                     set_irq_flags(i, IRQF_VALID);
>> +             }
>> +     } else {
>> +             printk(KERN_ERR "Unable to remap the Interrupt Controller "
>> +                             "registers, not enabling IRQs!\n");
>
> printk strings should be on a single line (can be > 80 columns) to make
> grepping easier. You could also use the pr_ macros with pr_fmt set.
>

Well, checkpatch.pl complained about that in the first place, so I
split the line. Should I merge them back in all instances?

<snip>

>> diff --git a/arch/arm/mach-vt8500/pwm.c b/arch/arm/mach-vt8500/pwm.c
>> new file mode 100644
>> index 0000000..d1356a1
>> --- /dev/null
>> +++ b/arch/arm/mach-vt8500/pwm.c
>
> I'm not sure what the state of the various efforts to provide a common
> pwm framework are, but you may want to check.
>

I did before starting to write this code, found nothing.

>> @@ -0,0 +1,254 @@
>> +/*
>> + * arch/arm/mach-vt8500/pwm.c
>> + *
>> + *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/pwm.h>
>> +
>> +#include <asm/div64.h>
>> +
>> +#define VT8500_NR_PWMS 4
>> +
>> +struct pwm_device {
>> +     struct list_head        node;
>> +     struct platform_device  *pdev;
>> +
>> +     const char      *label;
>> +
>> +     void __iomem    *regbase;
>> +
>> +     unsigned int    use_count;
>> +     unsigned int    pwm_id;
>> +};
>> +
>> +static inline void pwm_busy_wait(void __iomem *reg, u8 bitmask)
>> +{
>> +     int loops = 1000;
>> +     while ((readb(reg) & bitmask) && --loops)
>> +             cpu_relax();
>
> Ugh. If you are going to busy wait, can't you delay for a known amount
> of time? Even better, can this be replaced with wait_event or some
> equivalent?
>

The delay should be on the order of several bus cycles, where udelay
actually busy-waits, too. wait_event would be longer than that to set
up, and there is no associated interrupt.

>> +}
>> +
>> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>> +{
>> +     unsigned long long c;
>> +     unsigned long period_cycles, prescale, pv, dc;
>> +
>> +     if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
>> +             return -EINVAL;
>> +
>> +     c = 25000000/2; /* wild guess --- need to implement clocks */
>> +     c = c * period_ns;
>> +     do_div(c, 1000000000);
>> +     period_cycles = c;
>
> This looks like it could be reworked to remove the do_div call.
>

I just followed PXA implementation in this regard. Are there any
specific suggestions? Note that c should not be a complie-time
constant eventually, as this is the guessed PWM base frequency (should
be read from the hardware, but the code for clocks is not yet in).

>> +
>> +     if (period_cycles < 1)
>> +             period_cycles = 1;
>> +     prescale = (period_cycles - 1) / 4096;
>> +     pv = period_cycles / (prescale + 1) - 1;
>> +     if (pv > 4095)
>> +             pv = 4095;
>> +
>> +     if (prescale > 1023)
>> +             return -EINVAL;
>> +
>> +     dc = pv * duty_ns / period_ns;
>> +
>> +     pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 1));
>> +     writel(prescale, pwm->regbase + 0x4 + (pwm->pwm_id << 4));
>> +
>> +     pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 2));
>> +     writel(pv, pwm->regbase + 0x8 + (pwm->pwm_id << 4));
>> +
>> +     pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 3));
>> +     writel(dc, pwm->regbase + 0xc + (pwm->pwm_id << 4));
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL(pwm_config);
>> +
>> +int pwm_enable(struct pwm_device *pwm)
>> +{
>> +     pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 0));
>> +     writel(5, pwm->regbase + (pwm->pwm_id << 4));
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL(pwm_enable);
>> +
>> +void pwm_disable(struct pwm_device *pwm)
>> +{
>> +     pwm_busy_wait(pwm->regbase + 0x40 + pwm->pwm_id, (1 << 0));
>> +     writel(0, pwm->regbase + (pwm->pwm_id << 4));
>> +}
>> +EXPORT_SYMBOL(pwm_disable);
>> +
>> +static DEFINE_MUTEX(pwm_lock);
>> +static LIST_HEAD(pwm_list);
>
> These should be at the top of the file.
>

Ok.

>> +struct pwm_device *pwm_request(int pwm_id, const char *label)
>> +{
>> +     struct pwm_device *pwm;
>> +     int found = 0;
>> +
>> +     mutex_lock(&pwm_lock);
>> +
>> +     list_for_each_entry(pwm, &pwm_list, node) {
>> +             if (pwm->pwm_id == pwm_id) {
>> +                     found = 1;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (found) {
>> +             if (pwm->use_count == 0) {
>> +                     pwm->use_count++;
>> +                     pwm->label = label;
>> +             } else
>> +                     pwm = ERR_PTR(-EBUSY);
>> +     } else
>> +             pwm = ERR_PTR(-ENOENT);
>> +
>> +     mutex_unlock(&pwm_lock);
>> +     return pwm;
>> +}
>
> Maybe a bit clearer and more concise like this? Also replaces -ENOENT
> (No such file or directory) with -ENODEV (No such device):
>
>        pwm = ERR_PTR(-ENODEV);
>        mutex_lock(&pwm_lock);
>
>        list_for_each_entry(pwm, &pwm_list, node) {
>                if (pwm->pwm_id == pwm_id) {
>                        if (pwm->use_count != 0) {
>                                pwm = ERR_PTR(-EBUSY);
>                                break;
>                        }
>
>                        pwm->use_count++;
>                        pwm->label = label;
>                        break;
>                }
>        }
>
>        mutex_unlock(&pwm_lock);
>        return pwm;
>

Isn't pwm overwritten inside the loop? -ENODEV will then be lost with
this layout.

>> +EXPORT_SYMBOL(pwm_request);
>> +
>> +void pwm_free(struct pwm_device *pwm)
>> +{
>> +     mutex_lock(&pwm_lock);
>> +
>> +     if (pwm->use_count) {
>> +             pwm->use_count--;
>> +             pwm->label = NULL;
>> +     } else
>> +             pr_warning("PWM device already freed\n");
>> +
>
> Nitpick: Single line else should have braces if the if has braces
>

Ok.

>> +     mutex_unlock(&pwm_lock);
>> +}
>> +EXPORT_SYMBOL(pwm_free);
>> +
>> +static inline void __add_pwm(struct pwm_device *pwm)
>> +{
>> +     mutex_lock(&pwm_lock);
>> +     list_add_tail(&pwm->node, &pwm_list);
>> +     mutex_unlock(&pwm_lock);
>> +}
>> +
>> +static int __devinit pwm_probe(struct platform_device *pdev)
>> +{
>> +     struct pwm_device *pwms;
>> +     struct resource *r;
>> +     int ret = 0;
>> +     int i;
>> +
>> +     pwms = kzalloc(sizeof(struct pwm_device) * VT8500_NR_PWMS, GFP_KERNEL);
>> +     if (pwms == NULL) {
>> +             dev_err(&pdev->dev, "failed to allocate memory\n");
>> +             return -ENOMEM;
>> +     }
>
> Devices should ideally be a single entity, so one platform device per pwm.
>

We have 4 pwm outputs that share status registers, so they are not
really separable.

<snip>

>> diff --git a/arch/arm/mach-vt8500/timer.c b/arch/arm/mach-vt8500/timer.c
>> new file mode 100644
>> index 0000000..ab4f7aa
>> --- /dev/null
>> +++ b/arch/arm/mach-vt8500/timer.c
>> @@ -0,0 +1,154 @@
>> +/*
>> + *  arch/arm/mach-vt8500/timer.c
>> + *
>> + *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + */
>> +
>> +#include <linux/io.h>
>> +#include <linux/irq.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/clocksource.h>
>> +#include <linux/clockchips.h>
>> +
>> +#include <asm/mach/time.h>
>> +
>> +#include <mach/mmio_regs.h>
>> +#include <mach/irq_defs.h>
>> +
>> +#define VT8500_TIMER_OFFSET  0x0100
>> +#define TIMER_MATCH_VAL              0x0000
>> +#define TIMER_COUNT_VAL              0x0010
>> +#define TIMER_STATUS_VAL     0x0014
>> +#define TIMER_IER_VAL                0x001c          /* interrupt enable */
>> +#define TIMER_CTRL_VAL               0x0020
>> +#define TIMER_AS_VAL         0x0024          /* access status */
>> +#define TIMER_COUNT_R_ACTIVE (1 << 5)        /* not ready for read */
>> +#define TIMER_COUNT_W_ACTIVE (1 << 4)        /* not ready for write */
>> +#define TIMER_MATCH_W_ACTIVE (1 << 0)        /* not ready for write */
>> +#define VT8500_TIMER_HZ              3000000
>> +
>> +static void __iomem *regbase;
>> +
>> +static cycle_t vt8500_timer_read(struct clocksource *cs)
>> +{
>> +     int loops = 1000;
>> +     writel(3, regbase + TIMER_CTRL_VAL);
>> +     while ((readl((regbase + TIMER_AS_VAL)) & TIMER_COUNT_R_ACTIVE)
>> +                                             && --loops)
>> +             cpu_relax();
>
> More loop counting? Surely there is a better solution?
>

None that I could come up with. Again, the delay should be on the
order of several bus cycles.

<snip>

>> diff --git a/arch/arm/mach-vt8500/wm8505_7in.c b/arch/arm/mach-vt8500/wm8505_7in.c
>> new file mode 100644
>> index 0000000..181ad6f
>> --- /dev/null
>> +++ b/arch/arm/mach-vt8500/wm8505_7in.c
>> @@ -0,0 +1,81 @@
>> +/*
>> + *  arch/arm/mach-vt8500/wm8505_7in.c
>> + *
>> + *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + */
>> +
>> +#include <linux/io.h>
>> +#include <linux/pm.h>
>> +
>> +#include <asm/mach-types.h>
>> +#include <asm/mach/arch.h>
>> +
>> +#include <mach/mmio_regs.h>
>> +#include "devices.h"
>> +
>> +static void __iomem *pmc_hiber;
>> +
>> +static struct platform_device *devices[] __initdata = {
>> +     &vt8500_device_uart0,
>> +     &vt8500_device_ehci,
>> +     &vt8500_device_wm8505_fb,
>> +     &vt8500_device_ge_rops,
>> +     &vt8500_device_pwm,
>> +     &vt8500_device_pwmbl,
>> +     &vt8500_device_rtc,
>> +};
>> +
>> +static void vt8500_power_off(void)
>> +{
>> +     local_irq_disable();
>
> Is this necessary?
>

Vendor's code disables interrupts. I believe my device refused to
actually switch off without this.

Thanks for the comments, Ryan!

Best regards,
Alexey
