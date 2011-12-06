Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab1LFFjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 00:39:10 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49231 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab1LFFjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 00:39:09 -0500
Message-ID: <4EDDAA5C.2050809@cs.wisc.edu>
Date: Mon, 05 Dec 2011 23:38:36 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] virtio-scsi: add error handling
References: <1323106159-6562-1-git-send-email-pbonzini@redhat.com> <1323106159-6562-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1323106159-6562-3-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 11:29 AM, Paolo Bonzini wrote:
> +static int virtscsi_device_reset(struct scsi_cmnd *sc)
> +{
> +	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
> +	struct virtio_scsi_cmd *cmd;
> +
> +	sdev_printk(KERN_INFO, sc->device, "device reset\n");
> +	cmd = kmem_cache_zalloc(virtscsi_cmd_cache, GFP_ATOMIC);


Here and in abort you can use GFP_NOIO. No locks are held here and you
just want to make sure the allocation does not cause write outs.

You probably want some cmd preallocated here and in the queuecommand
path, so you can make progress even if memory is hard to come by.
Block/scsi drivers normally use mempools to do this.


> +	if (!cmd)
> +		return FAILED;
> +
> +	cmd->sc = sc;
> +	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
> +		.type = VIRTIO_SCSI_T_TMF,
> +		.subtype = VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET,
> +		.lun[0] = 1,
> +		.lun[1] = sc->device->id,
> +		.lun[2] = (sc->device->lun >> 8) | 0x40,
> +		.lun[3] = sc->device->lun & 0xff,

Not sure what is going on here. Is lun[8] is supposed to be the scsi lun
value like in the scsi specs? If so you just want

int_to_scsilun(sc->device->lun, lun);


>  static struct scsi_host_template virtscsi_host_template = {
>  	.module = THIS_MODULE,
>  	.name = "Virtio SCSI HBA",
>  	.proc_name = "virtio_scsi",
>  	.queuecommand = virtscsi_queuecommand,
>  	.this_id = -1,
> +	.eh_abort_handler               = virtscsi_abort,
> +	.eh_device_reset_handler        = virtscsi_device_reset,
>  

Tabbing looks off with the rest of your code.
