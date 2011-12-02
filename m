Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab1LBXHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:07:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:52603 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab1LBXHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:07:24 -0500
Message-ID: <1322867228.11728.19.camel@pasglop>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Date: Sat, 03 Dec 2011 10:07:08 +1100
In-Reply-To: <1322661299-28855-2-git-send-email-pbonzini@redhat.com>
References: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>
	 <1322661299-28855-2-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 14:54 +0100, Paolo Bonzini wrote:
> The virtio-scsi HBA is the basis of an alternative storage stack
> for QEMU-based virtual machines (including KVM).  Compared to
> virtio-blk it is more scalable, because it supports many LUNs
> on a single PCI slot), more powerful (it more easily supports
> passthrough of host devices to the guest) and more easily
> extensible (new SCSI features implemented by QEMU should not
> require updating the driver in the guest).

So apologies in advance if I missed something here but it looks to me
like you are hard wiring the various parameters such as max transfer
size, command size, number of segments, etc...  (basically the queue
limits).

The max transfer size especially is the real nasty one.

This is typically the one thing you should -really- obtain from the
other side. This is the number one reason why we cannot today reliably
emulate a SCSI controller in qemu -and- pass-through the SCSI commands
to the host /dev/sg or equivalent (only full device emulation is
reliable).

This is also typically what something like virtio-scsi allows us to fix,
so let's fix it. IE. we have the ability to query the "limits" of the
real HBA /  transport on the host side and to pass them along to the
guest, which enables us to do real pass-through.

In fact, spapr-vscsi (IBM pSeries vscsi) does provide the max req side
(though currently we lack the ability to query it from the kernel on the
qemu side but that's an orthogonal problem. There are ways to do it,
more or less buggy, but we can fix that).

So I very strongly suggest that you get the protocol right -now- and
make sure it carries those informations (even if the qemu side initially
only supports emulation and hard codes the queue limits, we can fix that
later and be backward compatible with older guests).

Ben.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/Kconfig       |    8 +
>  drivers/scsi/Makefile      |    1 +
>  drivers/scsi/virtio_scsi.c |  478 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/virtio_ids.h |    1 +
>  4 files changed, 488 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/virtio_scsi.c
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 06ea3bc..3ab6ad7 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1902,6 +1902,14 @@ config SCSI_BFA_FC
>  	  To compile this driver as a module, choose M here. The module will
>  	  be called bfa.
>  
> +config SCSI_VIRTIO
> +	tristate "virtio-scsi support (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL && VIRTIO
> +	help
> +          This is the virtual HBA driver for virtio.  It can be used with
> +          QEMU based VMMs (like KVM or Xen).  Say Y or M.
> +
> +
>  endif # SCSI_LOWLEVEL
>  
>  source "drivers/scsi/pcmcia/Kconfig"
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 2b88749..351b28b 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -141,6 +141,7 @@ obj-$(CONFIG_SCSI_CXGB4_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgbi/
>  obj-$(CONFIG_SCSI_BNX2_ISCSI)	+= libiscsi.o bnx2i/
>  obj-$(CONFIG_BE2ISCSI)		+= libiscsi.o be2iscsi/
>  obj-$(CONFIG_SCSI_PMCRAID)	+= pmcraid.o
> +obj-$(CONFIG_SCSI_VIRTIO)	+= virtio_scsi.o
>  obj-$(CONFIG_VMWARE_PVSCSI)	+= vmw_pvscsi.o
>  
>  obj-$(CONFIG_ARM)		+= arm/
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> new file mode 100644
> index 0000000..cf8732f
> --- /dev/null
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -0,0 +1,478 @@
> +/*
> + * Virtio SCSI HBA driver
> + *
> + * Copyright IBM Corp. 2010
> + * Copyright Red Hat, Inc. 2011
> + *
> + * Authors:
> + *  Stefan Hajnoczi   <stefanha@linux.vnet.ibm.com>
> + *  Paolo Bonzini   <pbonzini@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/virtio.h>
> +#include <linux/virtio_ids.h>
> +#include <linux/virtio_config.h>
> +#include <linux/virtio_scsi.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_cmnd.h>
> +
> +#define VIRTIO_SCSI_DEBUG 0
> +
> +static void dbg(const char *fmt, ...)
> +{
> +	if (VIRTIO_SCSI_DEBUG) {
> +		va_list args;
> +
> +		va_start(args, fmt);
> +		vprintk(fmt, args);
> +		va_end(args);
> +	}
> +}
> +
> +/* Command queue element */
> +struct virtio_scsi_cmd {
> +	struct scsi_cmnd *sc;
> +	union {
> +		struct virtio_scsi_cmd_req       cmd;
> +		struct virtio_scsi_ctrl_tmf_req  tmf;
> +		struct virtio_scsi_ctrl_an_req   an;
> +	} req;
> +	union {
> +		struct virtio_scsi_cmd_resp      cmd;
> +		struct virtio_scsi_ctrl_tmf_resp tmf;
> +		struct virtio_scsi_ctrl_an_resp  an;
> +		struct virtio_scsi_event         evt;
> +	} resp;
> +} ____cacheline_aligned_in_smp;
> +
> +/* Driver instance state */
> +struct virtio_scsi {
> +	/* Protects cmd_vq and sg[] */
> +	spinlock_t cmd_vq_lock;
> +
> +	struct virtio_device *vdev;
> +	struct virtqueue *ctrl_vq;
> +	struct virtqueue *event_vq;
> +	struct virtqueue *cmd_vq;
> +
> +	/* For sglist construction when adding commands to the virtqueue.  */
> +	struct scatterlist sg[];
> +};
> +
> +static struct kmem_cache *virtscsi_cmd_cache;
> +
> +static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
> +{
> +	return vdev->priv;
> +}
> +
> +static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
> +{
> +	if (!resid)
> +		return;
> +
> +	if (!scsi_bidi_cmnd(sc)) {
> +		scsi_set_resid(sc, resid);
> +		return;
> +	}
> +
> +	scsi_in(sc)->resid = min(resid, scsi_in(sc)->length);
> +	scsi_out(sc)->resid = resid - scsi_in(sc)->resid;
> +}
> +
> +/**
> + * virtscsi_complete_cmd - finish a scsi_cmd and invoke scsi_done
> + *
> + * Called with cmd_vq_lock held.
> + */
> +static void virtscsi_complete_cmd(void *buf)
> +{
> +	struct virtio_scsi_cmd *cmd = buf;
> +	struct scsi_cmnd *sc = cmd->sc;
> +	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
> +
> +	dbg("%s %d:%d:%d:%d cmd %p status %#02x sense_len %u\n", __func__,
> +		sc->device->host->host_no, sc->device->id,
> +		sc->device->channel, sc->device->lun,
> +		sc, resp->status, resp->sense_len);
> +
> +	sc->result = resp->status;
> +	virtscsi_compute_resid(sc, resp->resid);
> +	switch (resp->response) {
> +	case VIRTIO_SCSI_S_OK:
> +		set_host_byte(sc, DID_OK);
> +		break;
> +	case VIRTIO_SCSI_S_UNDERRUN:
> +		set_host_byte(sc, DID_BAD_TARGET);
> +	case VIRTIO_SCSI_S_ABORTED:
> +		set_host_byte(sc, DID_ABORT);
> +		break;
> +	case VIRTIO_SCSI_S_BAD_TARGET:
> +		set_host_byte(sc, DID_BAD_TARGET);
> +		break;
> +	case VIRTIO_SCSI_S_RESET:
> +		set_host_byte(sc, DID_RESET);
> +		break;
> +	case VIRTIO_SCSI_S_TRANSPORT_FAILURE:
> +		set_host_byte(sc, DID_TRANSPORT_DISRUPTED);
> +		break;
> +	case VIRTIO_SCSI_S_TARGET_FAILURE:
> +		set_host_byte(sc, DID_TARGET_FAILURE);
> +		break;
> +	case VIRTIO_SCSI_S_NEXUS_FAILURE:
> +		set_host_byte(sc, DID_NEXUS_FAILURE);
> +		break;
> +	default:
> +		scmd_printk(KERN_DEBUG, sc, "Unknown comand response %d",
> +			    resp->response);
> +		/* fall through */
> +	case VIRTIO_SCSI_S_FAILURE:
> +		set_host_byte(sc, DID_ERROR);
> +		break;
> +	}
> +
> +	WARN_ON(resp->sense_len > VIRTIO_SCSI_SENSE_SIZE);
> +	if (sc->sense_buffer) {
> +		memcpy(sc->sense_buffer, resp->sense,
> +		       min_t(u32, resp->sense_len, VIRTIO_SCSI_SENSE_SIZE));
> +		if (resp->sense_len)
> +			set_driver_byte(sc, DRIVER_SENSE);
> +	}
> +
> +	kmem_cache_free(virtscsi_cmd_cache, cmd);
> +	sc->scsi_done(sc);
> +}
> +
> +static void virtscsi_vq_done(struct virtqueue *vq, void (*fn)(void *buf))
> +{
> +	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
> +	struct virtio_scsi *vscsi = shost_priv(sh);
> +	void *buf;
> +	unsigned long flags;
> +	unsigned int len;
> +
> +	spin_lock_irqsave(&vscsi->cmd_vq_lock, flags);
> +
> +	do {
> +		virtqueue_disable_cb(vq);
> +		while ((buf = virtqueue_get_buf(vq, &len)) != NULL) {
> +			fn(buf);
> +		}
> +	} while (!virtqueue_enable_cb(vq));
> +
> +	spin_unlock_irqrestore(&vscsi->cmd_vq_lock, flags);
> +}
> +
> +static void virtscsi_cmd_done(struct virtqueue *vq)
> +{
> +	virtscsi_vq_done(vq, virtscsi_complete_cmd);
> +};
> +
> +/* These are still stubs.  */
> +static void virtscsi_complete_free(void *buf)
> +{
> +	struct virtio_scsi_cmd *cmd = buf;
> +
> +	kmem_cache_free(virtscsi_cmd_cache, cmd);
> +}
> +
> +static void virtscsi_ctrl_done(struct virtqueue *vq)
> +{
> +	virtscsi_vq_done(vq, virtscsi_complete_free);
> +};
> +
> +static void virtscsi_event_done(struct virtqueue *vq)
> +{
> +	virtscsi_vq_done(vq, virtscsi_complete_free);
> +};
> +
> +/**
> + * virtscsi_map_cmd - map a scsi_cmd to a virtqueue scatterlist
> + * @vscsi	: virtio_scsi state
> + * @sc		: command to be mapped
> + * @cmd		: command structure
> + * @out_num	: number of read-only elements
> + * @in_num	: number of write-only elements
> + *
> + * Called with cmd_vq_lock held.
> + */
> +static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
> +			     struct scsi_data_buffer *sdb)
> +{
> +	struct sg_table *table = &sdb->table;
> +	struct scatterlist *sg_elem;
> +	unsigned int idx = *p_idx;
> +	int i;
> +
> +	for_each_sg(table->sgl, sg_elem, table->nents, i)
> +		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
> +
> +	*p_idx = idx;
> +}
> +
> +static void virtscsi_map_cmd(struct virtio_scsi *vscsi, struct virtqueue *vq,
> +			     struct virtio_scsi_cmd *cmd, unsigned *out_num,
> +			     unsigned *in_num)
> +{
> +	struct scsi_cmnd *sc = cmd->sc;
> +	struct scatterlist *sg = vscsi->sg;
> +	unsigned int idx = 0;
> +
> +	if (sc) {
> +		struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
> +		BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
> +
> +		/* TODO: check feature bit and fail if unsupported?  */
> +		BUG_ON(sc->sc_data_direction == DMA_BIDIRECTIONAL);
> +	}
> +
> +	/* Request header.  */
> +	sg_set_buf(&sg[idx++], &cmd->req.cmd, sizeof(cmd->req.cmd));
> +
> +	/* Data-out buffer.  */
> +	if (sc && sc->sc_data_direction != DMA_FROM_DEVICE)
> +		virtscsi_map_sgl(sg, &idx, scsi_out(sc));
> +
> +	*out_num = idx;
> +
> +	/* Response header.  */
> +	sg_set_buf(&sg[idx++], &cmd->resp, sizeof(cmd->resp));
> +
> +	/* Data-in buffer */
> +	if (sc && sc->sc_data_direction != DMA_TO_DEVICE)
> +		virtscsi_map_sgl(sg, &idx, scsi_in(sc));
> +
> +	*in_num = idx - *out_num;
> +}
> +
> +static int virtscsi_kick_cmd(struct virtio_scsi *vscsi, struct virtqueue *vq,
> +			     struct virtio_scsi_cmd *cmd)
> +{
> +	unsigned int out_num, in_num;
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&vscsi->cmd_vq_lock, flags);
> +
> +	virtscsi_map_cmd(vscsi, vq, cmd, &out_num, &in_num);
> +
> +	ret = virtqueue_add_buf(vq, vscsi->sg, out_num, in_num, cmd);
> +	if (ret >= 0)
> +		virtqueue_kick(vq);
> +
> +	spin_unlock_irqrestore(&vscsi->cmd_vq_lock, flags);
> +	return ret;
> +}
> +
> +static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> +{
> +	struct virtio_scsi *vscsi = shost_priv(sh);
> +	struct virtio_scsi_cmd *cmd;
> +	int ret;
> +
> +	dbg("%s %d:%d:%d:%d got cmd %p CDB: %#02x\n", __func__,
> +		sc->device->host->host_no, sc->device->id,
> +		sc->device->channel, sc->device->lun,
> +		sc, sc->cmnd[0]);
> +
> +	ret = SCSI_MLQUEUE_HOST_BUSY;
> +	cmd = kmem_cache_zalloc(virtscsi_cmd_cache, GFP_ATOMIC);
> +	if (!cmd)
> +		goto out;
> +
> +	cmd->sc = sc;
> +	cmd->req.cmd = (struct virtio_scsi_cmd_req){
> +		.lun[0] = 1,
> +		.lun[1] = sc->device->id,
> +		.lun[2] = (sc->device->lun >> 8) | 0x40,
> +		.lun[3] = sc->device->lun & 0xff,
> +		.tag = (__u64)sc,
> +		.task_attr = VIRTIO_SCSI_S_SIMPLE,
> +		.prio = 0,
> +		.crn = 0,
> +	};
> +
> +	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
> +	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
> +
> +	if (virtscsi_kick_cmd(vscsi, vscsi->cmd_vq, cmd) >= 0)
> +		ret = 0;
> +
> +out:
> +	return ret;
> +}
> +
> +static struct scsi_host_template virtscsi_host_template = {
> +	.module = THIS_MODULE,
> +	.name = "Virtio SCSI HBA",
> +	.proc_name = "virtio_scsi",
> +	.queuecommand = virtscsi_queuecommand,
> +	.this_id = -1,
> +
> +	.can_queue = 1024,
> +	.max_sectors = 0xFFFF,
> +	.dma_boundary = UINT_MAX,
> +	.use_clustering = ENABLE_CLUSTERING,
> +	.cmd_per_lun = 1,
> +};
> +
> +#define virtscsi_config_get(vdev, fld) \
> +	({ \
> +		typeof(((struct virtio_scsi_config *)0)->fld) __val; \
> +		vdev->config->get(vdev, \
> +				  offsetof(struct virtio_scsi_config, fld), \
> +				  &__val, sizeof(__val)); \
> +		__val; \
> +	})
> +
> +#define virtscsi_config_set(vdev, fld, val) \
> +	(void)({ \
> +		typeof(((struct virtio_scsi_config *)0)->fld) __val = (val); \
> +		vdev->config->set(vdev, \
> +				  offsetof(struct virtio_scsi_config, fld), \
> +				  &__val, sizeof(__val)); \
> +	})
> +
> +static int __devinit virtscsi_init(struct virtio_device *vdev, struct virtio_scsi *vscsi)
> +{
> +	int err;
> +	struct virtqueue *vqs[3];
> +	vq_callback_t *callbacks[] = {
> +		virtscsi_ctrl_done,
> +		virtscsi_event_done,
> +		virtscsi_cmd_done
> +	};
> +	const char *names[] = {
> +		"control",
> +		"event",
> +		"command"
> +	};
> +
> +	/* Discover virtqueues and write information to configuration.  */
> +	err = vdev->config->find_vqs(vdev, 3, vqs, callbacks, names);
> +	if (err)
> +		return err;
> +
> +	vscsi->ctrl_vq = vqs[0];
> +	vscsi->event_vq = vqs[1];
> +	vscsi->cmd_vq = vqs[2];
> +
> +	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
> +	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
> +	return 0;
> +}
> +
> +static int __devinit virtscsi_probe(struct virtio_device *vdev)
> +{
> +	struct Scsi_Host *shost;
> +	struct virtio_scsi *vscsi;
> +	int err;
> +	u32 sg_elems;
> +
> +	/* We need to know how many segments before we allocate.
> +         * We need an extra sg elements at head and tail.
> +	 */
> +	sg_elems = virtscsi_config_get(vdev, seg_max);
> +
> +	dbg(KERN_ALERT "virtio-scsi sg_elems %d", __func__, sg_elems);
> +
> +	/* Allocate memory and link the structs together.  */
> +        shost = scsi_host_alloc(&virtscsi_host_template,
> +		sizeof(*vscsi) + sizeof(vscsi->sg[0]) * (sg_elems + 2));
> +
> +	if (!shost)
> +		return -ENOMEM;
> +
> +	shost->sg_tablesize = sg_elems;
> +	vscsi = shost_priv(shost);
> +	vscsi->vdev = vdev;
> +	vdev->priv = shost;
> +
> +	/* Random initializations.  */
> +	spin_lock_init(&vscsi->cmd_vq_lock);
> +	sg_init_table(vscsi->sg, sg_elems + 2);
> +
> +	err = virtscsi_init(vdev, vscsi);
> +	if (err)
> +		goto virtio_init_failed;
> +
> +	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1;
> +	shost->max_id = virtscsi_config_get(vdev, max_target) + 1;
> +	shost->max_channel = 0;
> +	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
> +	err = scsi_add_host(shost, &vdev->dev);
> +	if (err)
> +		goto scsi_add_host_failed;
> +
> +	scsi_scan_host(shost);
> +
> +	return 0;
> +
> +scsi_add_host_failed:
> +	vdev->config->del_vqs(vdev);
> +virtio_init_failed:
> +	scsi_host_put(shost);
> +	return err;
> +}
> +
> +static void __devexit virtscsi_remove_vqs(struct virtio_device *vdev)
> +{
> +	/* Stop all the virtqueues. */
> +	vdev->config->reset(vdev);
> +
> +	vdev->config->del_vqs(vdev);
> +}
> +
> +static void __devexit virtscsi_remove(struct virtio_device *vdev)
> +{
> +	struct Scsi_Host *shost = virtio_scsi_host(vdev);
> +
> +	scsi_remove_host(shost);
> +
> +	virtscsi_remove_vqs(vdev);
> +	scsi_host_put(shost);
> +}
> +
> +static struct virtio_device_id id_table[] = {
> +	{ VIRTIO_ID_SCSI, VIRTIO_DEV_ANY_ID },
> +	{ 0 },
> +};
> +
> +static struct virtio_driver virtio_scsi_driver = {
> +	.driver.name = KBUILD_MODNAME,
> +	.driver.owner = THIS_MODULE,
> +	.id_table = id_table,
> +	.probe = virtscsi_probe,
> +	.remove = __devexit_p(virtscsi_remove),
> +};
> +
> +static int __init init(void)
> +{
> +	virtscsi_cmd_cache = KMEM_CACHE(virtio_scsi_cmd, 0);
> +	if (!virtscsi_cmd_cache) {
> +		printk(KERN_ERR "kmem_cache_create() for "
> +				"virtscsi_cmd_cache failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	return register_virtio_driver(&virtio_scsi_driver);
> +}
> +
> +static void __exit fini(void)
> +{
> +	unregister_virtio_driver(&virtio_scsi_driver);
> +	kmem_cache_destroy(virtscsi_cmd_cache);
> +}
> +module_init(init);
> +module_exit(fini);
> +
> +MODULE_DEVICE_TABLE(virtio, id_table);
> +MODULE_DESCRIPTION("Virtio SCSI HBA driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
> index 85bb0bb..fee54c4 100644
> --- a/include/linux/virtio_ids.h
> +++ b/include/linux/virtio_ids.h
> @@ -34,6 +34,7 @@
>  #define VIRTIO_ID_CONSOLE	3 /* virtio console */
>  #define VIRTIO_ID_RNG		4 /* virtio ring */
>  #define VIRTIO_ID_BALLOON	5 /* virtio balloon */
> +#define VIRTIO_ID_SCSI		7 /* virtio scsi */
>  #define VIRTIO_ID_9P		9 /* 9p virtio console */
>  
>  #endif /* _LINUX_VIRTIO_IDS_H */


