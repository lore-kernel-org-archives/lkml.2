Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1JGTI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:08:27 -0400
Received: from mxout1.idt.com ([157.165.5.25]:36826 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab1JGTIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:08:25 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: RE: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Date: Fri, 7 Oct 2011 12:08:11 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552022D6C9A@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1317965252.1573.2238.camel@vkoul-udesk3>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
Thread-Index: AcyEst1sy2DKH0qITVi6ras03wdHgwAagffA
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com> <1317492077.1573.1839.camel@vkoul-udesk3> <0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com> <1317965252.1573.2238.camel@vkoul-udesk3>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan <dan.j.williams@intel.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p97J8a3H009416

Vinod Koul wrote:
> 
> On Mon, 2011-10-03 at 09:52 -0700, Bounine, Alexandre wrote:
> >
> > My concern here is that other subsystems may use/request DMA_SLAVE channel(s) as well
> > and wrongfully acquire one that belongs to RapidIO. In this case separation with another
> > flag may have a sense - it is possible to have a system that uses RapidIO
> > and other "traditional" DMA slave channel.
> Nope that will never happen in current form.
> Every controller driver today "magically" ensures that it doesn't get
> any other dma controllers channel. We use filter function for that.
> Although it is not clean yet and we are working to fix that but that's
> another discussion.
> Even specifying plain DMA_SLAVE should work if you code your filter
> function properly :)

RIO filter checks for DMA device associated with RapidIO mport object.
This should work reliable from the RapidIO side. It also verifies
that returned DMA channel is capable to service corresponding RIO device
(in system that has more than one RIO controller). 

... skip ...
> >
> > Second, having ability to pass private target information allows me to pass
> > information about remote target device on per-transfer basis.
> Okay, then why not pass the dma address and make your dma driver
> transparent (i saw you passed RIO address, IIRC 64+2 bits)
> Currently using dma_slave_config we pass channel specific information,
> things like peripheral address and config don't change typically
> between
> transfers and if you have some controller specific properties you can
> pass them by embedding dma_slave_config in your specific structure.
> Worst case, you can configure slave before every prepare

In addition to address on target RIO device I need to pass corresponding
device destination ID. With single channel capable to transfer data between
local memory and different RapidIO devices I have to pass device specific
information on per transfer basis (destID + 66-bit address + type of write ops, etc.).

Even having 8 channels (each set for specific target) will not help me with
full support of RapidIO network where I have 8- or 16-bit destID (256 or 64K
devices respectively).

RapidIO controller device (and its DMA component) may provide services to
multiple device drivers which service individual devices on RapidIO network
(similar to PCIe having multiple peripherals, but not using memory mapped
model - destID defines route to a device). 

Generic RapidIO controller may have only one DMA channel which services all
target devices forming the network. We may have multiple concurrent data
transfer requests for different devices.

Parallel discussion with Dan touches the same post-config approach and
another option. I like Dan's idea of having RIO-specific version of prep_sg().
At the same time my current implementation of rio_dma_prep_slave_sg() with
added appropriate locking may do job as well and keeps DMA part within
existing API (DMA_RAPIDIO removed).      

Alex.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
