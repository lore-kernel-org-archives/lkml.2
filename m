Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1EBTiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:38:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1121 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1EBTh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:37:59 -0400
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 12:37:57 -0700
Message-ID: <1304365077.7792.40.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 21:16 +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> diff --git a/drivers/pinmux/core.c b/drivers/pinmux/core.c

Trivial comments follow

[]
> +static ssize_t pinmux_name_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct pinmux_dev *pmxdev = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%s\n", pmxdev_get_name(pmxdev));
> +}

Unsized buffer, maybe snprintf?

> +static int pin_request(int pin, const char *function, bool gpio)
> +{
> +	struct pin_desc *desc;
> +	struct pinmux_dev *pmxdev;
> +	struct pinmux_ops *ops;
> +	int status = -EINVAL;
> +	unsigned long flags;
> +
> +	pr_debug("pin_request: request pin %d for %s\n", pin, function);

pr_debug("%s: request pin...", __func__?

> +		pr_err("pin_request: pin is invalid\n");

same here, etc...

> +	if (!pmxdev) {
> +		pr_warning("pin_warning: no pinmux device is handling %d!\n",

You use both pr_warning and pr_warn.  Please just use pr_warn.
Why use "pin_warning: "?

Maybe it'd be better to add

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
or
#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__

if you really want __func__.
I suggest that __func__ isn't useful.

> +	spin_unlock_irqrestore(&pin_desc_lock, flags);
> +	if (status)
> +		pr_err("pinmux pin_request: pin-%d (%s) status %d\n",
> +		       pin, function ? : "?", status);

"pinmux_pin_request: "?

> +static int pinmux_devices_show(struct seq_file *s, void *what)
> +{
> +	struct pinmux_dev *pmxdev;
> +
> +	seq_printf(s, "Available pinmux settings per pinmux device:\n");
> +	list_for_each_entry(pmxdev, &pinmuxdev_list, node) {
> +		struct pinmux_ops *ops = pmxdev->desc->ops;

const struct pinmux_ops?

> +		unsigned selector = 0;
> +
> +		seq_printf(s, "\nDevice %s:\n", pmxdev->desc->name);

I think the initial newline isn't necessary.

> +		while (ops->list_functions(pmxdev, selector) >= 0) {
> +			unsigned *pins;
> +			unsigned num_pins;
> +			const char *func = ops->get_function_name(pmxdev,
> +								  selector);
> +			int ret;
> +			int i;
> +
> +			ret = ops->get_function_pins(pmxdev, selector,
> +						     &pins, &num_pins);
> +
> +			if (ret)
> +				seq_printf(s, "%s [ERROR GETTING PINS]\n",
> +					   func);
> +
> +			else {
> +				seq_printf(s, "function: %s, pins = [ ", func);
> +				for (i = 0; i < num_pins; i++)
> +					seq_printf(s, "%d ", pins[i]);
> +				seq_printf(s, "]\n");

seq_printf used without additional arguments could be seq_puts

> +		pr_warn("pinmux: failed to create debugfs directory\n");

[]

> +	(void) debugfs_create_file("devices", S_IFREG | S_IRUGO,
> +				   debugfs_root, NULL, &pinmux_devices_ops);
> +	(void) debugfs_create_file("maps", S_IFREG | S_IRUGO,
> +				   debugfs_root, NULL, &pinmux_maps_ops);
> +	(void) debugfs_create_file("pins", S_IFREG | S_IRUGO,
> +				   debugfs_root, NULL, &pinmux_pins_ops);

Unnecessary casts to (void)?
> +static int __init pinmux_init(void)
> +{
> +	int ret;
> +
> +	ret = class_register(&pinmux_class);
> +	pr_info("pinmux framwork: handle up to %d pins\n", MACH_NR_PINS);

framework?

> diff --git a/include/linux/pinmux.h b/include/linux/pinmux.h
[]
> +/*
> + * Valid pin numbers are nonnegative and < MACH_NR_PINS. Invalid numbers can
> + * be used to indicate no-such-pin.
> + */
> +static inline int pin_is_valid(int pin)
> +{
> +	return ((unsigned)pin) < MACH_NR_PINS;
> +}

Couldn't pin just be declared unsigned or maybe u32?


