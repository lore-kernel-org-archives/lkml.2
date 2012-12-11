Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2LKJEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:04:10 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:20636
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab2LKJEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:04:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,258,1355094000"; 
   d="scan'208";a="165423256"
Date: Tue, 11 Dec 2012 10:04:03 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Linus Walleij <linus.walleij@linaro.org>
cc: Julia Lawall <julia.lawall@lip6.fr>, plagnioj@jcrosoft.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: question about drivers/pinctrl/pinctrl-at91.c
In-Reply-To: <CACRpkdY_znNHckam+PsysddCib2PP-6Lk4OM8_v34BX+p4pu-A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1212110958110.2091@hadrien>
References: <alpine.DEB.2.02.1212081643590.1984@hadrien> <CACRpkdY_znNHckam+PsysddCib2PP-6Lk4OM8_v34BX+p4pu-A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2012, Linus Walleij wrote:

> On Sat, Dec 8, 2012 at 4:52 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>
> > The function at91_dt_node_to_map in drivers/pinctrl/pinctrl-at91.c contains
> > the following code:
> >
> >        new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num,
> > GFP_KERNEL);
> >         if (!new_map)
> >                 return -ENOMEM;
> >
> >         *map = new_map;
> >         *num_maps = map_num;
> >
> >         /* create mux map */
> >         parent = of_get_parent(np);
> >         if (!parent) {
> >                 kfree(new_map);
> >                 return -EINVAL;
> >         }
> >
> > This is clearly not correct, because the combination of devm_kzalloc and
> > kfree risks creating a double free.
>
> Agreed, probably just some spurious leftover.
>
> > But I am not sure how best to fix it.
> > Is the data structure intended to normally exist until the driver's remove
> > function is called?  If so, perhaps the devm_kzalloc is OK.  If I just
> > remove the kfree, then the structure will persist until the remove function
> > is called, even though there was an error, which is perhaps not good.  So I
> > could change the kfree to devm_kfree?
>
> I was under the impression that if you exit the probe function
> with a negative value anything allocated with devm_* was freed
> immediately, that is atleast how it's described in
> Documentation/driver-model/devres.txt
> atleast that seems to be the intetion with the whole thing.

That is true, but I wasn't sure taht this function was part of the probe
function.  Its only reference is in:

static struct pinctrl_ops at91_pctrl_ops = {
        .get_groups_count       = at91_get_groups_count,
        .get_group_name         = at91_get_group_name,
        .get_group_pins         = at91_get_group_pins,
	.pin_dbg_show           = at91_pin_dbg_show,
        .dt_node_to_map         = at91_dt_node_to_map,
        .dt_free_map            = at91_dt_free_map,
};

Working backwards, one possible call site is pinctrl_get, which is an
exported function.  Is it safe to assume that it will always be called
from within a probe function?

thanks,
julia
