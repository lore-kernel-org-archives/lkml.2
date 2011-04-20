Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1DTPjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:39:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34170 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1DTPj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mAMq7TuA44VNBx5VRmMMB+2XhHUDqbK31OMnek5LB/gvnYnZgj0VQrzKEzAUzRppIq
         cmjh+0qWzEULKhapHPnA2sUoQETMM5AyzIAbz1kyRTYQ1BkPaP8BBlEmEsHmcEBdA+Fb
         5WxZUR/9+bOC0WZLLb/ppZfgt5V8YRFCOrs+o=
MIME-Version: 1.0
In-Reply-To: <20110420162958.09286aa7@lxorguk.ukuu.org.uk>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
	<BANLkTint6DGgosVkjK-sveyA9SL9WVS4Mg@mail.gmail.com>
	<BANLkTinaOk4Qq+uwdZQtapncwjpdTg9wmQ@mail.gmail.com>
	<20110420162958.09286aa7@lxorguk.ukuu.org.uk>
Date: Wed, 20 Apr 2011 17:39:28 +0200
X-Google-Sender-Auth: 5WNk18Ym3qSxc-cT62isAx-BrSY
Message-ID: <BANLkTi=QGoaNvJNM6SNsEduVa958bcLC1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Kyungmin Park <kmpark@infradead.org>, Ben Nizette <bn@niasdigital.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/20 Alan Cox <alan@lxorguk.ukuu.org.uk>:

> Would it not make sense to assume that given a situation where you have a
> GPIO that can be routed four ways that you actually implement it like the
> rest of the kernel - ie
>
>        r = gpio_request(n);    /* n, n+1, n+2, n+3 are the four ways
>                                */
>
>        if (r < 0)      /* EBUSY - someone else is using one of the
>                                four */
>                return -EBUSY;
>        /* Succeeded - will also have set the mux for us */
>
> At that point drivers don't need to know if a GPIO is muxed it'll just be
> busy if someone else is using it.

Yes indeed. I'd achive that by have the GPIO driver call the
padmux subsystem to see if it can mux in that specific pin or whether it's
taken by some other user/mux setting.

> It seems to me that if the goal of the gpio layer is to provide an
> abstraction then it can abstract muxes just fine and without needing
> drivers to know.

It's hard to use for all mux cases because it's pin-oriented rather
than mux-setting oriented I'd say.

For example: pins 0-7 can be used for an SDIO interface, or
you can use pins 0-3 and 4-7 as two SPI interfaces (just making
this up) then what you want is to control different mux alternatives
than mapping specific pins.

So my idea is you abstract muxes separately, we've done so
in the past, see c.f. this crude but working example:
arch/arm/mach-u300/padmux.[c|h]:

enum pmx_settings {
        U300_APP_PMX_MMC_SETTING,
        U300_APP_PMX_SPI_SETTING
};

struct pmx *pmx_get(struct device *dev, enum pmx_settings setting);
int pmx_put(struct device *dev, struct pmx *pmx);
int pmx_activate(struct device *dev, struct pmx *pmx);
int pmx_deactivate(struct device *dev, struct pmx *pmx);

(then snip mmc.c):

        /*
         * Setup padmuxing for MMC. Since this must always be
         * compiled into the kernel, pmx is never released.
         */
        pmx = pmx_get(mmcsd_device, U300_APP_PMX_MMC_SETTING);

        if (IS_ERR(pmx))
                pr_warning("Could not get padmux handle\n");
        else {
                ret = pmx_activate(mmcsd_device, pmx);
                if (IS_ERR_VALUE(ret))
                        pr_warning("Could not activate padmuxing\n");
        }

So while this enum cannot cut it for the generic case, the idea
is that you enumerate your padmux settings one way or another
and this is orthogonal to GPIO or other such stuff.

Then of course the GPIO driver can in turn call the padmux
subsystem to request its pins or fail/bail out if they are taken.

Yours,
Linus Walleij
