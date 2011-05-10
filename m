Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1EJWSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:18:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46189 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1EJWSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m5hhERv2oiy94AAjinEcpOF/lLLW3KRW5PJxAGtB0CKKNUt49hITSIf4fgM9fMmYrv
         SjzkOCm41r2yL7uUUY1mtmSwYnyWy+l7JXDwqb/YnHRCVg5kA2RjZ2j9HFCq16BJWTKt
         ZKatvJ3dXjWaTU4MnSVwCqCgs46uXTHegiWVQ=
MIME-Version: 1.0
In-Reply-To: <1304365077.7792.40.camel@Joe-Laptop>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
	<1304365077.7792.40.camel@Joe-Laptop>
Date: Wed, 11 May 2011 00:18:00 +0200
X-Google-Sender-Auth: GSxfTP0ZeosbQFKj0kt9fes7h4Q
Message-ID: <BANLkTi=XSevO72NqCYOYuketjE8XjeQU+A@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/2 Joe Perches <joe@perches.com>:
> On Mon, 2011-05-02 at 21:16 +0200, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>> diff --git a/drivers/pinmux/core.c b/drivers/pinmux/core.c
>
> Trivial comments follow
>
> []
>> +static ssize_t pinmux_name_show(struct device *dev,
>> +                             struct device_attribute *attr, char *buf)
>> +{
>> +     struct pinmux_dev *pmxdev = dev_get_drvdata(dev);
>> +
>> +     return sprintf(buf, "%s\n", pmxdev_get_name(pmxdev));
>> +}
>
> Unsized buffer, maybe snprintf?

This is the idiomatic way of providing sysfs strings (compare e.g.
*_show() in drivers/regulator/core.c), the char *buf comes
from the sysfs core in struct device_attribute in <linus/device.h>
with this prototype:

 ssize_t (*show)(struct device *dev, struct device_attribute *attr,
                        char *buf);


and I have no way of knowing how large that buffer is. Migrating all
of sysfs to provide the size of its buffers may help but do you really
mean I should do that as part of this patchset? It will require
refactoring the entire kernel :-(

>> +static int pin_request(int pin, const char *function, bool gpio)
>> +{
>> +     struct pin_desc *desc;
>> +     struct pinmux_dev *pmxdev;
>> +     struct pinmux_ops *ops;
>> +     int status = -EINVAL;
>> +     unsigned long flags;
>> +
>> +     pr_debug("pin_request: request pin %d for %s\n", pin, function);
>
> pr_debug("%s: request pin...", __func__?
>
>> +             pr_err("pin_request: pin is invalid\n");
>
> same here, etc...

What I am referring to here is not the name of the C function being
executed but the function that this group of pins is performing,
so a different ontology altogether.

But the prefix is indeed the function name so I get what you mean,
fixing it!

>> +     if (!pmxdev) {
>> +             pr_warning("pin_warning: no pinmux device is handling %d!\n",
>
> You use both pr_warning and pr_warn.  Please just use pr_warn.

Sure.

> Why use "pin_warning: "?

I was drunk.

> Maybe it'd be better to add
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> or
> #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
>
> if you really want __func__.
> I suggest that __func__ isn't useful.

Yep, I'll use the first one and replace all prefixes with pure meaningful
messages instead.

(Omitting such comments below - all fixed.)

>> +static int pinmux_devices_show(struct seq_file *s, void *what)
>> +{
>> +     struct pinmux_dev *pmxdev;
>> +
>> +     seq_printf(s, "Available pinmux settings per pinmux device:\n");
>> +     list_for_each_entry(pmxdev, &pinmuxdev_list, node) {
>> +             struct pinmux_ops *ops = pmxdev->desc->ops;
>
> const struct pinmux_ops?

Yepps, const:ed it everywhere!

>> +             unsigned selector = 0;
>> +
>> +             seq_printf(s, "\nDevice %s:\n", pmxdev->desc->name);
>
> I think the initial newline isn't necessary.

Nope. Leftover.

>> +             while (ops->list_functions(pmxdev, selector) >= 0) {
>> +                     unsigned *pins;
>> +                     unsigned num_pins;
>> +                     const char *func = ops->get_function_name(pmxdev,
>> +                                                               selector);
>> +                     int ret;
>> +                     int i;
>> +
>> +                     ret = ops->get_function_pins(pmxdev, selector,
>> +                                                  &pins, &num_pins);
>> +
>> +                     if (ret)
>> +                             seq_printf(s, "%s [ERROR GETTING PINS]\n",
>> +                                        func);
>> +
>> +                     else {
>> +                             seq_printf(s, "function: %s, pins = [ ", func);
>> +                             for (i = 0; i < num_pins; i++)
>> +                                     seq_printf(s, "%d ", pins[i]);
>> +                             seq_printf(s, "]\n");
>
> seq_printf used without additional arguments could be seq_puts

Yep, fixed everywhere I sent in a non-argumented string.

>> +     (void) debugfs_create_file("devices", S_IFREG | S_IRUGO,
>> +                                debugfs_root, NULL, &pinmux_devices_ops);
>> +     (void) debugfs_create_file("maps", S_IFREG | S_IRUGO,
>> +                                debugfs_root, NULL, &pinmux_maps_ops);
>> +     (void) debugfs_create_file("pins", S_IFREG | S_IRUGO,
>> +                                debugfs_root, NULL, &pinmux_pins_ops);
>
> Unnecessary casts to (void)?

Yep lost them.

>> +static int __init pinmux_init(void)
>> +{
>> +     int ret;
>> +
>> +     ret = class_register(&pinmux_class);
>> +     pr_info("pinmux framwork: handle up to %d pins\n", MACH_NR_PINS);
>
> framework?

Should be subsystem. Fixed it.

>> diff --git a/include/linux/pinmux.h b/include/linux/pinmux.h
> []
>> +/*
>> + * Valid pin numbers are nonnegative and < MACH_NR_PINS. Invalid numbers can
>> + * be used to indicate no-such-pin.
>> + */
>> +static inline int pin_is_valid(int pin)
>> +{
>> +     return ((unsigned)pin) < MACH_NR_PINS;
>> +}
>
> Couldn't pin just be declared unsigned or maybe u32?

No, because like in the GPIO subsystem you *may* want to send in invalid
pins, and those are identified by negative numbers.

Thanks a *lot* for your detailed review Joe, please supply your Reviewed-by:
on the next (v2) patch set if you think it looks alright.

Yours,
Linus Walleij
