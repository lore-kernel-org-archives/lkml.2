Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab2BMJUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:20:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab2BMJUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:20:22 -0500
Message-ID: <4F38D5BC.8010705@redhat.com>
Date: Mon, 13 Feb 2012 10:19:56 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Christian Hoff <christian.hoff@de.ibm.com>, BORNTRAE@linux.vnet.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, mst@redhat.com, rusty@rustcorp.com.au
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com>  <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com>  <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com>  <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>  <4F313526.2050907@redhat.com>  <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>  <4F3390FB.80107@redhat.com> <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 09:16 PM, James Bottomley wrote:
> Well, no-one's yet answered the question I had about why.  virtio-scsi
> seems to be a basic duplication of virtio-blk except that it seems to
> fix some problems virtio-blk has.  Namely queue parameter discover,
> which virtio-blk doesn't seem to do.

The biggest differences between virtio-blk and virtio-scsi are that:

1) how the feature set is defined.  virtio-blk defines the feature set 
of the device through a shared spec between the guest and the host.  The 
virtio-scsi spec does not define a feature set for the devices, only for 
the transport.  Introducing new features in the guest does not need to 
be done specifically for virt, it can be done in generic code (sd.c). 
This results in a large feature set and at the same time a very stable spec.

Right now virtio-blk covers common usecases nicely.  However, the Linux 
block layer _is_ growing support for new operations: discard is already 
there, write same is in the works, extended copy will also come in due 
time.  Perhaps we'll add them to virtio-blk, perhaps not.  If we will, 
we will have to modify the spec, the host implementation, and the guest 
drivers for each possible guest OS.  virtio-scsi will support them 
transparently.  Depending on your configuration, it might work without 
touching the host at all.


2) for disks with SCSI attachment, the native interface is exposed 
precisely as it is in the host.  I think we had some misunderstanding 
WRT queue parameter discovery.  My concern with virtio-blk's SG_IO 
support is more general than that.  It is that SG_IO accesses the host 
disk, not the guest disk.  They will have the same data, but they are 
effectively different disks.  For example they might have different 
queue parameters, hence the misunderstanding.

People are mostly using the SG_IO interface for sane purposes.  For 
example you can ping the storage with INQUIRY commands to detect 
problems on the NAS or SAN.  For these usecases the difference does not 
matter.  However, there _are_ worrisome usecases for SG_IO that people 
are looking at.  For example installing vendor backup tools in their 
guests.  These tools send vendor-specific commands to the disks. 
Nothing particularly insane about that, but we want them to do it using 
a saner interface than VIRTIO_BLK_T_SCSI_CMD.


On top of this, only virtio-scsi obviously will support devices such as 
tapes.

> There may also be a reason to cut the stack lower down.  Error
> handling is most often cited for this, but no-one's satisfactorily
> explaned why it's better to do error handling in the guest instead of
> the host.

It's not necessarily better.  However error handling in the host may 
simply not be there.  This is for example the case of NFS-based storage 
with the "hard" option.

Paolo
