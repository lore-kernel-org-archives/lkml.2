Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab2IBIMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 04:12:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49292 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2IBIMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 04:12:23 -0400
MIME-Version: 1.0
In-Reply-To: <1344500448-10927-1-git-send-email-qiang.liu@freescale.com>
References: <1344500448-10927-1-git-send-email-qiang.liu@freescale.com>
Date: Sun, 2 Sep 2012 01:12:22 -0700
X-Google-Sender-Auth: u5Hdn8DqxKWTBLfYuYOzdksSSwA
Message-ID: <CAA9_cmdqmuhAcaqfkjvKSpsTL350BAJcY8pn6U=SJ9Nok1-XuA@mail.gmail.com>
Subject: Re: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
From: Dan Williams <djbw@fb.com>
To: qiang.liu@freescale.com
Cc: linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, leoli@freescale.com,
        kim.phillips@freescale.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, arnd@arndb.de, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 1:20 AM,  <qiang.liu@freescale.com> wrote:
> From: Qiang Liu <qiang.liu@freescale.com>
>
> Expose Talitos's XOR functionality to be used for RAID parity
> calculation via the Async_tx layer.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
> Signed-off-by: Maneesh Gupta <Maneesh.Gupta@freescale.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> ---
>  drivers/crypto/Kconfig   |    9 +
>  drivers/crypto/talitos.c |  413 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/talitos.h |   53 ++++++
>  3 files changed, 475 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index be6b2ba..f0a7c29 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -222,6 +222,15 @@ config CRYPTO_DEV_TALITOS
>           To compile this driver as a module, choose M here: the module
>           will be called talitos.
>
> +config CRYPTO_DEV_TALITOS_RAIDXOR
> +       bool "Talitos RAID5 XOR Calculation Offload"
> +       default y

No, default y.  The user should explicitly enable this.

> +       select DMA_ENGINE
> +       depends on CRYPTO_DEV_TALITOS
> +       help
> +         Say 'Y' here to use the Freescale Security Engine (SEC) to
> +         offload RAID XOR parity Calculation
> +

Is it faster than cpu xor?

Will this engine be coordinating with another to handle memory copies?
 The dma mapping code for async_tx/raid is broken when dma mapping
requests overlap or cross dma device boundaries [1].

[1]: http://marc.info/?l=linux-arm-kernel&m=129407269402930&w=2

> +static void talitos_process_pending(struct talitos_xor_chan *xor_chan)
> +{
> +       struct talitos_xor_desc *desc, *_desc;
> +       unsigned long flags;
> +       int status;
> +       struct talitos_private *priv;
> +       int ch;
> +
> +       priv = dev_get_drvdata(xor_chan->dev);
> +       ch = atomic_inc_return(&priv->last_chan) &
> +                                 (priv->num_channels - 1);

Maybe a comment about why this this is duplicated from
talitos_cra_init()?  It sticks out here and I had to go looking to
find out why this channel number increments on submit.


> +       spin_lock_irqsave(&xor_chan->desc_lock, flags);
> +
> +       list_for_each_entry_safe(desc, _desc, &xor_chan->pending_q, node) {
> +               status = talitos_submit(xor_chan->dev, ch, &desc->hwdesc,
> +                                       talitos_release_xor, desc);
> +               if (status != -EINPROGRESS)
> +                       break;
> +
> +               list_del(&desc->node);
> +               list_add_tail(&desc->node, &xor_chan->in_progress_q);
> +       }
> +
> +       spin_unlock_irqrestore(&xor_chan->desc_lock, flags);
> +}
> +
> +static void talitos_xor_run_tx_complete_actions(struct talitos_xor_desc *desc,
> +               struct talitos_xor_chan *xor_chan)
> +{
> +       struct device *dev = xor_chan->dev;
> +       dma_addr_t dest, addr;
> +       unsigned int src_cnt = desc->unmap_src_cnt;
> +       unsigned int len = desc->unmap_len;
> +       enum dma_ctrl_flags flags = desc->async_tx.flags;
> +       struct dma_async_tx_descriptor *tx = &desc->async_tx;
> +
> +       /* unmap dma addresses */
> +       dest = desc->hwdesc.ptr[6].ptr;
> +       if (likely(!(flags & DMA_COMPL_SKIP_DEST_UNMAP)))
> +               dma_unmap_page(dev, dest, len, DMA_BIDIRECTIONAL);
> +
> +       desc->idx = 6 - src_cnt;
> +       if (likely(!(flags & DMA_COMPL_SKIP_SRC_UNMAP))) {
> +               while(desc->idx < 6) {

Checkpatch says:
ERROR: space required before the open parenthesis '('


> +                       addr = desc->hwdesc.ptr[desc->idx++].ptr;
> +                       if (addr == dest)
> +                               continue;
> +                       dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
> +               }
> +       }
> +
> +       /* run dependent operations */
> +       dma_run_dependencies(tx);

Here is where we run into problems if another engine accesses these
same buffers, especially on ARM v6+.

> +}
> +
> +static void talitos_release_xor(struct device *dev, struct talitos_desc *hwdesc,
> +                               void *context, int error)
> +{
> +       struct talitos_xor_desc *desc = context;
> +       struct talitos_xor_chan *xor_chan;
> +       dma_async_tx_callback callback;
> +       void *callback_param;
> +
> +       if (unlikely(error))
> +               dev_err(dev, "xor operation: talitos error %d\n", error);
> +
> +       xor_chan = container_of(desc->async_tx.chan, struct talitos_xor_chan,
> +                               common);
> +       spin_lock_bh(&xor_chan->desc_lock);
> +       if (xor_chan->completed_cookie < desc->async_tx.cookie)
> +               xor_chan->completed_cookie = desc->async_tx.cookie;
> +

Use dma_cookie_complete().

> +       callback = desc->async_tx.callback;
> +       callback_param = desc->async_tx.callback_param;
> +
> +       if (callback) {
> +               spin_unlock_bh(&xor_chan->desc_lock);
> +               callback(callback_param);
> +               spin_lock_bh(&xor_chan->desc_lock);

As mentioned you'll either need to ensure that
talitos_process_pending() is only called from the tasklet, or upgrade
these locks to hardirq safe.

> +       }
> +
> +       talitos_xor_run_tx_complete_actions(desc, xor_chan);
> +
> +       list_del(&desc->node);
> +       list_add_tail(&desc->node, &xor_chan->free_desc);
> +       spin_unlock_bh(&xor_chan->desc_lock);
> +       if (!list_empty(&xor_chan->pending_q))
> +               talitos_process_pending(xor_chan);
> +}
> +
> +/**
> + * talitos_issue_pending - move the descriptors in submit
> + * queue to pending queue and submit them for processing
> + * @chan: DMA channel
> + */
> +static void talitos_issue_pending(struct dma_chan *chan)
> +{
> +       struct talitos_xor_chan *xor_chan;
> +
> +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +       spin_lock_bh(&xor_chan->desc_lock);
> +       list_splice_tail_init(&xor_chan->submit_q,
> +                                &xor_chan->pending_q);
> +       spin_unlock_bh(&xor_chan->desc_lock);
> +       talitos_process_pending(xor_chan);
> +}
> +
> +static dma_cookie_t talitos_async_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +       struct talitos_xor_desc *desc;
> +       struct talitos_xor_chan *xor_chan;
> +       dma_cookie_t cookie;
> +
> +       desc = container_of(tx, struct talitos_xor_desc, async_tx);
> +       xor_chan = container_of(tx->chan, struct talitos_xor_chan, common);
> +
> +       spin_lock_bh(&xor_chan->desc_lock);
> +
> +       cookie = xor_chan->common.cookie + 1;
> +       if (cookie < 0)
> +               cookie = 1;

Should use the new dma_cookie_assign() helper.

> +
> +       desc->async_tx.cookie = cookie;
> +       xor_chan->common.cookie = desc->async_tx.cookie;
> +
> +       list_splice_tail_init(&desc->tx_list,
> +                                &xor_chan->submit_q);
> +
> +       spin_unlock_bh(&xor_chan->desc_lock);
> +
> +       return cookie;
> +}
> +
> +static struct talitos_xor_desc *talitos_xor_alloc_descriptor(
> +                               struct talitos_xor_chan *xor_chan, gfp_t flags)
> +{
> +       struct talitos_xor_desc *desc;
> +
> +       desc = kmalloc(sizeof(*desc), flags);
> +       if (desc) {
> +               xor_chan->total_desc++;
> +               desc->async_tx.tx_submit = talitos_async_tx_submit;
> +       }
> +
> +       return desc;
> +}
> +
[..]
> +
> +static struct dma_async_tx_descriptor *talitos_prep_dma_xor(
> +                       struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
> +                       unsigned int src_cnt, size_t len, unsigned long flags)
> +{
> +       struct talitos_xor_chan *xor_chan;
> +       struct talitos_xor_desc *new;
> +       struct talitos_desc *desc;
> +       int i, j;
> +
> +       BUG_ON(len > TALITOS_MAX_DATA_LEN);
> +
> +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +
> +       spin_lock_bh(&xor_chan->desc_lock);
> +       if (!list_empty(&xor_chan->free_desc)) {
> +               new = container_of(xor_chan->free_desc.next,
> +                                  struct talitos_xor_desc, node);
> +               list_del(&new->node);
> +       } else {
> +                new = talitos_xor_alloc_descriptor(xor_chan, GFP_KERNEL | GFP_DMA);

You can't hold a spin_lock over a GFP_KERNEL allocation.

> +       }
> +       spin_unlock_bh(&xor_chan->desc_lock);
> +
> +       if (!new) {
> +               dev_err(xor_chan->common.device->dev,
> +                       "No free memory for XOR DMA descriptor\n");
> +               return NULL;
> +       }
> +       dma_async_tx_descriptor_init(&new->async_tx, &xor_chan->common);
> +
> +       INIT_LIST_HEAD(&new->node);
> +       INIT_LIST_HEAD(&new->tx_list);
> +
> +       desc = &new->hwdesc;
> +       /* Set destination: Last pointer pair */
> +       to_talitos_ptr(&desc->ptr[6], dest);
> +       desc->ptr[6].len = cpu_to_be16(len);
> +       desc->ptr[6].j_extent = 0;
> +       new->unmap_src_cnt = src_cnt;
> +       new->unmap_len = len;
> +
> +       /* Set Sources: End loading from second-last pointer pair */
> +       for (i = 5, j = 0; j < src_cnt && i >= 0; i--, j++) {
> +               to_talitos_ptr(&desc->ptr[i], src[j]);
> +               desc->ptr[i].len = cpu_to_be16(len);
> +               desc->ptr[i].j_extent = 0;
> +       }
> +
> +       /*
> +        * documentation states first 0 ptr/len combo marks end of sources
> +        * yet device produces scatter boundary error unless all subsequent
> +        * sources are zeroed out
> +        */
> +       for (; i >= 0; i--) {
> +               to_talitos_ptr(&desc->ptr[i], 0);
> +               desc->ptr[i].len = 0;
> +               desc->ptr[i].j_extent = 0;
> +       }
> +
> +       desc->hdr = DESC_HDR_SEL0_AESU | DESC_HDR_MODE0_AESU_XOR |
> +               DESC_HDR_TYPE_RAID_XOR;
> +
> +       new->async_tx.parent = NULL;
> +       new->async_tx.next = NULL;
> +       new->async_tx.cookie = 0;
> +       async_tx_ack(&new->async_tx);
> +
> +       list_add_tail(&new->node, &new->tx_list);
> +
> +       new->async_tx.flags = flags;
> +       new->async_tx.cookie = -EBUSY;
> +
> +       return &new->async_tx;
> +}
> +
> +static void talitos_unregister_async_xor(struct device *dev)
> +{
> +       struct talitos_private *priv = dev_get_drvdata(dev);
> +       struct talitos_xor_chan *xor_chan;
> +       struct dma_chan *chan, *_chan;
> +
> +       if (priv->dma_dev_common.chancnt)
> +               dma_async_device_unregister(&priv->dma_dev_common);
> +
> +       list_for_each_entry_safe(chan, _chan, &priv->dma_dev_common.channels,
> +                               device_node) {
> +               xor_chan = container_of(chan, struct talitos_xor_chan,
> +                                       common);
> +               list_del(&chan->device_node);
> +               priv->dma_dev_common.chancnt--;
> +               kfree(xor_chan);
> +       }
> +}
> +
> +/**
> + * talitos_register_dma_async - Initialize the Freescale XOR ADMA device
> + * It is registered as a DMA device with the capability to perform
> + * XOR operation with the Async_tx layer.
> + * The various queues and channel resources are also allocated.
> + */
> +static int talitos_register_async_tx(struct device *dev, int max_xor_srcs)
> +{
> +       struct talitos_private *priv = dev_get_drvdata(dev);
> +       struct dma_device *dma_dev = &priv->dma_dev_common;
> +       struct talitos_xor_chan *xor_chan;
> +       int err;
> +
> +       xor_chan = kzalloc(sizeof(struct talitos_xor_chan), GFP_KERNEL);
> +       if (!xor_chan) {
> +               dev_err(dev, "unable to allocate xor channel\n");
> +               return -ENOMEM;
> +       }
> +
> +       dma_dev->dev = dev;
> +       dma_dev->device_alloc_chan_resources = talitos_alloc_chan_resources;
> +       dma_dev->device_free_chan_resources = talitos_free_chan_resources;
> +       dma_dev->device_prep_dma_xor = talitos_prep_dma_xor;
> +       dma_dev->max_xor = max_xor_srcs;
> +       dma_dev->device_tx_status = talitos_is_tx_complete;
> +       dma_dev->device_issue_pending = talitos_issue_pending;
> +       INIT_LIST_HEAD(&dma_dev->channels);
> +       dma_cap_set(DMA_XOR, dma_dev->cap_mask);
> +
> +       xor_chan->dev = dev;
> +       xor_chan->common.device = dma_dev;
> +       xor_chan->total_desc = 0;
> +       INIT_LIST_HEAD(&xor_chan->submit_q);
> +       INIT_LIST_HEAD(&xor_chan->pending_q);
> +       INIT_LIST_HEAD(&xor_chan->in_progress_q);
> +       INIT_LIST_HEAD(&xor_chan->free_desc);
> +       spin_lock_init(&xor_chan->desc_lock);
> +
> +       list_add_tail(&xor_chan->common.device_node, &dma_dev->channels);
> +       dma_dev->chancnt++;
> +
> +       err = dma_async_device_register(dma_dev);
> +       if (err) {
> +               dev_err(dev, "Unable to register XOR with Async_tx\n");
> +               goto err_out;
> +       }
> +
> +       return err;
> +
> +err_out:
> +       talitos_unregister_async_xor(dev);
> +       return err;
> +}
> +#endif
> +
>  /*
>   * crypto alg
>   */
> @@ -2891,6 +3284,26 @@ static int talitos_probe(struct platform_device *ofdev)
>                         dev_info(dev, "hwrng\n");
>         }
>
> +#ifdef CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR

Kill these ifdefs in the C file.  Do something like: if
(xor_enabled()) { } around the code sections that are optional so you
always get compile coverage.  Where xor_enabled() is a shorter form of
IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR).

> +       /*
> +        * register with async_tx xor, if capable
> +        * SEC 2.x support up to 3 RAID sources,
> +        * SEC 3.x support up to 6
> +        */
> +       if (hw_supports(dev, DESC_HDR_SEL0_AESU | DESC_HDR_TYPE_RAID_XOR)) {
> +               int max_xor_srcs = 3;
> +               if (of_device_is_compatible(np, "fsl,sec3.0"))
> +                       max_xor_srcs = 6;
> +               err = talitos_register_async_tx(dev, max_xor_srcs);
> +               if (err) {
> +                       dev_err(dev, "failed to register async_tx xor: %d\n",
> +                                       err);
> +                       goto err_out;
> +               }
> +               dev_info(dev, "max_xor_srcs %d\n", max_xor_srcs);
> +       }
> +#endif
> +
>         /* register crypto algorithms the device supports */
>         for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
>                 if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
> diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
> index 61a1405..fc9d125 100644
> --- a/drivers/crypto/talitos.h
> +++ b/drivers/crypto/talitos.h
> @@ -30,6 +30,7 @@
>
>  #define TALITOS_TIMEOUT 100000
>  #define TALITOS_MAX_DATA_LEN 65535
> +#define TALITOS_MAX_DESCRIPTOR_NR 256
>
>  #define DESC_TYPE(desc_hdr) ((be32_to_cpu(desc_hdr) >> 3) & 0x1f)
>  #define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
> @@ -131,7 +132,57 @@ struct talitos_private {
>
>         /* hwrng device */
>         struct hwrng rng;
> +
> +#ifdef CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR
> +       /* XOR Device */
> +       struct dma_device dma_dev_common;
> +#endif
> +};
> +
> +#ifdef CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR
> +/**
> + * talitos_xor_chan - context management for the async_tx channel
> + * @completed_cookie: the last completed cookie
> + * @desc_lock: lock for tx queue
> + * @total_desc: number of descriptors allocated
> + * @submit_q: queue of submitted descriptors
> + * @pending_q: queue of pending descriptors
> + * @in_progress_q: queue of descriptors in progress
> + * @free_desc: queue of unused descriptors
> + * @dev: talitos device implementing this channel
> + * @common: the corresponding xor channel in async_tx
> + */
> +struct talitos_xor_chan {
> +       dma_cookie_t completed_cookie;
> +       spinlock_t desc_lock;
> +       unsigned int total_desc;
> +       struct list_head submit_q;
> +       struct list_head pending_q;
> +       struct list_head in_progress_q;
> +       struct list_head free_desc;
> +       struct device *dev;
> +       struct dma_chan common;
> +};
> +
> +/**
> + * talitos_xor_desc - software xor descriptor
> + * @async_tx: the referring async_tx descriptor
> + * @node:
> + * @hwdesc: h/w descriptor
> + * @unmap_src_cnt: number of xor sources
> + * @unmap_len: transaction byte count
> + * @idx: index of xor sources
> + */
> +struct talitos_xor_desc {
> +       struct dma_async_tx_descriptor async_tx;
> +       struct list_head tx_list;
> +       struct list_head node;
> +       struct talitos_desc hwdesc;
> +       unsigned int unmap_src_cnt;
> +       unsigned int unmap_len;
> +       unsigned int idx;
>  };
> +#endif
>
>  extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
>                           void (*callback)(struct device *dev,
> @@ -284,6 +335,7 @@ extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
>  /* primary execution unit mode (MODE0) and derivatives */
>  #define        DESC_HDR_MODE0_ENCRYPT          cpu_to_be32(0x00100000)
>  #define        DESC_HDR_MODE0_AESU_CBC         cpu_to_be32(0x00200000)
> +#define        DESC_HDR_MODE0_AESU_XOR         cpu_to_be32(0x0c600000)
>  #define        DESC_HDR_MODE0_DEU_CBC          cpu_to_be32(0x00400000)
>  #define        DESC_HDR_MODE0_DEU_3DES         cpu_to_be32(0x00200000)
>  #define        DESC_HDR_MODE0_MDEU_CONT        cpu_to_be32(0x08000000)
> @@ -344,6 +396,7 @@ extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
>  #define DESC_HDR_TYPE_IPSEC_ESP                        cpu_to_be32(1 << 3)
>  #define DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU  cpu_to_be32(2 << 3)
>  #define DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU       cpu_to_be32(4 << 3)
> +#define DESC_HDR_TYPE_RAID_XOR                  cpu_to_be32(21 << 3)
>
>  /* link table extent field bits */
>  #define DESC_PTR_LNKTBL_JUMP                   0x80
