Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1JMKjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:39:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61273 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab1JMKjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:39:10 -0400
MIME-Version: 1.0
In-Reply-To: <20111013031819.GA15829@ponder.secretlab.ca>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
	<20111013031819.GA15829@ponder.secretlab.ca>
Date: Thu, 13 Oct 2011 12:39:08 +0200
Message-ID: <CACRpkdb_HTjYHmX6BZC3Q7h8Zr5VKb6rbyUd8oeuCyvJQxbstA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 5:18 AM, Grant Likely <grant.likely@secretlab.ca> wrote:

> Nit: put the changelog above the s-o-b lines so it will appear in the
> linux commit log.

OK I'll collect all of them and stash them into it for v10

>> +The GPIO drivers may want to perform operations of various types on the same
>> +physical pins that are also registered as GPIO pins.
>
> ...also registered as PINMUX pins?

Yes.

>>  source "drivers/ptp/Kconfig"
>>
>> +# pinctrl before gpio - gpio drivers may need it
>
> This shouldn't actually be an ordering constraint.  It might be a
> temporary restriction on the Makefiles, but it isn't at all for Kconfig.

True, was blinded by similar comments in that Kconfig, such as
this:
# input before char - char/joystick depends on it. As does USB.

Anyway I took out the comment.

>> +menuconfig PINCTRL
>> +     bool "PINCTRL Support"
>> +     depends on SYSFS && EXPERIMENTAL
>
> Why depends on SYSFS?  That shouldn't be a consideration at all.

Dropped last week. Leftover from when I registered this
bus...

>> +
>> +/**
>> + * get_pctldev_from_dev() - look up pin controller device
>
> Naming abbreviation is a little agressive.  Please use pinctrl
> everywhere instead of a mix between pctl and pinctrl.

OK. Renamed a few functions accordingly.
Also added a fixup to the SirfPrimaII driver to use
the new names.

>> +     if (found)
>> +             return pctldev;
>> +
>> +     return NULL;
>
> or simply:
>
>        return found ? pctldev : NULL;

OK.

>> +     /* Loop over the pin controllers */
>> +     mutex_lock(&pinctrldev_list_mutex);
>> +     list_for_each_entry(pctldev, &pinctrldev_list, node) {
>> +             struct pinctrl_gpio_range *range;
>> +
>> +             range = pinctrl_match_gpio_range(pctldev, gpio);
>> +             if (range != NULL) {
>> +                     *outdev = pctldev;
>> +                     *outrange = range;
>> +                     return 0;
>
> Neglected to drop mutex

Yep noted by another reviewe also today...

>> +/**
>> + * pinctrl_register() - register a pin controller device
>> + * @pctldesc: descriptor for this pin controller
>> + * @dev: parent device for this pin controller
>> + * @driver_data: private pin controller data for this pin controller
>> + */
>> +struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
>> +                                 struct device *dev, void *driver_data)
>> +{
>> +     static atomic_t pinmux_no = ATOMIC_INIT(0);
>> +     struct pinctrl_dev *pctldev;
>> +     int ret;
>> +
>> +     if (pctldesc == NULL)
>> +             return ERR_PTR(-EINVAL);
>
> I urge you to consider carefully before relying on the ERR_PTR()
> pattern.  It isn't easy to for a compiler or a human to check if
> ERR_PTR values are being handled properly, and is therefore a likely
> source of bugs.  Unless it is *absolutely critical* to return an error
> code instead of NULL on error, I strongly recommend returning NULL
> from this function on failure.
>
> From what I see from this function, the error codes are less useful
> that using pr_err() calls.

Agreed, we return NULL on error instead.
Design pattern comes from clocks and regulators, it's not
that useful in this case, maybe not in the other cases either.

Fixed usage in U300 and Sirf controller as well.

> I think this is pretty close to ready.  If you address the comments
> I've made above then you can add my Acked-by:
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Thanks a lot Grant!

Yours,
Linus Walleij
