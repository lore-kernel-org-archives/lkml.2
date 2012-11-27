Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2K0E4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:56:09 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:64775 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2K0E4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:56:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121116232638.1766.86886.stgit@djiang5-linux.ch.intel.com>
References: <20121116232638.1766.86886.stgit@djiang5-linux.ch.intel.com>
Date: Mon, 26 Nov 2012 20:56:06 -0800
X-Google-Sender-Auth: HtIL0evnDwSlbh8aK_EtHVO1Z-E
Message-ID: <CAA9_cmfYpa+ByFDJNwqxsj+e_3xrZD-=EP-NGQmWuWjgc7ZRtw@mail.gmail.com>
Subject: Re: [PATCH] ioat: remove chanerr mask setting for IOAT v3.x
From: Dan Williams <djbw@fb.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 3:26 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> The CHANERRMSK_INT register should be 0. The existing code set a value
> for a workaround to address a pre-silicon bug on the Intel 5520 IO hub that
> has been fixed when the hardware was released. There is no need for this
> code.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
>  drivers/dma/ioat/dma_v3.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index f7f1dc6..60c15c4 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -1126,12 +1126,8 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
>         chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
>         writel(chanerr, chan->reg_base + IOAT_CHANERR_OFFSET);
>
> -       /* -= IOAT ver.3 workarounds =- */
> -       /* Write CHANERRMSK_INT with 3E07h to mask out the errors
> -        * that can cause stability issues for IOAT ver.3, and clear any
> -        * pending errors
> -        */
> -       pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0x3e07);
> +       /* clearn CHANERRMASK_INT and clear any pending errors */
> +       pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0);

Can we get rid of this write / register access altogether?  Then the
driver will load on systems where extended pci configuration space is
not available.
