Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761087Ab2JaWsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:48:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39654 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760988Ab2JaWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:47:04 -0400
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjur@brendeland.net, dmitry.tarnyagin@stericsson.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Vikram ARV <vikram.arv@stericsson.com>
Subject: [RFC virtio-next 4/4] caif_virtio: Add CAIF over virtio
Date: Wed, 31 Oct 2012 23:46:54 +0100
Message-Id: <1351723614-4145-5-git-send-email-sjur@brendeland.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
References: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add the CAIF Virtio Link layer, used for communicating with a
modem over shared memory. Virtio is used as the transport mechanism.

In the TX direction the virtio rings are used in the normal fashion,
sending data in the available ring. But in the rx direction the
the we have flipped the direction of the virtio ring, and
implemented the virtio access-function similar to what is found
in vhost.c.

CAIF also uses the virtio configuration space for getting
configuration parameters such as headroom, tailroom etc.

Signed-off-by: Vikram ARV <vikram.arv@stericsson.com>
Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/net/caif/Kconfig        |    9 +
 drivers/net/caif/Makefile       |    3 +
 drivers/net/caif/caif_virtio.c  |  627 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_ids.h |    1 +
 4 files changed, 640 insertions(+)
 create mode 100644 drivers/net/caif/caif_virtio.c

diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index abf4d7a..a01f617 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -47,3 +47,12 @@ config CAIF_HSI
        The caif low level driver for CAIF over HSI.
        Be aware that if you enable this then you also need to
        enable a low-level HSI driver.
+
+config CAIF_VIRTIO
+       tristate "CAIF virtio transport driver"
+       default n
+       depends on CAIF
+       depends on REMOTEPROC
+       select VIRTIO
+       ---help---
+       The caif driver for CAIF over Virtio.
diff --git a/drivers/net/caif/Makefile b/drivers/net/caif/Makefile
index 91dff86..d9ee26a 100644
--- a/drivers/net/caif/Makefile
+++ b/drivers/net/caif/Makefile
@@ -13,3 +13,6 @@ obj-$(CONFIG_CAIF_SHM) += caif_shm.o
 
 # HSI interface
 obj-$(CONFIG_CAIF_HSI) += caif_hsi.o
+
+# Virtio interface
+obj-$(CONFIG_CAIF_VIRTIO) += caif_virtio.o
diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
new file mode 100644
index 0000000..e50940f
--- /dev/null
+++ b/drivers/net/caif/caif_virtio.c
@@ -0,0 +1,627 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Contact: Sjur Brendeland / sjur.brandeland@stericsson.com
+ * Authors: Vicram Arv / vikram.arv@stericsson.com,
+ *	    Dmitry Tarnyagin / dmitry.tarnyagin@stericsson.com
+ *	    Sjur Brendeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ":" fmt
+#include <linux/module.h>
+#include <linux/virtio.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+#include <linux/dma-mapping.h>
+#include <linux/netdevice.h>
+#include <linux/if_arp.h>
+#include <linux/spinlock.h>
+#include <net/caif/caif_dev.h>
+#include <linux/virtio_caif.h>
+#include "../drivers/virtio/vring.h"
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Vicram Arv <vikram.arv@stericsson.com>");
+MODULE_DESCRIPTION("Virtio CAIF Driver");
+
+/*
+ * struct cfv_info - Caif Virtio control structure
+ * @cfdev:	caif common header
+ * @vdev:	Associated virtio device
+ * @vq_rx:	rx/downlink virtqueue
+ * @vq_tx:	tx/uplink virtqueue
+ * @ndev:	associated netdevice
+ * @queued_tx:	number of buffers queued in the tx virtqueue
+ * @watermark_tx: indicates number of buffers the tx queue
+ *		should shrink to to unblock datapath
+ * @tx_lock:	protects vq_tx to allow concurrent senders
+ * @tx_hr:	transmit headroom
+ * @rx_hr:	receive headroom
+ * @tx_tr:	transmit tailroom
+ * @rx_tr:	receive tailroom
+ * @mtu:	transmit max size
+ * @mru:	receive max size
+ */
+struct cfv_info {
+	struct caif_dev_common cfdev;
+	struct virtio_device *vdev;
+	struct virtqueue *vq_rx;
+	struct virtqueue *vq_tx;
+	struct net_device *ndev;
+	unsigned int queued_tx;
+	unsigned int watermark_tx;
+	/* Protect access to vq_tx */
+	spinlock_t tx_lock;
+	/* Copied from Virtio config space */
+	u16 tx_hr;
+	u16 rx_hr;
+	u16 tx_tr;
+	u16 rx_tr;
+	u32 mtu;
+	u32 mru;
+};
+
+/*
+ * struct token_info - maintains Transmit buffer data handle
+ * @size:	size of transmit buffer
+ * @dma_handle: handle to allocated dma device memory area
+ * @vaddr:	virtual address mapping to allocated memory area
+ */
+struct token_info {
+	size_t size;
+	u8 *vaddr;
+	dma_addr_t dma_handle;
+};
+
+/* Default if virtio config space is unavailable */
+#define CFV_DEF_MTU_SIZE 4096
+#define CFV_DEF_HEADROOM 16
+#define CFV_DEF_TAILROOM 16
+
+/* Require IP header to be 4-byte aligned. */
+#define IP_HDR_ALIGN 4
+
+/*
+ * virtqueue_next_avail_desc - get the next available descriptor
+ * @_vq: the struct virtqueue we're talking about
+ * @head: index of the descriptor in the ring
+ *
+ * Look for the next available descriptor in the available ring.
+ * Return NULL if nothing new in the available.
+ */
+static struct vring_desc *virtqueue_next_avail_desc(struct virtqueue *_vq,
+						    int *head)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 avail_idx, hd, last_avail_idx = vq->last_avail_idx;
+
+	START_USE(vq);
+
+	if (unlikely(vq->broken))
+		goto err;
+
+	/* The barier secures observability of avail->idx after interrupt */
+	virtio_rmb(vq);
+
+	if (vq->last_avail_idx == vq->vring.avail->idx)
+		goto err;
+
+	avail_idx = vq->vring.avail->idx;
+	if (unlikely((u16)(avail_idx - last_avail_idx) > vq->vring.num)) {
+		BAD_RING(vq, "Avail index moved from %u to %u",
+			 last_avail_idx, avail_idx);
+		goto err;
+	}
+
+	/*
+	 * The barier secures observability of the ring content
+	 * after avail->idx update
+	 */
+	virtio_rmb(vq);
+
+	hd =  vq->vring.avail->ring[last_avail_idx & (vq->vring.num - 1)];
+	/* If their number is silly, that's an error. */
+	if (unlikely(hd >= vq->vring.num)) {
+		BAD_RING(vq, "Remote says index %d > %u is available",
+			 *head, vq->vring.num);
+		goto err;
+	}
+
+	END_USE(vq);
+	*head = hd;
+	return &vq->vring.desc[hd];
+err:
+	END_USE(vq);
+	*head = -1;
+	return NULL;
+}
+
+/*
+ * virtqueue_next_linked_desc - get next linked descriptor from the ring
+ * @_vq: the struct virtqueue we're talking about
+ * @desc: "current" descriptor
+ *
+ * Each buffer in the virtqueues is a chain of descriptors. This
+ * function returns the next descriptor in the chain,* or NULL if we're at
+ * the end.
+ *
+ * Side effect: the function increments vq->last_avail_idx if a non-linked
+ * descriptor is passed as &desc argument.
+ */
+static struct vring_desc *virtqueue_next_linked_desc(struct virtqueue *_vq,
+						     struct vring_desc *desc)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	unsigned int next;
+
+	START_USE(vq);
+
+	/* If this descriptor says it doesn't chain, we're done. */
+	if (!(desc->flags & VRING_DESC_F_NEXT))
+		goto no_next;
+
+	next = desc->next;
+	/* Make sure compiler knows to grab that: we don't want it changing! */
+	/* We will use the result as an index in an array, so most
+	 * architectures only need a compiler barrier here.
+	 */
+	read_barrier_depends();
+
+	if (unlikely(next >= vq->vring.num)) {
+		BAD_RING(vq, "Desc index is %u > %u\n", next, vq->vring.num);
+		goto err;
+	}
+
+	desc = &vq->vring.desc[next];
+
+	if (desc->flags & VRING_DESC_F_INDIRECT) {
+		pr_err("Indirect descriptor not supported\n");
+		goto err;
+	}
+
+	END_USE(vq);
+	return desc;
+no_next:
+	vq->last_avail_idx++;
+err:
+	END_USE(vq);
+	return NULL;
+}
+
+/*
+ * virtqueue_add_buf_to_used - release a used descriptor
+ * @_vq: the struct virtqueue we're talking about
+ * @head: index of the descriptor to be released
+ * @len: number of linked descriptors in a chain
+ *
+ * The function releases a used descriptor in a reversed ring
+ */
+static int virtqueue_add_buf_to_used(struct virtqueue *_vq,
+				     unsigned int head, int len)
+{
+	struct vring_virtqueue *vr_vq = to_vvq(_vq);
+	struct vring_used_elem	*used;
+	int used_idx, err = -EINVAL;
+
+	START_USE(vr_vq);
+
+	if (unlikely(vr_vq->broken))
+		goto err;
+
+	if (unlikely(head >= vr_vq->vring.num)) {
+		BAD_RING(vr_vq, "Invalid head index (%u) > max desc idx (%u) ",
+			 head, vr_vq->vring.num - 1);
+		goto err;
+	}
+
+	/*
+	 * The virtqueue contains a ring of used buffers.  Get a pointer to the
+	 * next entry in that used ring.
+	 */
+	used_idx = (vr_vq->vring.used->idx & (vr_vq->vring.num - 1));
+	used = &vr_vq->vring.used->ring[used_idx];
+	used->id = head;
+	used->len = len;
+
+	/* Make sure buffer is written before we update index. */
+	virtio_wmb(vr_vq);
+	++vr_vq->vring.used->idx;
+	err = 0;
+err:
+	END_USE(vr_vq);
+	return err;
+
+}
+
+/*
+ * virtqueue_next_desc - get next available or linked descriptor
+ * @_vq: the struct virtqueue we're talking about
+ * @desc: "current" descriptor.
+ * @head: on return it is filled by the descriptor index in case of
+ *	available descriptor was returned, or -1 in case of linked
+ *	descriptor.
+ *
+ * The function is to be used as an iterator through received descriptors.
+ */
+static struct vring_desc *virtqueue_next_desc(struct virtqueue *_vq,
+					      struct vring_desc *desc,
+					      int *head)
+{
+	struct vring_desc *next = virtqueue_next_linked_desc(_vq, desc);
+
+	if (next == NULL) {
+		virtqueue_add_buf_to_used(_vq, *head, 0);
+		/* tell the remote processor to recycle buffer */
+		virtqueue_kick(_vq);
+		next = virtqueue_next_avail_desc(_vq, head);
+	} 
+	return next;
+}
+
+/*
+ * This is invoked whenever the remote processor completed processing
+ * a TX msg we just sent it, and the buffer is put back to the used ring.
+ */
+static void cfv_release_used_buf(struct virtqueue *vq_tx)
+{
+	struct cfv_info *cfv = vq_tx->vdev->priv;
+
+	BUG_ON(vq_tx != cfv->vq_tx);
+
+	for (;;) {
+		unsigned int len;
+		struct token_info *buf_info;
+
+		/* Get used buffer from used ring to recycle used descriptors */
+		spin_lock_bh(&cfv->tx_lock);
+		buf_info = virtqueue_get_buf(vq_tx, &len);
+
+		if (!buf_info)
+			goto out;
+
+		BUG_ON(!cfv->queued_tx);
+		if (--cfv->queued_tx < cfv->watermark_tx) {
+			cfv->watermark_tx = 0;
+			netif_tx_wake_all_queues(cfv->ndev);
+		}
+		spin_unlock_bh(&cfv->tx_lock);
+
+		dma_free_coherent(vq_tx->vdev->dev.parent->parent,
+				  buf_info->size, buf_info->vaddr,
+				  buf_info->dma_handle);
+		kfree(buf_info);
+	}
+	return;
+out:
+	spin_unlock_bh(&cfv->tx_lock);
+}
+
+static int cfv_read_desc(struct vring_desc *d,
+			 void **buf, size_t *size)
+{
+	if (d->flags & VRING_DESC_F_INDIRECT) {
+		pr_warn("Indirect descriptor not supported by CAIF\n");
+		return -EINVAL;
+	}
+
+	if (!(d->flags & VRING_DESC_F_WRITE)) {
+		pr_warn("Write descriptor not supported by CAIF\n");
+		/* CAIF expects a input descriptor here */
+		return -EINVAL;
+	}
+	*buf = phys_to_virt(d->addr);
+	*size = d->len;
+	return 0;
+}
+
+static struct sk_buff *cfv_alloc_and_copy_skb(struct cfv_info *cfv,
+					      u8 *frm, u32 frm_len)
+{
+	struct sk_buff *skb;
+	u32 cfpkt_len, pad_len;
+
+	/* Verify that packet size with down-link header and mtu size */
+	if (frm_len > cfv->mru || frm_len <= cfv->rx_hr + cfv->rx_tr) {
+		netdev_err(cfv->ndev,
+			   "Invalid frmlen:%u  mtu:%u hr:%d tr:%d\n",
+			   frm_len, cfv->mru,  cfv->rx_hr,
+			   cfv->rx_tr);
+		return NULL;
+	}
+
+	cfpkt_len = frm_len - (cfv->rx_hr + cfv->rx_tr);
+
+	pad_len = (unsigned long)(frm + cfv->rx_hr) & (IP_HDR_ALIGN - 1);
+
+	skb = netdev_alloc_skb(cfv->ndev, frm_len + pad_len);
+	if (!skb)
+		return NULL;
+
+	/* Reserve space for headers. */
+	skb_reserve(skb, cfv->rx_hr + pad_len);
+
+	memcpy(skb_put(skb, cfpkt_len), frm + cfv->rx_hr, cfpkt_len);
+	return skb;
+}
+
+/*
+ * This is invoked whenever the remote processor has sent down-link data
+ * on the Rx VQ avail ring and it's time to digest a message.
+ *
+ * CAIF virtio passes a complete CAIF frame including head/tail room
+ * in each linked descriptor. So iterate over all available buffers
+ * in available-ring and the associated linked descriptors.
+ */
+static void cfv_recv(struct virtqueue *vq_rx)
+{
+	struct cfv_info *cfv = vq_rx->vdev->priv;
+	struct vring_desc *desc;
+	struct sk_buff *skb;
+	int head = -1;
+	void *buf;
+	size_t len;
+
+	for (desc = virtqueue_next_avail_desc(vq_rx, &head);
+	     desc != NULL && !cfv_read_desc(desc, &buf, &len);
+	     desc = virtqueue_next_desc(vq_rx, desc, &head)) {
+
+		skb = cfv_alloc_and_copy_skb(cfv, buf, len);
+
+		if (!skb)
+			goto err;
+
+		skb->protocol = htons(ETH_P_CAIF);
+		skb_reset_mac_header(skb);
+		skb->dev = cfv->ndev;
+
+		/* Push received packet up the stack. */
+		if (netif_receive_skb(skb))
+			goto err;
+
+		++cfv->ndev->stats.rx_packets;
+		cfv->ndev->stats.rx_bytes += skb->len;
+	}
+	return;
+err:
+	++cfv->ndev->stats.rx_dropped;
+	return;
+}
+
+static int cfv_netdev_open(struct net_device *netdev)
+{
+	netif_carrier_on(netdev);
+	return 0;
+}
+
+static int cfv_netdev_close(struct net_device *netdev)
+{
+	netif_carrier_off(netdev);
+	return 0;
+}
+
+static struct token_info *cfv_alloc_and_copy_to_dmabuf(struct cfv_info *cfv,
+						       struct sk_buff *skb,
+						       struct scatterlist *sg)
+{
+	struct caif_payload_info *info = (void *)&skb->cb;
+	struct token_info *buf_info = NULL;
+	u8 pad_len, hdr_ofs;
+
+	if (unlikely(cfv->tx_hr + skb->len + cfv->tx_tr > cfv->mtu)) {
+		netdev_warn(cfv->ndev, "Invalid packet len (%d > %d)\n",
+			    cfv->tx_hr + skb->len + cfv->tx_tr, cfv->mtu);
+		goto err;
+	}
+
+	buf_info = kmalloc(sizeof(struct token_info), GFP_ATOMIC);
+	if (unlikely(!buf_info))
+		goto err;
+
+	/* Make the IP header aligned in tbe buffer */
+	hdr_ofs = cfv->tx_hr + info->hdr_len;
+	pad_len = hdr_ofs & (IP_HDR_ALIGN - 1);
+	buf_info->size = cfv->tx_hr + skb->len + cfv->tx_tr + pad_len;
+
+	if (WARN_ON_ONCE(cfv->vdev->dev.parent))
+		goto err;
+
+	/* allocate coherent memory for the buffers */
+	buf_info->vaddr =
+		dma_alloc_coherent(cfv->vdev->dev.parent->parent,
+				   buf_info->size, &buf_info->dma_handle,
+				   GFP_ATOMIC);
+	if (unlikely(!buf_info->vaddr)) {
+		netdev_warn(cfv->ndev,
+			    "Out of DMA memory (alloc %zu bytes)\n",
+			    buf_info->size);
+		goto err;
+	}
+
+	/* copy skbuf contents to send buffer */
+	skb_copy_bits(skb, 0, buf_info->vaddr + cfv->tx_hr + pad_len, skb->len);
+	sg_init_one(sg, buf_info->vaddr + pad_len,
+		    skb->len + cfv->tx_hr + cfv->rx_hr);
+	return buf_info;
+err:
+	kfree(buf_info);
+	return NULL;
+}
+
+/*
+ * This is invoked whenever the host processor application has sent up-link data.
+ * Send it in the TX VQ avail ring.
+ *
+ * CAIF Virtio sends does not use linked descriptors in the tx direction.
+ */
+static int cfv_netdev_tx(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct cfv_info *cfv = netdev_priv(netdev);
+	struct token_info *buf_info;
+	struct scatterlist sg;
+	bool flow_off = false;
+
+	buf_info = cfv_alloc_and_copy_to_dmabuf(cfv, skb, &sg);
+	spin_lock_bh(&cfv->tx_lock);
+
+	/*
+	 * Add buffer to avail ring.
+	 * Note: in spite of a space check at beginning of the function,
+	 * the add_buff call might fail in case of concurrent access on smp
+	 * systems.
+	 */
+	if (WARN_ON(virtqueue_add_buf(cfv->vq_tx, &sg, 0, 1,
+				      buf_info, GFP_ATOMIC) < 0)) {
+		/* It should not happen */
+		++cfv->ndev->stats.tx_dropped;
+		flow_off = true;
+	} else {
+		/* update netdev statistics */
+		cfv->queued_tx++;
+		cfv->ndev->stats.tx_packets++;
+		cfv->ndev->stats.tx_bytes += skb->len;
+	}
+
+	/*
+	 * Flow-off check takes into account number of cpus to make sure
+	 * virtqueue will not be overfilled in any possible smp conditions.
+	 */
+	flow_off = cfv->queued_tx + num_present_cpus() >=
+		virtqueue_get_vring_size(cfv->vq_tx);
+
+	/* tell the remote processor it has a pending message to read */
+	virtqueue_kick(cfv->vq_tx);
+
+	if (flow_off) {
+		cfv->watermark_tx = cfv->queued_tx >> 1;
+		netif_tx_stop_all_queues(netdev);
+	}
+
+	spin_unlock_bh(&cfv->tx_lock);
+
+	dev_kfree_skb(skb);
+
+	/* Try to speculatively free used buffers */
+	if (flow_off)
+		cfv_release_used_buf(cfv->vq_tx);
+
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops cfv_netdev_ops = {
+	.ndo_open = cfv_netdev_open,
+	.ndo_stop = cfv_netdev_close,
+	.ndo_start_xmit = cfv_netdev_tx,
+};
+
+static void cfv_netdev_setup(struct net_device *netdev)
+{
+	netdev->netdev_ops = &cfv_netdev_ops;
+	netdev->type = ARPHRD_CAIF;
+	netdev->tx_queue_len = 100;
+	netdev->flags = IFF_POINTOPOINT | IFF_NOARP;
+	netdev->mtu = CFV_DEF_MTU_SIZE;
+	netdev->destructor = free_netdev;
+}
+
+#define GET_VIRTIO_CONFIG_OPS(_v, _var, _f) \
+	((_v)->config->get(_v, offsetof(struct virtio_caif_transf_config, _f), \
+			   &_var, \
+			   FIELD_SIZEOF(struct virtio_caif_transf_config, _f)))
+
+static int __devinit cfv_probe(struct virtio_device *vdev)
+{
+	vq_callback_t *vq_cbs[] = { cfv_recv, cfv_release_used_buf };
+	const char *names[] = { "input", "output" };
+	const char *cfv_netdev_name = "cfvrt";
+	struct net_device *netdev;
+	struct virtqueue *vqs[2];
+	struct cfv_info *cfv;
+	int err = 0;
+
+	netdev = alloc_netdev(sizeof(struct cfv_info), cfv_netdev_name,
+			      cfv_netdev_setup);
+	if (!netdev)
+		return -ENOMEM;
+
+	cfv = netdev_priv(netdev);
+	cfv->vdev = vdev;
+	cfv->ndev = netdev;
+
+	spin_lock_init(&cfv->tx_lock);
+
+	/* Get two virtqueues, for tx/ul and rx/dl */
+	err = vdev->config->find_vqs(vdev, 2, vqs, vq_cbs, names);
+	if (err)
+		goto free_cfv;
+
+	cfv->vq_rx = vqs[0];
+	cfv->vq_tx = vqs[1];
+
+	if (vdev->config->get) {
+		GET_VIRTIO_CONFIG_OPS(vdev, cfv->tx_hr, headroom);
+		GET_VIRTIO_CONFIG_OPS(vdev, cfv->rx_hr, headroom);
+		GET_VIRTIO_CONFIG_OPS(vdev, cfv->tx_tr, tailroom);
+		GET_VIRTIO_CONFIG_OPS(vdev, cfv->rx_tr, tailroom);
+		GET_VIRTIO_CONFIG_OPS(vdev, cfv->mtu, mtu);
+		GET_VIRTIO_CONFIG_OPS(vdev, cfv->mru, mtu);
+	} else {
+		cfv->tx_hr = CFV_DEF_HEADROOM;
+		cfv->rx_hr = CFV_DEF_HEADROOM;
+		cfv->tx_tr = CFV_DEF_TAILROOM;
+		cfv->rx_tr = CFV_DEF_TAILROOM;
+		cfv->mtu = CFV_DEF_MTU_SIZE;
+		cfv->mru = CFV_DEF_MTU_SIZE;
+
+	}
+
+	vdev->priv = cfv;
+
+	netif_carrier_off(netdev);
+
+	/* register Netdev */
+	err = register_netdev(netdev);
+	if (err) {
+		dev_err(&vdev->dev, "Unable to register netdev (%d)\n", err);
+		goto vqs_del;
+	}
+
+	/* tell the remote processor it can start sending messages */
+	virtqueue_kick(cfv->vq_rx);
+	return 0;
+
+vqs_del:
+	vdev->config->del_vqs(cfv->vdev);
+free_cfv:
+	free_netdev(netdev);
+	return err;
+}
+
+static void __devexit cfv_remove(struct virtio_device *vdev)
+{
+	struct cfv_info *cfv = vdev->priv;
+	vdev->config->reset(vdev);
+	vdev->config->del_vqs(cfv->vdev);
+	unregister_netdev(cfv->ndev);
+}
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_CAIF, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static unsigned int features[] = {
+};
+
+static struct virtio_driver caif_virtio_driver = {
+	.feature_table		= features,
+	.feature_table_size	= ARRAY_SIZE(features),
+	.driver.name		= KBUILD_MODNAME,
+	.driver.owner		= THIS_MODULE,
+	.id_table		= id_table,
+	.probe			= cfv_probe,
+	.remove			= cfv_remove,
+};
+
+module_driver(caif_virtio_driver, register_virtio_driver,
+	      unregister_virtio_driver);
+MODULE_DEVICE_TABLE(virtio, id_table);
diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index 270fb22..8ddad5a 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -37,5 +37,6 @@
 #define VIRTIO_ID_RPMSG		7 /* virtio remote processor messaging */
 #define VIRTIO_ID_SCSI		8 /* virtio scsi */
 #define VIRTIO_ID_9P		9 /* 9p virtio console */
+#define VIRTIO_ID_CAIF		12 /* virtio caif */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
1.7.9.5

