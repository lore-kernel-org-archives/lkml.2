Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1LAKLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:11:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64586 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1LAKLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:11:37 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174FDAFF30@HQMAIL01.nvidia.com>
References: <1322160380-27711-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDAFF30@HQMAIL01.nvidia.com>
Date: Thu, 1 Dec 2011 11:11:36 +0100
Message-ID: <CACRpkdZueyZkOq20qq_jDn27cfkChM58cR+TvPKfifSwFwiQ5w@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] pinctrl: introduce generic pin config
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 8:45 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, November 24, 2011 11:46 AM:

>> +void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
> ...
>> +     for(i = 0; i < ARRAY_SIZE(conf_items); i++) {
> ...
>> +             /* We want to check out this parameter */
>> +             config = (unsigned long) conf_items[i].param;
>
> Don't you need to use to_config_packed() here?

Yep! Fixed it.

>> +             ret = pin_config_get(pctldev, pin, &config);
>> +             /* These are legal errors */
>> +             if (ret == -EINVAL || ret == -ENOTSUPP)
>> +                     continue;
>
> Ah, I guess I see why you consider -ENOTSUPP an error that you don't want
> to print to syslog. Maybe you should call _pin_config_get() here which
> doesn't spew messages on -ENOTSUPP, but have the public pin_config_get()
> function spew errors.

I just deleted the error check for now since it's not necessary.
Better keep the code compact and simple.

>> +             if (ret) {
>> +                     seq_printf(s, "ERROR READING CONFIG SETTING %d ", i);
>> +                     continue;
>> +             }
>> +             /* Space between multiple configs */
>> +             seq_puts(s, " ");
>> +             seq_puts(s, conf_items[i].display);
>> +             /* Print unit if available */
>> +             if (conf_items[i].format && config != 0)
>> +                     seq_printf(s, " (%lu %s)", config,
>> +                                conf_items[i].format);
>
> Don't you need to use to_config_argument() here?

Yes. I'm too sloppy :-(

>> @@ -169,6 +169,8 @@ static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
>>  {
>>       const struct pinconf_ops *ops = pctldev->desc->confops;
>>
>> +     /* no-op when not using generic pin config */
>> +     pinconf_generic_dump_pin(pctldev, s, pin);
>>       if (ops && ops->pin_config_dbg_show)
>>               ops->pin_config_dbg_show(pctldev, s, pin);
>>  }
>
> This is really a comment on the previous patch, but what about config
> params that only apply to groups?

Oh! I need to create a separate debugfs file for that.
Thanks for this nice catch!

>> diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
>
>> +/*
>> + * You shouldn't even be able to compile with these enums etc unless you're
>> + * using generic pin config. That is why this is defined out.
>> + */
>> +#ifdef CONFIG_GENERIC_PINCONF
>
> Hmm. I'd prefer to have drivers able to use both generic values and
> extend them with custom values. Can't we just use the top bit of the
> param value to indicate 0:standard (from the enum below) 1:custom
> (something meaningful to only the individual pinctrl driver). This
> could then trigger calling pinconf_generic_dump_pin() or not for
> example.

Hm...

That will get messy when if I refactor this stuff, add new enums
and whatever.

>> +#ifdef CONFIG_GENERIC_PINCONF
>> +     bool is_generic;
>> +#endif
>
> ... and get rid of that flag.

This is for the case wher you have both generic and non-generic
config controllers onboard a system.

Like in the generic debugfs dump function:

	if (!ops->is_generic)
		return;

If I take this out, the generic debugfs code will be used for
everything.

And then the generic sematics which you didn't like in the
previous patch:

if (ret == -EINVAL || ret == -ENOTSUPP)

Need to go back in, else the generic debugfs stuff won't
work.

I'm really not sure about that kind of extension, it feels to
me like a hard-to grasp unstable middleground between two
clean-cut solutions "all custom" or "all generic".

Yours,
Linus Walleij
