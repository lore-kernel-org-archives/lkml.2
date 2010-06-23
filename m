Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0FWAkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 20:40:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37435 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0FWAkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 20:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lrtnnksz4KbOt1oSkBvAza2wILYAke4dzxrruF4P7kyu5d7Tt+bBJs4qpTKcCRCKm9
         1swv+9bPWnAJ0W+/yk4kbgqzJ5Qqa8aUBvPKsCbFELCq3qj7m3CF8D08P+9CTUvN8iCh
         bmdryE8ML8e9ICZCushdJfG2/TQZuLlvPr8q8=
MIME-Version: 1.0
In-Reply-To: <20100618155149.1356.84206.stgit@localhost.localdomain>
References: <20100618155149.1356.84206.stgit@localhost.localdomain>
Date: Tue, 22 Jun 2010 17:40:44 -0700
X-Google-Sender-Auth: CbbDOy7wrZpMkhWxYX-DrkCER_k
Message-ID: <AANLkTilvD6KKEY3GE2Q0q3z4gu6K6RwkMWbRaRPl9_pU@mail.gmail.com>
Subject: Re: [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
From: Dan Williams <dan.j.williams@intel.com>
To: Alan Cox <alan@linux.intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 8:51 AM, Alan Cox <alan@linux.intel.com> wrote:
> From: Vinod Koul <vinod.koul@intel.com>
>
> This patch add DMA drivers for DMA controllers in Langwell chipset
> of Intel(R) Moorestown platform and DMA controllers in Penwell of
> Intel(R) Medfield platfrom
>
> This patch adds support for Moorestown DMAC1 and DMAC2 controllers.
> It also add support for Medfiled GP DMA and DMAC1 controllers.
> These controllers supports memory to peripheral and peripheral to
> memory transfers
> It support only single block transfers
> This driver is based on Kernel DMA engine
> Anyone who wishes to use this controller should use DMA engine APIs
>
> This controller exposes DMA_SLAVE capabilities and notifies the client drivers
> of DMA transaction completion
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
[..]
> ++ *    midc_do_start           begin a transaction
> ++ *    @midc: channel
> ++ *    @first: first descriptor of series
> ++ *
> ++ *    Load a transaction into the engine. This must be called with dwc->lock
> ++ *    held and bh disabled.
> ++ */
> +static void midc_dostart(struct intel_mid_dma_chan *midc, struct intel_mid_dma_desc

(nit) The function name does not match the kernel doc, and I don't
know if those extra "+" characters will throw off the kernel-doc
scripts.  They also show up on midc_put_desc, but not
midc_scan_descriptors.

> +/*check desc, mark as complete when tx is complete*/
> +static void
> +midc_scan_descriptors(struct middma_device *mid, struct intel_mid_dma_chan *midc)
> +{
> +       struct intel_mid_dma_desc *desc = NULL, *_desc = NULL;
> +/*     u32 status_xfer; */
> +
> +       dma_dbg("called \n");
> +/*     status_xfer = ioread32(midc->dma_base + RAW_TFR);
> +       status_xfer = (status_xfer >> midc->ch_id) & 0x1;
> +       dma_dbg("ch[%d]:  status_xfer %x \n", midc->ch_id, status_xfer);
> +       if (!status_xfer)
> +               return;
> +*/
> +       /*tx is complete*/
> +       list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
> +               if (desc == NULL)
> +                       continue;

How do we ever get desc == NULL at this point?

> +               if (desc->status == DMA_IN_PROGRESS)  {
> +                       desc->status = DMA_SUCCESS;
> +                       midc_descriptor_complete(midc, desc);
> +               }
> +       }
> +       return;
> +}
> +
[..]
> +#define _dma_printk(level, format, arg...)  \
> +       printk(level "LNW_DMA: %s %d " format, __func__, __LINE__, ## arg)
> +
> +#ifdef CONFIG_LNW_DMA_DEBUG
> +#define dma_dbg(format, arg...) _dma_printk(KERN_DEBUG, "DBG " format , ## arg)
> +#else
> +#define dma_dbg(format, arg...) do {} while (0);
> +#endif

This makes us lose compile coverage of the debug statements so they
bitrot until someone needs to debug a problem.

[..]
> +struct intel_mid_dma_slave {
> +       enum dma_data_direction         dirn;
> +       enum intel_mid_dma_width        src_width; /*width of DMA src txn*/
> +       enum intel_mid_dma_width        dst_width; /*width of DMA dst txn*/
> +       enum intel_mid_dma_hs_mode      hs_mode;  /*handshaking*/
> +       enum intel_mid_dma_mode         cfg_mode; /*mode configuration*/
> +       enum intel_mid_dma_msize        src_msize; /*size if src burst*/
> +       enum intel_mid_dma_msize        dst_msize; /*size of dst burst*/
> +       dma_async_tx_callback           callback; /*callback function*/
> +       void                            *callback_param; /*param for callback*/

Any advantage to having a default callback in the slave configuration?
 Why not let the client specify the callback on each operation, is it
a callback that the client does not know about?
