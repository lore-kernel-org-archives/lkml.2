Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab1EIHFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:05:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48442 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab1EIHFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nrRcJP33rN4vqmKBGBE/8xkDlf5oB4vOZ08Sw7leLgUEFhxusBvmQ96XOqJF5M8yZx
         3zk0cOePg0dXo771zy74qQlfWVW/4XNte+xWSdIPr/2DLciaowubzAas6FbAXrJNKhd7
         sWMllm7k1LaLUdvrA6PE9sv1r702VHjlTnSd4=
MIME-Version: 1.0
In-Reply-To: <1304901131-7104-17-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
	<1304901131-7104-17-git-send-email-sameo@linux.intel.com>
Date: Mon, 9 May 2011 09:05:19 +0200
X-Google-Sender-Auth: OW5R-dKDa_9LT6AnZCPA6kU3CSQ
Message-ID: <BANLkTinHyGv11px+cO_ORL0-83T4c-mbsQ@mail.gmail.com>
Subject: Re: [PATCH 16/19] mfd: Use mfd cell platform_data for tps6105x cells
 platform bits
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/9 Samuel Ortiz <sameo@linux.intel.com>:

> With the addition of a platform device mfd_cell pointer, MFD drivers
> can go back to passing platform data back to their sub drivers.
> This allows for an mfd_cell->mfd_data removal and thus keep the
> sub drivers MFD agnostic. This is mostly needed for non MFD aware
> sub drivers.
>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

I have some question marks on this one...

> --- a/drivers/mfd/tps6105x.c
> +++ b/drivers/mfd/tps6105x.c
> @@ -183,7 +183,8 @@ static int __devinit tps6105x_probe(struct i2c_client *client,
>        /* Set up and register the platform devices. */
>        for (i = 0; i < ARRAY_SIZE(tps6105x_cells); i++) {
>                /* One state holder for all drivers, this is simple */
> -               tps6105x_cells[i].mfd_data = tps6105x;
> +               tps6105x_cells[i].platform_data = tps6105x;
> +               tps6105x_cells[i].pdata_size = sizeof(*tps6105x);

ACK

> --- a/drivers/regulator/tps6105x-regulator.c
> +++ b/drivers/regulator/tps6105x-regulator.c
> @@ -137,7 +137,7 @@ static struct regulator_desc tps6105x_regulator_desc = {
>  */
>  static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
>  {
> -       struct tps6105x *tps6105x = mfd_get_data(pdev);
> +       struct tps6105x *tps6105x = pdev->dev.platform_data;

Can you use platform_get_drvdata(pdev); instead?

>        struct tps6105x_platform_data *pdata = tps6105x->pdata;
>        int ret;
>
> @@ -164,7 +164,7 @@ static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
>
>  static int __devexit tps6105x_regulator_remove(struct platform_device *pdev)
>  {
> -       struct tps6105x *tps6105x = platform_get_drvdata(pdev);
> +       struct tps6105x *tps6105x = pdev->dev.platform_data;

And this is a NO-OP, actually a bug in the present code, just leave it
as it is and the other changes removing the mfd->mfd_data fixes the bug...

Yours,
Linus Walleij
