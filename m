Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2FRQkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:40:53 -0400
Received: from antcom.de ([188.40.178.216]:44164 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab2FRQkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:40:51 -0400
Message-ID: <4FDF5A10.5080706@antcom.de>
Date: Mon, 18 Jun 2012 18:40:48 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org
Subject: Re: [PATCH] gpio: of_get_named_gpio_flags() return -EPROBE_DEFER
 if GPIO not yet available
References: <1339927893-8842-1-git-send-email-stigge@antcom.de> <4FDE8D27.6030508@wwwdotorg.org> <4FDEF293.9080305@antcom.de> <4FDF403E.9090302@wwwdotorg.org> <4FDF4461.60707@antcom.de> <4FDF4543.6090009@wwwdotorg.org> <4FDF47D8.9000309@antcom.de> <4FDF4D14.50203@wwwdotorg.org>
In-Reply-To: <4FDF4D14.50203@wwwdotorg.org>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 05:45 PM, Stephen Warren wrote:
>>>> Should be easy to fix (replacing the if (... == -ENODEV) to -EPROBE_DEFER.
>>>>
>>>> Will you provide patches as signalled, of should I? Which branch would
>>>> be the correct one to build on top?
>>>
>>> I'm happy either way. It'd probably be best to roll the change into your
>>> patch/series so you can manage all the dependencies in one series, but
>>> if you can't for some reason, I'm happy to provide a patch for this.
>>
>> I should be able ;-) - is broonie's sound.git, branch for-next the
>> correct one to patch against?
> 
> Yes, that's the one. Thanks.

I'm posting this as a series of 2 for the sound changes only. Would be 
easiest to merge separately via sound/for-next, and the gpiolib-of 
change via gpio. However, this could break bisecting.

Since the respective precondition commits are only in the sound tree, 
this would be the only one practical for merging a single combined 
patch (combining those 3). Would this be OK for the GPIO maintainers? 
It's practically only a one-line change in gpiolib-of.c that would come 
in via sound.

Thanks in advance,

Roland


PS: Just for illustration purposes for the sound maintainers:
---
 drivers/gpio/gpiolib-of.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.orig/drivers/gpio/gpiolib-of.c
+++ linux-2.6/drivers/gpio/gpiolib-of.c
@@ -62,7 +62,10 @@ static int of_gpiochip_find_and_xlate(st
 int of_get_named_gpio_flags(struct device_node *np, const char *propname,
                            int index, enum of_gpio_flags *flags)
 {
-       struct gg_data gg_data = { .flags = flags, .out_gpio = -ENODEV };
+       /* Return -EPROBE_DEFER to support probe() functions to be called
+        * later when the GPIO actually becomes available
+        */
+       struct gg_data gg_data = { .flags = flags, .out_gpio = -EPROBE_DEFER };
        int ret;

        /* .of_xlate might decide to not fill in the flags, so clear it. */
