Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2JIJb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:31:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44788 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2JIJbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:31:25 -0400
MIME-Version: 1.0
In-Reply-To: <1349496603-20775-6-git-send-email-cheiny@synaptics.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-6-git-send-email-cheiny@synaptics.com>
Date: Tue, 9 Oct 2012 11:31:23 +0200
Message-ID: <CACRpkdZht7RfL48FjxnCKD9R7tHaKdQjM=hO47coMkoctPH_tw@mail.gmail.com>
Subject: Re: [RFC PATCH 05/06] input/rmi4: F01 - device control
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 6, 2012 at 6:10 AM, Christopher Heiny <cheiny@synaptics.com> wrote:

> RMI Function 01 implements basic device control and power management
> behaviors for the RMI4 sensor.  Since the last patch, we've decoupled rmi_f01.c
> implementation from rmi_driver.c, so rmi_f01.c acts as a standard driver
> module to handle F01 devices on the RMI bus.
>
> Like other modules, a number of attributes have been moved from sysfs to
> debugfs, depending on their expected use.
>
>
> rmi_f01.h exports definitions that we expect to be used by other functionality
> in the future (such as firmware reflash).
>
>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> Cc: Joeri de Gram <j.de.gram@gmail.com>
>
> ---

There is liberal whitespacing above. (No big deal, but anyway.)

(...)
> +/**
> + * @reset - set this bit to force a firmware reset of the sensor.
> + */
> +union f01_device_commands {
> +       struct {
> +               bool reset:1;
> +               u8 reserved:7;
> +       } __attribute__((__packed__));
> +       u8 reg;
> +};

I'm still scared by these unions. I see what you're doing but my
preferred style of driver writing is to use a simple u8 if you just treat
it the right way with some |= and &= ...

#include <linux/bitops.h>

#define F01_RESET BIT(0)

u8 my_command = F01_RESET;

send(&my_command);

I will not insist on this because it's a bit about programming style.
For memory-mapped devices we usually do it my way, but this
is more like some protocol and I know protocols like to do things
with structs and stuff so no big deal.

> +#ifdef CONFIG_RMI4_DEBUG
> +struct f01_debugfs_data {
> +       bool done;
> +       struct rmi_function_container *fc;
> +};
> +
> +static int f01_debug_open(struct inode *inodep, struct file *filp)
> +{
> +       struct f01_debugfs_data *data;
> +       struct rmi_function_container *fc = inodep->i_private;
> +
> +       data = devm_kzalloc(&fc->dev, sizeof(struct f01_debugfs_data),
> +               GFP_KERNEL);

Wait, you probably did this because I requested it, but I was maybe
wrong?

Will this not re-allocate a chunk every time you look at a debugfs
file? So it leaks memory?

In that case common kzalloc() and kfree() is the way to go, as it
is for dynamic buffers. Sorry for screwing things up for you. :-(

> +       for (i = 0; i < f01->irq_count && *local_buf != 0;
> +            i++, local_buf += 2) {
> +               int irq_shift;
> +               int interrupt_enable;
> +               int result;
> +
> +               irq_reg = i / 8;
> +               irq_shift = i % 8;

Please stop doing these arithmetics-turned-maths things.

irq_reg = i >> 8;
irq_shift = i & 0xFF;

(...)
> +static ssize_t rmi_fn_01_interrupt_enable_show(struct device *dev,
> +                               struct device_attribute *attr, char *buf)
> +{
> +       struct rmi_function_container *fc;
> +       struct f01_data *data;
> +       int i, len, total_len = 0;
> +       char *current_buf = buf;
> +
> +       fc = to_rmi_function_container(dev);
> +       data = fc->data;
> +       /* loop through each irq value and copy its
> +        * string representation into buf */
> +       for (i = 0; i < data->irq_count; i++) {
> +               int irq_reg;
> +               int irq_shift;
> +               int interrupt_enable;
> +
> +               irq_reg = i / 8;
> +               irq_shift = i % 8;

Dito.

(...)
> +static int f01_probe(struct device *dev);

Do you really need to forward-declare this?

(...)
> +static struct rmi_function_handler function_handler = {
> +       .driver = {
> +               .owner = THIS_MODULE,
> +               .name = "rmi_f01",
> +               .bus = &rmi_bus_type,
> +               .probe = f01_probe,
> +               .remove = f01_remove_device,
> +       },
> +       .func = 0x01,
> +       .config = rmi_f01_config,
> +       .attention = rmi_f01_attention,
> +
> +#ifdef CONFIG_PM
> +       .suspend = rmi_f01_suspend,
> +       .resume = rmi_f01_resume,
> +#endif  /* CONFIG_PM */
> +};

Just move this block of struct *below* the probe function...

> +static __devinit int f01_probe(struct device *dev)

Header file looks OK (if these unions is the way to go...)

Yours,
Linus Walleij
