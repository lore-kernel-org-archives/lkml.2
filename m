Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1GYUIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:08:48 -0400
Received: from mga12.intel.com ([143.182.124.36]:57183 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751544Ab1GYUIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
References: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
	<1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
	<CACRpkdbWHmob3EWJc6u5=yh=rNwVSR5hu9-Xud5kvQNU9-POtA@mail.gmail.com>
	<CAJe_Zhc4uJB8N9i2w38zzP3+XxcYF2v-zwsrhERWSi-yObV-6A@mail.gmail.com>
	<CABE8wwt7dkwgeahYBSUufOvJmVNfYyTss6U5qBgjJk9RVLBkYg@mail.gmail.com>
	<CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
	<CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com>
	<CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
Date: Mon, 25 Jul 2011 13:08:42 -0700
Message-ID: <CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        vinod.koul@intel.com, rmk+kernel@arm.linux.org.uk,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 12:17 PM, Jaswinder Singh
<jaswinder.singh@linaro.org> wrote:
> On 26 July 2011 00:25, Williams, Dan J <dan.j.williams@intel.com> wrote:
>>>> Unless you guaranteed that every id is globally unique I don't see how
>>>> they are generically usable by common clients?
>>>>
>>> Yes. And the first step is to allow DMAC drivers to freely set chan_id value.
>>> Platform could pass the list and mapping of supported 'global channels'
>>> via platform_data(?) which the DMAC drivers could set in chan_id
>>> And I am not sure of defining a new variable for that, because chan_id
>>> is actually used only by some dmac drivers for internal purpose only -
>>> which they could do by private variables.
>>
>> Yes, it does appear to have grown a lot of dubious usage in
>> drivers/dma/ for something that is described as just a "channel ID for
>> sysfs".  The intent was for drivers that need to maintain their own
>> hardware specific identification to define a local id scheme (like
>> iop-adma does in the iop3xx case).
>
> You mean chan_id is meant to be used for _internal_ purposes by DMAC drivers ?
>
> Shouldn't there instead be just something like 'void *dmac_data' for
> DMAC drivers to hang their private info on?
>
> Sorry, I couldn't find chan_id in drivers/dma/iop-adma.c
> Do I misunderstand ?

/**
 * struct iop_adma_device - internal representation of an ADMA device
 * @pdev: Platform device
 * @id: HW ADMA Device selector
 * @dma_desc_pool: base of DMA descriptor region (DMA address)
 * @dma_desc_pool_virt: base of DMA descriptor region (CPU address)
 * @common: embedded struct dma_device
 */
struct iop_adma_device {
        struct platform_device *pdev;
        int id;
        dma_addr_t dma_desc_pool;
        void *dma_desc_pool_virt;
        struct dma_device common;
};

Where that 'id' is the internal identifier and chan_id from struct
dma_chan is ignored.

>> I can sort of see why it is attractive for the goal of having clients
>> being able to talk to multiple DMACs since it is a field that all
>> channels already implement.  But, I don't think we should be mixing
>> sysfs presentation details with a capability that indicates a certain
>> compatibility level in a DMAC driver implementation.  If the goal is
>> to be able to use a single client with multiple drivers that, to me,
>> is asking for a new capability bit (dma_transaction_type) rather than
>> an id.  Do you have an example of the client and the DMACs that would
>> first take advantage of such a cross DMAC compatibility?
>>
> Apparently I fail to explain my well. let me ask you this....
>
> Some DMAC drivers initialize chan_id before calling dma_async_device_register().
> And dma_async_device_register() overwrites the chan_id _always_.
>
> Clearly only _one_ of them should be setting chan_id. Which was meant to be?

Correct, it is meant that chan_id is only a sysfs property.  Any
driver usage that is assuming chan_id is anything more than a
guaranteed unique number within a given dma_device's list of channels
is probably inferring too much.
