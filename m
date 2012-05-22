Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2EVJQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:16:08 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:53862 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757071Ab2EVJQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:16:05 -0400
Message-ID: <4FBB5908.4010505@stericsson.com>
Date: Tue, 22 May 2012 11:14:48 +0200
From: frq09524 <ludovic.barre@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/7] remoteproc: resource table overhaul
References: <1330589497-4139-1-git-send-email-ohad@wizery.com> <1330589497-4139-2-git-send-email-ohad@wizery.com> <4F6354E4.8030704@monstr.eu> <CAK=Wgbbbi4GnuHedSh6cR1LhkZr8c9q6i=_TLSL252LpPB8Xsw@mail.gmail.com> <CAK=WgbYeQr5ZwTSBo+ZJUzN7fQ--0QbC8HSjrGT-Geycs4SKcg@mail.gmail.com> <CAHTX3d+=QTZo994jct6+pPqsCniG0B2a_9q6fLdGjvcbZ7qj_A@mail.gmail.com> <CAK=WgbahzGHmvszw6HBgihN4NcPA8ceaQCNSOk_FC61bToxBXQ@mail.gmail.com> <CAHTX3dK8rDomYqWvBX1ay200AmM1dBCYD3nJ2UYbzC_SSFankw@mail.gmail.com>
In-Reply-To: <CAHTX3dK8rDomYqWvBX1ay200AmM1dBCYD3nJ2UYbzC_SSFankw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad and Michal

yes I can share my patch, remoteproc has evolved and my patch is not 
aligned on latest version of remote proc (especially since remoteproc: 
remove the single rpmsg vdev limitation).

Ohad, for alignment I can take the latest branch of kernel.org 
(remoteproc) branch for-next?

/BR
Ludovic Barré

On 05/22/2012 07:51 AM, Michal Simek wrote:
> Hi Ohad and Ludovic,
>
> 2012/5/21 Ohad Ben-Cohen <ohad@wizery.com <mailto:ohad@wizery.com>>
>
>     Hi Michal,
>
>     On Mon, May 21, 2012 at 4:02 PM, Michal Simek <monstr@monstr.eu
>     <mailto:monstr@monstr.eu>> wrote:
>      > I have looked at it and tested on latest and greatest and the
>     problem is
>      > still there.
>
>     Ok, I see why this is happening.
>
>     We're now allocating the vrings' DMA in ->find_vqs() just before we
>     boot the remote processor, and we release it on ->del_vqs(). These are
>     the virtio handlers for setting up and tearing down the vrings, so it
>     makes sense to do so, but as a result, we still don't get the early
>     carveout allocation you wanted.
>
>      > I have looked at the code and path is
>      > rproc_fw_config_virtio -> rproc_handliefirtion_rsc ->
>     rproc_handle_vdev
>
>     Please note that rproc_handle_vdev doesn't allocate any DMA at this
>     point, and the allocation path is now quite different - it begins with
>     virtio_rpmsg_bus probing and then calling into the ->find_vqs()
>     handler.
>
>
>      > For me it is necessary to ensure that dma_alloc_coherent in
>      > rproc_alloc_vring is called after carveout allocation
>      > just because dma_alloc_cohorent takes mermory from preallocated
>     pool which
>      > starts at 0x0.
>
>     ok.
>
>      > I also don't have
>      > any other advance mechanism how to ensure mapping for the second
>     arm core.
>
>     Probably the best way to ensure this (without it breaking unexpectedly
>     again as remoteproc evolves) is to have separate sub-devices for
>     different kind of memories, which remoteproc could then look up using
>     something like device_find_child().
>
>     Ludovic is exploring this direction too, because STE also needs to
>     bind specific memory regions with predefined purposes, without
>     depending on the order of DMA allocations.
>
>
> It is good that someone else has similar requirements.
>
>
>     I think Ludovic already has a preliminary patch which he may be able
>     to share with you.
>
>
> Ludovic: Can you share your patch with us? I would like to try it.
>
>
>      > Here is log which I need to get. Look at attached patch which
>     exactly show
>      > you what I need to do which I have tested.
>
>     Yes, I see. Another temporary approach might be moving the vrings'
>     allocations to the rproc_handle_rsc table (in the RSC_VDEV slot), but
>     I'm not sure we want to merge this as well because this solution too
>     is only hiding the real issue and not solving it permanently.
>
>
> Simple enabling RSC_VDEV in rproc_handle_rsc doesn't work.
>
> BTW: I am using kernel modules and there is no dependency for
> virtio_rpmsg_bus in remoteproc module
> in sense if you load remoteproc module you also need to load
> virtio_rpmsg_bus to get firmware to work.
>
> I think that will be good to create that dependency automatically
> because you need to load virtio_rpmsg_bus
> when you problem remoteproc module.
>
> ~ # lsmod
> ~ # modprobe zynq_remoteproc
> zynq_remoteproc: Unknown symbol rproc_register (err 0)
> zynq_remoteproc: Unknown symbol rproc_alloc (err 0)
> zynq_remoteproc: Unknown symbol rproc_vq_interrupt (err 0)
> zynq_remoteproc: Unknown symbol rproc_free (err 0)
> zynq_remoteproc: Unknown symbol rproc_unregister (err 0)
> CPU1: shutdown
> zynq_remoteproc 0.remoteproc-test: 0.remoteproc-test is available
> zynq_remoteproc 0.remoteproc-test: Note: remoteproc is still under
> development and considered experimental.
> zynq_remoteproc 0.remoteproc-test: THE BINARY FORMAT IS NOT YET
> FINALIZED, and backward compatibility isn't yet guaranteed.
> ~ # zynq_remoteproc 0.remoteproc-test: registered virtio0 (type 7)
>
> ~ # lsmod
> zynq_remoteproc 4346 0 - Live 0xbf01f000
> remoteproc 13831 1 zynq_remoteproc, Live 0xbf018000
> virtio 2840 1 remoteproc, Live 0xbf008000
> virtio_ring 4965 1 remoteproc, Live 0xbf013000
> ~ #
> ~ # modprobe virtio_rpmsg_bus
> zynq_remoteproc 0.remoteproc-test: powering up 0.remoteproc-test
> zynq_remoteproc 0.remoteproc-test: Booting fw image test, size 2351790
> zynq_remoteproc 0.remoteproc-test: remote processor 0.remoteproc-test is
> now up
> virtio_rpmsg_bus virtio0: rpmsg host is online
> virtio_rpmsg_bus virtio0: creating channel rpmsg-timer-statistic addr 0x50
> ~ #
> ~ # lsmod
> virtio_rpmsg_bus 7575 0 - Live 0xbf024000
> zynq_remoteproc 4346 1 - Live 0xbf01f000
> remoteproc 13831 1 zynq_remoteproc, Live 0xbf018000
> virtio 2840 2 virtio_rpmsg_bus,remoteproc, Live 0xbf008000
> virtio_ring 4965 2 virtio_rpmsg_bus,remoteproc, Live 0xbf013000
> ~ #
>
> Can you see the same behavior on omap?
>
> Thanks,
> Michal
>
>
>
>
>
>
>
>

