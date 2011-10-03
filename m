Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1JCGYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 02:24:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58582 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1JCGYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 02:24:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
References: <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	<1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1317200618.1573.1765.camel@vkoul-udesk3>
	<CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	<1317295068.1573.1780.camel@vkoul-udesk3>
	<CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	<CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	<CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
	<CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
	<CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
Date: Mon, 3 Oct 2011 11:54:23 +0530
Message-ID: <CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 October 2011 06:03, Barry Song <21cnbao@gmail.com> wrote:
> 2011/10/2 Jassi Brar <jaswinder.singh@linaro.org>

>> > For example, it can't use
>> > MEM_TO_MEM to map, it still need to know whether the memory is source
>> > or dest.
>> MEM_TO_MEM means "From Memory Source To Memory Destination"
>>  Map Src buffer with DMA_TO_DEVICE and Dst buffer with DMA_FROM_DEVICE
>>
>> MEM_TO_DEV means "From Memory Source To FIFO Destination"
>>  Map Src buffer with DMA_TO_DEVICE.
>>
>> DEV_TO_MEM means "From FIFO Source To Memory Destination"
>>  Map Dst buffer with DMA_FROM_DEVICE
>>
>> DEV_TO_DEV means "From FIFO Source To FIFO Destination"
>>
>> What else would you want to know ?
>
> that is the problem. for example, drivers can't use MEM_TO_MEM as a
> flag to do dma mapping. so xfer_direction can't cover all that
> dma_data_direction can do.  that's why you need both
> dma_data_direction and xfer_direction with some similar flags in them.
>
The client drivers map the src/dst buffers and the dmac driver unmaps
them by default(!). For which, the dmac driver doesn't look at anything
other than
     DMA_COMPL_SKIP_SRC/DST_UNMAP
     DMA_COMPL_SRC/DST_UNMAP_SINGLE
  bits of 'enum dma_ctrl_flags'.
For this unmap'ing purpose, the usage of dma_data_direction is already
internal to the dmac driver.
[BTW, the scheme is broken because the dmac driver can't know if
the client mapped the buffers with DMA_TO/FROM_DEVICE or with
DMA_BIDIRECTION (dmatest.c does so)]

The only use of 'enum dma_data_direction' in DMAEngine _api_ is
in 'struct dma_slave_config', device_prep_slave_sg and device_prep_dma_cyclic.
Where too the dmac drivers disregard any value other than DMA_TO_DEVICE
and DMA_FROM_DEVICE and very rightly so IMO.

So replacing dma_data_direction usage with xfer_direction in
dmaengine is the best thing to do.

I don't know how better could I explain. If you still think otherwise,
please do tell exactly when would a client need to use both the
flags - dma_data_direction and xfer_direction?


>> > How could we have two macro names: SRC_MEM, DEST_MEM for mapping. or just add:
>> > dma_map_single_src
>> > dma_map_single_dst
>> Not sure what you mean by this.
>
> my point is dma_data_direction is named wrong after we have your
> xfer_direction. people will think dma_data_direction just means dma is
> transferred from where to where. doesn't dma_data_direction mean m2d,
> m2m, d2d, d2m just from the name? but actually it is just the mapping
> direction now.
>
So basically you mean people might get confused because
of 'dma_data_direction' and 'xfer_direction' names.
The concern might or might not be serious, but it certainly doesn't
warrant any change to dma_data_direction.

-j
