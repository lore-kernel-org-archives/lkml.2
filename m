Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab1IUI1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:27:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33647 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1IUI13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <1316166200-20595-1-git-send-email-Baohua.Song@csr.com>
References: <1316166200-20595-1-git-send-email-Baohua.Song@csr.com>
Date: Wed, 21 Sep 2011 13:57:27 +0530
Message-ID: <CABb+yY2L=wfRoascoriAcnNMKkV7LbQEHCpp78+rCY=aM46x7A@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: delete redundant chan_id and chancnt
 initialization in dma drivers
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Barry Song <Baohua.Song@csr.com>
Cc: dan.j.williams@intel.com, Piotr Ziecik <kosmo@semihalf.com>,
        Jaswinder Singh <jassi.brar@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Pelagicore AB <info@pelagicore.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Yong Wang <yong.y.wang@intel.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 3:13 PM, Barry Song <Baohua.Song@csr.com> wrote:
> dma_async_device_register will re-init chan_id and chancnt,
> so whatever chan_id and chancnt are set in drivers, they will
> be re-written by dma_async_device_register.
>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Piotr Ziecik <kosmo@semihalf.com>
> Cc: Yong Wang <yong.y.wang@intel.com>
> Cc: Jaswinder Singh <jassi.brar@samsung.com>
> Cc: Pelagicore AB <info@pelagicore.com>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> ---
>  drivers/dma/at_hdmac.c      |    5 ++---
>  drivers/dma/dw_dmac.c       |    5 ++---
>  drivers/dma/intel_mid_dma.c |    2 --
>  drivers/dma/mpc512x_dma.c   |    1 -
>  drivers/dma/pch_dma.c       |    2 --
>  drivers/dma/pl330.c         |    2 --
>  drivers/dma/timb_dma.c      |    3 +--

Apparently ....

drivers/dma/ppc4xx/adma.c
drivers/dma/ipu/ipu_idmac.c
       still write to chan_id.

drivers/dma/amba-pl08x.c
drivers/dma/fsldma.c
drivers/dma/ioat/dma_v2.c
drivers/dma/ioat/dma.c
drivers/dma/mpc512x_dma.c
drivers/dma/shdma.c
       still write to chancnt

Most of them are simply a matter of removal, but some seem
like really depending upon setting them(?)

Anyways, even after you modify those as well, chan_id and chancnt
are rendered overstaying guests in dmaengine core. Because chan_id
of each channel would be _precisely_ the order in which the
_dmac-driver_ added the channel to the 'channels' list.

So if their values are _always_ gonna be just contiguously incrementing
why need variables for that in the dmaengine api?
Dmac drivers could use local variables for that.

OTOH, why not chan_id be left solely for use by dmac drivers read by the
dmaengine only to create sysfs entries ?
