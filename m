Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403Ab2J2PSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:18:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33945 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab2J2PR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:17:58 -0400
Message-ID: <508E9E22.6030201@wwwdotorg.org>
Date: Mon, 29 Oct 2012 09:17:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] spi: tegra: add spi driver for SLINK controller
References: <1350557233-31234-1-git-send-email-ldewangan@nvidia.com> <5085A667.2000100@wwwdotorg.org> <508ADB1C.6040602@nvidia.com>
In-Reply-To: <508ADB1C.6040602@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 12:49 PM, Laxman Dewangan wrote:
> Thanks Stephen for review.
> I have taken care of almost all feedback. Some of having my below comments.
> 
> On Tuesday 23 October 2012 01:32 AM, Stephen Warren wrote:
>> On 10/18/2012 04:47 AM, Laxman Dewangan wrote:
>>> Tegra20/Tegra30 supports the spi interface through its SLINK
>>> controller. Add spi driver for SLINK controller.

>>> +     val_write = SLINK_RDY;
>>> +     val_write |= (val&  SLINK_FIFO_ERROR);
>> Why not just always set SLINK_FIFO_ERROR; does it have to be set in the
>> write only if the status was previously asserted? If that is true, how
>> do you avoid a race condition where the bit gets set in SLINK_STATUS
>> after you read it but before you write to clear it?
>
> Status gets updated together. There is no steps of updating status.

Sorry, I don't understand this answer.

>>> +     spin_lock_irqsave(&tspi->lock, flags);
>>> +     if (err) {
>>> +             dev_err(tspi->dev,
>>> +                     "DmaXfer: ERROR bit set 0x%x\n",
>>> tspi->status_reg);
>>> +             dev_err(tspi->dev,
>>> +                     "DmaXfer 0x%08x:0x%08x:0x%08x\n",
>>> tspi->command_reg,
>>> +                             tspi->command2_reg,
>>> tspi->dma_control_reg);
>>> +             tegra_periph_reset_assert(tspi->clk);
>>> +             udelay(2);
>>> +             tegra_periph_reset_deassert(tspi->clk);
>> Do we /have/ to reset the SPI block; can't we just disable it in the
>> control register, clear all status, and re-program it from scratch?
>>
>> If at all possible, I would like to avoid introducing any new use of
>> tegra_periph_reset_{,de}assert, since that API has no standard subsystem
>> equivalent (or if it does, isn't hooked into the standard subsystem
>> yet), and hence means this driver relies on a header file currently in
>> arch/arm/mach-tegra/include/mach, and we need to move or delete all such
>> headers in order to support single zImage.
> 
> Is there a way to support the reset of controller. We will need this
> functionality.

Why do we need to reset the controller at all; can't we simply program
all the (few) configuration registers? Are there HW bugs that hang the
controller and require a reset or something?
