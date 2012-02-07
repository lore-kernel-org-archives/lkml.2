Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2BGJzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:55:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab2BGJzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:55:06 -0500
Message-ID: <4F30F4EE.4080607@redhat.com>
Date: Tue, 07 Feb 2012 10:54:54 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Christian Hoff <christian.hoff@de.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        rusty@rustcorp.com.au, mst@redhat.com, kvm@vger.kernel.org
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com>
In-Reply-To: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 10:51 AM, Christian Hoff wrote:
> Hello Paolo,
>
> first let me say that your patch is working fine on my local clone of the
> qemu repository.
>
> Let me ask just one question about the format of the data being
> transmitted over the virtqueue.
>
> Paolo Bonzini wrote:
> +                cmd->req.cmd = (struct virtio_scsi_cmd_req){
> +                                .lun[0] = 1,
> +                                .lun[1] = sc->device->id,
> +                                .lun[2] = (sc->device->lun>>  8) | 0x40,
> +                                .lun[3] = sc->device->lun&  0xff,
> +                               [...]
> +                };
>
> Can't we have seperate fields for the SCSI target ID and the LUN number
> here? Putting all this into a single field seems confusing. The following
> line of code (sc->device->lun>>  8) | 0x40 essentially means that LUN
> numbers will be limited to 8+6 Bits=14 Bits for no obvious reason that I
> can see. Maybe we could just split the LUN field up into two uint32 fields
> for target ID and LUN number?

The 14-bit limitation can be lifted.  SAM defines a 24-bit LUN format 
too, but I've never seen it used in practice.

> Also, lun[1] = sc->device->id means that only 255 SCSI target IDs will be
> supported. Think about bigger usage scenarios, such as FCP networks with
> several hundred HBAs in the net. If you want to have the target ID<->HBA
> mapping the same as on the guest as on the host, then 255 virtual target
> IDs could be a limit.

I think you would hit other scalability limitations well before that.  I 
plan to give each target its own MSI-X interrupt, but there is no 
infinite supplies of those either.

VMware only supports 15 targets and 255 LUNs per host, by comparison.  I 
think 255 targets and 16383 LUNs is already several times more than is 
actually needed.  But in any case, we could still use the fixed "1" byte 
to go beyond 255 targets.

> Sorry for coming up so late with these suggestions. I hope there is still
> enough time left to discuss and address these problems.

Sure. :)  I hope the above answer is satisfactory, though.

Paolo
