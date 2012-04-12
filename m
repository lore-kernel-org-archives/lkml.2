Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab2DLPFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:05:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59402 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab2DLPFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:05:44 -0400
MIME-Version: 1.0
In-Reply-To: <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
References: <cover.1334219873.git.rubini@gnudd.com>
	<5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
Date: Thu, 12 Apr 2012 17:05:43 +0200
Message-ID: <CACRpkdZCY+tbTgPyt7MWaZw93O_m28tMgaB8SbDAtJS-0VuGtw@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 10:48 AM, Alessandro Rubini <rubini@gnudd.com> wrote:

> +/*
> + * Special method: alternate functions and pullup/pulldown. This is only
> + * invoked on startup to configure gpio's according to platform data.
> + * FIXME : this functionality shall be managed (and exported to other drivers)
> + * via the pin control subsystem.
> + */
> +static void gsta_set_config(struct gsta_gpio *chip, int nr, unsigned cfg)
> +{
> +       struct gsta_regs __iomem *regs = __regs(chip, nr);
> +       unsigned long flags;
> +       u32 bit = __bit(nr);
> +       u32 val;
> +       int err = 0;
> +
> +       pr_info("%s: %p %i %i\n", __func__, chip, nr, cfg);
> +
> +       if (cfg == PINMUX_TYPE_NONE)
> +               return;
> +
> +       /* Alternate function or not? */
> +       spin_lock_irqsave(&chip->lock, flags);
> +       val = readl(&regs->afsela);
> +       if (cfg == PINMUX_TYPE_FUNCTION)
> +               val |= bit;
> +       else
> +               val &= ~bit;
> +       writel(val | bit, &regs->afsela);
> +       if (cfg == PINMUX_TYPE_FUNCTION) {
> +               spin_unlock_irqrestore(&chip->lock, flags);
> +               return;
> +       }
> +
> +       /* not alternate function: set details */
> +       switch (cfg) {
> +       case PINMUX_TYPE_OUTPUT_LOW:
> +               writel(bit, &regs->dirs);
> +               writel(bit, &regs->datc);
> +               break;
> +       case PINMUX_TYPE_OUTPUT_HIGH:
> +               writel(bit, &regs->dirs);
> +               writel(bit, &regs->dats);
> +               break;
> +       case PINMUX_TYPE_INPUT:
> +               writel(bit, &regs->dirc);
> +               val = readl(&regs->pdis) | bit;
> +               writel(val, &regs->pdis);
> +               break;
> +       case PINMUX_TYPE_INPUT_PULLUP:
> +               writel(bit, &regs->dirc);
> +               val = readl(&regs->pdis) & ~bit;
> +               writel(val, &regs->pdis);
> +               writel(bit, &regs->dats);
> +               break;
> +       case PINMUX_TYPE_INPUT_PULLDOWN:
> +               writel(bit, &regs->dirc);
> +               val = readl(&regs->pdis) & ~bit;
> +               writel(val, &regs->pdis);
> +               writel(bit, &regs->datc);
> +               break;
> +       default:
> +               err = 1;
> +       }
> +       spin_unlock_irqrestore(&chip->lock, flags);
> +       if (err)
> +               pr_err("%s: chip %p, pin %i, cfg %i is invalid\n",
> +                      __func__, chip, nr, cfg);
> +}

I would still prefer to use the pinctrl subsystem for this from day 1 instead of
adding more custom stuff for later refactoring...

Yours,
Linus Walleij
