Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2HXBrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:47:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33385 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2HXBra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:47:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Davide Ciminaghi <dciminaghi@mail.gnudd.com>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1340242165-4279-1-git-send-email-dciminaghi@mail.gnudd.com>
Cc: shawn.guo@linaro.org, viresh.linux@gmail.com, arnd@arndb.de,
        akpm@linux-foundation.org, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
References: <1340242165-4279-1-git-send-email-dciminaghi@mail.gnudd.com>
Message-ID: <20120824014719.4547.80902@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH RFC] sta2x11 common clock framework implementation
Date: Thu, 23 Aug 2012 18:47:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Davide Ciminaghi (2012-06-20 18:29:25)
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 7b989ca..72013efe 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -497,6 +497,9 @@ config STA2X11
>         depends on X86_32_NON_STANDARD && PCI
>         select X86_DEV_DMA_OPS
>         select X86_DMA_REMAP
> +       select HAVE_CLK
> +       select CLKDEV_LOOKUP
> +       select COMMON_CLK
>         select SWIOTLB
>         select MFD_STA2X11
>         select ARCH_REQUIRE_GPIOLIB

You only need to select COMMON_CLK here.  It selects CLKDEV_LOOKUP which
in turn selects HAVE_CLK.

<snip>
> diff --git a/drivers/clk/sta2x11/clk-audio-pll.c b/drivers/clk/sta2x11/clk-audio-pll.c
> new file mode 100644
> index 0000000..6b28126
> --- /dev/null
> +++ b/drivers/clk/sta2x11/clk-audio-pll.c
> @@ -0,0 +1,146 @@
> +/*
> + * Common clock api implementation for sta2x11
> + * audio-pll clock type implementation
> + *

Nitpick:  It is more common to put the copyright header at the very top
and then this brief description below it.

> + * Copyright ST Microelectronics 2012 (Davide Ciminaghi)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */

<snip>
> +static int clk_audio_pll_enable(struct clk_hw *hw)
> +{
> +       struct clk_audio_pll *audio_pll = to_clk_audio_pll(hw);
> +       u32 scpllctl;
> +       spin_lock(audio_pll->lock);

spin_lock_irqsave?  clk_enable may be called with interrupts disabled.

> +       scpllctl = readl(audio_pll->base + SCTL_SCPLLCTL);
> +       scpllctl &= ~SCTL_SCPLLCTL_AUDIO_PLL_PD;
> +       writel(scpllctl, audio_pll->base + SCTL_SCPLLCTL);
> +       spin_unlock(audio_pll->lock);

ditto.

> +       return 0;
> +}
> +
> +static void clk_audio_pll_disable(struct clk_hw *hw)
> +{
> +       struct clk_audio_pll *audio_pll = to_clk_audio_pll(hw);
> +       u32 scpllctl;
> +       spin_lock(audio_pll->lock);

ditto.

> +       scpllctl = readl(audio_pll->base + SCTL_SCPLLCTL);
> +       scpllctl |= SCTL_SCPLLCTL_AUDIO_PLL_PD;
> +       writel(scpllctl, audio_pll->base + SCTL_SCPLLCTL);
> +       spin_unlock(audio_pll->lock);

ditto.

> +}
> +
> +static const struct clk_ops clk_soc_pll_ops = {
> +       .enable = clk_audio_pll_enable,
> +       .disable = clk_audio_pll_disable,
> +       .recalc_rate = clk_audio_pll_recalc_rate,
> +};
> +
> +
> +struct clk *sta2x11_clk_audio_pll(const char *name, const char *parent_name,
> +                                 void __iomem *base, spinlock_t *lock)
> +{

How about register_sta2x11_clk_audio_pll?

> diff --git a/drivers/clk/sta2x11/clk-soc-pll.c b/drivers/clk/sta2x11/clk-soc-pll.c
> new file mode 100644
> index 0000000..80dc8bc
> --- /dev/null
> +++ b/drivers/clk/sta2x11/clk-soc-pll.c
> @@ -0,0 +1,94 @@
> +/*
> + * Common clock api implementation for sta2x11
> + * soc-pll clock type implementation
> + *
> + * Copyright ST Microelectronics 2012 (Davide Ciminaghi)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +#define DEBUG
> +
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/sta2x11-mfd.h>
> +#include <asm/sta2x11.h>

#include <clk-provider.h>?

<snip>
> diff --git a/drivers/clk/sta2x11/clk.h b/drivers/clk/sta2x11/clk.h
> new file mode 100644
> index 0000000..f505a64
> --- /dev/null
> +++ b/drivers/clk/sta2x11/clk.h
> @@ -0,0 +1,68 @@
> +/*
> + * Common clock api implementation for sta2x11
> + *
> + * Davide Ciminaghi 2012 <ciminaghi@gnudd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +#ifndef __STA2X11_CLK_H__
> +#define __STA2X11_CLK_H__
> +
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>

If clk-provider.h is included then clk.h is redundant.

<snip>
> +/*
> + * struct sta2x11_clk_data
> + * This structure is used to build the table listing all the
> + * clocks for a connext chip.
> + *
> + * @basename : basename of the clock (a .%d suffix will be added to
> + * deal with multiple connext instances).
> + * @type : sta2x11 clock type (see clk.h, enum sta2x11_clk_type)
> + * @reg_offset : the controlling register's offset for this clock
> + * @init : pointer to init function. When this pointer is not NULL, the
> + * pointed function is invoked before clock registration. This is used to
> + * fill the clock struct fields which are unknown at compile time (typically
> + * virtual addresses of controlling registers).
> + * @args : arguments needed for registration
> + */
> +struct sta2x11_clk_data {
> +       const char *basename;
> +       int type;
> +       unsigned int reg_offset;
> +       void (*init)(struct sta2x11_clk_data *, struct sta2x11_clk_reg_data *);
> +       unsigned long flags;
> +       union {
> +               struct  {
> +                       const char *parent_name;
> +                       unsigned long rate;
> +               } fixed_rate_root;
> +               struct {
> +                       const char *parent_name;
> +                       unsigned int mult;
> +                       unsigned int div;
> +               } fixed_factor;
> +               struct {
> +                       const char **parent_names;
> +                       u8 num_parents;
> +                       void __iomem *reg;
> +                       u8 shift;
> +                       u8 width;
> +                       u8 clk_mux_flags;
> +                       spinlock_t *lock;
> +               } mux;
> +               struct {
> +                       const char *parent_name;
> +                       void __iomem *base;
> +                       spinlock_t *lock;
> +               } soc_pll;
> +               struct {
> +                       const char *parent_name;
> +                       void __iomem *base;
> +                       spinlock_t *lock;
> +               } audio_pll;
> +               struct {
> +                       const char *parent_name;
> +                       void __iomem *reg;
> +                       u8 shift;
> +                       u8 width;
> +                       spinlock_t *lock;
> +                       unsigned int *div_tab;
> +               } tab_divider;
> +       } args;
> +};
> +

Yikes.  Is this code copied from a legacy clock framework
implementation?  Since we have the nice struct clk_hw abstraction now I
think it is worth considering breaking up struct sta2x11_clk_data into
separate structs, one for each clock types.  This lets you get rid of
the union and the .type member while keeping things nice and tidy and
reducing the number of run-time checks.

> +/* Various helper macros used to setup the clock table */
> +
> +/*
> + * Use this macro to declare a fixed clock with no parents
> + *
> + * @name : clock name
> + * @f : clock frequency
> + */
> +#define DECLARE_FIXED_RATE_ROOT_CLK(n, f)                              \
> +       [n] = {                                                         \
> +               .basename = #n,                                         \
> +               .type = fixed_rate_root,                                \
> +               .flags = CLK_IS_ROOT,                                   \
> +               .args = {                                               \
> +                       .fixed_rate_root = {                            \
> +                               .parent_name = NULL,                    \
> +                               .rate = f,                              \
> +                       }                                               \
> +               }                                                       \
> +       }

The change mentioned above might help you with these macros.

Regards,
Mike

