Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1G0FEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 01:04:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:53564 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab1G0FEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 01:04:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,274,1309762800"; 
   d="scan'208";a="31903027"
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linus.walleij@stericsson.com,
        per.friden@stericsson.com, wei.zhang@freescale.com,
        ebony.zhu@freescale.com, iws@ovro.caltech.edu, s.hauer@pengutronix.de,
        maciej.sosnowski@intel.com, saeed@marvell.com, shawn.guo@freescale.com,
        yur@emcraft.com, agust@denx.de, iwamatsu.nobuhiro@renesas.com,
        per.forlin@stericsson.com, jonas.aberg@stericsson.com,
        anemo@mba.ocn.ne.jp
In-Reply-To: <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
References: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
	 <1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
	 <CACRpkdbWHmob3EWJc6u5=yh=rNwVSR5hu9-Xud5kvQNU9-POtA@mail.gmail.com>
	 <CAJe_Zhc4uJB8N9i2w38zzP3+XxcYF2v-zwsrhERWSi-yObV-6A@mail.gmail.com>
	 <CABE8wwt7dkwgeahYBSUufOvJmVNfYyTss6U5qBgjJk9RVLBkYg@mail.gmail.com>
	 <CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
	 <CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com>
	 <CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
	 <CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
	 <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	 <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
	 <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 09:51:39 +0530
Message-ID: <1311740499.1536.56.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 23:42 +0530, Jaswinder Singh wrote:
> On 26 July 2011 20:59, Williams, Dan J <dan.j.williams@intel.com> wrote:
> > On Tue, Jul 26, 2011 at 7:30 AM, Jaswinder Singh
> > <jaswinder.singh@linaro.org> wrote:
> >> On 26 July 2011 01:38, Williams, Dan J <dan.j.williams@intel.com> wrote:
> >>> Correct, it is meant that chan_id is only a sysfs property.  Any
> >>> driver usage that is assuming chan_id is anything more than a
> >>> guaranteed unique number within a given dma_device's list of channels
> >>> is probably inferring too much.
> >>
> >> So you mean dmac/client drivers are wrong if they make use of chan_id.
> >> They shouldn't count upon it's value - which is set by DMA API for a completely
> >> independent purpose, i.e, creating contiguous sysfs entries.
> >
> > They can count on it being unique, and maybe the fact that it is in
> > the same order as dma_device.channels.
> The latter implies the former. And it is already the dmac driver that
> decides the
> rank of a channel in the list.
> 
> >
> >>
> >> Since "chan_id is only a sysfs property" and the fact that it is used
> >> only _once_
> >> by the DMA API
> >>
> >> In drivers/dma/dmaengine.c
> >>
> >>      chan->chan_id = chancnt++;
> >>      dev_set_name(&chan->dev->device, "dma%dchan%d",
> >>                             device->dev_id, chan->chan_id);
> >>
> >>
> >> Can't we do away with chan_id altogether ? by having
> >>
> >>      dev_set_name(&chan->dev->device, "dma%dchan%d",
> >>                             device->dev_id, chancnt++);
> >>
> >> I mean why make every instance of dma_chan bigger by 4bytes ?
> >>
> >> So why shouldn't we remove chan_id completely from the DMA API ?
> >
> > Good point...  Let's remove chan_id from the core and push it into the
> > drivers that need it.
> >
> If you agree, I would preserve the chan_id in 'struct dma_chan' but remove
> any assignment to it in dmaengine.c  and let the dmac drivers use it freely.
> That would:-
> a) Let dmac drivers decide what numbers they want to show up in sysfs.
> b) chan_id is easily reachable by client drivers, so it is better this way.
> c) It would mean lesser and simpler changes to extant users of it.
But this can cause conflict between two controllers who think they are
assigning unique numbers. IMO sysfs representation needs to be with
dmaengine only. How do we guarantee uniqueness b/w two controllers?

Also I am not sure about the approach: The whole point is to make filter
function select based on some channel number "x", but you should filter
channels based on controller you want and capability of a channel. If
caps is not enough to filter we should add more flags but asking that I
need channel 'y' doesn't sound right to me.
This is all coming from that fact that some drivers assume channel 'a'
is for this type of transfer and channel 'b' for something else, for a
dma controller that really doesn't matter, as all channels have similar
capabilities and can do similar things so you should
_get_channel_based_on_caps rather than on some numbering.

Lastly, why do you need a channel reserved for some type of transfer, is
it for assigning h/w interface for dma transfer, if so that can be
achieved in different ways as well


-- 
~Vinod

