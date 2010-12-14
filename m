Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163Ab0LNVWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:22:21 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60960 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760126Ab0LNVWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:22:20 -0500
From: Chase Douglas <chase.douglas@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Revert "input: mt: Interface and MT_TOOL documentation updates"
Date: Tue, 14 Dec 2010 13:21:09 -0800
Message-Id: <1292361672-2581-2-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new MT_TOOL_ENVELOPE code has ambiguities that may be remedied by
changing to a different interface construct.

This reverts commit e665f5646d4b7d0b470be6afd817edfb43556921.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 Documentation/input/multi-touch-protocol.txt |   39 ++++++++------------------
 include/linux/input.h                        |    6 ++--
 2 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index 5ab352e..351fab8 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -169,14 +169,12 @@ described by adding the MINOR parameters, such that MAJOR and MINOR are the
 major and minor axis of an ellipse. Finally, the orientation of the oval
 shape can be describe with the ORIENTATION parameter.
 
-For type A devices, further specification of the touch shape is possible
-via ABS_MT_BLOB_ID.
-
 The ABS_MT_TOOL_TYPE may be used to specify whether the touching tool is a
-contact or a pen or something else. Finally, the ABS_MT_TRACKING_ID event
-may be used to track identified contacts over time [5]. In the type B
-protocol, the use of ABS_MT_TOOL_TYPE and ABS_MT_TRACKING_ID is implicit
-via the input_mt_report_slot_state() function.
+contact or a pen or something else.  Devices with more granular information
+may specify general shapes as blobs, i.e., as a sequence of rectangular
+shapes grouped together by an ABS_MT_BLOB_ID. Finally, for the few devices
+that currently support it, the ABS_MT_TRACKING_ID event may be used to
+report contact tracking from hardware [5].
 
 
 Event Semantics
@@ -248,35 +246,22 @@ ABS_MT_TOOL_TYPE
 
 The type of approaching tool. A lot of kernel drivers cannot distinguish
 between different tool types, such as a finger or a pen. In such cases, the
-event should be omitted. The protocol currently supports MT_TOOL_FINGER,
-MT_TOOL_PEN and MT_TOOL_ENVELOPE [2]. For type B devices, this event is
-handled by input core, via the input_mt interface.
-
-- The MT_TOOL_FINGER type is the default, and represents a finger touch.
-
-- The MT_TOOL_PEN type represents a pen, and the list of related tools is
-expected to grow with time.
-
-- The MT_TOOL_ENVELOPE type is used to indicate that the contact position
-is not well-defined, and is only used for legacy hardware. The real contact
-positions are to be found within the bounding rectangle formed by the
-envelope contact positions.
+event should be omitted. The protocol currently supports MT_TOOL_FINGER and
+MT_TOOL_PEN and MT_TOOL_ENVELOPE [2].
 
 ABS_MT_BLOB_ID
 
 The BLOB_ID groups several packets together into one arbitrarily shaped
-contact. The sequence of points forms a polygon which defines the shape of
-the contact. This is a low-level anonymous grouping for type A devices, and
+contact. This is a low-level anonymous grouping for type A devices, and
 should not be confused with the high-level trackingID [5]. Most type A
 devices do not have blob capability, so drivers can safely omit this event.
 
 ABS_MT_TRACKING_ID
 
 The TRACKING_ID identifies an initiated contact throughout its life cycle
-[5]. The value range of the TRACKING_ID should be large enough to ensure
-unique identification of a contact maintained over an extended period of
-time. For type B devices, this event is handled by input core, via the
-input_mt interface.
+[5]. This event is mandatory for type B devices. The value range of the
+TRACKING_ID should be large enough to ensure unique identification of a
+contact maintained over an extended period of time.
 
 
 Event Computation
@@ -336,6 +321,6 @@ difference between the contact position and the approaching tool position
 could be used to derive tilt.
 [2] ABS_MT_ENVELOPE contacts represent an envelope of the contacts rather
 than the actual contacts. Used with older, not fully MT capable, devices.
-[3] The mtdev project: http://bitmath.org/code/mtdev/.
+[3] Multitouch X driver project: http://bitmath.org/code/multitouch/.
 [4] See the section on event computation.
 [5] See the section on finger tracking.
diff --git a/include/linux/input.h b/include/linux/input.h
index 787aa7e..cd0618c 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -847,9 +847,9 @@ struct input_keymap_entry {
 /*
  * MT_TOOL types
  */
-#define MT_TOOL_FINGER		0	/* normal finger */
-#define MT_TOOL_PEN		1	/* pen tool */
-#define MT_TOOL_ENVELOPE	2	/* rectangle corner - older hw only */
+#define MT_TOOL_FINGER		0
+#define MT_TOOL_PEN		1
+#define MT_TOOL_ENVELOPE	2
 #define MT_TOOL_MAX		2
 
 /*
-- 
1.7.1

