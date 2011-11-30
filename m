Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1K3ORM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:17:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab1K3ORH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:17:07 -0500
Message-ID: <4ED63AE1.8090105@suse.de>
Date: Wed, 30 Nov 2011 15:17:05 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-scsi <linux-scsi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: virtio-scsi spec (was Re: [PATCH] Add virtio-scsi to the virtio
 spec)
References: <1322661042-28191-1-git-send-email-pbonzini@redhat.com> <1322661042-28191-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1322661042-28191-2-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 02:50 PM, Paolo Bonzini wrote:
> Appendix H: SCSI Host Device
> 
> The virtio SCSI host device groups together one or more simple
> virtual devices (ie. disk), and allows communicating to these
> devices using the SCSI protocol. An instance of the device
> represents a SCSI host with possibly many buses (also known as
> channels or paths), targets and LUNs attached.
> 
> The virtio SCSI device services two kinds of requests:
> 
> * command requests for a logical unit;
> 
> * task management functions related to a logical unit, target or
>   command.
> 
> The device is also able to send out notifications about added and
> removed logical units. Together, these capabilities provide a
> SCSI transport protocol that uses virtqueues as the transfer
> medium. In the transport protocol, the virtio driver acts as the
> initiator, while the virtio SCSI host provides one or more
> targets that receive and process the requests.
> 
> Configuration
> =============
> 
> * Subsystem Device ID 7
> 
> * Virtqueues 0:controlq; 1:eventq; 2..n:request queues.
> 
> * Feature bits
> 
>   VIRTIO_SCSI_F_INOUT (0)
>   A single request can include both read-only and write-only data buffers.
> 
> * Device configuration layout
>   All fields of this configuration are always available. sense_size and
>   cdb_size are writable by the guest.
> 
>     struct virtio_scsi_config {
>         u32 num_queues;
>         u32 seg_max;
>         u32 event_info_size;
>         u32 sense_size;
>         u32 cdb_size;
>         u16 max_channel;
>         u16 max_target;
>         u32 max_lun;
>     };
> 
>   num_queues is the total number of virtqueues exposed by the
>     device. The driver is free to use only one request queue, or
>     it can use more to achieve better performance.
> 
>   seg_max is the maximum number of segments that can be in a
>     command. A bidirectional command can include seg_max input
>     segments and seg_max output segments.
> 
I would like to have the other request_queue limitations exposed
here, too.
Most notably we're missing the maximum size of an individual segment
and the maximum size of the overall I/O request.
Without it we can't efficiently map onto pass-through devices.

>   event_info_size is the maximum size that the device will fill
>     for buffers that the driver places in the eventq. The driver
>     should always put buffers at least of this size. It is
>     written by the device depending on the set of negotated
>     features.
> 
>   sense_size is the maximum size of the sense data that the
>     device will write. The default value is written by the device
>     and will always be 96, but the driver can modify it. It is
>     restored to the default when the device is reset.
> 
>   cdb_size is the maximum size of the CDB that the driver will
>     write. The default value is written by the device and will
>     always be 32, but the driver can likewise modify it. It is
>     restored to the default when the device is reset.
> 
>   max_channel, max_target and max_lun can be used by the driver
>     as hints for scanning the logical units on the host. In the
>     current version of the spec, they will always be respectively
>     0, 255 and 16383.
> 
As this is the host specification I really would like to see an host
identifier somewhere in there.
Otherwise we won't be able to reliably identify a virtio SCSI host.
Plus you can't calculate the ITL nexus information, making
Persistent Reservations impossible.
However, we should be able to delegate this to a specific controlq
command.

> Device Initialization
> =====================
> 
> The initialization routine should first of all discover the
> device's virtqueues.
> 
> If the driver uses the eventq, it should then place at least a
> buffer in the eventq.
> 
> The driver can immediately issue requests (for example, INQUIRY
> or REPORT LUNS) or task management functions (for example, I_T
> RESET).
> 
> Device Operation: request queues
> ================================
> 
> The driver queues requests to an arbitrary request queue, and they are
> used by the device on that same queue. In this version of the spec,
> if a driver uses more than one queue it is the responsibility of the
> driver to ensure strict request ordering; commands placed on different
> queue will be consumed with no order constraints.
> 
> Requests have the following format:
> 
>     struct virtio_scsi_req_cmd {
>         u8 lun[8];
>         u64 id;
>         u8 task_attr;
>         u8 prio;
>         u8 crn;
>         char cdb[cdb_size];
>         char dataout[];
>         u32 sense_len;
>         u32 residual;
>         u16 status_qualifier;
>         u8 status;
>         u8 response;
>         u8 sense[sense_size];
>         char datain[];
>     };
> 
>     /* command-specific response values */
>     #define VIRTIO_SCSI_S_OK                0
>     #define VIRTIO_SCSI_S_UNDERRUN          1
>     #define VIRTIO_SCSI_S_ABORTED           2
>     #define VIRTIO_SCSI_S_BAD_TARGET        3
>     #define VIRTIO_SCSI_S_RESET             4
>     #define VIRTIO_SCSI_S_TRANSPORT_FAILURE 5
>     #define VIRTIO_SCSI_S_TARGET_FAILURE    6
>     #define VIRTIO_SCSI_S_NEXUS_FAILURE     7
>     #define VIRTIO_SCSI_S_FAILURE           8
> 
>     /* task_attr */
>     #define VIRTIO_SCSI_S_SIMPLE            0
>     #define VIRTIO_SCSI_S_ORDERED           1
>     #define VIRTIO_SCSI_S_HEAD              2
>     #define VIRTIO_SCSI_S_ACA               3
> 
> The lun field addresses a target and logical unit in the
> virtio-scsi device's SCSI domain. In this version of the spec,
> the only supported format for the LUN field is: first byte set to
> 1, second byte set to target, third and fourth byte representing
> a single level LUN structure, followed by four zero bytes. With
> this representation, a virtio-scsi device can serve up to 256
> targets and 16384 LUNs per target.
> 
> The id field is the command identifier ("tag").
> 
> Task_attr, prio and crn should be left to zero: command priority
> is explicitly not supported by this version of the device;
> task_attr defines the task attribute as in the table above, but
> all task attributes may be mapped to SIMPLE by the device; crn
> may also be provided by clients, but is generally expected to be
> 0. The maximum CRN value defined by the protocol is 255, since
> CRN is stored in an 8-bit integer.
> 
> All of these fields are defined in SAM. They are always
> read-only, as are the cdb and dataout field. The cdb_size is
> taken from the configuration space.
> 
> sense and subsequent fields are always write-only. The sense_len
> field indicates the number of bytes actually written to the sense
> buffer. The residual field indicates the residual size,
> calculated as "data_length - number_of_transferred_bytes", for
> read or write operations. For bidirectional commands, the
> number_of_transferred_bytes includes both read and written bytes.
> A residual field that is less than the size of datain means that
> the dataout field was processed entirely. A residual field that
> exceeds the size of datain means that the dataout field was
> processed partially and the datain field was not processed at
> all.
> 
> The status byte is written by the device to be the status
> code as defined by SAM.
> 
> The response byte is written by the device to be one of the
> following:
> 
>   VIRTIO_SCSI_S_OK when the request was completed and the status
>   byte is filled with a SCSI status code (not necessarily
>   "GOOD").
> 
>   VIRTIO_SCSI_S_UNDERRUN if the content of the CDB requires
>   transferring more data than is available in the data buffers.
> 
>   VIRTIO_SCSI_S_ABORTED if the request was cancelled due to an
>   ABORT TASK or ABORT TASK SET task management function.
> 
>   VIRTIO_SCSI_S_BAD_TARGET if the request was never processed
>   because the target indicated by the lun field does not exist.
> 
>   VIRTIO_SCSI_S_RESET if the request was cancelled due to a bus
>   or device reset.
> 
>   VIRTIO_SCSI_S_TRANSPORT_FAILURE if the request failed due to a
>   problem in the connection between the host and the target
>   (severed link).
> 
>   VIRTIO_SCSI_S_TARGET_FAILURE if the target is suffering a
>   failure and the guest should not retry on other paths.
> 
>   VIRTIO_SCSI_S_NEXUS_FAILURE if the nexus is suffering a failure
>   but retrying on other paths might yield a different result.
> 
>   VIRTIO_SCSI_S_FAILURE for other host or guest error. In
>   particular, if neither dataout nor datain is empty, and the
>   VIRTIO_SCSI_F_INOUT feature has not been negotiated, the
>   request will be immediately returned with a response equal to
>   VIRTIO_SCSI_S_FAILURE.
> 
We should be adding

VIRTIO_SCSI_S_BUSY

for a temporary failure, indicating that a command retry
might be sufficient to clear this situation.
Equivalent to VIRTIO_SCSI_S_NEXUS_FAILURE, but issuing a retry on
the same path.

Thanks for the write-up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
