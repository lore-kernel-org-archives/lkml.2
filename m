Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1JBAdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 20:33:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62381 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1JBAdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 20:33:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
References: <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
 <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
 <1317200618.1573.1765.camel@vkoul-udesk3> <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
 <1317295068.1573.1780.camel@vkoul-udesk3> <CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
 <CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
 <CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com> <CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 2 Oct 2011 08:33:18 +0800
Message-ID: <CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/2 Jassi Brar <jaswinder.singh@linaro.org>
>
> On 1 October 2011 08:35, Barry Song <21cnbao@gmail.com> wrote:
> > 2011/10/1 Jassi Brar <jaswinder.singh@linaro.org>:
> >> On 30 September 2011 12:13, Barry Song <21cnbao@gmail.com> wrote:
> >>>
> >>> i support we can update dma_data_direction to:   MEM_TO_MEM,
> >>> MEM_TO_DEV,  DEV_TO_MEM, DEV_TO_DEV.
> >>>
> >> So basically you are suggesting to replace 'enum dma_data_direction'
> >> with 'enum xfer_direction'
> >> I am not sure about that. I think they represent different things and
> >> hence should be separate.
> >> dma_data_direction tells the mapping of a buffer while the other
> >> tells if the src and dst are memory or a device's FIFO.
> >>
> > you are kind of right now. now people use dma_data_direction to do
> > mapping for dma buffer. even with all 4 direction, people still use
> > the old two direction to do mapping.
> > For example, it can't use
> > MEM_TO_MEM to map, it still need to know whether the memory is source
> > or dest.
> MEM_TO_MEM means "From Memory Source To Memory Destination"
>  Map Src buffer with DMA_TO_DEVICE and Dst buffer with DMA_FROM_DEVICE
>
> MEM_TO_DEV means "From Memory Source To FIFO Destination"
>  Map Src buffer with DMA_TO_DEVICE.
>
> DEV_TO_MEM means "From FIFO Source To Memory Destination"
>  Map Dst buffer with DMA_FROM_DEVICE
>
> DEV_TO_DEV means "From FIFO Source To FIFO Destination"
>
> What else would you want to know ?

that is the problem. for example, drivers can't use MEM_TO_MEM as a
flag to do dma mapping. so xfer_direction can't cover all that
dma_data_direction can do.  that's why you need both
dma_data_direction and xfer_direction with some similar flags in them.

>
> > i just don't like to the two old macro names. it seems i get a ticket
> > flying from New York to Beijing, but actually, we fly to Mexico...
> > so by the moment, dma_data_direction seems just to mean how to do map,
> > but xfer_direction is the real transfer direction.
> Not every dmac driver would need to know the src and dst type _only_ for buffer
> mapping. Some might have to reprogram the channel accordingly, say.
> The point is to give exact info about src and dst to dmac client driver and let
> it do what it must.
>
> > How could we have two macro names: SRC_MEM, DEST_MEM for mapping. or just add:
> > dma_map_single_src
> > dma_map_single_dst
> Not sure what you mean by this.

my point is dma_data_direction is named wrong after we have your
xfer_direction. people will think dma_data_direction just means dma is
transferred from where to where. doesn't dma_data_direction mean m2d,
m2m, d2d, d2m just from the name? but actually it is just the mapping
direction now.

so we might make mapping things be the mapping things but not the data
direction things. we might rename macros DMA_FROM_DEV, DMA_TO_DEV in
it to MEM_DST and MEM_SRC. or we split dma_map_single class functions
into dma_map_single_src and dma_map_single_dst. then for the memory
buffer as dma src, we map it by dma_map_single_src. for the memory
buffer as dma dst, we map it by dma_map_single_dst.

-barry
