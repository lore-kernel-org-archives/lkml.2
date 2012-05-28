Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2E1QTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:19:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43223 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2E1QTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:19:37 -0400
MIME-Version: 1.0
In-Reply-To: <1338187691-32616-1-git-send-email-dbaryshkov@gmail.com>
References: <1338187691-32616-1-git-send-email-dbaryshkov@gmail.com>
Date: Tue, 29 May 2012 00:19:36 +0800
Message-ID: <CACRpkdaRSE9ixE6qdJK+X_WqFQt7KauiUxZDpjNjng0U9SVacg@mail.gmail.com>
Subject: Re: [PATCH][V2] gpio: add a driver for GPIO pins found on AMD-8111
 south bridge chips
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 2:48 PM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:

> Add a driver to use GPIO pins available on several AMD south bridges
> (currently only AMD 8111 is supported).
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>
> Changes since V1:
> * Replaced magic numbers in register access with named values

This is looking a lot better, some nitpicking:

> +#define AMD_GPIO_MODE_ALTFN    0x08 /* Or 0x09 */

Hm Hm I wonder what this register does... looks a lot like a mux.
(Just philisophizing...)

> +static int __init mod_init(void)
> +{
> +       int err = -ENODEV;
> +       struct pci_dev *pdev = NULL;
> +       const struct pci_device_id *ent;
> +
> +       for_each_pci_dev(pdev) {
> +               ent = pci_match_id(pci_tbl, pdev);
> +               if (ent)
> +                       goto found;

It's not like I know how PCI abstractions really work, but what happens
here if there would be two instances of the device? It looks like you will
only find the first?

> +       }
> +       /* Device not found. */
> +       goto out;

Can't you just return -ENODEV here? Why jump around...

Now as I said I'm not a PCI expert, but isn't the proper way to do this
to use this stuff:

static struct pci_driver amd_gpio_driver = {
        .name =         "amd-gpio",
        .id_table =     pci_ids,
        .probe =        amd_gpio_probe,
        .remove =       __devexit_p(amd_gpio_remove),
};

static int __init amd_gpio_init(void)
{
        return pci_register_driver(&amd_gpio_driver);
}

static void __exit amd_gpio_exit(void)
{
        pci_unregister_driver(&amd_gpio_driver);
}

module_init(amd_gpio_init);
module_exit(amd_gpio_exit);

Then start working from the probe function insteaf of go and
iterate over the PCI bus yourself? I was thinking there was a
reason for but couldn't find any.

Yours,
Linus Walleij
