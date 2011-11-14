Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1KNN4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 08:56:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35257 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1KNN4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 08:56:33 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbC=w5vRvgLVpAcmcampt-baTydpLHBexak4RzxUcO32Q@mail.gmail.com>
References: <1321074108-10025-1-git-send-email-inderpal.singh@linaro.org>
	<CACRpkdbC=w5vRvgLVpAcmcampt-baTydpLHBexak4RzxUcO32Q@mail.gmail.com>
Date: Mon, 14 Nov 2011 19:26:33 +0530
Message-ID: <CAJuYYwSvRYWdoccSN3nU7G4zXyTjt7vkjAd_vDx=QchG+yd5Cg@mail.gmail.com>
Subject: Re: [PATCH] ARM: SAMSUNG: Save/restore GPIO drive strength across suspend/resume
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Inderpal Singh <inderpal.singh@linaro.org>,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 12 November 2011 16:30, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Nov 12, 2011 at 6:01 AM, Inderpal Singh
> <inderpal.singh@linaro.org> wrote:
>
>> GPIO driver strength settings are not preserved across suspend/resume
>> for s5pc100, s5pv210 and Exynos platforms which has been the cause of
>> mmc/sd card read/write failures after resume. Fix this by saving and
>> restoring the GPIO driver strength register settings across suspend/resume.
>>
>> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
>
> On a related theme: I am thinking about how to support preserving
> drive strength (etc) across suspend/resume and deepsleep in the
> pincontrol subsystem.
>
> Currently I am playing with the idea to let pin groups have states,
> as the different configurations seem to be 90% or so about very
> specific sleep modes, so say:
>
> pinconf_set_group_state("mmcgroup", PINCONF_STATE_ACTIVE);
> pinconf_set_group_state("mmcgroup", PINCONF_STATE_SUSPENDED);
> pinconf_set_group_state("mmcgroup", PINCONF_STATE_SLEEP);


The API name suggests that power state is set based on a pin group.
For a driver, the following could be convenient as the driver transits
through various power management states.

struct pinmux pmx;
pmx = pinmux_get(dev, "i2c0");

[...]

pinmux_set_state(pmx, PINCONF_STATE_SLEEP);
[...]
pinmux_set_state(pmx, PINCONF_STATE_ACTIVE);


>
> This would then instruct each pin controller driver to configure
> each pin apropriately for the given state, and that cross-references
> to a table keeping track of the preset per-pin for each state.
>
> My intuitive idea is that letting the core keep track of the state of
> every pin and letting pin groups harness the settings for a group
> of pins is the proper approach to the problem.
>
> Do you think something like this will work for the S5P:s?


Adding the responsibility of managing/configuring registers for
different power states to a pin group does seem suitable for Exynos.
Along with the pin list, a implementation of a pin group could include
a callback to manage the registers for a particular pin state. Such a
callback could be reused for all the pin groups as required.

Thanks,
Thomas.

>
> Yours,
> Linus Walleij
>
