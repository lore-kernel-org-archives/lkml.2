Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161021Ab2JXRck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:32:40 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37421 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935257Ab2JXRci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <1351089926-32161-3-git-send-email-lee.jones@linaro.org>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
	<1351089926-32161-3-git-send-email-lee.jones@linaro.org>
Date: Wed, 24 Oct 2012 19:32:37 +0200
Message-ID: <CACRpkdaeBW2ecQZ2fA-hL8o47pYpjZ=5Mn131F87u58rX+dekw@mail.gmail.com>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The clock framework has changed somewhat and it's now better to
> invoke clock_prepare_enable() and clk_disable_unprepare() rather
> than the legacy clk_enable() and clk_disable() calls. This patch
> converts the Nomadik Pin Control driver to the new framework.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

(...)
> -               clk_enable(chip->clk);
> +               clk_prepare_enable(chip->clk);
(...)
> -               clk_disable(chip->clk);
> +               clk_disable_unprepare(chip->clk);

(Repeated for each occurence.)

Is this *really* causing a regression? I mean the driver
begin like this in nmk_gpio_probe():

        clk = devm_clk_get(&dev->dev, NULL);
        if (IS_ERR(clk)) {
                ret = PTR_ERR(clk);
                goto out;
        }
        clk_prepare(clk);

Then it leaves the clock prepared. So the clock is always
prepared. You would only need to enable/disable it at times.

And the semantics of the clk_enable/clk_disable call pair
is such that it is fastpath and should be real quick, and that
is exactly why we're using it repeatedly like that. Inserting
clk_unprepare() effectively could make the whole driver a
lot slower, so convince me on this one. ...

I suspect the real bug (if there is one) must be in the clock
implementation.

Yours,
Linus Walleij
