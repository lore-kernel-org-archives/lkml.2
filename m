Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1FGNof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:44:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab1FGNod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:44:33 -0400
Message-ID: <4DEE2B15.4090809@redhat.com>
Date: Tue, 07 Jun 2011 15:43:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Hannes Reinecke <hare@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: virtio scsi host draft specification, v3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

after some preliminary discussion on the QEMU mailing list, I present a
draft specification for a virtio-based SCSI host (controller, HBA, you
name it).

The virtio SCSI host is the basis of an alternative storage stack for
KVM. This stack would overcome several limitations of the current
solution, virtio-blk:

1) scalability limitations: virtio-blk-over-PCI puts a strong upper
limit on the number of devices that can be added to a guest. Common
configurations have a limit of ~30 devices. While this can be worked
around by implementing a PCI-to-PCI bridge, or by using multifunction
virtio-blk devices, these solutions either have not been implemented
yet, or introduce management restrictions. On the other hand, the SCSI
architecture is well known for its scalability and virtio-scsi supports
advanced feature such as multiqueueing.

2) limited flexibility: virtio-blk does not support all possible storage
scenarios. For example, it does not allow SCSI passthrough or persistent
reservations. In principle, virtio-scsi provides anything that the
underlying SCSI target (be it physical storage, iSCSI or the in-kernel
target) supports.

3) limited extensibility: over the time, many features have been added
to virtio-blk. Each such change requires modifications to the virtio
specification, to the guest drivers, and to the device model in the
host. The virtio-scsi spec has been written to follow SAM conventions,
and exposing new features to the guest will only require changes to the
host's SCSI target implementation.


Comments are welcome.

Paolo 

------------------------------- >8 -----------------------------------


Virtio SCSI Host Device Spec
============================

The virtio SCSI host device groups together one or more simple virtual
devices (ie. disk), and allows communicating to these devices using the
SCSI protocol.  An instance of the device represents a SCSI host with
possibly many buses, targets and LUN attached.

The virtio SCSI device services two kinds of requests:

- command requests for a logical unit;

- task management functions related to a logical unit, target or
command.

The device is also able to send out notifications about added
and removed logical units.

v1:
    First public version

v2:
    Merged all virtqueues into one, removed separate TARGET fields

v3:
    Added configuration information and reworked descriptor structure.
    Added back multiqueue on Avi's request, while still leaving TARGET
    fields out.  Added dummy event and clarified some aspects of the
    event protocol.  First version sent to a wider audience (linux-kernel
    and virtio lists).

Configuration
-------------

Subsystem Device ID
    TBD

Virtqueues
    0:controlq
    1:eventq
    2..n:request queues

Feature bits
    VIRTIO_SCSI_F_INOUT (0) - Whether a single request can include both
        read-only and write-only data buffers.

Device configuration layout
    struct virtio_scsi_config {
        u32 num_queues;
        u32 event_info_size;
        u32 sense_size;
        u32 cdb_size;
    }

    num_queues is the total number of virtqueues exposed by the
    device.  The driver is free to use only one request queue, or
    it can use more to achieve better performance.

    event_info_size is the maximum size that the device will fill
    for buffers that the driver places in the eventq.  The
    driver should always put buffers at least of this size.

    sense_size is the maximum size of the sense data that the device
    will write.  The default value is written by the device and
    will always be 96, but the driver can modify it.

    cdb_size is the maximum size of the CBD that the driver
    will write.  The default value is written by the device and
    will always be 32, but the driver can likewise modify it.

Device initialization
---------------------

The initialization routine should first of all discover the device's
virtqueues.

The driver should then place at least a buffer in the eventq.
Buffers returned by the device on the eventq may be referred
to as "events" in the rest of the document.

The driver can immediately issue requests (for example, INQUIRY or
REPORT LUNS) or task management functions (for example, I_T RESET).

Device operation: request queues
--------------------------------

The driver queues requests to an arbitrary request queue, and they are
used by the device on that same queue.

Requests have the following format:

    struct virtio_scsi_req_cmd {
        u8 lun[8];
        u64 id;
        u8 task_attr;
        u8 prio;
        u8 crn;
        char cdb[cdb_size];
        char dataout[];

        u8 sense[sense_size];
        u32 sense_len;
        u32 residual;
        u16 status_qualifier;
        u8 status;
        u8 response;
        char datain[];
    };

    /* command-specific response values */
    #define VIRTIO_SCSI_S_OK              0
    #define VIRTIO_SCSI_S_UNDERRUN        1
    #define VIRTIO_SCSI_S_ABORTED         2
    #define VIRTIO_SCSI_S_FAILURE         3

    /* task_attr */
    #define VIRTIO_SCSI_S_SIMPLE          0
    #define VIRTIO_SCSI_S_ORDERED         1
    #define VIRTIO_SCSI_S_HEAD            2
    #define VIRTIO_SCSI_S_ACA             3

    The lun field addresses a bus, target and logical unit in the SCSI
    host.  The id field is the command identifier as defined in SAM.

    Task_attr, prio and CRN are defined in SAM.  The prio field should
    always be zero, as command priority is explicitly not supported by
    this version of the device.  task_attr defines the task attribute as
    in the table above, Note that all task attributes may be mapped to
    SIMPLE by the device.  CRN is generally expected to be 0, but clients
    can provide it.  The maximum CRN value defined by the protocol is 255,
    since CRN is stored in an 8-bit integer.

    All of these fields are always read-only, as are the cdb and dataout
    field.  sense and subsequent fields are always write-only.

    The sense_len field indicates the number of bytes actually written
    to the sense buffer.  The residual field indicates the residual
    size, calculated as data_length - number_of_transferred_bytes, for
    read or write operations.

    The status byte is written by the device to be the SCSI status code.

    The response byte is written by the device to be one of the following:

    - VIRTIO_SCSI_S_OK when the request was completed and the status byte
      is filled with a SCSI status code (not necessarily "GOOD").

    - VIRTIO_SCSI_S_UNDERRUN if the content of the CDB requires transferring
      more data than is available in the data buffers.

    - VIRTIO_SCSI_S_ABORTED if the request was cancelled due to a reset
      or another task management function.

    - VIRTIO_SCSI_S_FAILURE for other host or guest error.  In particular,
      if neither dataout nor datain is empty, and the VIRTIO_SCSI_F_INOUT
      feature has not been negotiated, the request will be immediately
      returned with a response equal to VIRTIO_SCSI_S_FAILURE.

Device operation: controlq
--------------------------

The controlq is used for other SCSI transport operations.
Requests have the following format:

    struct virtio_scsi_ctrl
    {
        u32 type;
        ...
        u8 response;
    }

    The type identifies the remaining fields.

The following commands are defined:

- Task management function

    #define VIRTIO_SCSI_T_TMF                      0

    #define VIRTIO_SCSI_T_TMF_ABORT_TASK           0
    #define VIRTIO_SCSI_T_TMF_ABORT_TASK_SET       1
    #define VIRTIO_SCSI_T_TMF_CLEAR_ACA            2
    #define VIRTIO_SCSI_T_TMF_CLEAR_TASK_SET       3
    #define VIRTIO_SCSI_T_TMF_I_T_NEXUS_RESET      4
    #define VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET   5
    #define VIRTIO_SCSI_T_TMF_QUERY_TASK           6
    #define VIRTIO_SCSI_T_TMF_QUERY_TASK_SET       7

    struct virtio_scsi_ctrl_tmf
    {
        u32 type;
        u32 subtype;
        u8 lun[8];
        u64 id;
        u8 additional[];
        u8 response;
    }

    /* command-specific response values */
    #define VIRTIO_SCSI_S_FUNCTION_COMPLETE        0
    #define VIRTIO_SCSI_S_FAILURE                  3
    #define VIRTIO_SCSI_S_FUNCTION_SUCCEEDED       4
    #define VIRTIO_SCSI_S_FUNCTION_REJECTED        5
    #define VIRTIO_SCSI_S_INCORRECT_LUN            6

    The type is VIRTIO_SCSI_T_TMF.  All fields but the last one are
    filled by the driver, the response field is filled in by the device.
    The id command must match the id in a SCSI command.  Irrelevant fields
    for the requested TMF are ignored.

    Note that since ACA is not supported by this version of the spec,
    VIRTIO_SCSI_T_TMF_CLEAR_ACA is always a no-operation.

    The outcome of the task management function is written by the device
    in the response field.  Return values map 1-to-1 with those defined
    in SAM.

- Asynchronous notification query

    #define VIRTIO_SCSI_T_AN_QUERY                    1

    struct virtio_scsi_ctrl_an {
        u32 type;
        u8  lun[8];
        u32 event_requested;
        u32 event_actual;
        u8  response;
    }

    #define VIRTIO_SCSI_EVT_ASYNC_OPERATIONAL_CHANGE  2
    #define VIRTIO_SCSI_EVT_ASYNC_POWER_MGMT          4
    #define VIRTIO_SCSI_EVT_ASYNC_EXTERNAL_REQUEST    8
    #define VIRTIO_SCSI_EVT_ASYNC_MEDIA_CHANGE        16
    #define VIRTIO_SCSI_EVT_ASYNC_MULTI_HOST          32
    #define VIRTIO_SCSI_EVT_ASYNC_DEVICE_BUSY         64

    By sending this command, the driver asks the device which events
    the given LUN can report, as described in paragraphs 6.6 and A.6
    of the SCSI MMC specification.  The driver writes the events it is
    interested in into the event_requested; the device responds by
    writing the events that it supports into event_actual.

    The type is VIRTIO_SCSI_T_AN_QUERY.  The lun and event_requested
    fields are written by the driver.  The event_actual and response
    fields are written by the device.

    Valid values of the response byte are VIRTIO_SCSI_S_OK or
    VIRTIO_SCSI_S_FAILURE (with the same meaning as above).

- Asynchronous notification subscription

    #define VIRTIO_SCSI_T_AN_SUBSCRIBE                2

    struct virtio_scsi_ctrl_an {
        u32 type;
        u8  lun[8];
        u32 event_requested;
        u32 event_actual;
        u8  response;
    }

    #define VIRTIO_SCSI_EVT_ASYNC_MEDIA_CHANGE        16

    By sending this command, the driver asks the specified LUN to report
    events for its physical interface, as described in Annex A of the SCSI
    MMC specification.  The driver writes the events it is interested in
    into the event_requested; the device responds by writing the events
    that it supports into event_actual.

    The type is VIRTIO_SCSI_T_AN_SUBSCRIBE.  The lun and event_requested
    fields are written by the driver.  The event_actual and response
    fields are written by the device.

    Valid values of the response byte are VIRTIO_SCSI_S_OK,
    VIRTIO_SCSI_S_FAILURE (with the same meaning as above).

Device operation: eventq
------------------------

The eventq is used by the device to report information on logical units
that are attached to it.  The driver should always leave a few (?) buffers
ready in the eventq.  The device will end up dropping events if it finds
no buffer ready.

Buffers are placed in the eventq and filled by the device when interesting
events occur.  The buffers should be strictly write-only (device-filled)
and the size of the buffers should be at least the value given in the
device's configuration information.

Events have the following format:

    #define VIRTIO_SCSI_T_EVENTS_MISSED   0x80000000

    struct virtio_scsi_ctrl_recv {
        u32 event;
        ...
    }

If bit 31 is set in the event field, the device failed to report an
event due to missing buffers.  In this case, the driver should poll the
logical units for unit attention conditions, and/or do whatever form of
bus scan is appropriate for the guest operating system.

Other data that the device writes to the buffer depends on the contents
of the event field.  The following events are defined:

- No event

    #define VIRTIO_SCSI_T_NO_EVENT         0

    This event is fired in the following cases:

    1) When the device detects in the eventq a buffer that is shorter
    than what is indicated in the configuration field, it will use
    it immediately and put this dummy value in the event field.
    A well-written driver will never observe this situation.

    2) When events are dropped, the device may signal this event as
    soon as the drivers makes a buffer available, in order to request
    action from the driver.  In this case, of course, this event will
    be reported with the VIRTIO_SCSI_T_EVENTS_MISSED flag.

- Transport reset

    #define VIRTIO_SCSI_T_TRANSPORT_RESET  1

    struct virtio_scsi_reset {
        u32 event;
        u8  lun[8];
        u32 reason;
    }

    #define VIRTIO_SCSI_EVT_RESET_HARD         0
    #define VIRTIO_SCSI_EVT_RESET_RESCAN       1
    #define VIRTIO_SCSI_EVT_RESET_REMOVED      2

    By sending this event, the device signals that a logical unit
    on a target has been reset, including the case of a new device
    appearing or disappearing on the bus.

    The device fills in all fields.  The event field is set to
    VIRTIO_SCSI_T_TRANSPORT_RESET.  The lun field addresses a bus,
    target and logical unit in the SCSI host.

    The reason value is one of the four #define values appearing above.
    VIRTIO_SCSI_EVT_RESET_REMOVED is used if the target or logical unit
    is no longer able to receive commands.  VIRTIO_SCSI_EVT_RESET_HARD
    is used if the logical unit has been reset, but is still present.
    VIRTIO_SCSI_EVT_RESET_RESCAN is used if a target or logical unit has
    just appeared on the device.

    When VIRTIO_SCSI_EVT_RESET_REMOVED or VIRTIO_SCSI_EVT_RESET_RESCAN
    is sent for LUN 0, the driver should ask the initiator to rescan
    the target, in order to detect the case when an entire target has
    appeared or disappeared.

    Events will also be reported via sense codes (this obviously does
    not apply to newly appeared buses or targets, since the application
    has never discovered them):

    - VIRTIO_SCSI_EVT_RESET_HARD
      sense UNIT ATTENTION
      asc POWER ON, RESET OR BUS DEVICE RESET OCCURRED

    - VIRTIO_SCSI_EVT_RESET_RESCAN
      sense UNIT ATTENTION
      asc REPORTED LUNS DATA HAS CHANGED

    - VIRTIO_SCSI_EVT_RESET_REMOVED
      sense ILLEGAL REQUEST
      asc LOGICAL UNIT NOT SUPPORTED

    The preferred way to detect transport reset is always to use events,
    because sense codes are only seen by the driver when it sends a
    SCSI command to the logical unit or target.  However, in case events
    are dropped, the initiator will still be able to synchronize with the
    actual state of the controller if the driver asks the initiator to
    rescan of the SCSI bus.  During the rescan, the initiator will be
    able to observe the above sense codes, and it will process them as
    if it the driver had received the equivalent event.

- Asynchronous notification

    #define VIRTIO_SCSI_T_ASYNC_NOTIFY     2

    struct virtio_scsi_an_event {
        u32 event;
        u8  lun[8];
        u32 reason;
    }

    By sending this event, the device signals that an asynchronous
    event was fired from a physical interface.

    All fields are written by the device.  The event field is set to
    VIRTIO_SCSI_T_ASYNC_NOTIFY.  The reason field is a subset of the
    events that the driver has subscribed to via the "Asynchronous
    notification subscription" command.

    When dropped events are reported, the driver should poll for 
    asynchronous events manually using SCSI commands.
