Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2KGUk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:40:59 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46398 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2KGUk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:40:58 -0500
MIME-Version: 1.0
In-Reply-To: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
Date: Wed, 7 Nov 2012 12:40:57 -0800
X-Google-Sender-Auth: 7dKw-Eofc00JCUNcMgDUB6rLMII
Message-ID: <CAA9_cmfkDkF7tEmVTfD_vxtMhoTwxfFPnxtOEPT_xwsNgT1=8g@mail.gmail.com>
Subject: Re: [PATCH 00/20] DMA: DMA unmap fixes
From: Dan Williams <djbw@fb.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Ira Snyder <iws@ovro.caltech.edu>,
        "Koul, Vinod" <vinod.koul@intel.com>, vipin.kumar@st.com,
        t.figa@samsung.com,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        Dave Jiang <dave.jiang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 2:00 AM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> Hi,
>
> Currently DMA subsystem does DMA mapping in the core code and DMA
> unmapping is done by device drivers.  This is counterintuitive,
> causes code duplication and subtle errors (some drivers like PL330
> one don't implement DMA unmapping code).  The following patchset
> modifies DMA subsystem to do DMA unmapping in the core code.
> It results in simpler code, less code duplication (more than 400
> LOC is gone) and fixes the issue with missing DMA unmapping code
> in some drivers.  Additionally many cases when DMA wasn't unmapped
> on a failure are also fixed.
>
>
> patches #1-3 add missing DMA unmap on failure to async_tx core
> code (async_memcpy()), ioat and fsmc_nand drivers
>
> patch #4 fixes DMA flags used by carma-fpga driver

Ack patches 1-4

> patches #5-7 fix core code and dmatest driver to DMA unmap for
> MEMCPY operations

Yes, this needs to move out of the drivers, but it needs to move past
the core and into the dmaengine clients directly (md/raid and
net_dma).  The slave_dma usage model already does this as each client
takes responsibility for dma mapping.  Doing this in the core has some
downsides, maybe they're negligible: 1/ all drivers suffer the size
increase to dma_async_tx_descriptor 2/ pure polling usage models like
net_dma will now trigger dma channel interrupts to run the callback.

That being said this cleanup does get us a step closer to where
dmaengine needs to go, and I have not found time to do the "move it to
the client" patches mentioned above.  So I'm inclined to proceed with
them.  Does anyone still see positive benefits from net_dma?

> patch #8 adds missing DMA unmap on failure to ioat3 driver
>
> patch #9 fixes build for async_memset.c
>
> patch #10 adds missing DMA unmap on failure to async tx core
> code (async_memset())

Ack patches 8-10

>
> patches #11-18 fix async_tx core code and dmatest driver to do
> DMA unmap for MEMSET, XOR, XOR_VAL, PQ and PQ_VAL operations
>

Some comments in the patch.

> patches #19-20 remove no longer needed DMA unmap code from
> device drivers and DMA unmap flags from code code
>
>
> This patchset was tested on PL330 DMA controller using MEMCPY
> operations.  It would be great if somebody could test it on
> more advanced controller capable of MEMSET, XOR, XOR_VAL,
> PQ and PQ_VAL operations (especially since the conversion of
> XOR and PQ operations was not obvious).

async_tx has a bug in that it permits overlapping dma mappings or
operations that cross dma boundaries, but these patches don't make
this worse.  The interim "fix" I am proposing for this to drop support
for channel configurations that require an operation chain to switch
channels.  This will allow the removal the async_tx_ack() machinery
and hopefully prompt channel switching users to contribute to the md
changes needed to support this properly.  In the meantime the
async_tx_ack bits are just adding needless complexity to the drivers
that don't care about that functionality.

--
Dan
