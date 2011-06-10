Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab1FJMzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:55:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:52920 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab1FJMzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:55:39 -0400
Message-ID: <4DF21447.6090005@suse.de>
Date: Fri, 10 Jun 2011 14:55:35 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
References: <4DEE2B15.4090809@redhat.com>
In-Reply-To: <4DEE2B15.4090809@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 03:43 PM, Paolo Bonzini wrote:
> Hi all,
>
> after some preliminary discussion on the QEMU mailing list, I present a
> draft specification for a virtio-based SCSI host (controller, HBA, you
> name it).
>
> The virtio SCSI host is the basis of an alternative storage stack for
> KVM. This stack would overcome several limitations of the current
> solution, virtio-blk:
>
> 1) scalability limitations: virtio-blk-over-PCI puts a strong upper
> limit on the number of devices that can be added to a guest. Common
> configurations have a limit of ~30 devices. While this can be worked
> around by implementing a PCI-to-PCI bridge, or by using multifunction
> virtio-blk devices, these solutions either have not been implemented
> yet, or introduce management restrictions. On the other hand, the SCSI
> architecture is well known for its scalability and virtio-scsi supports
> advanced feature such as multiqueueing.
>
> 2) limited flexibility: virtio-blk does not support all possible storage
> scenarios. For example, it does not allow SCSI passthrough or persistent
> reservations. In principle, virtio-scsi provides anything that the
> underlying SCSI target (be it physical storage, iSCSI or the in-kernel
> target) supports.
>
> 3) limited extensibility: over the time, many features have been added
> to virtio-blk. Each such change requires modifications to the virtio
> specification, to the guest drivers, and to the device model in the
> host. The virtio-scsi spec has been written to follow SAM conventions,
> and exposing new features to the guest will only require changes to the
> host's SCSI target implementation.
>
>
> Comments are welcome.
>
> Paolo
>
> ------------------------------->8 -----------------------------------
>
>
> Virtio SCSI Host Device Spec
> ============================
>
> The virtio SCSI host device groups together one or more simple virtual
> devices (ie. disk), and allows communicating to these devices using the
> SCSI protocol.  An instance of the device represents a SCSI host with
> possibly many buses, targets and LUN attached.
>
> The virtio SCSI device services two kinds of requests:
>
> - command requests for a logical unit;
>
> - task management functions related to a logical unit, target or
> command.
>
> The device is also able to send out notifications about added
> and removed logical units.
>
> v1:
>      First public version
>
> v2:
>      Merged all virtqueues into one, removed separate TARGET fields
>
> v3:
>      Added configuration information and reworked descriptor structure.
>      Added back multiqueue on Avi's request, while still leaving TARGET
>      fields out.  Added dummy event and clarified some aspects of the
>      event protocol.  First version sent to a wider audience (linux-kernel
>      and virtio lists).
>
> Configuration
> -------------
>
> Subsystem Device ID
>      TBD
>
> Virtqueues
>      0:controlq
>      1:eventq
>      2..n:request queues
>
> Feature bits
>      VIRTIO_SCSI_F_INOUT (0) - Whether a single request can include both
>          read-only and write-only data buffers.
>
> Device configuration layout
>      struct virtio_scsi_config {
>          u32 num_queues;
>          u32 event_info_size;
>          u32 sense_size;
>          u32 cdb_size;
>      }
>
>      num_queues is the total number of virtqueues exposed by the
>      device.  The driver is free to use only one request queue, or
>      it can use more to achieve better performance.
>
>      event_info_size is the maximum size that the device will fill
>      for buffers that the driver places in the eventq.  The
>      driver should always put buffers at least of this size.
>
>      sense_size is the maximum size of the sense data that the device
>      will write.  The default value is written by the device and
>      will always be 96, but the driver can modify it.
>
>      cdb_size is the maximum size of the CBD that the driver
>      will write.  The default value is written by the device and
>      will always be 32, but the driver can likewise modify it.
>
> Device initialization
> ---------------------
>
> The initialization routine should first of all discover the device's
> virtqueues.
>
> The driver should then place at least a buffer in the eventq.
> Buffers returned by the device on the eventq may be referred
> to as "events" in the rest of the document.
>
> The driver can immediately issue requests (for example, INQUIRY or
> REPORT LUNS) or task management functions (for example, I_T RESET).
>
> Device operation: request queues
> --------------------------------
>
> The driver queues requests to an arbitrary request queue, and they are
> used by the device on that same queue.
>
What about request ordering?
If requests are placed on arbitrary queues you'll inevitably run on 
locking issues to ensure strict request ordering.
I would add here:

If a device uses more than one queue it is the responsibility of the 
device to ensure strict request ordering.

> Requests have the following format:
>
>      struct virtio_scsi_req_cmd {
>          u8 lun[8];
>          u64 id;
>          u8 task_attr;
>          u8 prio;
>          u8 crn;
>          char cdb[cdb_size];
>          char dataout[];
>
>          u8 sense[sense_size];
>          u32 sense_len;
>          u32 residual;
>          u16 status_qualifier;
>          u8 status;
>          u8 response;
>          char datain[];
>      };
>
>      /* command-specific response values */
>      #define VIRTIO_SCSI_S_OK              0
>      #define VIRTIO_SCSI_S_UNDERRUN        1
>      #define VIRTIO_SCSI_S_ABORTED         2
>      #define VIRTIO_SCSI_S_FAILURE         3
>
>      /* task_attr */
>      #define VIRTIO_SCSI_S_SIMPLE          0
>      #define VIRTIO_SCSI_S_ORDERED         1
>      #define VIRTIO_SCSI_S_HEAD            2
>      #define VIRTIO_SCSI_S_ACA             3
>
>      The lun field addresses a bus, target and logical unit in the SCSI
>      host.  The id field is the command identifier as defined in SAM.
>
Please do not rely in bus/target/lun here. These are leftovers from 
parallel SCSI and do not have any meaning on modern SCSI 
implementation (eg FC or SAS). Rephrase that to

The lun field is the Logical Unit Number as defined in SAM.

>      Task_attr, prio and CRN are defined in SAM.  The prio field should
>      always be zero, as command priority is explicitly not supported by
>      this version of the device.  task_attr defines the task attribute as
>      in the table above, Note that all task attributes may be mapped to
>      SIMPLE by the device.  CRN is generally expected to be 0, but clients
>      can provide it.  The maximum CRN value defined by the protocol is 255,
>      since CRN is stored in an 8-bit integer.
>
>      All of these fields are always read-only, as are the cdb and dataout
>      field.  sense and subsequent fields are always write-only.
>
>      The sense_len field indicates the number of bytes actually written
>      to the sense buffer.  The residual field indicates the residual
>      size, calculated as data_length - number_of_transferred_bytes, for
>      read or write operations.
>
>      The status byte is written by the device to be the SCSI status code.
>
?? I doubt that exists. Make that:

The status byte is written by the device to be the status code as 
defined in SAM.

>      The response byte is written by the device to be one of the following:
>
>      - VIRTIO_SCSI_S_OK when the request was completed and the status byte
>        is filled with a SCSI status code (not necessarily "GOOD").
>
>      - VIRTIO_SCSI_S_UNDERRUN if the content of the CDB requires transferring
>        more data than is available in the data buffers.
>
>      - VIRTIO_SCSI_S_ABORTED if the request was cancelled due to a reset
>        or another task management function.
>
>      - VIRTIO_SCSI_S_FAILURE for other host or guest error.  In particular,
>        if neither dataout nor datain is empty, and the VIRTIO_SCSI_F_INOUT
>        feature has not been negotiated, the request will be immediately
>        returned with a response equal to VIRTIO_SCSI_S_FAILURE.
>
And, of course:

VIRTIO_SCSI_S_DISCONNECT if the request could not be processed due 
to a communication failure (eg device was removed or could not be
reached).

The remaining bits seem to be okay.

One general question:

This specification implies a strict one-to-one mapping between host 
and target. IE there is no way of specifying more than one target 
per host.
This will make things like ALUA (Asymmetric Logical Unit Access)
a bit tricky to implement, as the port states there are bound to 
target port groups. So with the virtio host spec we would need to 
specify two hosts to represent that.

If that's the intention here I'm fine, but maybe we should be 
specifying this expressis verbis somewhere.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
