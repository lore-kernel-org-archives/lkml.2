Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0ESCl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:41:28 -0400
Received: from leo.clearchain.com ([199.73.29.74]:31319 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0ESCl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:41:27 -0400
Date: Wed, 19 May 2010 12:37:27 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
Message-ID: <20100519023727.GA21030@barra.bne.redhat.com>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274213429-22667-2-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Wed, 19 May 2010 12:10:27 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 10:10:29PM +0200, Henrik Rydberg wrote:
> This patch adds documentation for the SYN_MT_SLOT event and gives
> examples of how to use the event slot protocol.

thanks, this is really nice documentation! the approach seems good, though I
do have a few questions inline.

> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  Documentation/input/multi-touch-protocol.txt |  201 ++++++++++++++++++--------
>  1 files changed, 137 insertions(+), 64 deletions(-)
> 
> diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
> index c0fc1c7..100aec0 100644
> --- a/Documentation/input/multi-touch-protocol.txt
> +++ b/Documentation/input/multi-touch-protocol.txt
> @@ -6,31 +6,143 @@ Multi-touch (MT) Protocol
>  Introduction
>  ------------
>  
> -In order to utilize the full power of the new multi-touch devices, a way to
> -report detailed finger data to user space is needed. This document
> -describes the multi-touch (MT) protocol which allows kernel drivers to
> -report details for an arbitrary number of fingers.
> +In order to utilize the full power of the new multi-touch and multi-user
> +devices, a way to report detailed data from multiple contacts, i.e.,
> +objects in direct contact with the device surface, is needed.  This
> +document describes the multi-touch (MT) protocol which allows kernel
> +drivers to report details for an arbitrary number of contacts.
> +
> +The protocol is divided into two types, depending on the capabilities of the
> +hardware. For devices handling anonymous contacts (type A), the protocol
> +describes how to send the raw data for all contacts to the receiver. For
> +devices capable of tracking identifiable contacts (type B), the protocol
> +describes how to send updates for individual contacts via event slots.
> +
> +
> +Protocol Usage
> +--------------
> +
> +Contact details are sent sequentially as separate packets of ABS_MT
> +events. Only the ABS_MT events are recognized as part of a contact
> +packet. Since these events are ignored by current single-touch (ST)
> +applications, the MT protocol can be implemented on top of the ST protocol
> +in an existing driver.
> +
> +Drivers for type A devices mark the end of a packet by calling the
> +input_mt_sync() function, which generates a SYN_MT_REPORT event. This
> +instructs the receiver to accept the data for the current contact and
> +prepare to receive another. Drivers for type B devices mark the beginning
> +of a packet by calling the input_mt_slot() function with a slot as
> +argument, which generates a SYN_MT_SLOT event. This instructs the receiver
> +to prepare for updates of the given slot.
> +
> +The end of a multi-touch transfer is marked by calling the usual
> +input_sync() function. This instructs the receiver to act upon events
> +accumulated since last EV_SYN/SYN_REPORT and prepare to receive a new set
> +of events/packets.
>  
> +The main difference between the raw type A protocol and the higher level
> +type B slot protocol lies in the usage of identifiable contacts. The slot
> +protocol requires the use of the ABS_MT_TRACKING_ID, either provided by the
> +hardware of computed from the raw data [5].
>  
> -Usage
> ------
> +For type A devices, the kernel driver should generate an arbitrary
> +enumeration of the set of anonymous contacts currently on the surface. The
> +order in which the packets appear in the event stream is not important.
> +Event filtering and finger tracking is left to user space [3].
>  
> -Anonymous finger details are sent sequentially as separate packets of ABS
> -events. Only the ABS_MT events are recognized as part of a finger
> -packet. The end of a packet is marked by calling the input_mt_sync()
> -function, which generates a SYN_MT_REPORT event. This instructs the
> -receiver to accept the data for the current finger and prepare to receive
> -another. The end of a multi-touch transfer is marked by calling the usual
> -input_sync() function. This instructs the receiver to act upon events
> -accumulated since last EV_SYN/SYN_REPORT and prepare to receive a new
> -set of events/packets.
> +For type B devices, the kernel driver should associate a slot with each
> +identified contact, and use that slot to propagate changes for the contact.
> +Creation, replacement and destruction of contacts is achieved by modifying
> +the ABS_MT_TRACKING_ID of the associated slot.  Since only changes are
> +propagated, the full state of each initiated contact has to reside in the
> +receiving end.  Upon receiving an MT event, one simply updates the
> +appropriate attribute of the active slot.

Is there a limit on the number of slots?
Will all drivers with ABS_MT_TRACKING_ID use slots? if not, how can I know
in advance if a device may use slots or not?

[...]
> +
> +Protocol Example B
> +------------------
> +
> +Here is what a minimal event sequence for a two-contact touch would look
> +like for a type B device:
> +
> +   SYN_MT_SLOT 0
> +   ABS_MT_TRACKING_ID 45
> +   ABS_MT_POSITION_X x[0]
> +   ABS_MT_POSITION_Y y[0]
> +   SYN_MT_SLOT 1
> +   ABS_MT_TRACKING_ID 46
> +   ABS_MT_POSITION_X x[1]
> +   ABS_MT_POSITION_Y y[1]
> +   SYN_REPORT
> +
> +Here is the sequence after moving contact 45 in the x direction:
> +
> +   SYN_MT_SLOT 0
> +   ABS_MT_POSITION_X x[0]
> +   SYN_REPORT
> +
> +Here is the sequence after lifting the contact in slot 0:
> +
> +   ABS_MT_TRACKING_ID 0
> +   SYN_REPORT
> +
> +The active slot is already 0, so the SYN_MT_SLOT is omitted.  The message
> +removes the association of slot 0 with contact 45, thereby destroying
> +contact 45 and freeing slot 0 to be reused for another contact.

I'm probably missing something here, but how would a process know which one
is the active slot if it didn't get the previous event?

Cheers,
  Peter

> +
> +Finally, here is the sequence after lifting the second contact:
> +
> +   SYN_MT_SLOT 1
> +   ABS_MT_TRACKING_ID 0
> +   SYN_REPORT
> +
> +
> +Event Usage
> +-----------
>  
>  A set of ABS_MT events with the desired properties is defined. The events
>  are divided into categories, to allow for partial implementation.  The
>  minimum set consists of ABS_MT_POSITION_X and ABS_MT_POSITION_Y, which
> -allows for multiple fingers to be tracked.  If the device supports it, the
> +allows for multiple contacts to be tracked.  If the device supports it, the
>  ABS_MT_TOUCH_MAJOR and ABS_MT_WIDTH_MAJOR may be used to provide the size
> -of the contact area and approaching finger, respectively.
> +of the contact area and approaching contact, respectively.
>  
>  The TOUCH and WIDTH parameters have a geometrical interpretation; imagine
>  looking through a window at someone gently holding a finger against the
> @@ -41,56 +153,26 @@ ABS_MT_TOUCH_MAJOR, the diameter of the outer region is
>  ABS_MT_WIDTH_MAJOR. Now imagine the person pressing the finger harder
>  against the glass. The inner region will increase, and in general, the
>  ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR, which is always smaller than
> -unity, is related to the finger pressure. For pressure-based devices,
> +unity, is related to the contact pressure. For pressure-based devices,
>  ABS_MT_PRESSURE may be used to provide the pressure on the contact area
>  instead.
>  
> -In addition to the MAJOR parameters, the oval shape of the finger can be
> +In addition to the MAJOR parameters, the oval shape of the contact can be
>  described by adding the MINOR parameters, such that MAJOR and MINOR are the
>  major and minor axis of an ellipse. Finally, the orientation of the oval
>  shape can be describe with the ORIENTATION parameter.
>  
>  The ABS_MT_TOOL_TYPE may be used to specify whether the touching tool is a
> -finger or a pen or something else.  Devices with more granular information
> +contact or a pen or something else.  Devices with more granular information
>  may specify general shapes as blobs, i.e., as a sequence of rectangular
>  shapes grouped together by an ABS_MT_BLOB_ID. Finally, for the few devices
>  that currently support it, the ABS_MT_TRACKING_ID event may be used to
> -report finger tracking from hardware [5].
> -
> -Here is what a minimal event sequence for a two-finger touch would look
> -like:
> +report contact tracking from hardware [5].
>  
> -   ABS_MT_POSITION_X
> -   ABS_MT_POSITION_Y
> -   SYN_MT_REPORT
> -   ABS_MT_POSITION_X
> -   ABS_MT_POSITION_Y
> -   SYN_MT_REPORT
> -   SYN_REPORT
> -
> -Here is the sequence after lifting one of the fingers:
> -
> -   ABS_MT_POSITION_X
> -   ABS_MT_POSITION_Y
> -   SYN_MT_REPORT
> -   SYN_REPORT
> -
> -And here is the sequence after lifting the remaining finger:
> -
> -   SYN_MT_REPORT
> -   SYN_REPORT
> -
> -If the driver reports one of BTN_TOUCH or ABS_PRESSURE in addition to the
> -ABS_MT events, the last SYN_MT_REPORT event may be omitted. Otherwise, the
> -last SYN_REPORT will be dropped by the input core, resulting in no
> -zero-finger event reaching userland.
>  
>  Event Semantics
>  ---------------
>  
> -The word "contact" is used to describe a tool which is in direct contact
> -with the surface. A finger, a pen or a rubber all classify as contacts.
> -
>  ABS_MT_TOUCH_MAJOR
>  
>  The length of the major axis of the contact. The length should be given in
> @@ -192,20 +274,11 @@ finger along the X axis (1).
>  Finger Tracking
>  ---------------
>  
> -The kernel driver should generate an arbitrary enumeration of the set of
> -anonymous contacts currently on the surface. The order in which the packets
> -appear in the event stream is not important.
> -
>  The process of finger tracking, i.e., to assign a unique trackingID to each
> -initiated contact on the surface, is left to user space; preferably the
> -multi-touch X driver [3]. In that driver, the trackingID stays the same and
> -unique until the contact vanishes (when the finger leaves the surface). The
> -problem of assigning a set of anonymous fingers to a set of identified
> -fingers is a euclidian bipartite matching problem at each event update, and
> -relies on a sufficiently rapid update rate.
> -
> -There are a few devices that support trackingID in hardware. User space can
> -make use of these native identifiers to reduce bandwidth and cpu usage.
> +initiated contact on the surface, is a Euclidian Bipartite Matching
> +problem.  At each event synchronization, the set of actual contacts are
> +matched to the set of contacts from the previos synchronization. A full
> +implementation can be found in [3].
>  
>  
>  Gestures
> -- 
> 1.6.3.3
> 
