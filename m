Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1KRL74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:59:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36974 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1KRL7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:59:55 -0500
MIME-Version: 1.0
In-Reply-To: <d2b66ba1a6c2b34f7e0b82e31bc360684c734759.1321507421.git.viresh.kumar@st.com>
References: <cover.1321507421.git.viresh.kumar@st.com> <d2b66ba1a6c2b34f7e0b82e31bc360684c734759.1321507421.git.viresh.kumar@st.com>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 18 Nov 2011 17:29:14 +0530
X-Google-Sender-Auth: QkWadkYV5FqJnO8dBldr4gOJixo
Message-ID: <CAH+eYFCLauXusdDs75qm2rGB5Y0==bhTbxPJD+gyaaZQVbvsVw@mail.gmail.com>
Subject: Re: [PATCH V2 5/5] gpio/gpio-stmpe: ADD support for stmpe variant 801
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 11:02, Viresh Kumar <viresh.kumar@st.com> wrote:
> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
> index 4c980b5..000b019 100644
> --- a/drivers/gpio/gpio-stmpe.c
> +++ b/drivers/gpio/gpio-stmpe.c
> @@ -65,7 +65,15 @@ static void stmpe_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
>        u8 reg = stmpe->regs[which] - (offset / 8);
>        u8 mask = 1 << (offset % 8);
>
> -       stmpe_reg_write(stmpe, reg, mask);
> +       /*
> +        * Some variants have single register for gpio set/clear functionality.
> +        * For them we need to write 0 to clear and 1 to set.
> +        */
> +       if (!val && (stmpe->regs[STMPE_IDX_GPSR_LSB] ==
> +                               stmpe->regs[STMPE_IDX_GPCR_LSB]))
> +               stmpe_set_bits(stmpe, reg, mask, ~mask);
> +       else
> +               stmpe_set_bits(stmpe, reg, mask, mask);
>  }

This code,

 (1) for 801, when clearing one GPIO, sets all the others.
 (2) for other devices, adds an an unnecessary read (within stmpe_set_bits()),
     which wasn't there before.

Please rework to something like:

	if (stmpe->regs[...)
		stmpe_set_bits(stmpe, reg, mask, val ? mask : 0);
	else
		stmpe_reg_write(stmpe, reg, mask);

>
>  static int stmpe_gpio_direction_output(struct gpio_chip *chip,
> @@ -125,10 +133,19 @@ static struct gpio_chip template_chip = {
>  static int stmpe_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  {
>        struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
> +       struct stmpe *stmpe = stmpe_gpio->stmpe;
>        int offset = d->irq - stmpe_gpio->irq_base;
>        int regoffset = offset / 8;
>        int mask = 1 << (offset % 8);
>
> +       /* STMPE801 doesn't have RE and FE registers */
> +       if (stmpe->partnum == STMPE801) {
> +               if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
> +                       return 0;

This looks wrong.  From the datasheet I see that it supports edges only,
so perhaps you meant to say IRQ_TYPE_EDGE_* above.

In that case please reorganize this to add the return 0 after the
existing check which excludes levels (below).

> +               else
> +                       return -EINVAL;
> +       }
> +
>        if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
>                return -EINVAL;
