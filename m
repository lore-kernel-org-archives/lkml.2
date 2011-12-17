Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546Ab1LQBM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 20:12:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1LQBMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 20:12:18 -0500
Date: Fri, 16 Dec 2011 17:12:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] Resurrect Intel740 driver: i740fb
Message-Id: <20111216171216.f307b3fe.akpm@linux-foundation.org>
In-Reply-To: <201112080024.24383.linux@rainbow-software.org>
References: <201112080024.24383.linux@rainbow-software.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011 00:24:18 +0100
Ondrej Zary <linux@rainbow-software.org> wrote:

> This is a resurrection of an old (like 2.4.19) out-of-tree driver for
> Intel740 graphics cards and modify it for recent kernels. The old driver is
> located at: http://sourceforge.net/projects/i740fbdev/files/
> 
> This is a new driver based on skeletonfb, using most of the low level HW code
> from the old driver. The DDC code is completely new.
> 
> The driver was tested on two 8MB cards: Protac AG240D and Diamond Stealth II
> G460.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

The original driver appears to have been written by Andrey Ulanov.  It
would be nice to mention that in the changelog and it is desirable that
you seek his Signed-off-by:, please.

> Changes in v4:
>  - shortened many lines to fit 80-char limit
>  - removed useless inb_p and outb_p functions
>  - converted DDC (and some other) code to i740outreg_mask
>  - removed useless wm initialization in i740_calc_fifo()
>  - ALIGN macro is used instead of manual alignment
>  - removed inactive code
>  - simplified i740_setcolreg()
>  - info->var used for panning
>  - fixed out-of-video-memory checking

It still generates a large number of checkpatch errors.  If you've
reviewed those and made the decision to ignore them then OK(ish). 
Otherwise, please check.

>
> ...
>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/fb.h>
> +#include <linux/init.h>
> +#include <linux/pci.h>
> +#include <linux/pci_ids.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-algo-bit.h>

Should there have been a dependency on i2c in the Kconfig entry?  If
not, has the driver been tested with is2 disabled?

> +#include <linux/console.h>
> +#include <video/vga.h>
> +
>
> ...
>
> +#define I740_RFREQ (1e6)
> +#define TARGET_MAX_N 30
> +
> +#define I740_FFIX		8
> +#define I740_REF_FREQ		(u32) (66.66666666667 * (1 << I740_FFIX) + 0.5)
> +#define I740_MAX_VCO_FREQ	(u32)(450.00000000000 * (1 << I740_FFIX) + 0.5)

There should be no floating point in the kernel, normally.  Given the
casts, these will obviously not get any further than the compiler.  But
if these could be redone to avoid the float, that would be nice.

> +#define I740_CALC_VCLKfix(m, n, p, d)   ((((((m) * I740_REF_FREQ * (4 << ((d) << 1)))) / (n)) + ((1 << (p)) / 2)) / (1 << (p)))

This macro should be dragged out and shot.  And it will cause bugs if
invoked using an expression with side-effects.  There's no need to do
this to ourselves - please turn it into a nice, lower-case-named C
function with proper identifiers, code comments, etc.

> +static void i740_calc_vclk(u32 freq_hz, struct i740fb_par *par)
> +{
> +	u32 freq = freq_hz / (u32)(1e6 / I740_RFREQ);
> +	const u32 err_max =
> +		freq / (u32)(I740_RFREQ / 0.005 / (1 << I740_FFIX) + 0.5);
> +	const u32 err_target =
> +		freq / (u32)(I740_RFREQ / 0.001 / (1 << I740_FFIX) + 0.5);
> +	u32 err_best = (u32)(512.0 * (1 << I740_FFIX));
> +	u32 f_err, f_vco;
> +	int m_best = 0, n_best = 0, p_best = 0, d_best = 0;
> +	int m, n, i;
> +
> +	/* find log2(MAX_VCO_FREQ/f_target) */
> +	for (i = 0; i < 16; i++)
> +		if ((I740_MAX_VCO_FREQ) / (1 << i) < freq / (u32)(I740_RFREQ / (1 << I740_FFIX)))

Use the existing ilog2()?

> +			break;
> +	i--;
> +	p_best = i;
> +
> +	d_best = 0;
> +	f_vco = (freq * (1 << p_best)) / (u32)(I740_RFREQ / (1 << I740_FFIX));
> +	freq = freq / (u32)(I740_RFREQ / (1 << I740_FFIX));
> +
> +	n = 2;
> +	do {
> +		n++;
> +		m = ((f_vco * n) / I740_REF_FREQ + 2) / 4;
> +
> +		if (m < 3)
> +			m = 3;
> +
> +		{
> +			u32 f_out = I740_CALC_VCLKfix(m, n, p_best, d_best);
> +
> +			f_err = (freq - f_out);
> +
> +			if (abs(f_err) < err_max) {
> +				m_best = m;
> +				n_best = n;
> +				err_best = f_err;
> +			}
> +		}
> +	} while ((abs(f_err) >= err_target) &&
> +		 ((n <= TARGET_MAX_N) || (abs(err_best) > err_max)));
> +
> +	if (abs(f_err) < err_target) {
> +		m_best = m;
> +		n_best = n;
> +	}
> +
> +	par->video_clk2_m = (m_best-2) & 0xFF;
> +	par->video_clk2_n = (n_best-2) & 0xFF;
> +	par->video_clk2_mn_msbs = ((((n_best-2) >> 4) & VCO_N_MSBS)
> +				 | (((m_best-2) >> 8) & VCO_M_MSBS));
> +	par->video_clk2_div_sel =
> +		((p_best << 4) | (d_best ? 4 : 0) | REF_DIV_1);
> +}
> +
>
> ...
>
> +#ifndef MODULE
> +static int  __init i740fb_setup(char *options)
> +{
> +	char *opt;
> +
> +	if (!options || !*options)
> +		return 0;
> +
> +	while ((opt = strsep(&options, ",")) != NULL) {
> +		if (!*opt)
> +			continue;
> +#ifdef CONFIG_MTRR
> +		else if (!strncmp(opt, "mtrr:", 5))
> +			mtrr = simple_strtoul(opt + 5, NULL, 0);
> +#endif
> +		else
> +			mode_option = opt;
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +int __init i740fb_init(void)
> +{
> +#ifndef MODULE
> +	char *option = NULL;
> +
> +	if (fb_get_options("i740fb", &option))
> +		return -ENODEV;
> +	i740fb_setup(option);
> +#endif
> +
> +	return pci_register_driver(&i740fb_driver);
> +}

hm, the "ifdef MODULE" stuff looks old-fashioned, but quite a few fbdev
drivers appear to be doing it.

>
> ...
>

Should we also be adding a documentation file for thei driver?  Tell
people what the various module options do?

