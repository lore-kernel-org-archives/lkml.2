Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1LSNMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:12:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1LSNMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:12:03 -0500
Message-ID: <4EEF380E.6040101@redhat.com>
Date: Mon, 19 Dec 2011 14:11:42 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v3 1/2] virtio-scsi: first version
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com> <1324296188-3426-2-git-send-email-pbonzini@redhat.com> <4EEF2C86.6010003@suse.de>
In-Reply-To: <4EEF2C86.6010003@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 01:22 PM, Hannes Reinecke wrote:
>> +	case VIRTIO_SCSI_S_UNDERRUN:
>> +		set_host_byte(sc, DID_ERROR);
>> +		break;
> Hmm. Not sure this is correct.
> UNDERRUN could be a valid state, eg it is quite common to send
> an INQUIRY with a length of 255 bytes. And only evaluate the
> bytes which are actually send back.

This happens when you send an INQUIRY with a sglist of 255 bytes and an 
ALLOCATION LENGTH of 300 bytes.  The spec says "VIRTIO_SCSI_S_UNDERRUN 
[is returned] if the content of the CDB requires transferring more data 
than is available in the data buffers".

> And, it's not good style to match the same DID_XXX error code to
> several internal errors. I would prefer having a 1:1 match for
> VIRTIO_SCSI_S_XXX and DID_XXX error codes.

There is no DID_XXX value for underrun, but it's quite useful to have it 
diagnosed separately in traces.

>> +static struct scsi_host_template virtscsi_host_template = {
>> +	.module = THIS_MODULE,
>> +	.name = "Virtio SCSI HBA",
>> +	.proc_name = "virtio_scsi",
>> +	.queuecommand = virtscsi_queuecommand,
>> +	.this_id = -1,
>> +
>> +	.can_queue = 1024,
>> +	.dma_boundary = UINT_MAX,
>> +	.use_clustering = ENABLE_CLUSTERING,
>> +};
>> +
> Hmm. Apparently you support more than one LUN, yet no
> ->slave_alloc() callback is present. So how do you scan the bus here?

What does slave_alloc have to do with scanning?  I don't need hostdata, 
so I don't have slave_alloc.

Scanning is here:

         err = scsi_add_host(shost, &vdev->dev);
         if (err)
                 goto scsi_add_host_failed;

         scsi_scan_host(shost);

> Do you actually have a working backend implementation?

Hmm... yes, of course...

Paolo
