Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab1IACJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 22:09:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60346 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab1IACJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 22:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <1314826214-22428-1-git-send-email-msalter@redhat.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
Date: Thu, 1 Sep 2011 10:09:17 +0800
Message-ID: <CACVXFVPN7SCk8z=vatphyM=PhZDAwtyDidALYPeVkuJ_zxpBvA@mail.gmail.com>
Subject: Re: [PATCH 0/3] RFC: addition to DMA API
From: Ming Lei <ming.lei@canonical.com>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stern@rowland.harvard.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 1, 2011 at 5:30 AM, Mark Salter <msalter@redhat.com> wrote:
> This patch set arose out of a discussion on linux-arm concerning a
> performance problem with USB on some ARMv7 based platforms. The
> problem was tracked down by ming.lei@canonical.com and found to be
> the result of CPU writes to DMA-coherent memory being delayed in a
> write buffer between the CPU and memory. One proposed patch fixed
> only the immediate problem with the USB EHCI driver, but several
> folks thought a more general approach was needed, so I put this series
> of patches together as a starting point for wider discussion outside
> the ARM specific list.

After some further thoughts, I think it is not a good idea to introduce a
general DMA API to handle this case, see below:

1. The side-effect of new API is that it will make descriptors of dma in a
partial update, such as qtd in the ehci case, even ehci can handle this
successful, but it is really not good to make DMA bus master see a
partial update of descriptor, and I am not  sure that other kind of bus masters
can handle this correctly, which may introduce other problems. A proper memory
barrier will always make dma master see a atomic update of dma descriptors,
which should be the preferred way to take by device driver.

2, most of such cases can be handled correctly by mb/wmb/rmb barriers.
The ehci case I reported is in the one of the most tricky code path in
ehci driver,
and it should be a special case, and up to now, we only have found this case
can't be handled by memory barriers. Is there other cases which can't be handled
correctly by mb/wmb/rmb? If so, please point it out.

3, The new DMA API for the purpose to be introduced is much easier to
understand, and much easier to use than memory barrier, so it is very
possible to make device driver guys misuse or abuse it instead of using
memory barrier first to handle the case.

>
> The original problem seen was that USB storage performance was unusually
> poor on some ARMv7 based platforms. With my particular setup, I was
> seeing hdparm -t report ~5.6MB/s on an SMP Cortex-A9 based platform
> where the same disk driver would get ~21MB/s on a Cortex-A8 based system.
> My understanding from subsequent discussion is that the A9 cores have
> a write buffer between the CPU and memory which could buffer data for a
> prolonged period even in the case of DMA coherent mappings. The ARM
> architecture code largely mitigates this by doing a write buffer flush
> as part of the MMIO functions used to write to device registers. This
> avoids problems in almost all drivers because most need to write to a
> device register to tell the device when something is written in the
> shared DMA coherent memory. In the case of USB, an EHCI host controller
> will poll certain DMA coherent memory locations for information coming
> from the CPU. In that case, the write buffering negatively affects
> performance.
>
> This series of patches adds a new function to the DMA API to deal with
> ARMv7 and any future architectures which have write buffering even for
> DMA coherent memory. The proposed dma_coherent_write_sync() function
> will allow those few drivers which need it to force out write buffer
> data in a timely way to avoid performace issues.
>
> Mark Salter (3):
>  add dma_coherent_write_sync to DMA API
>  define ARM-specific dma_coherent_write_sync
>  add dma_coherent_write_sync calls to USB EHCI driver
>
>  Documentation/DMA-API-HOWTO.txt    |   15 +++++++++++++++
>  Documentation/DMA-API.txt          |   12 ++++++++++++
>  arch/arm/include/asm/dma-mapping.h |   10 ++++++++++
>  drivers/usb/host/ehci-q.c          |    7 ++++++-
>  include/linux/dma-mapping.h        |    6 ++++++
>  5 files changed, 49 insertions(+), 1 deletions(-)
>
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

thanks,
--
Ming Lei
