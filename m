Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab2H3OXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 10:23:39 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:16057
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab2H3OXg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 10:23:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Izz1202hzz8275ch8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220hbe9i1155h)
From: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
To: Liu Qiang-B32616 <B32616@freescale.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: Li Yang-R58472 <r58472@freescale.com>,
        Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
Thread-Topic: [PATCH v7 1/8] Talitos: Support for async_tx XOR offload
Thread-Index: AQHNdguqCb6kg8ccq0eFzI8Qh3DpXZdyVvuw
Date: Thu, 30 Aug 2012 14:23:29 +0000
Message-ID: <FD18E5D573A8AB48A365D4D78185DE992E5C0D@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1344500448-10927-1-git-send-email-qiang.liu@freescale.com>
In-Reply-To: <1344500448-10927-1-git-send-email-qiang.liu@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.171.73.48]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012 11:20:48 +0300, qiang.liu@freescale.com wrote:
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


> +static void talitos_xor_run_tx_complete_actions(struct talitos_xor_desc *desc,
> +		struct talitos_xor_chan *xor_chan)
> +{
> +	struct device *dev = xor_chan->dev;
> +	dma_addr_t dest, addr;
> +	unsigned int src_cnt = desc->unmap_src_cnt;
> +	unsigned int len = desc->unmap_len;
> +	enum dma_ctrl_flags flags = desc->async_tx.flags;
> +	struct dma_async_tx_descriptor *tx = &desc->async_tx;
> +
> +	/* unmap dma addresses */
> +	dest = desc->hwdesc.ptr[6].ptr;
> +	if (likely(!(flags & DMA_COMPL_SKIP_DEST_UNMAP)))
> +		dma_unmap_page(dev, dest, len, DMA_BIDIRECTIONAL);
> +
> +	desc->idx = 6 - src_cnt;
> +	if (likely(!(flags & DMA_COMPL_SKIP_SRC_UNMAP))) {
> +		while(desc->idx < 6) {
> +			addr = desc->hwdesc.ptr[desc->idx++].ptr;
> +			if (addr == dest)
> +				continue;
> +			dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
> +		}
> +	}

No need for braces around the while block.

> +	/* run dependent operations */
> +	dma_run_dependencies(tx);
> +}


> +static void talitos_release_xor(struct device *dev, struct talitos_desc *hwdesc,
> +				void *context, int error)
> +{
> +	struct talitos_xor_desc *desc = context;
> +	struct talitos_xor_chan *xor_chan;
> +	dma_async_tx_callback callback;
> +	void *callback_param;
> +
> +	if (unlikely(error))
> +		dev_err(dev, "xor operation: talitos error %d\n", error);
> +
> +	xor_chan = container_of(desc->async_tx.chan, struct talitos_xor_chan,
> +				common);
> +	spin_lock_bh(&xor_chan->desc_lock);
> +	if (xor_chan->completed_cookie < desc->async_tx.cookie)
> +		xor_chan->completed_cookie = desc->async_tx.cookie;
> +
> +	callback = desc->async_tx.callback;
> +	callback_param = desc->async_tx.callback_param;
> +
> +	if (callback) {
> +		spin_unlock_bh(&xor_chan->desc_lock);
> +		callback(callback_param);
> +		spin_lock_bh(&xor_chan->desc_lock);
> +	}

Since callback_param is used only here, maybe:

if (callback) {
	void *callback_param = desc->async_tx.callback_param;

	spin_unlock_bh(&xor_chan->desc_lock);
	callback(callback_param);
	spin_lock_bh(&xor_chan->desc_lock);
}

> +
> +	talitos_xor_run_tx_complete_actions(desc, xor_chan);
> +
> +	list_del(&desc->node);
> +	list_add_tail(&desc->node, &xor_chan->free_desc);
> +	spin_unlock_bh(&xor_chan->desc_lock);
> +	if (!list_empty(&xor_chan->pending_q))
> +		talitos_process_pending(xor_chan);
> +}


> +static int talitos_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	struct talitos_xor_chan *xor_chan;
> +	struct talitos_xor_desc *desc;
> +	LIST_HEAD(tmp_list);
> +	int i;
> +
> +	xor_chan = container_of(chan, struct talitos_xor_chan, common);
> +
> +	if (!list_empty(&xor_chan->free_desc))
> +		return xor_chan->total_desc;
> +
> +	for (i = 0; i < TALITOS_MAX_DESCRIPTOR_NR; i++) {
> +		desc = talitos_xor_alloc_descriptor(xor_chan,
> +				GFP_KERNEL | GFP_DMA);

talitos_xor_alloc_descriptor() is called here without holding
the xor_chan->desc_lock and it increments xor_chan->total_desc.
Isn't this an issue ?

> +		if (!desc) {
> +			dev_err(xor_chan->common.device->dev,
> +				"Only %d initial descriptors\n", i);
> +			break;
> +		}
> +		list_add_tail(&desc->node, &tmp_list);
> +	}
> +
> +	if (!i)
> +		return -ENOMEM;
> +
> +	/* At least one desc is allocated */
> +	spin_lock_bh(&xor_chan->desc_lock);
> +	list_splice_init(&tmp_list, &xor_chan->free_desc);
> +	spin_unlock_bh(&xor_chan->desc_lock);
> +
> +	return xor_chan->total_desc;
> +}


> +/**
> + * talitos_register_dma_async - Initialize the Freescale XOR ADMA device
> + * It is registered as a DMA device with the capability to perform
> + * XOR operation with the Async_tx layer.
> + * The various queues and channel resources are also allocated.
> + */
> +static int talitos_register_async_tx(struct device *dev, int max_xor_srcs)
> +{
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +	struct dma_device *dma_dev = &priv->dma_dev_common;
> +	struct talitos_xor_chan *xor_chan;
> +	int err;
> +
> +	xor_chan = kzalloc(sizeof(struct talitos_xor_chan), GFP_KERNEL);
> +	if (!xor_chan) {
> +		dev_err(dev, "unable to allocate xor channel\n");
> +		return -ENOMEM;
> +	}
> +
> +	dma_dev->dev = dev;
> +	dma_dev->device_alloc_chan_resources = talitos_alloc_chan_resources;
> +	dma_dev->device_free_chan_resources = talitos_free_chan_resources;
> +	dma_dev->device_prep_dma_xor = talitos_prep_dma_xor;
> +	dma_dev->max_xor = max_xor_srcs;
> +	dma_dev->device_tx_status = talitos_is_tx_complete;
> +	dma_dev->device_issue_pending = talitos_issue_pending;
> +	INIT_LIST_HEAD(&dma_dev->channels);
> +	dma_cap_set(DMA_XOR, dma_dev->cap_mask);
> +
> +	xor_chan->dev = dev;
> +	xor_chan->common.device = dma_dev;
> +	xor_chan->total_desc = 0;
> +	INIT_LIST_HEAD(&xor_chan->submit_q);
> +	INIT_LIST_HEAD(&xor_chan->pending_q);
> +	INIT_LIST_HEAD(&xor_chan->in_progress_q);
> +	INIT_LIST_HEAD(&xor_chan->free_desc);
> +	spin_lock_init(&xor_chan->desc_lock);
> +
> +	list_add_tail(&xor_chan->common.device_node, &dma_dev->channels);
> +	dma_dev->chancnt++;
> +
> +	err = dma_async_device_register(dma_dev);
> +	if (err) {
> +		dev_err(dev, "Unable to register XOR with Async_tx\n");
> +		goto err_out;

Replace the jump with talitos_unregister_async_xor(dev) and
remove code under err_out label.

> +	}
> +
> +	return err;
> +
> +err_out:
> +	talitos_unregister_async_xor(dev);
> +	return err;
> +}
> +#endif


> diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
> index 61a1405..fc9d125 100644
> --- a/drivers/crypto/talitos.h
> +++ b/drivers/crypto/talitos.h
> @@ -30,6 +30,7 @@
> 
>  #define TALITOS_TIMEOUT 100000
>  #define TALITOS_MAX_DATA_LEN 65535
> +#define TALITOS_MAX_DESCRIPTOR_NR 256

This refers only to xor descriptors, so renaming it similar to
TALITOS_MAX_XOR_DESCRIPTOR_NR would make sense.

Besides these:
1. As Dan Williams mentioned, you should explain why you are using
both spin_lock_bh and spin_lock_irqsave on the same lock.
2. I don't see anything added to talitos_remove(). Shouldn't
talitos_unregister_async_xor() be called? Anything else?
Have you tested with talitos built as a module?

Horia

