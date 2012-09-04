Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab2IDM2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:28:53 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:13202
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756938Ab2IDM2t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:28:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I542M1432Izz1202hzz8275ch8275eh8275bh8275dha1495iz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220hbe9i1155h)
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Dan Williams <djbw@fb.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
Thread-Topic: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
Thread-Index: AQHNdgub00M+ZZ203UWQ+rzcgDFksJd3LRUAgAL+X1A=
Date: Tue, 4 Sep 2012 12:28:42 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70FFB67@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1344500448-10927-1-git-send-email-qiang.liu@freescale.com>
 <CAA9_cmdqmuhAcaqfkjvKSpsTL350BAJcY8pn6U=SJ9Nok1-XuA@mail.gmail.com>
In-Reply-To: <CAA9_cmdqmuhAcaqfkjvKSpsTL350BAJcY8pn6U=SJ9Nok1-XuA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.99]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Sunday, September 02, 2012 4:12 PM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; herbert@gondor.hengli.com.au;
> davem@davemloft.net; linux-kernel@vger.kernel.org; linuxppc-
> dev@lists.ozlabs.org; Li Yang-R58472; Phillips Kim-R1AAHA;
> vinod.koul@intel.com; dan.j.williams@intel.com; arnd@arndb.de;
> gregkh@linuxfoundation.org
> Subject: Re: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
> 
> On Thu, Aug 9, 2012 at 1:20 AM,  <qiang.liu@freescale.com> wrote:
> > From: Qiang Liu <qiang.liu@freescale.com>
> >
> > Expose Talitos's XOR functionality to be used for RAID parity
> > calculation via the Async_tx layer.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
> > Signed-off-by: Maneesh Gupta <Maneesh.Gupta@freescale.com>
> > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> > ---
> >  drivers/crypto/Kconfig   |    9 +
> >  drivers/crypto/talitos.c |  413
> ++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/crypto/talitos.h |   53 ++++++
> >  3 files changed, 475 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> > index be6b2ba..f0a7c29 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -222,6 +222,15 @@ config CRYPTO_DEV_TALITOS
> >           To compile this driver as a module, choose M here: the module
> >           will be called talitos.
> >
> > +config CRYPTO_DEV_TALITOS_RAIDXOR
> > +       bool "Talitos RAID5 XOR Calculation Offload"
> > +       default y
> 
> No, default y.  The user should explicitly enable this.
Ok, I will change it to N.

> 
> > +       select DMA_ENGINE
> > +       depends on CRYPTO_DEV_TALITOS
> > +       help
> > +         Say 'Y' here to use the Freescale Security Engine (SEC) to
> > +         offload RAID XOR parity Calculation
> > +
> 
> Is it faster than cpu xor?
Yes, I tested with IOZone, cpu load is also reduced.
I think one possible reason is the processor of p1022ds is not strong as others, so the performance is improved obviously.

> 
> Will this engine be coordinating with another to handle memory copies?
>  The dma mapping code for async_tx/raid is broken when dma mapping
> requests overlap or cross dma device boundaries [1].
> 
> [1]: http://marc.info/?l=linux-arm-kernel&m=129407269402930&w=2
Yes, it needs fsl-dma to handle memcpy copies.
I read your link, the unmap address is stored in talitos hwdesc, the address will be unmapped when async_tx ack this descriptor, I know fsl-dma won't wait this ack flag in current kernel, so I fix it in fsl-dma patch 5/8. Do you mean that?

> 
> > +static void talitos_process_pending(struct talitos_xor_chan *xor_chan)
> > +{
> > +       struct talitos_xor_desc *desc, *_desc;
> > +       unsigned long flags;
> > +       int status;
> > +       struct talitos_private *priv;
> > +       int ch;
> > +
> > +       priv = dev_get_drvdata(xor_chan->dev);
> > +       ch = atomic_inc_return(&priv->last_chan) &
> > +                                 (priv->num_channels - 1);
> 
> Maybe a comment about why this this is duplicated from
> talitos_cra_init()?  It sticks out here and I had to go looking to
> find out why this channel number increments on submit.
My fault, I will correct it as below,

atomic_read((&priv->last_chan) & (priv->num_channels - 1);

> 
> 
> > +       spin_lock_irqsave(&xor_chan->desc_lock, flags);
> > +
> > +       list_for_each_entry_safe(desc, _desc, &xor_chan->pending_q,
> node) {
> > +               status = talitos_submit(xor_chan->dev, ch, &desc-
> >hwdesc,
> > +                                       talitos_release_xor, desc);
> > +               if (status != -EINPROGRESS)
> > +                       break;
> > +
> > +               list_del(&desc->node);
> > +               list_add_tail(&desc->node, &xor_chan->in_progress_q);
> > +       }
> > +
> > +       spin_unlock_irqrestore(&xor_chan->desc_lock, flags);
> > +}
> > +
> > +static void talitos_xor_run_tx_complete_actions(struct
> talitos_xor_desc *desc,
> > +               struct talitos_xor_chan *xor_chan)
> > +{
> > +       struct device *dev = xor_chan->dev;
> > +       dma_addr_t dest, addr;
> > +       unsigned int src_cnt = desc->unmap_src_cnt;
> > +       unsigned int len = desc->unmap_len;
> > +       enum dma_ctrl_flags flags = desc->async_tx.flags;
> > +       struct dma_async_tx_descriptor *tx = &desc->async_tx;
> > +
> > +       /* unmap dma addresses */
> > +       dest = desc->hwdesc.ptr[6].ptr;
> > +       if (likely(!(flags & DMA_COMPL_SKIP_DEST_UNMAP)))
> > +               dma_unmap_page(dev, dest, len, DMA_BIDIRECTIONAL);
> > +
> > +       desc->idx = 6 - src_cnt;
> > +       if (likely(!(flags & DMA_COMPL_SKIP_SRC_UNMAP))) {
> > +               while(desc->idx < 6) {
> 
> Checkpatch says:
> ERROR: space required before the open parenthesis '('
I will correct it next.

> 
> 
> > +                       addr = desc->hwdesc.ptr[desc->idx++].ptr;
> > +                       if (addr == dest)
> > +                               continue;
> > +                       dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
> > +               }
> > +       }
> > +
> > +       /* run dependent operations */
> > +       dma_run_dependencies(tx);
> 
> Here is where we run into problems if another engine accesses these
> same buffers, especially on ARM v6+.
Do you mean in dma_run_dependencies() will occur to the async_tx descriptor of fsl-dma will be processed? I'm not clearly.


> 
> > +}
> > +
> > +static void talitos_release_xor(struct device *dev, struct
> talitos_desc *hwdesc,
> > +                               void *context, int error)
> > +{
> > +       struct talitos_xor_desc *desc = context;
> > +       struct talitos_xor_chan *xor_chan;
> > +       dma_async_tx_callback callback;
> > +       void *callback_param;
> > +
> > +       if (unlikely(error))
> > +               dev_err(dev, "xor operation: talitos error %d\n",
> error);
> > +
> > +       xor_chan = container_of(desc->async_tx.chan, struct
> talitos_xor_chan,
> > +                               common);
> > +       spin_lock_bh(&xor_chan->desc_lock);
> > +       if (xor_chan->completed_cookie < desc->async_tx.cookie)
> > +               xor_chan->completed_cookie = desc->async_tx.cookie;
> > +
> 
> Use dma_cookie_complete().
Ok, I will correct it.

> 
> > +       callback = desc->async_tx.callback;
> > +       callback_param = desc->async_tx.callback_param;
> > +
> > +       if (callback) {
> > +               spin_unlock_bh(&xor_chan->desc_lock);
> > +               callback(callback_param);
> > +               spin_lock_bh(&xor_chan->desc_lock);
> 
> As mentioned you'll either need to ensure that
> talitos_process_pending() is only called from the tasklet, or upgrade
> these locks to hardirq safe.
The point is flush_channel can be called both of interrupt and tasklet.
So the process should be redesigned that make sure talitos_process_pending() is only called from tasklet. I will fix it in next series.
Thanks.

> 
> > +       }
> > +
> > +       talitos_xor_run_tx_complete_actions(desc, xor_chan);
> > +
> > +       list_del(&desc->node);
> > +       list_add_tail(&desc->node, &xor_chan->free_desc);
> > +       spin_unlock_bh(&xor_chan->desc_lock);
> > +       if (!list_empty(&xor_chan->pending_q))
> > +               talitos_process_pending(xor_chan);
> > +}
> > +
> > +/**
> > + * talitos_issue_pending - move the descriptors in submit
> > + * queue to pending queue and submit them for processing
> > + * @chan: DMA channel
> > + */
> > +static void talitos_issue_pending(struct dma_chan *chan)
> > +{
> > +       struct talitos_xor_chan *xor_chan;
> > +
> > +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> > +       spin_lock_bh(&xor_chan->desc_lock);
> > +       list_splice_tail_init(&xor_chan->submit_q,
> > +                                &xor_chan->pending_q);
> > +       spin_unlock_bh(&xor_chan->desc_lock);
> > +       talitos_process_pending(xor_chan);
> > +}
> > +
> > +static dma_cookie_t talitos_async_tx_submit(struct
> dma_async_tx_descriptor *tx)
> > +{
> > +       struct talitos_xor_desc *desc;
> > +       struct talitos_xor_chan *xor_chan;
> > +       dma_cookie_t cookie;
> > +
> > +       desc = container_of(tx, struct talitos_xor_desc, async_tx);
> > +       xor_chan = container_of(tx->chan, struct talitos_xor_chan,
> common);
> > +
> > +       spin_lock_bh(&xor_chan->desc_lock);
> > +
> > +       cookie = xor_chan->common.cookie + 1;
> > +       if (cookie < 0)
> > +               cookie = 1;
> 
> Should use the new dma_cookie_assign() helper.
Ok.

> 
> > +
> > +       desc->async_tx.cookie = cookie;
> > +       xor_chan->common.cookie = desc->async_tx.cookie;
> > +
> > +       list_splice_tail_init(&desc->tx_list,
> > +                                &xor_chan->submit_q);
> > +
> > +       spin_unlock_bh(&xor_chan->desc_lock);
> > +
> > +       return cookie;
> > +}
> > +
> > +static struct talitos_xor_desc *talitos_xor_alloc_descriptor(
> > +                               struct talitos_xor_chan *xor_chan,
> gfp_t flags)
> > +{
> > +       struct talitos_xor_desc *desc;
> > +
> > +       desc = kmalloc(sizeof(*desc), flags);
> > +       if (desc) {
> > +               xor_chan->total_desc++;
> > +               desc->async_tx.tx_submit = talitos_async_tx_submit;
> > +       }
> > +
> > +       return desc;
> > +}
> > +
> [..]
I will remove this line.

> > +
> > +static struct dma_async_tx_descriptor *talitos_prep_dma_xor(
> > +                       struct dma_chan *chan, dma_addr_t dest,
> dma_addr_t *src,
> > +                       unsigned int src_cnt, size_t len, unsigned long
> flags)
> > +{
> > +       struct talitos_xor_chan *xor_chan;
> > +       struct talitos_xor_desc *new;
> > +       struct talitos_desc *desc;
> > +       int i, j;
> > +
> > +       BUG_ON(len > TALITOS_MAX_DATA_LEN);
> > +
> > +       xor_chan = container_of(chan, struct talitos_xor_chan, common);
> > +
> > +       spin_lock_bh(&xor_chan->desc_lock);
> > +       if (!list_empty(&xor_chan->free_desc)) {
> > +               new = container_of(xor_chan->free_desc.next,
> > +                                  struct talitos_xor_desc, node);
> > +               list_del(&new->node);
> > +       } else {
> > +                new = talitos_xor_alloc_descriptor(xor_chan,
> GFP_KERNEL | GFP_DMA);
> 
> You can't hold a spin_lock over a GFP_KERNEL allocation.
Ok, I will fix it in next.

> 
> > +       }
> > +       spin_unlock_bh(&xor_chan->desc_lock);
> > +
> > +       if (!new) {
> > +               dev_err(xor_chan->common.device->dev,
> > +                       "No free memory for XOR DMA descriptor\n");
> > +               return NULL;
> > +       }
> > +       dma_async_tx_descriptor_init(&new->async_tx, &xor_chan->common);
> > +
> > +       INIT_LIST_HEAD(&new->node);
> > +       INIT_LIST_HEAD(&new->tx_list);
> > +
> > +       desc = &new->hwdesc;
> > +       /* Set destination: Last pointer pair */
> > +       to_talitos_ptr(&desc->ptr[6], dest);
> > +       desc->ptr[6].len = cpu_to_be16(len);
> > +       desc->ptr[6].j_extent = 0;
> > +       new->unmap_src_cnt = src_cnt;
> > +       new->unmap_len = len;
> > +
> > +       /* Set Sources: End loading from second-last pointer pair */
> > +       for (i = 5, j = 0; j < src_cnt && i >= 0; i--, j++) {
> > +               to_talitos_ptr(&desc->ptr[i], src[j]);
> > +               desc->ptr[i].len = cpu_to_be16(len);
> > +               desc->ptr[i].j_extent = 0;
> > +       }
> > +
> > +       /*
> > +        * documentation states first 0 ptr/len combo marks end of
> sources
> > +        * yet device produces scatter boundary error unless all
> subsequent
> > +        * sources are zeroed out
> > +        */
> > +       for (; i >= 0; i--) {
> > +               to_talitos_ptr(&desc->ptr[i], 0);
> > +               desc->ptr[i].len = 0;
> > +               desc->ptr[i].j_extent = 0;
> > +       }
> > +
> > +       desc->hdr = DESC_HDR_SEL0_AESU | DESC_HDR_MODE0_AESU_XOR |
> > +               DESC_HDR_TYPE_RAID_XOR;
> > +
> > +       new->async_tx.parent = NULL;
> > +       new->async_tx.next = NULL;
> > +       new->async_tx.cookie = 0;
> > +       async_tx_ack(&new->async_tx);
> > +
> > +       list_add_tail(&new->node, &new->tx_list);
> > +
> > +       new->async_tx.flags = flags;
> > +       new->async_tx.cookie = -EBUSY;
> > +
> > +       return &new->async_tx;
> > +}
> > +
> > +static void talitos_unregister_async_xor(struct device *dev)
> > +{
> > +       struct talitos_private *priv = dev_get_drvdata(dev);
> > +       struct talitos_xor_chan *xor_chan;
> > +       struct dma_chan *chan, *_chan;
> > +
> > +       if (priv->dma_dev_common.chancnt)
> > +               dma_async_device_unregister(&priv->dma_dev_common);
> > +
> > +       list_for_each_entry_safe(chan, _chan, &priv-
> >dma_dev_common.channels,
> > +                               device_node) {
> > +               xor_chan = container_of(chan, struct talitos_xor_chan,
> > +                                       common);
> > +               list_del(&chan->device_node);
> > +               priv->dma_dev_common.chancnt--;
> > +               kfree(xor_chan);
> > +       }
> > +}
> > +
> > +/**
> > + * talitos_register_dma_async - Initialize the Freescale XOR ADMA
> device
> > + * It is registered as a DMA device with the capability to perform
> > + * XOR operation with the Async_tx layer.
> > + * The various queues and channel resources are also allocated.
> > + */
> > +static int talitos_register_async_tx(struct device *dev, int
> max_xor_srcs)
> > +{
> > +       struct talitos_private *priv = dev_get_drvdata(dev);
> > +       struct dma_device *dma_dev = &priv->dma_dev_common;
> > +       struct talitos_xor_chan *xor_chan;
> > +       int err;
> > +
> > +       xor_chan = kzalloc(sizeof(struct talitos_xor_chan), GFP_KERNEL);
> > +       if (!xor_chan) {
> > +               dev_err(dev, "unable to allocate xor channel\n");
> > +               return -ENOMEM;
> > +       }
> > +
> > +       dma_dev->dev = dev;
> > +       dma_dev->device_alloc_chan_resources =
> talitos_alloc_chan_resources;
> > +       dma_dev->device_free_chan_resources =
> talitos_free_chan_resources;
> > +       dma_dev->device_prep_dma_xor = talitos_prep_dma_xor;
> > +       dma_dev->max_xor = max_xor_srcs;
> > +       dma_dev->device_tx_status = talitos_is_tx_complete;
> > +       dma_dev->device_issue_pending = talitos_issue_pending;
> > +       INIT_LIST_HEAD(&dma_dev->channels);
> > +       dma_cap_set(DMA_XOR, dma_dev->cap_mask);
> > +
> > +       xor_chan->dev = dev;
> > +       xor_chan->common.device = dma_dev;
> > +       xor_chan->total_desc = 0;
> > +       INIT_LIST_HEAD(&xor_chan->submit_q);
> > +       INIT_LIST_HEAD(&xor_chan->pending_q);
> > +       INIT_LIST_HEAD(&xor_chan->in_progress_q);
> > +       INIT_LIST_HEAD(&xor_chan->free_desc);
> > +       spin_lock_init(&xor_chan->desc_lock);
> > +
> > +       list_add_tail(&xor_chan->common.device_node, &dma_dev-
> >channels);
> > +       dma_dev->chancnt++;
> > +
> > +       err = dma_async_device_register(dma_dev);
> > +       if (err) {
> > +               dev_err(dev, "Unable to register XOR with Async_tx\n");
> > +               goto err_out;
> > +       }
> > +
> > +       return err;
> > +
> > +err_out:
> > +       talitos_unregister_async_xor(dev);
> > +       return err;
> > +}
> > +#endif
> > +
> >  /*
> >   * crypto alg
> >   */
> > @@ -2891,6 +3284,26 @@ static int talitos_probe(struct platform_device
> *ofdev)
> >                         dev_info(dev, "hwrng\n");
> >         }
> >
> > +#ifdef CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR
> 
> Kill these ifdefs in the C file.  Do something like: if
> (xor_enabled()) { } around the code sections that are optional so you
> always get compile coverage.  Where xor_enabled() is a shorter form of
> IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS_RAIDXOR).
I'm confused how to implement this interface,
First, this feature should be added in Kconfig (default N)
Second, the only judge condition is SEC version, but some time we don't want involve function XOR even though the SEC (version is not higher than 3.0, SEC 4.0 is CAAM module) support this feature.
Last, there is not any hardware support.
Can you give me an example? Thanks.



