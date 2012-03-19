Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2CSHHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:07:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60205 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2CSHHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:07:47 -0400
Message-ID: <4F66DB3D.4010407@monstr.eu>
Date: Mon, 19 Mar 2012 08:07:41 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH 1/7] remoteproc: resource table overhaul
References: <1330589497-4139-1-git-send-email-ohad@wizery.com> <1330589497-4139-2-git-send-email-ohad@wizery.com> <4F6354E4.8030704@monstr.eu> <CAK=Wgbbbi4GnuHedSh6cR1LhkZr8c9q6i=_TLSL252LpPB8Xsw@mail.gmail.com>
In-Reply-To: <CAK=Wgbbbi4GnuHedSh6cR1LhkZr8c9q6i=_TLSL252LpPB8Xsw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> On Fri, Mar 16, 2012 at 4:57 PM, Michal Simek <monstr@monstr.eu> wrote:
>> In previous version I had carverout first which means that code was copyied
>> to physical address 0x0 and then vrigns were allocated. Current code
>> allocate vring first and then RTOS is not able to run from zero address.
> 
> In general, depending on specific allocation ordering is error prone
> and you shouldn't do it.

Yes, I agree with you. It was in v1.


> For a given device, we treat memory allocated with
> dma_alloc_coherent() as homogeneous. We care about its utilization and
> alignments of allocations rather than their specific location in the
> total region.

For zynq platform is very important to use addresses from 0 for rtos.
The main reason why it is so important is ARM reset vectors.


> If that's not the case, and there's special memory you want assigned
> with a specific purpose, than it's recommended to let the code make
> sure it happens explicitly, and not rely on implicit order of
> allocation.

Sure.


> Today there's no way to assign several memory regions with a specific
> device, but a reasonable workaround that's being used is creating
> several sub-devices with the special memory, and then looking them up
> with stuff like device_for_each_child() or device_find_child().
> 
> About your specific issue: the current allocation scheme was chosen
> for simplicity, but I do plan to change it back by postponing the
> vring dma allocation until a remote processor is really powered on.
> It's not a lot of memory, but this way we'd only allocate it when
> really needed (so if it's CMA, others could use it).
> 
> IOW: you can probably just wait a bit until this patch is ready and
> take it into your tree. It will most likely bring back the behavior you
> need :)

OK. I will use v1 where allocation is based on order in resource table.
It is not ideal but it is working.

 From my point of view will be the best to call dma_alloc_coherent only once
which will allocate the whole chunk of memory which is required for "RTOS".

My resource table is easy:
#define TEXT_BASE 0
struct resource_table __resource resources = {
	1, /* we're the first version that implements this */
	3, /* number of entries in the table */
	0, 0, /* reserved, must be zero */
	/* offsets to entries */
	{
			offsetof(struct resource_table, text_cout),
			offsetof(struct resource_table, rpmsg_vdev),
			offsetof(struct resource_table, trace),
	},
	{
		TYPE_CARVEOUT, 0, 0, SZ_1M, 0, 0, "MEM_DATA",
	},
	{
		TYPE_VDEV, VIRTIO_ID_RPMSG, 0,
		RPMSG_IPU_C0_FEATURES, 0, 0, 0, 2, { 0, 0 },
		/* no config data */
	},

	/* the two vrings */
	{ TEXT_BASE + SZ_1M, 4096, 256, 1, 0 },
	{ TEXT_BASE + SZ_1M + 0x4000, 4096, 256, 2, 0 },

	{
		TYPE_TRACE, TEXT_BASE + 0x40000, 0x8000, 0, "trace",
	},

};

But as you see I need to keep that offset structure which is
that text/data starts at address 0, vrings0 on 0x100000, vrigns1 on 0x104000
and trace buffer 0x140000.

If dma_alloc_coherent is called just once with size taken from resource table.
(For my case for example 2MB=0x200000) and offset are driven by remoteproc then
it should just work.


Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
