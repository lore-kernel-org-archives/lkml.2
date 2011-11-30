Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1K3Nv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:51:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab1K3NvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:51:22 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization <virtualization@lists.linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@redhat.com>
Subject: virtio-scsi spec (was Re: [PATCH] Add virtio-scsi to the virtio spec)
Date: Wed, 30 Nov 2011 14:50:42 +0100
Message-Id: <1322661042-28191-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1322661042-28191-1-git-send-email-pbonzini@redhat.com>
References: <1322661042-28191-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Appendix H: SCSI Host Device

The virtio SCSI host device groups together one or more simple
virtual devices (ie. disk), and allows communicating to these
devices using the SCSI protocol. An instance of the device
represents a SCSI host with possibly many buses (also known as
channels or paths), targets and LUNs attached.

The virtio SCSI device services two kinds of requests:

* command requests for a logical unit;

* task management functions related to a logical unit, target or
  command.

The device is also able to send out notifications about added and
removed logical units. Together, these capabilities provide a
SCSI transport protocol that uses virtqueues as the transfer
medium. In the transport protocol, the virtio driver acts as the
initiator, while the virtio SCSI host provides one or more
targets that receive and process the requests.

Configuration
=============

* Subsystem Device ID 7

* Virtqueues 0:controlq; 1:eventq; 2..n:request queues.

* Feature bits

  VIRTIO_SCSI_F_INOUT (0)
  A single request can include both read-only and write-only data buffers.

* Device configuration layout
  All fields of this configuration are always available. sense_size and
  cdb_size are writable by the guest.

    struct virtio_scsi_config {
        u32 num_queues;
        u32 seg_max;
        u32 event_info_size;
        u32 sense_size;
        u32 cdb_size;
        u16 max_channel;
        u16 max_target;
        u32 max_lun;
    };

  num_queues is the total number of virtqueues exposed by the
    device. The driver is free to use only one request queue, or
    it can use more to achieve better performance.

  seg_max is the maximum number of segments that can be in a
    command. A bidirectional command can include seg_max input
    segments and seg_max output segments.

  event_info_size is the maximum size that the device will fill
    for buffers that the driver places in the eventq. The driver
    should always put buffers at least of this size. It is
    written by the device depending on the set of negotated
    features.

  sense_size is the maximum size of the sense data that the
    device will write. The default value is written by the device
    and will always be 96, but the driver can modify it. It is
    restored to the default when the device is reset.

  cdb_size is the maximum size of the CDB that the driver will
    write. The default value is written by the device and will
    always be 32, but the driver can likewise modify it. It is
    restored to the default when the device is reset.

  max_channel, max_target and max_lun can be used by the driver
    as hints for scanning the logical units on the host. In the
    current version of the spec, they will always be respectively
    0, 255 and 16383.

Device Initialization
=====================

The initialization routine should first of all discover the
device's virtqueues.

If the driver uses the eventq, it should then place at least a
buffer in the eventq.

The driver can immediately issue requests (for example, INQUIRY
or REPORT LUNS) or task management functions (for example, I_T
RESET).

Device Operation: request queues
================================

The driver queues requests to an arbitrary request queue, and they are
used by the device on that same queue. In this version of the spec,
if a driver uses more than one queue it is the responsibility of the
driver to ensure strict request ordering; commands placed on different
queue will be consumed with no order constraints.

Requests have the following format:

    struct virtio_scsi_req_cmd {
        u8 lun[8];
        u64 id;
        u8 task_attr;
        u8 prio;
        u8 crn;
        char cdb[cdb_size];
        char dataout[];
        u32 sense_len;
        u32 residual;
        u16 status_qualifier;
        u8 status;
        u8 response;
        u8 sense[sense_size];
        char datain[];
    };

    /* command-specific response values */
    #define VIRTIO_SCSI_S_OK                0
    #define VIRTIO_SCSI_S_UNDERRUN          1
    #define VIRTIO_SCSI_S_ABORTED           2
    #define VIRTIO_SCSI_S_BAD_TARGET        3
    #define VIRTIO_SCSI_S_RESET             4
    #define VIRTIO_SCSI_S_TRANSPORT_FAILURE 5
    #define VIRTIO_SCSI_S_TARGET_FAILURE    6
    #define VIRTIO_SCSI_S_NEXUS_FAILURE     7
    #define VIRTIO_SCSI_S_FAILURE           8

    /* task_attr */
    #define VIRTIO_SCSI_S_SIMPLE            0
    #define VIRTIO_SCSI_S_ORDERED           1
    #define VIRTIO_SCSI_S_HEAD              2
    #define VIRTIO_SCSI_S_ACA               3

The lun field addresses a target and logical unit in the
virtio-scsi device's SCSI domain. In this version of the spec,
the only supported format for the LUN field is: first byte set to
1, second byte set to target, third and fourth byte representing
a single level LUN structure, followed by four zero bytes. With
this representation, a virtio-scsi device can serve up to 256
targets and 16384 LUNs per target.

The id field is the command identifier ("tag").

Task_attr, prio and crn should be left to zero: command priority
is explicitly not supported by this version of the device;
task_attr defines the task attribute as in the table above, but
all task attributes may be mapped to SIMPLE by the device; crn
may also be provided by clients, but is generally expected to be
0. The maximum CRN value defined by the protocol is 255, since
CRN is stored in an 8-bit integer.

All of these fields are defined in SAM. They are always
read-only, as are the cdb and dataout field. The cdb_size is
taken from the configuration space.

sense and subsequent fields are always write-only. The sense_len
field indicates the number of bytes actually written to the sense
buffer. The residual field indicates the residual size,
calculated as "data_length - number_of_transferred_bytes", for
read or write operations. For bidirectional commands, the
number_of_transferred_bytes includes both read and written bytes.
A residual field that is less than the size of datain means that
the dataout field was processed entirely. A residual field that
exceeds the size of datain means that the dataout field was
processed partially and the datain field was not processed at
all.

The status byte is written by the device to be the status
code as defined by SAM.

The response byte is written by the device to be one of the
following:

  VIRTIO_SCSI_S_OK when the request was completed and the status
  byte is filled with a SCSI status code (not necessarily
  "GOOD").

  VIRTIO_SCSI_S_UNDERRUN if the content of the CDB requires
  transferring more data than is available in the data buffers.

  VIRTIO_SCSI_S_ABORTED if the request was cancelled due to an
  ABORT TASK or ABORT TASK SET task management function.

  VIRTIO_SCSI_S_BAD_TARGET if the request was never processed
  because the target indicated by the lun field does not exist.

  VIRTIO_SCSI_S_RESET if the request was cancelled due to a bus
  or device reset.

  VIRTIO_SCSI_S_TRANSPORT_FAILURE if the request failed due to a
  problem in the connection between the host and the target
  (severed link).

  VIRTIO_SCSI_S_TARGET_FAILURE if the target is suffering a
  failure and the guest should not retry on other paths.

  VIRTIO_SCSI_S_NEXUS_FAILURE if the nexus is suffering a failure
  but retrying on other paths might yield a different result.

  VIRTIO_SCSI_S_FAILURE for other host or guest error. In
  particular, if neither dataout nor datain is empty, and the
  VIRTIO_SCSI_F_INOUT feature has not been negotiated, the
  request will be immediately returned with a response equal to
  VIRTIO_SCSI_S_FAILURE.

Device Operation: controlq
==========================

The controlq is used for other SCSI transport operations.
Requests have the following format:

    struct virtio_scsi_ctrl {
        u32 type;
        ...
        u8 response;
    };

    /* response values valid for all commands */
    #define VIRTIO_SCSI_S_OK                       0
    #define VIRTIO_SCSI_S_BAD_TARGET               3
    #define VIRTIO_SCSI_S_TRANSPORT_FAILURE        5
    #define VIRTIO_SCSI_S_TARGET_FAILURE           6
    #define VIRTIO_SCSI_S_NEXUS_FAILURE            7
    #define VIRTIO_SCSI_S_FAILURE                  8
    #define VIRTIO_SCSI_S_INCORRECT_LUN            11

The type identifies the remaining fields.

The following commands are defined:

* Task management function

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
    #define VIRTIO_SCSI_S_FUNCTION_SUCCEEDED       9
    #define VIRTIO_SCSI_S_FUNCTION_REJECTED        10

  The type is VIRTIO_SCSI_T_TMF; the subtype field defines. All
  fields except response are filled by the driver. The subtype
  field must always be specified and identifies the requested
  task management function. Other fields may be irrelevant for
  the requested TMF are ignored. The lun field is in the same
  format specified for request queues; the single level LUN is
  ignored when the task management function addresses a whole I_T
  nexus. When relevant, the value of the id field is matched
  against the id values passed on the requestq.

  Note that since ACA is not supported by this version of the
  spec, VIRTIO_SCSI_T_TMF_CLEAR_ACA is always a no-operation.

  The outcome of the task management function is written by the
  device in the response field. The command-specific response
  values map 1-to-1 with those defined in SAM.

* Asynchronous notification query

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

  By sending this command, the driver asks the device which
  events the given LUN can report, as described in paragraphs 6.6
  and A.6 of the SCSI MMC specification. The driver writes the
  events it is interested in into the event_requested; the device
  responds by writing the events that it supports into
  event_actual.

  The type is VIRTIO_SCSI_T_AN_QUERY. The lun and event_requested
  fields are written by the driver. The event_actual and response
  fields are written by the device.

  No command-specific values are defined for the response byte.

* Asynchronous notification subscription

    #define VIRTIO_SCSI_T_AN_SUBSCRIBE                2

    struct virtio_scsi_ctrl_an {
        u32 type;
        u8  lun[8];
        u32 event_requested;
        u32 event_actual;
        u8  response;
    }

  By sending this command, the driver asks the specified LUN to
  report events for its physical interface, again as described in
  the SCSI MMC specification. The driver writes the events it is
  interested in into the event_requested; the device responds by
  writing the events that it supports into event_actual.

  Event types are the same as for the asynchronous notification
  query message.

  The type is VIRTIO_SCSI_T_AN_SUBSCRIBE. The lun and
  event_requested fields are written by the driver. The
  event_actual and response fields are written by the device.

  No command-specific values are defined for the response byte.

Device Operation: eventq
========================

The eventq is used by the device to report information on logical
units that are attached to it. The driver should always leave a few
buffers ready in the eventq. In general, the device will not queue
events to cope with an empty eventq, and will end up dropping events if
it finds no buffer ready. However, when reporting events for many LUNs
(e.g. when a whole target disappears), the device can throttle events
to avoid dropping them. For this reason, placing 10-15 buffers on the
event queue should be enough.

Buffers are placed in the eventq and filled by the device when
interesting events occur. The buffers should be strictly
write-only (device-filled) and the size of the buffers should be
at least the value given in the device's configuration
information.

Buffers returned by the device on the eventq will be referred to
as "events" in the rest of this section. Events have the
following format:

    #define VIRTIO_SCSI_T_EVENTS_MISSED   0x80000000

    struct virtio_scsi_event {
        u32 event;
        ...
    }

If bit 31 is set in the event field, the device failed to report
an event due to missing buffers. In this case, the driver should
poll the logical units for unit attention conditions, and/or do
whatever form of bus scan is appropriate for the guest operating
system.

Other data that the device writes to the buffer depends on the
contents of the event field. The following events are defined:

* No event

    #define VIRTIO_SCSI_T_NO_EVENT         0

  This event is fired in the following cases:

  * When the device detects in the eventq a buffer that is
    shorter than what is indicated in the configuration field, it
    might use it immediately and put this dummy value in the
    event field. A well-written driver will never observe this
    situation.

  * When events are dropped, the device may signal this event as
    soon as the drivers makes a buffer available, in order to
    request action from the driver. In this case, of course, this
    event will be reported with the VIRTIO_SCSI_T_EVENTS_MISSED
    flag.

* Transport reset

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
  appearing or disappearing on the bus.The device fills in all
  fields. The event field is set to
  VIRTIO_SCSI_T_TRANSPORT_RESET. The lun field addresses a
  logical unit in the SCSI host.

  The reason value is one of the three #define values appearing
  above:

  * VIRTIO_SCSI_EVT_RESET_REMOVED ("LUN/target removed") is used
    if the target or logical unit is no longer able to receive
    commands.

  * VIRTIO_SCSI_EVT_RESET_HARD ("LUN hard reset") is used if the
    logical unit has been reset, but is still present.

  * VIRTIO_SCSI_EVT_RESET_RESCAN ("rescan LUN/target") is used if
    a target or logical unit has just appeared on the device.

  The "removed" and "rescan" events, when sent for LUN 0, may
  apply to the entire target. After receiving them the driver
  should ask the initiator to rescan the target, in order to
  detect the case when an entire target has appeared or
  disappeared.

  Events will also be reported via sense codes (this obviously
  does not apply to newly appeared buses or targets, since the
  application has never discovered them):

  * "LUN/target removed" maps to sense key ILLEGAL REQUEST, asc
    0x25, ascq 0x00 (LOGICAL UNIT NOT SUPPORTED)

  * "LUN hard reset" maps to sense key UNIT ATTENTION, asc 0x29
    (POWER ON, RESET OR BUS DEVICE RESET OCCURRED)

  * "rescan LUN/target" maps to sense key UNIT ATTENTION, asc
    0x3f, ascq 0x0e (REPORTED LUNS DATA HAS CHANGED)

  The preferred way to detect transport reset is always to use
  events, because sense codes are only seen by the driver when it
  sends a SCSI command to the logical unit or target. However, in
  case events are dropped, the initiator will still be able to
  synchronize with the actual state of the controller if the
  driver asks the initiator to rescan of the SCSI bus. During the
  rescan, the initiator will be able to observe the above sense
  codes, and it will process them as if it the driver had
  received the equivalent event.

* Asynchronous notification

    #define VIRTIO_SCSI_T_ASYNC_NOTIFY     2

    struct virtio_scsi_an_event {
        u32 event;
        u8  lun[8];
        u32 reason;
    }

  By sending this event, the device signals that an asynchronous
  event was fired from a physical interface.

  All fields are written by the device. The event field is set to
  VIRTIO_SCSI_T_ASYNC_NOTIFY. The lun field addresses a logical
  unit in the SCSI host. The reason field is a subset of the
  events that the driver has subscribed to via the "Asynchronous
  notification subscription" command.

  When dropped events are reported, the driver should poll for
  asynchronous events manually using SCSI commands.

