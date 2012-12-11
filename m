Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2LKIvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:51:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63043 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2LKIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:51:06 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1212081643590.1984@hadrien>
References: <alpine.DEB.2.02.1212081643590.1984@hadrien>
Date: Tue, 11 Dec 2012 09:51:04 +0100
Message-ID: <CACRpkdY_znNHckam+PsysddCib2PP-6Lk4OM8_v34BX+p4pu-A@mail.gmail.com>
Subject: Re: question about drivers/pinctrl/pinctrl-at91.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: plagnioj@jcrosoft.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 8, 2012 at 4:52 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:

> The function at91_dt_node_to_map in drivers/pinctrl/pinctrl-at91.c contains
> the following code:
>
>        new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num,
> GFP_KERNEL);
>         if (!new_map)
>                 return -ENOMEM;
>
>         *map = new_map;
>         *num_maps = map_num;
>
>         /* create mux map */
>         parent = of_get_parent(np);
>         if (!parent) {
>                 kfree(new_map);
>                 return -EINVAL;
>         }
>
> This is clearly not correct, because the combination of devm_kzalloc and
> kfree risks creating a double free.

Agreed, probably just some spurious leftover.

> But I am not sure how best to fix it.
> Is the data structure intended to normally exist until the driver's remove
> function is called?  If so, perhaps the devm_kzalloc is OK.  If I just
> remove the kfree, then the structure will persist until the remove function
> is called, even though there was an error, which is perhaps not good.  So I
> could change the kfree to devm_kfree?

I was under the impression that if you exit the probe function
with a negative value anything allocated with devm_* was freed
immediately, that is atleast how it's described in
Documentation/driver-model/devres.txt
atleast that seems to be the intetion with the whole thing.

So just delete the kfree() oneliner.

Yours,
Linus Walleij
