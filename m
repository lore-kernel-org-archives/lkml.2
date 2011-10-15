Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1JORoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 13:44:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:23182 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab1JORoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 13:44:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="63252308"
Subject: RE: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data
 transfers
From: Vinod Koul <vinod.koul@intel.com>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Cc: Dan <dan.j.williams@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552022D6C9A@CORPEXCH1.na.ads.idt.com>
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com>
	 <1317492077.1573.1839.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com>
	 <1317965252.1573.2238.camel@vkoul-udesk3>
	 <0CE8B6BE3C4AD74AB97D9D29BD24E552022D6C9A@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Oct 2011 23:05:42 +0530
Message-ID: <1318700142.23438.45.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 12:08 -0700, Bounine, Alexandre wrote:
> Vinod Koul wrote:
> > 
> > On Mon, 2011-10-03 at 09:52 -0700, Bounine, Alexandre wrote:
Adding Jassi to this and sorry for late reply...

> ... skip ...
> > >
> > > Second, having ability to pass private target information allows me to pass
> > > information about remote target device on per-transfer basis.
> > Okay, then why not pass the dma address and make your dma driver
> > transparent (i saw you passed RIO address, IIRC 64+2 bits)
> > Currently using dma_slave_config we pass channel specific information,
> > things like peripheral address and config don't change typically
> > between
> > transfers and if you have some controller specific properties you can
> > pass them by embedding dma_slave_config in your specific structure.
> > Worst case, you can configure slave before every prepare
> 
> In addition to address on target RIO device I need to pass corresponding
> device destination ID. With single channel capable to transfer data between
> local memory and different RapidIO devices I have to pass device specific
> information on per transfer basis (destID + 66-bit address + type of write ops, etc.).
> 
> Even having 8 channels (each set for specific target) will not help me with
> full support of RapidIO network where I have 8- or 16-bit destID (256 or 64K
> devices respectively).
> 
> RapidIO controller device (and its DMA component) may provide services to
> multiple device drivers which service individual devices on RapidIO network
> (similar to PCIe having multiple peripherals, but not using memory mapped
> model - destID defines route to a device). 
> 
> Generic RapidIO controller may have only one DMA channel which services all
> target devices forming the network. We may have multiple concurrent data
> transfer requests for different devices.
> 
> Parallel discussion with Dan touches the same post-config approach and
> another option. I like Dan's idea of having RIO-specific version of prep_sg().
> At the same time my current implementation of rio_dma_prep_slave_sg() with
> added appropriate locking may do job as well and keeps DMA part within
> existing API (DMA_RAPIDIO removed). 
Thanks this helps to understand your model.

Per above you need destID, 66bit address and type of write to be passed
for each transfer. Looking at your rio_dma_data, i cant see the destID.

Nevertheless we have few ways to solve this, pass this using
dma_slave_config _every-time_ before doing a prep_slave_sg. Or as Dan
pointed out create RIO specific version. Principally I am not for adding
a subsystem specific stuff, even more when we are talking about
converging and cutting down on dmaengine API :)

Another alternate approach could be to add one more argument to
prep_slave_sg API which allows us to pass additional runtime specific
parameters. This can be NULL and unused for existing drivers and used in
RIO and any future subsystems which want to use dmaengine.
Thoughts...?

-- 
~Vinod

