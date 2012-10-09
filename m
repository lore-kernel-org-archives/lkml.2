Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2JIJFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:05:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44908 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2JIJFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:05:44 -0400
MIME-Version: 1.0
In-Reply-To: <1349496603-20775-4-git-send-email-cheiny@synaptics.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-4-git-send-email-cheiny@synaptics.com>
Date: Tue, 9 Oct 2012 11:05:42 +0200
Message-ID: <CACRpkdY+hK=zbZz6K-ONyAckfpZ-n+TS5c25AxRETVk1M9weQw@mail.gmail.com>
Subject: Re: [RFC PATCH 03/06] input/rmi4: I2C physical interface
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

> The I2C physical driver is not extensively changed in terms of functionality
> since the previous patch.  Management of the attention GPIO has been moved to
> rmi_driver.c (see previous email), and most of the debug related interfaces
> have been moved from sysfs to debugfs.  Control of the debug features has been
> moved from compile-time to runtime switches available via debugfs.
>
> The core I2C functionality was previously ACKed by Jean Delvare.  I don't
> believe that portion of the code has changed much since then, but we'd
> appreciate a second glance at this.

The above commit blurb looks more like a changelog than a description
of the actual patch. Nothing wrong with that but begin by describing
the patch first.

(...)
> +#ifdef CONFIG_RMI4_DEBUG
> +
> +#include <linux/debugfs.h>
> +#include <linux/uaccess.h>

Just move these up to the common includes. It doesn't matter
that they get included even when debug is not enabled.

> +static int setup_debugfs(struct rmi_device *rmi_dev, struct rmi_i2c_data *data);
> +static void teardown_debugfs(struct rmi_i2c_data *data);

Why do you need to forward-declare these? Can't you just move them
up above the functions using them?

> +struct i2c_debugfs_data {
> +       bool done;

Done with what? ... needs some doc.

> +       struct rmi_i2c_data *i2c_data;
> +};

(...)
> +static int __devinit rmi_i2c_probe(struct i2c_client *client,
> +                                 const struct i2c_device_id *id)
(...)
> +       rmi_phys = kzalloc(sizeof(struct rmi_phys_device), GFP_KERNEL);
(...)
> +       data = kzalloc(sizeof(struct rmi_i2c_data), GFP_KERNEL);

Can you use devm_kzalloc(&client->dev, ...) for these so you don't
need to free() them explicitly?

(...)
> +static int __devexit rmi_i2c_remove(struct i2c_client *client)
> +{
> +       struct rmi_phys_device *phys = i2c_get_clientdata(client);
> +       struct rmi_device_platform_data *pd = client->dev.platform_data;
> +
> +       /* Can I remove this disable_device */
> +       /*disable_device(phys); */

So just delete these two lines then?

Yours,
Linus Walleij
