Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2EUOBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:01:04 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60949 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab2EUOBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:01:01 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.15.47]
In-Reply-To: <CAHTX3d+=QTZo994jct6+pPqsCniG0B2a_9q6fLdGjvcbZ7qj_A@mail.gmail.com>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
 <1330589497-4139-2-git-send-email-ohad@wizery.com> <4F6354E4.8030704@monstr.eu>
 <CAK=Wgbbbi4GnuHedSh6cR1LhkZr8c9q6i=_TLSL252LpPB8Xsw@mail.gmail.com>
 <CAK=WgbYeQr5ZwTSBo+ZJUzN7fQ--0QbC8HSjrGT-Geycs4SKcg@mail.gmail.com> <CAHTX3d+=QTZo994jct6+pPqsCniG0B2a_9q6fLdGjvcbZ7qj_A@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 21 May 2012 17:00:40 +0300
Message-ID: <CAK=WgbahzGHmvszw6HBgihN4NcPA8ceaQCNSOk_FC61bToxBXQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] remoteproc: resource table overhaul
To: Michal Simek <monstr@monstr.eu>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Mon, May 21, 2012 at 4:02 PM, Michal Simek <monstr@monstr.eu> wrote:
> I have looked at it and tested on latest and greatest and the problem is
> still there.

Ok, I see why this is happening.

We're now allocating the vrings' DMA in ->find_vqs() just before we
boot the remote processor, and we release it on ->del_vqs(). These are
the virtio handlers for setting up and tearing down the vrings, so it
makes sense to do so, but as a result, we still don't get the early
carveout allocation you wanted.

> I have looked at the code and path is
> rproc_fw_config_virtio -> rproc_handliefirtion_rsc -> rproc_handle_vdev

Please note that rproc_handle_vdev doesn't allocate any DMA at this
point, and the allocation path is now quite different - it begins with
virtio_rpmsg_bus probing and then calling into the ->find_vqs()
handler.

> For me it is necessary to ensure that dma_alloc_coherent in
> rproc_alloc_vring is called after carveout allocation
> just because dma_alloc_cohorent takes mermory from preallocated pool which
> starts at 0x0.

ok.

> I also don't have
> any other advance mechanism how to ensure mapping for the second arm core.

Probably the best way to ensure this (without it breaking unexpectedly
again as remoteproc evolves) is to have separate sub-devices for
different kind of memories, which remoteproc could then look up using
something like device_find_child().

Ludovic is exploring this direction too, because STE also needs to
bind specific memory regions with predefined purposes, without
depending on the order of DMA allocations.

I think Ludovic already has a preliminary patch which he may be able
to share with you.

> Here is log which I need to get. Look at attached patch which exactly show
> you what I need to do which I have tested.

Yes, I see. Another temporary approach might be moving the vrings'
allocations to the rproc_handle_rsc table (in the RSC_VDEV slot), but
I'm not sure we want to merge this as well because this solution too
is only hiding the real issue and not solving it permanently.

Thanks,
Ohad.
