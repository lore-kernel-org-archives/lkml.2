Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1LAIg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:36:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35121 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1LAIg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:36:56 -0500
Message-ID: <4ED73CA3.5080409@redhat.com>
Date: Thu, 01 Dec 2011 09:36:51 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Sasha Levin <levinsasha928@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
References: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>  <1322661299-28855-2-git-send-email-pbonzini@redhat.com> <1322721200.3651.24.camel@lappy>
In-Reply-To: <1322721200.3651.24.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 07:33 AM, Sasha Levin wrote:
> On Wed, 2011-11-30 at 14:54 +0100, Paolo Bonzini wrote:
>> The virtio-scsi HBA is the basis of an alternative storage stack
>> for QEMU-based virtual machines (including KVM).  Compared to
>> virtio-blk it is more scalable, because it supports many LUNs
>> on a single PCI slot), more powerful (it more easily supports
>> passthrough of host devices to the guest) and more easily
>> extensible (new SCSI features implemented by QEMU should not
>> require updating the driver in the guest).
>>
>> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
>> ---
>>   drivers/scsi/Kconfig       |    8 +
>>   drivers/scsi/Makefile      |    1 +
>>   drivers/scsi/virtio_scsi.c |  478 ++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/virtio_ids.h |    1 +
>    include/linux/virtio_scsi.h is missing here.
>
>>   4 files changed, 488 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/scsi/virtio_scsi.c
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 06ea3bc..3ab6ad7 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -1902,6 +1902,14 @@ config SCSI_BFA_FC
>>   	  To compile this driver as a module, choose M here. The module will
>>   	  be called bfa.
>>
>> +config SCSI_VIRTIO
>> +	tristate "virtio-scsi support (EXPERIMENTAL)"
>> +	depends on EXPERIMENTAL&&  VIRTIO
>> +	help
>> +          This is the virtual HBA driver for virtio.  It can be used with
>> +          QEMU based VMMs (like KVM or Xen).  Say Y or M.
>
> QEMU based? What about non-QEMU based? :)

You should first change VIRTIO_BLK. :)  (Just kidding, point taken).

>> +
>> +static void dbg(const char *fmt, ...)
>> +{
>> +	if (VIRTIO_SCSI_DEBUG) {
>> +		va_list args;
>> +
>> +		va_start(args, fmt);
>> +		vprintk(fmt, args);
>> +		va_end(args);
>> +	}
>> +}
>
> Or possibly switch from dbg() here to dev_dbg() which would let you use
> standard kernel interfaces to enable/disable debugging.

I changed to sdev_printk/scmd_printk everywhere.

>> +static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>> +{
>> +	struct virtio_scsi *vscsi = shost_priv(sh);
>> +	struct virtio_scsi_cmd *cmd;
>> +	int ret;
>> +
>> +	dbg("%s %d:%d:%d:%d got cmd %p CDB: %#02x\n", __func__,
>> +		sc->device->host->host_no, sc->device->id,
>> +		sc->device->channel, sc->device->lun,
>> +		sc, sc->cmnd[0]);
>> +
>> +	ret = SCSI_MLQUEUE_HOST_BUSY;
>> +	cmd = kmem_cache_zalloc(virtscsi_cmd_cache, GFP_ATOMIC);
>
> GFP_ATOMIC? Not GFP_KERNEL?

Done.

>> +static int __devinit virtscsi_init(struct virtio_device *vdev, struct virtio_scsi *vscsi)
>> +{
>> +	int err;
>> +	struct virtqueue *vqs[3];
>> +	vq_callback_t *callbacks[] = {
>> +		virtscsi_ctrl_done,
>> +		virtscsi_event_done,
>> +		virtscsi_cmd_done
>> +	};
>
> The spec is talking about multiple request vqs, while here they are
> limited to one. Is adding multiple request vqs really speeds things up?

The main advantage is having multiple MSI-X vectors.  It's quite common 
in physical HBAs.

> How was it tested without being supported by the driver?

The driver code was just a hack and not good for upstream.

>> +	const char *names[] = {
>> +		"control",
>> +		"event",
>> +		"command"
>
> The spec calls them "control", "event" and "request". We should keep the
> same names as the spec here and in variable names used int the code
> ('cmd_vq' should probably be 'req_vq' or something similar).

Will fix.  The lock is also protecting more than the req_vq.

>> +	};
>> +
>> +	/* Discover virtqueues and write information to configuration.  */
>> +	err = vdev->config->find_vqs(vdev, 3, vqs, callbacks, names);
>> +	if (err)
>> +		return err;
>> +
>> +	vscsi->ctrl_vq = vqs[0];
>> +	vscsi->event_vq = vqs[1];
>> +	vscsi->cmd_vq = vqs[2];
>> +
>> +	virtscsi_config_set(vdev, cdb_size, VIRTIO_SCSI_CDB_SIZE);
>> +	virtscsi_config_set(vdev, sense_size, VIRTIO_SCSI_SENSE_SIZE);
>> +	return 0;
>> +}
>> +
>> +static int __devinit virtscsi_probe(struct virtio_device *vdev)
>> +{
>> +	struct Scsi_Host *shost;
>> +	struct virtio_scsi *vscsi;
>> +	int err;
>> +	u32 sg_elems;
>> +
>> +	/* We need to know how many segments before we allocate.
>> +         * We need an extra sg elements at head and tail.
>> +	 */
>> +	sg_elems = virtscsi_config_get(vdev, seg_max);
>
> Maybe default to one if not specified (=0), like in virtio-blk.

Good idea.  Though with sg_elems=1 it is insanely slow.

>> +
>> +	dbg(KERN_ALERT "virtio-scsi sg_elems %d", __func__, sg_elems);
>> +
>> +	/* Allocate memory and link the structs together.  */
>> +        shost = scsi_host_alloc(&virtscsi_host_template,
>> +		sizeof(*vscsi) + sizeof(vscsi->sg[0]) * (sg_elems + 2));
>> +
>> +	if (!shost)
>> +		return -ENOMEM;
>> +
>> +	shost->sg_tablesize = sg_elems;
>> +	vscsi = shost_priv(shost);
>> +	vscsi->vdev = vdev;
>> +	vdev->priv = shost;
>> +
>> +	/* Random initializations.  */
>> +	spin_lock_init(&vscsi->cmd_vq_lock);
>> +	sg_init_table(vscsi->sg, sg_elems + 2);
>> +
>> +	err = virtscsi_init(vdev, vscsi);
>> +	if (err)
>> +		goto virtio_init_failed;
>> +
>> +	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1;
>> +	shost->max_id = virtscsi_config_get(vdev, max_target) + 1;
>> +	shost->max_channel = 0;
>> +	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
>> +	err = scsi_add_host(shost,&vdev->dev);
>> +	if (err)
>> +		goto scsi_add_host_failed;
>> +
>> +	scsi_scan_host(shost);
>> +
>> +	return 0;
>> +
>> +scsi_add_host_failed:
>> +	vdev->config->del_vqs(vdev);
>> +virtio_init_failed:
>> +	scsi_host_put(shost);
>> +	return err;
>> +}
>> +
>> +static void __devexit virtscsi_remove_vqs(struct virtio_device *vdev)
>> +{
>> +	/* Stop all the virtqueues. */
>> +	vdev->config->reset(vdev);
>> +
>> +	vdev->config->del_vqs(vdev);
>> +}
>> +
>> +static void __devexit virtscsi_remove(struct virtio_device *vdev)
>> +{
>> +	struct Scsi_Host *shost = virtio_scsi_host(vdev);
>> +
>> +	scsi_remove_host(shost);
>> +
>> +	virtscsi_remove_vqs(vdev);
>> +	scsi_host_put(shost);
>> +}
>> +
>> +static struct virtio_device_id id_table[] = {
>> +	{ VIRTIO_ID_SCSI, VIRTIO_DEV_ANY_ID },
>> +	{ 0 },
>> +};
>> +
>> +static struct virtio_driver virtio_scsi_driver = {
>> +	.driver.name = KBUILD_MODNAME,
>> +	.driver.owner = THIS_MODULE,
>> +	.id_table = id_table,
>> +	.probe = virtscsi_probe,
>> +	.remove = __devexit_p(virtscsi_remove),
>> +};
>> +
>> +static int __init init(void)
>> +{
>> +	virtscsi_cmd_cache = KMEM_CACHE(virtio_scsi_cmd, 0);
>
> Shouldn't these kmemcaches be per-device and not globally shared between
> all devices?

In practice it will be rare (and it's part of the design) to have more 
than one virtio-scsi device (perhaps two: one for passthrough and one 
for other block devices).  If the kmemcaches are a bottleneck, what you 
want is making them per-virtqueue.  Fixing it is simple if it turns out 
to be a problem, and it is simpler if I do it together with multi-vq 
support.

Thanks for the review.
