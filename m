Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1KGM36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:29:58 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47547 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab1KGM34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:29:56 -0500
MIME-Version: 1.0
In-Reply-To: <5366f62b74861af357a0aecdb4e27aa69ffd703b.1320312035.git.viresh.kumar@st.com>
References: <5366f62b74861af357a0aecdb4e27aa69ffd703b.1320312035.git.viresh.kumar@st.com>
Date: Mon, 7 Nov 2011 13:29:54 +0100
Message-ID: <CACRpkdY=uN9W26mE7=TyXGkhcWsfOeGOyTBGQ3WzabNNHqa_-w@mail.gmail.com>
Subject: Re: [PATCH] mfd/stmpe: Add support for irq over gpio pin
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: rabin.vincent@stericsson.com, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com, bhavna.yadav@st.com,
        vincenzo.frascino@st.com, mirko.gardi@st.com,
        srinidhi.kasagar@stericsson.com, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Thu, Nov 3, 2011 at 10:26 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> @@ -925,15 +928,28 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
>
>        i2c_set_clientdata(i2c, stmpe);
>
> +       if (pdata->irq_over_gpio) {
> +               ret = gpio_request_one(pdata->irq_gpio, GPIOF_DIR_IN, "stmpe");
> +               if (ret) {
> +                       dev_err(stmpe->dev, "failed to request IRQ GPIO: %d\n",
> +                                       ret);
> +                       goto out_free;
> +               }
> +
> +               stmpe->irq = gpio_to_irq(pdata->irq_gpio);
> +       } else {
> +               stmpe->irq = i2c->irq;
> +       }
> +
>        ret = stmpe_chip_init(stmpe);
>        if (ret)
> -               goto out_free;
> +               goto free_gpio;
>
>        ret = stmpe_irq_init(stmpe);
>        if (ret)
> -               goto out_free;
> +               goto free_gpio;
>
> -       ret = request_threaded_irq(stmpe->i2c->irq, NULL, stmpe_irq,
> +       ret = request_threaded_irq(stmpe->irq, NULL, stmpe_irq,
>                                   pdata->irq_trigger | IRQF_ONESHOT,
>                                   "stmpe", stmpe);
>        if (ret) {
> @@ -951,9 +967,11 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
>
>  out_removedevs:
>        mfd_remove_devices(stmpe->dev);
> -       free_irq(stmpe->i2c->irq, stmpe);
> +       free_irq(stmpe->irq, stmpe);
>  out_removeirq:
>        stmpe_irq_remove(stmpe);
> +free_gpio:
> +       gpio_free(pdata->irq_gpio);

Will that work if you didn't request irq over GPIO?

If you did not request GPIO and stmpe_chip_init()
fails this will still be executed.

Maybe:

if (pdata->irq_over_gpio)
   gpio_free(pdata->irq_gpio);

>  out_free:
>        kfree(stmpe);
>        return ret;
> @@ -965,9 +983,12 @@ static int __devexit stmpe_remove(struct i2c_client *client)
>
>        mfd_remove_devices(stmpe->dev);
>
> -       free_irq(stmpe->i2c->irq, stmpe);
> +       free_irq(stmpe->irq, stmpe);
>        stmpe_irq_remove(stmpe);
>
> +       if (stmpe->pdata->irq_over_gpio)
> +               gpio_free(stmpe->pdata->irq_gpio);
> +

Here it seems correct.

> diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
> index be1af7c..7901351 100644
> --- a/include/linux/mfd/stmpe.h
> +++ b/include/linux/mfd/stmpe.h
> @@ -76,6 +76,7 @@ struct stmpe {
>        struct stmpe_variant_info *variant;
>        const u8 *regs;
>
> +       int irq;
>        int irq_base;
>        int num_gpios;
>        u8 ier[2];
> @@ -194,6 +195,8 @@ struct stmpe_platform_data {
>        unsigned int irq_trigger;
>        bool irq_invert_polarity;
>        bool autosleep;
> +       bool irq_over_gpio;
> +       int irq_gpio;
>        int autosleep_timeout;

Please also update the kerneldoc for struct stmpe.

Yours,
Linus Walleij
