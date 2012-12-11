Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2LKJHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:07:15 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54139 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2LKJHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:07:13 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: question about drivers/pinctrl/pinctrl-at91.c
To: Julia Lawall <julia.lawall@lip6.fr>, plagnioj@jcrosoft.com,
        linus.walleij@linaro.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <alpine.DEB.2.02.1212081643590.1984@hadrien>
References: <alpine.DEB.2.02.1212081643590.1984@hadrien>
Date: Tue, 11 Dec 2012 09:06:59 +0000
Message-Id: <20121211090659.DAC4C3E076D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2012 16:52:42 +0100 (CET), Julia Lawall <julia.lawall@lip6.fr> wrote:
> The function at91_dt_node_to_map in drivers/pinctrl/pinctrl-at91.c 
> contains the following code:
> 
>         new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num, GFP_KERNEL);
>          if (!new_map)
>                  return -ENOMEM;
> 
>          *map = new_map;
>          *num_maps = map_num;
> 
>          /* create mux map */
>          parent = of_get_parent(np);
>          if (!parent) {
>                  kfree(new_map);
>                  return -EINVAL;
>          }
> 
> This is clearly not correct, because the combination of devm_kzalloc and 
> kfree risks creating a double free.  But I am not sure how best to fix it. 
> Is the data structure intended to normally exist until the driver's remove 
> function is called?  If so, perhaps the devm_kzalloc is OK.  If I just 
> remove the kfree, then the structure will persist until the remove 
> function is called, even though there was an error, which is perhaps not 
> good.  So I could change the kfree to devm_kfree?

Hi Julia,

I don't have that file in my tree. Is it in linux-next? (I'm too lazy to
go and look)

Yes, devm_kfree() is the right thing to call, but I'd be tempted to just
drop the free entirely. If it fails there is something wrong and it will
get cleaned up when the probe returns a fail code... but look at the
code; if failing there is a valid way for the driver to operate, then
doing the cleanup is the right thing....

Alternately the of_get_parent() call could simply be moved above the
devm_kzalloc() and then the issue becomes moot.  :-)

g.

