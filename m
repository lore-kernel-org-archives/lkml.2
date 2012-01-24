Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2AXWdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:33:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61176 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2AXWdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:33:44 -0500
MIME-Version: 1.0
In-Reply-To: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
Date: Tue, 24 Jan 2012 23:33:43 +0100
Message-ID: <CACRpkdZvakueQGYX0wyTFWmpC6wiixj2g1PTuKM4CgEzqJbmig@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: add a driver for NVIDIA Tegra
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 7:22 PM, Stephen Warren <swarren@nvidia.com> wrote:

> This adds a driver for the Tegra pinmux, and required parameterization
> data for Tegra20 and Tegra30.

Very appetizing - the only scary thing is the size. Some
comments, if noone else yells after these are addressed I might
just merge it (or I find more things to complain about...)

> +static int tegra_pinconf_reg(struct tegra_pmx *pmx,
> +                            const struct tegra_pingroup *g,
> +                            enum tegra_pinconf_param param,
> +                            s8 *bank, s16 *reg, s8 *bit, s8 *width)

Why are the four last parameters signed?

Or, rather as it seems to be a consequence of this:

> +struct tegra_pingroup {
> +       const char *name;
> +       const unsigned *pins;
> +       unsigned npins;
> +       int funcs[4];
> +       int func_safe;
> +       s16 mux_reg;            /* Mux register offset */
> +       s8 mux_bank;            /* Mux register bank */
> +       s8 mux_bit;             /* Mux register bit */
> +       s16 pupd_reg;           /* Pull-up/down register offset */
> +       s8 pupd_bank;           /* Pull-up/down register bank */
> +       s8 pupd_bit;            /* Pull-up/down register bit */
> +       s16 tri_reg;            /* Tri-state register offset */
> +       s8 tri_bank;            /* Tri-state register bank */
> +       s8 tri_bit;             /* Tri-state register bit */
> +       s16 einput_reg;         /* Enable-input register offset */
> +       s8 einput_bank;         /* Enable-input register bank */
> +       s8 einput_bit;          /* Enable-input register bit */
> +       s16 odrain_reg;         /* Open-drain register offset */
> +       s8 odrain_bank;         /* Open-drain register bank */
> +       s8 odrain_bit;          /* Open-drain register bit */
> +       s16 lock_reg;           /* Lock register offset */
> +       s8 lock_bank;           /* Lock register bank */
> +       s8 lock_bit;            /* Lock register bit */
> +       s16 ioreset_reg;        /* IO reset register offset */
> +       s8 ioreset_bank;        /* IO reset register bank */
> +       s8 ioreset_bit;         /* IO reset register bit */
> +       s16 drv_reg;            /* Drive fields register offset */
> +       s8 drv_bank;            /* Drive fields register bank */
> +       s8 hsm_bit;             /* High Speed Mode register bit */
> +       s8 schmitt_bit;         /* Scmitt register bit */
> +       s8 lpmd_bit;            /* Low Power Mode register bit */
> +       s8 drvdn_bit;           /* Drive Down register bit */
> +       s8 drvdn_width;         /* Drive Down field width */
> +       s8 drvup_bit;           /* Drive Up register bit */
> +       s8 drvup_width;         /* Drive Up field width */
> +       s8 slwr_bit;            /* Slew Rising register bit */
> +       s8 slwr_width;          /* Slew Rising field width */
> +       s8 slwf_bit;            /* Slew Falling register bit */
> +       s8 slwf_width;          /* Slew Falling field width */
> +};

Why are all of these things (reg bank bit ets) signed?
Especially since a lot of them appear to translate into
readl() writel() calls in the end, and these are unsigned.

Also, things named  *_bit are a bit (no pun intended) binary,
are they containing a single bit? In that case say

u8 foo:1

To mark that it's only one bit wide, or u8 foo:4 for four bits
etc.

Looking from the use of them in this manner:

val &= ~(0x3 << g->mux_bit);

It looks like mux_bit should be

u8 mux_bit:2;

And so on.

func_safe doesn't look like an int either when I look at
the code. It's something else, u8?

Second, please move out the inline comment to kerneldoc
above the struct.

The rest is pretty straight forward I think.

Yours,
Linus Wallleij
