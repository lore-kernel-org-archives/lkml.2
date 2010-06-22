Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0FVRCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:02:52 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:52684 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321Ab0FVRCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:02:50 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
       Benjamin Tissoires <tissoire@cena.fr>,
       Chase Douglas <chase.douglas@canonical.com>,
       Rafi Rubin <rafi@seas.upenn.edu>, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: Document the MT event slot protocol (rev5b)
Date: Tue, 22 Jun 2010 19:02:06 +0200
Message-Id: <1277226126-3801-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OR6ri-00007Z-3k.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OR6ri-00007Z-3k 7c786bc3d2be108f2e6ac1b0557ce306
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation for the ABS_MT_SLOT event and gives
examples of how to use the event slot protocol.

Reviewed-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Dmitry,

This version contains a small adjustment regarding the use of
ABS_MT_TRACKING_ID. The previous version of the document allowed any
id outside the range specified by the device to denote an unused
slot. This is difficult to handle in userspace, since the valid range
is unknown. The change here presented tightens the definition of a
valid ABS_MT_TRACKING_ID to be a non-negative number, and explicitly
states to use -1 to denote an unused slot.

Ping, I left your reviewed-by in there, I hope that is alright.

Thanks,
Henrik

 Documentation/input/multi-touch-protocol.txt |  217 ++++++++++++++++++--------
 1 files changed, 148 insertions(+), 69 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index c0fc1c7..3ab038d 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -6,31 +6,148 @@ Multi-touch (MT) Protocol
 Introduction
 ------------
 
-In order to utilize the full power of the new multi-touch devices, a way to
-report detailed finger data to user space is needed. This document
-describes the multi-touch (MT) protocol which allows kernel drivers to
-report details for an arbitrary number of fingers.
+In order to utilize the full power of the new multi-touch and multi-user
+devices, a way to report detailed data from multiple contacts, i.e.,
+objects in direct contact with the device surface, is needed.  This
+document describes the multi-touch (MT) protocol which allows kernel
+drivers to report details for an arbitrary number of contacts.
+
+The protocol is divided into two types, depending on the capabilities of the
+hardware. For devices handling anonymous contacts (type A), the protocol
+describes how to send the raw data for all contacts to the receiver. For
+devices capable of tracking identifiable contacts (type B), the protocol
+describes how to send updates for individual contacts via event slots.
+
+
+Protocol Usage
+--------------
+
+Contact details are sent sequentially as separate packets of ABS_MT
+events. Only the ABS_MT events are recognized as part of a contact
+packet. Since these events are ignored by current single-touch (ST)
+applications, the MT protocol can be implemented on top of the ST protocol
+in an existing driver.
+
+Drivers for type A devices separate contact packets by calling
+input_mt_sync() at the end of each packet. This generates a SYN_MT_REPORT
+event, which instructs the receiver to accept the data for the current
+contact and prepare to receive another.
+
+Drivers for type B devices separate contact packets by calling
+input_mt_slot(), with a slot as argument, at the beginning of each packet.
+This generates an ABS_MT_SLOT event, which instructs the receiver to
+prepare for updates of the given slot.
+
+All drivers mark the end of a multi-touch transfer by calling the usual
+input_sync() function. This instructs the receiver to act upon events
+accumulated since last EV_SYN/SYN_REPORT and prepare to receive a new set
+of events/packets.
+
+The main difference between the raw type A protocol and the higher level
+type B slot protocol lies in the usage of identifiable contacts. The slot
+protocol requires the use of the ABS_MT_TRACKING_ID, either provided by the
+hardware or computed from the raw data [5].
+
+For type A devices, the kernel driver should generate an arbitrary
+enumeration of the set of anonymous contacts currently on the surface. The
+order in which the packets appear in the event stream is not important.
+Event filtering and finger tracking is left to user space [3].
+
+For type B devices, the kernel driver should associate a slot with each
+identified contact, and use that slot to propagate changes for the contact.
+Creation, replacement and destruction of contacts is achieved by modifying
+the ABS_MT_TRACKING_ID of the associated slot.  A non-negative tracking id
+is interpreted as a contact, and the value -1 denotes an unused slot.  A
+tracking id not previously present is considered new, and a tracking id no
+longer present is considered removed.  Since only changes are propagated,
+the full state of each initiated contact has to reside in the receiving
+end.  Upon receiving an MT event, one simply updates the appropriate
+attribute of the current slot.
+
+
+Protocol Example A
+------------------
+
+Here is what a minimal event sequence for a two-contact touch would look
+like for a type A device:
+
+   ABS_MT_POSITION_X x[0]
+   ABS_MT_POSITION_Y y[0]
+   SYN_MT_REPORT
+   ABS_MT_POSITION_X x[1]
+   ABS_MT_POSITION_Y y[1]
+   SYN_MT_REPORT
+   SYN_REPORT
 
+The sequence after moving one of the contacts looks exactly the same; the
+raw data for all present contacts are sent between every synchronization
+with SYN_REPORT.
 
-Usage
------
+Here is the sequence after lifting the first contact:
+
+   ABS_MT_POSITION_X x[1]
+   ABS_MT_POSITION_Y y[1]
+   SYN_MT_REPORT
+   SYN_REPORT
+
+And here is the sequence after lifting the second contact:
+
+   SYN_MT_REPORT
+   SYN_REPORT
+
+If the driver reports one of BTN_TOUCH or ABS_PRESSURE in addition to the
+ABS_MT events, the last SYN_MT_REPORT event may be omitted. Otherwise, the
+last SYN_REPORT will be dropped by the input core, resulting in no
+zero-contact event reaching userland.
 
-Anonymous finger details are sent sequentially as separate packets of ABS
-events. Only the ABS_MT events are recognized as part of a finger
-packet. The end of a packet is marked by calling the input_mt_sync()
-function, which generates a SYN_MT_REPORT event. This instructs the
-receiver to accept the data for the current finger and prepare to receive
-another. The end of a multi-touch transfer is marked by calling the usual
-input_sync() function. This instructs the receiver to act upon events
-accumulated since last EV_SYN/SYN_REPORT and prepare to receive a new
-set of events/packets.
+
+Protocol Example B
+------------------
+
+Here is what a minimal event sequence for a two-contact touch would look
+like for a type B device:
+
+   ABS_MT_SLOT 0
+   ABS_MT_TRACKING_ID 45
+   ABS_MT_POSITION_X x[0]
+   ABS_MT_POSITION_Y y[0]
+   ABS_MT_SLOT 1
+   ABS_MT_TRACKING_ID 46
+   ABS_MT_POSITION_X x[1]
+   ABS_MT_POSITION_Y y[1]
+   SYN_REPORT
+
+Here is the sequence after moving contact 45 in the x direction:
+
+   ABS_MT_SLOT 0
+   ABS_MT_POSITION_X x[0]
+   SYN_REPORT
+
+Here is the sequence after lifting the contact in slot 0:
+
+   ABS_MT_TRACKING_ID -1
+   SYN_REPORT
+
+The slot being modified is already 0, so the ABS_MT_SLOT is omitted.  The
+message removes the association of slot 0 with contact 45, thereby
+destroying contact 45 and freeing slot 0 to be reused for another contact.
+
+Finally, here is the sequence after lifting the second contact:
+
+   ABS_MT_SLOT 1
+   ABS_MT_TRACKING_ID -1
+   SYN_REPORT
+
+
+Event Usage
+-----------
 
 A set of ABS_MT events with the desired properties is defined. The events
 are divided into categories, to allow for partial implementation.  The
 minimum set consists of ABS_MT_POSITION_X and ABS_MT_POSITION_Y, which
-allows for multiple fingers to be tracked.  If the device supports it, the
+allows for multiple contacts to be tracked.  If the device supports it, the
 ABS_MT_TOUCH_MAJOR and ABS_MT_WIDTH_MAJOR may be used to provide the size
-of the contact area and approaching finger, respectively.
+of the contact area and approaching contact, respectively.
 
 The TOUCH and WIDTH parameters have a geometrical interpretation; imagine
 looking through a window at someone gently holding a finger against the
@@ -41,56 +158,26 @@ ABS_MT_TOUCH_MAJOR, the diameter of the outer region is
 ABS_MT_WIDTH_MAJOR. Now imagine the person pressing the finger harder
 against the glass. The inner region will increase, and in general, the
 ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR, which is always smaller than
-unity, is related to the finger pressure. For pressure-based devices,
+unity, is related to the contact pressure. For pressure-based devices,
 ABS_MT_PRESSURE may be used to provide the pressure on the contact area
 instead.
 
-In addition to the MAJOR parameters, the oval shape of the finger can be
+In addition to the MAJOR parameters, the oval shape of the contact can be
 described by adding the MINOR parameters, such that MAJOR and MINOR are the
 major and minor axis of an ellipse. Finally, the orientation of the oval
 shape can be describe with the ORIENTATION parameter.
 
 The ABS_MT_TOOL_TYPE may be used to specify whether the touching tool is a
-finger or a pen or something else.  Devices with more granular information
+contact or a pen or something else.  Devices with more granular information
 may specify general shapes as blobs, i.e., as a sequence of rectangular
 shapes grouped together by an ABS_MT_BLOB_ID. Finally, for the few devices
 that currently support it, the ABS_MT_TRACKING_ID event may be used to
-report finger tracking from hardware [5].
+report contact tracking from hardware [5].
 
-Here is what a minimal event sequence for a two-finger touch would look
-like:
-
-   ABS_MT_POSITION_X
-   ABS_MT_POSITION_Y
-   SYN_MT_REPORT
-   ABS_MT_POSITION_X
-   ABS_MT_POSITION_Y
-   SYN_MT_REPORT
-   SYN_REPORT
-
-Here is the sequence after lifting one of the fingers:
-
-   ABS_MT_POSITION_X
-   ABS_MT_POSITION_Y
-   SYN_MT_REPORT
-   SYN_REPORT
-
-And here is the sequence after lifting the remaining finger:
-
-   SYN_MT_REPORT
-   SYN_REPORT
-
-If the driver reports one of BTN_TOUCH or ABS_PRESSURE in addition to the
-ABS_MT events, the last SYN_MT_REPORT event may be omitted. Otherwise, the
-last SYN_REPORT will be dropped by the input core, resulting in no
-zero-finger event reaching userland.
 
 Event Semantics
 ---------------
 
-The word "contact" is used to describe a tool which is in direct contact
-with the surface. A finger, a pen or a rubber all classify as contacts.
-
 ABS_MT_TOUCH_MAJOR
 
 The length of the major axis of the contact. The length should be given in
@@ -157,15 +244,16 @@ MT_TOOL_PEN [2].
 ABS_MT_BLOB_ID
 
 The BLOB_ID groups several packets together into one arbitrarily shaped
-contact. This is a low-level anonymous grouping, and should not be confused
-with the high-level trackingID [5]. Most kernel drivers will not have blob
-capability, and can safely omit the event.
+contact. This is a low-level anonymous grouping for type A devices, and
+should not be confused with the high-level trackingID [5]. Most type A
+devices do not have blob capability, so drivers can safely omit this event.
 
 ABS_MT_TRACKING_ID
 
 The TRACKING_ID identifies an initiated contact throughout its life cycle
-[5]. There are currently only a few devices that support it, so this event
-should normally be omitted.
+[5]. This event is mandatory for type B devices. The value range of the
+TRACKING_ID should be large enough to ensure unique identification of a
+contact maintained over an extended period of time.
 
 
 Event Computation
@@ -192,20 +280,11 @@ finger along the X axis (1).
 Finger Tracking
 ---------------
 
-The kernel driver should generate an arbitrary enumeration of the set of
-anonymous contacts currently on the surface. The order in which the packets
-appear in the event stream is not important.
-
 The process of finger tracking, i.e., to assign a unique trackingID to each
-initiated contact on the surface, is left to user space; preferably the
-multi-touch X driver [3]. In that driver, the trackingID stays the same and
-unique until the contact vanishes (when the finger leaves the surface). The
-problem of assigning a set of anonymous fingers to a set of identified
-fingers is a euclidian bipartite matching problem at each event update, and
-relies on a sufficiently rapid update rate.
-
-There are a few devices that support trackingID in hardware. User space can
-make use of these native identifiers to reduce bandwidth and cpu usage.
+initiated contact on the surface, is a Euclidian Bipartite Matching
+problem.  At each event synchronization, the set of actual contacts is
+matched to the set of contacts from the previous synchronization. A full
+implementation can be found in [3].
 
 
 Gestures
-- 
1.6.3.3

