Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1K2OYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:24:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab1K2OYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:24:49 -0500
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] pinctrl: make a deep copy of pinmux map
Date: Tue, 29 Nov 2011 14:24:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1322567938-28321-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1322567938-28321-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111291424.41178.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:6Gw2LeU04Vc9cGKy0Z+ZUvGJHw0nMQvdUVMXNsZBZIB
 hUlbKrS5lBd+KTKSr2FxxAhLCQItpzvneLXS25PwShOrozANxp
 cIBYSrTSTDu8OevSL9Q7/aPAWzg16+qOQnrcB7SKGPGRm+F5Vc
 iLmLjR+5sFpXZX6wawMj9ZvByYPIgix8R4pbnVOFEmiQgb+7Zf
 b19qEXydM2GxyAYWTjAQkV/KskAFbWSIh5UvdbZHRsrNnqnQLo
 lvEJ7uoodiZ9cuNcJQ+VDhaFUwUrqA7P4aZY4UU+8WnJ8UviEk
 d/XDiW+yeXuKlA/gIBShZ4FGOlHqgbUY9Oo+NAdKXscmxAnOik
 Sx42jhS5Lt9XAMKqI129hJNw4YEX2KDwvBQUnlIEr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 November 2011, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This makes a deep copy of the pinmux function map instead of
> keeping the copy supplied from the platform around. This makes
> it possible to tag the platforms map with __initdata as is also
> done as part of this patch.
> 
> Rationale: a certain target platform (PXA) has numerous
> pinmux maps, many of which will be lying around unused after
> boot in a multi-platform binary. Instead, deep-copy the one
> we're going to use and tag them all __initdata so they go away
> after boot.
> 
> Suggested-by: Arnd Bergmann <arnd.bergmann@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Very nice!

>  /**
>   * pinmux_register_mappings() - register a set of pinmux mappings
> - * @maps: the pinmux mappings table to register
> + * @maps: the pinmux mappings table to register, this should be marked with
> + *	__initdata so it can be discarded after boot, this function will
> + *	perform a deep copy (including strings) for the mapping entries.
>   * @num_maps: the number of maps in the mapping table
>   *

Is it actually necessary to copy the strings? I always thought they
end up in the constant data section even if the data structure that
they are defined in is in initdata.

> +
> +	/* Allocate a deep copy of the map array */
> +	pinmux_maps = kzalloc(sizeof(struct pinmux_map) * num_maps,
> +			      GFP_KERNEL);

I guess it's easier to use kmemdup here. At least there is no
point in zeroing the array when the next step is to overwrite it.

	Arnd

