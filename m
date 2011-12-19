Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1LSMWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:22:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1LSMWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:22:35 -0500
Message-ID: <4EEF2C86.6010003@suse.de>
Date: Mon, 19 Dec 2011 13:22:30 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v3 1/2] virtio-scsi: first version
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com> <1324296188-3426-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1324296188-3426-2-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 01:03 PM, Paolo Bonzini wrote:
> The virtio-scsi HBA is the basis of an alternative storage stack
> for QEMU-based virtual machines (including KVM).  Compared to
> virtio-blk it is more scalable, because it supports many LUNs
> on a single PCI slot), more powerful (it more easily supports
> passthrough of host devices to the guest) and more easily
> extensible (new SCSI features implemented by QEMU should not
> require updating the driver in the guest).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>         v2->v3: added mempool, formatting fixes
> 
> 	v1->v2: use dbg_dev, sdev_printk, scmd_printk
>            - renamed lock to vq_lock
>            - renamed cmd_vq to req_vq (and other similar changes)
>            - fixed missing break in VIRTIO_SCSI_S_UNDERRUN
>            - added VIRTIO_SCSI_S_BUSY
>            - removed unused argument from virtscsi_map_cmd
>            - fixed two tabs that had slipped in
>            - moved max_sectors and cmd_per_lun from template to config space
>            - __attribute__((packed)) -> __packed
> 
>  drivers/scsi/Kconfig        |    8 +
>  drivers/scsi/Makefile       |    1 +
>  drivers/scsi/virtio_scsi.c  |  497 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/virtio_scsi.h |  112 +++++++++++
>  include/linux/virtio_ids.h  |    1 +
>  5 files changed, 519 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/virtio_scsi.c
>  create mode 100644 include/linux/virtio_scsi.h
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
> +          This is the virtual HBA driver for virtio.  If the kernel will
> +          be used in a virtual machine, say Y or M.
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
> @@ -0,0 +1,497 @@
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
> +#include <linux/mempool.h>
> +#include <linux/virtio.h>
> +#include <linux/virtio_ids.h>
> +#include <linux/virtio_config.h>
> +#include <linux/virtio_scsi.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_cmnd.h>
> +
> +#define VIRTIO_SCSI_MEMPOOL_SZ 64
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
> +	/* Protects ctrl_vq, req_vq and sg[] */
> +	spinlock_t vq_lock;
> +
> +	struct virtio_device *vdev;
> +	struct virtqueue *ctrl_vq;
> +	struct virtqueue *event_vq;
> +	struct virtqueue *req_vq;
> +
> +	/* For sglist construction when adding commands to the virtqueue.  */
> +	struct scatterlist sg[];
> +};
> +
> +static struct kmem_cache *virtscsi_cmd_cache;
> +static mempool_t *virtscsi_cmd_pool;
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
> + * Called with vq_lock held.
> + */
> +static void virtscsi_complete_cmd(void *buf)
> +{
> +	struct virtio_scsi_cmd *cmd = buf;
> +	struct scsi_cmnd *sc = cmd->sc;
> +	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
> +
> +	dev_dbg(&sc->device->sdev_gendev,
> +		"cmd %p response %u status %#02x sense_len %u\n",
> +		sc, resp->response, resp->status, resp->sense_len);
> +
> +	sc->result = resp->status;
> +	virtscsi_compute_resid(sc, resp->resid);
> +	switch (resp->response) {
> +	case VIRTIO_SCSI_S_OK:
> +		set_host_byte(sc, DID_OK);
> +		break;
> +	case VIRTIO_SCSI_S_UNDERRUN:
> +		set_host_byte(sc, DID_ERROR);
> +		break;
Hmm. Not sure this is correct.
UNDERRUN could be a valid state, eg it is quite common to send
an INQUIRY with a length of 255 bytes. And only evaluate the
bytes which are actually send back.
For those cases you'd be incurring an UNDERRUN, but it's not
actually an error, just sloppy programming.
So returning DID_ERROR here doesn't look correct.

But again, this would depend on the backend implementation.
At least it'll need a clarification in the spec under which
circumstances UNDERRUN should be set.

> +	case VIRTIO_SCSI_S_ABORTED:
> +		set_host_byte(sc, DID_ABORT);
> +		break;
> +	case VIRTIO_SCSI_S_BAD_TARGET:
> +		set_host_byte(sc, DID_BAD_TARGET);
> +		break;
> +	case VIRTIO_SCSI_S_RESET:
> +		set_host_byte(sc, DID_RESET);
> +		break;
> +	case VIRTIO_SCSI_S_BUSY:
> +		set_host_byte(sc, DID_BUS_BUSY);
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
> +		scmd_printk(KERN_WARNING, sc, "Unknown response %d",
> +			    resp->response);
> +		/* fall through */
> +	case VIRTIO_SCSI_S_FAILURE:
> +		set_host_byte(sc, DID_ERROR);
> +		break;
This is surely an odd coding style; normally is 'default' at the end...

And, it's not good style to match the same DID_XXX error code to
several internal errors. I would prefer having a 1:1 match for
VIRTIO_SCSI_S_XXX and DID_XXX error codes.
This will make debugging easier.

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
> +	mempool_free(cmd, virtscsi_cmd_pool);
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
> +	spin_lock_irqsave(&vscsi->vq_lock, flags);
> +
> +	do {
> +		virtqueue_disable_cb(vq);
> +		while ((buf = virtqueue_get_buf(vq, &len)) != NULL)
> +			fn(buf);
> +	} while (!virtqueue_enable_cb(vq));
> +
> +	spin_unlock_irqrestore(&vscsi->vq_lock, flags);
> +}
> +
> +static void virtscsi_req_done(struct virtqueue *vq)
> +{
> +	virtscsi_vq_done(vq, virtscsi_complete_cmd);
> +};
> +
> +/* These are still stubs.  */
> +static void virtscsi_complete_free(void *buf)
> +{
> +	struct virtio_scsi_cmd *cmd = buf;
> +
> +	mempool_free(cmd, virtscsi_cmd_pool);
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
> +/**
> + * virtscsi_map_cmd - map a scsi_cmd to a virtqueue scatterlist
> + * @vscsi	: virtio_scsi state
> + * @cmd		: command structure
> + * @out_num	: number of read-only elements
> + * @in_num	: number of write-only elements
> + *
> + * Called with vq_lock held.
> + */
> +static void virtscsi_map_cmd(struct virtio_scsi *vscsi,
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
> +	spin_lock_irqsave(&vscsi->vq_lock, flags);
> +
> +	virtscsi_map_cmd(vscsi, cmd, &out_num, &in_num);
> +
> +	ret = virtqueue_add_buf(vq, vscsi->sg, out_num, in_num, cmd);
> +	if (ret >= 0)
> +		virtqueue_kick(vq);
> +
> +	spin_unlock_irqrestore(&vscsi->vq_lock, flags);
> +	return ret;
> +}
> +
> +static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> +{
> +	struct virtio_scsi *vscsi = shost_priv(sh);
> +	struct virtio_scsi_cmd *cmd;
> +	int ret;
> +
> +	dev_dbg(&sc->device->sdev_gendev,
> +		"cmd %p CDB: %#02x\n", sc, sc->cmnd[0]);
> +
> +	ret = SCSI_MLQUEUE_HOST_BUSY;
> +	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_ATOMIC);
> +	if (!cmd)
> +		goto out;
> +
> +	memset(cmd, 0, sizeof(*cmd));
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
> +	if (virtscsi_kick_cmd(vscsi, vscsi->req_vq, cmd) >= 0)
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
> +	.dma_boundary = UINT_MAX,
> +	.use_clustering = ENABLE_CLUSTERING,
> +};
> +
Hmm. Apparently you support more than one LUN, yet no
->slave_alloc() callback is present. So how do you scan the bus here?

Do you actually have a working backend implementation?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
