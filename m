Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030446Ab2CIWu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:50:56 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:59326 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030323Ab2CIWuw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:50:52 -0500
MIME-Version: 1.0
In-Reply-To: <20120307212025.GC26882@pengutronix.de>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org> <20120307212025.GC26882@pengutronix.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 9 Mar 2012 14:50:26 -0800
Message-ID: <CAJOA=zM0rymi3r897grTbWRA2UZm07Fb4682ee15Z0Zz1RtA3g@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] clk: basic clock hardware types
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 1:20 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Sat, Mar 03, 2012 at 12:29:01AM -0800, Mike Turquette wrote:
>> +struct clk *clk_register_divider(struct device *dev, const char *name,
>> +             const char *parent_name, unsigned long flags,
>> +             void __iomem *reg, u8 shift, u8 width,
>> +             u8 clk_divider_flags, spinlock_t *lock)
>> +{
>> +     struct clk_divider *div;
>> +     char **parent_names = NULL;
>> +     u8 len;
>> +
>> +     div = kmalloc(sizeof(struct clk_divider), GFP_KERNEL);
>> +
>> +     if (!div) {
>> +             pr_err("%s: could not allocate divider clk\n", __func__);
>> +             return ERR_PTR(-ENOMEM);
>> +     }
>> +
>> +     /* struct clk_divider assignments */
>> +     div->reg = reg;
>> +     div->shift = shift;
>> +     div->width = width;
>> +     div->flags = clk_divider_flags;
>> +     div->lock = lock;
>> +
>> +     if (parent_name) {
>> +             parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
>> +
>> +             if (! parent_names)
>> +                     goto out;
>> +
>> +             len = sizeof(char) * strlen(parent_name);
>> +
>> +             parent_names[0] = kmalloc(len, GFP_KERNEL);
>> +
>> +             if (!parent_names[0])
>> +                     goto out;
>> +
>> +             strncpy(parent_names[0], parent_name, len);
>> +     }
>> +
>> +out:
>> +     return clk_register(dev, name,
>> +                     &clk_divider_ops, &div->hw,
>> +                     parent_names,
>> +                     (parent_name ? 1 : 0),
>> +                     flags);
>> +}
>
> clk_register_divider and also clk_register_gate have some problems.
> First you allocate memory with exactly the string length without
> the terminating 0. Then the functions leak memory when clk_register
> fails. Could you fold in the following patch to fix this?

Thanks for the patch Sascha.  This has been pulled into v6 and tested.

Regards,
Mike

>
> Sascha
>
> 8<--------------------------------------------------
>
> fix divider/gate registration
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/clk/clk-divider.c    |   34 +++++++++++++++-------------------
>  drivers/clk/clk-gate.c       |   33 ++++++++++++++-------------------
>  include/linux/clk-provider.h |    2 ++
>  3 files changed, 31 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 8f02930..99b6b55 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -156,14 +156,13 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
>                u8 clk_divider_flags, spinlock_t *lock)
>  {
>        struct clk_divider *div;
> -       char **parent_names = NULL;
> -       u8 len;
> +       struct clk *clk;
>
> -       div = kmalloc(sizeof(struct clk_divider), GFP_KERNEL);
> +       div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
>
>        if (!div) {
>                pr_err("%s: could not allocate divider clk\n", __func__);
> -               return ERR_PTR(-ENOMEM);
> +               return NULL;
>        }
>
>        /* struct clk_divider assignments */
> @@ -174,25 +173,22 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
>        div->lock = lock;
>
>        if (parent_name) {
> -               parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
> -
> -               if (! parent_names)
> -                       goto out;
> -
> -               len = sizeof(char) * strlen(parent_name);
> -
> -               parent_names[0] = kmalloc(len, GFP_KERNEL);
> -
> -               if (!parent_names[0])
> +               div->parent[0] = kstrdup(parent_name, GFP_KERNEL);
> +               if (!div->parent[0])
>                        goto out;
> -
> -               strncpy(parent_names[0], parent_name, len);
>        }
>
> -out:
> -       return clk_register(dev, name,
> +       clk = clk_register(dev, name,
>                        &clk_divider_ops, &div->hw,
> -                       parent_names,
> +                       div->parent,
>                        (parent_name ? 1 : 0),
>                        flags);
> +       if (clk)
> +               return clk;
> +
> +out:
> +       kfree(div->parent[0]);
> +       kfree(div);
> +
> +       return NULL;
>  }
> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> index e831f7b..92c0489 100644
> --- a/drivers/clk/clk-gate.c
> +++ b/drivers/clk/clk-gate.c
> @@ -80,14 +80,13 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
>                u8 clk_gate_flags, spinlock_t *lock)
>  {
>        struct clk_gate *gate;
> -       char **parent_names = NULL;
> -       u8 len;
> +       struct clk *clk;
>
> -       gate = kmalloc(sizeof(struct clk_gate), GFP_KERNEL);
> +       gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
>
>        if (!gate) {
>                pr_err("%s: could not allocate gated clk\n", __func__);
> -               return ERR_PTR(-ENOMEM);
> +               return NULL;
>        }
>
>        /* struct clk_gate assignments */
> @@ -97,25 +96,21 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
>        gate->lock = lock;
>
>        if (parent_name) {
> -               parent_names = kmalloc(sizeof(char *), GFP_KERNEL);
> -
> -               if (! parent_names)
> -                       goto out;
> -
> -               len = sizeof(char) * strlen(parent_name);
> -
> -               parent_names[0] = kmalloc(len, GFP_KERNEL);
> -
> -               if (!parent_names[0])
> +               gate->parent[0] = kstrdup(parent_name, GFP_KERNEL);
> +               if (!gate->parent[0])
>                        goto out;
> -
> -               strncpy(parent_names[0], parent_name, len);
>        }
>
> -out:
> -       return clk_register(dev, name,
> +       clk = clk_register(dev, name,
>                        &clk_gate_ops, &gate->hw,
> -                       parent_names,
> +                       gate->parent,
>                        (parent_name ? 1 : 0),
>                        flags);
> +       if (clk)
> +               return clk;
> +out:
> +       kfree(gate->parent[0]);
> +       kfree(gate);
> +
> +       return NULL;
>  }
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 9b7dd5e..ed1f918 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -174,6 +174,7 @@ struct clk_gate {
>        u8              bit_idx;
>        u8              flags;
>        spinlock_t      *lock;
> +       char            *parent[1];
>  };
>
>  #define CLK_GATE_SET_TO_DISABLE                BIT(0)
> @@ -210,6 +211,7 @@ struct clk_divider {
>        u8              width;
>        u8              flags;
>        spinlock_t      *lock;
> +       char            *parent[1];
>  };
>
>  #define CLK_DIVIDER_ONE_BASED          BIT(0)
> --
> 1.7.9.1
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
