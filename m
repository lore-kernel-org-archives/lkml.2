Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2F0IZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:25:01 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:35140 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2F0IYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:24:53 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmY7AA/D6k9V5qg+PGdsb2JhbABFtiMZAQEBATc0gnUTAQ8YgQIKGhOID7lOFJEtA5ZEhFOMfw
X-IronPort-AV: E=Sophos;i="4.77,483,1336341600"; 
   d="scan'208";a="142751869"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr,
        benjamin.tissoires@gmail.com, peter.hutterer@who-t.net,
        chasedouglas@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Input: MT - Include win8 support
Date: Wed, 27 Jun 2012 10:28:10 +0200
Message-Id: <1340785690-13652-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly released HID protocol for win8 multitouch devices is capable
of transmitting more information about each touch. In particular, it
includes details useful for touch alignment. This patch completes the
MT protocol with the ABS_MT_TOOL_X/Y events, and documents how to map
win8 devices.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi all,

Here is the patch following the RFC on win8 MT support. An ascii-art
version of the figure has been included, Peter's orientation text is
there, and the usage section has been extended with more semantics and
mappings. Hopefully the similarities and differences between the
models are clearer now. Also, the usage of azimuth has been left out,
awaiting an actual device using it.

Cheers,
Henrik

 Documentation/input/multi-touch-protocol.txt | 118 +++++++++++++++++++++------
 include/linux/input.h                        |   8 +-
 2 files changed, 97 insertions(+), 29 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index 543101c..2c17961 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -162,26 +162,48 @@ are divided into categories, to allow for partial implementation.  The
 minimum set consists of ABS_MT_POSITION_X and ABS_MT_POSITION_Y, which
 allows for multiple contacts to be tracked.  If the device supports it, the
 ABS_MT_TOUCH_MAJOR and ABS_MT_WIDTH_MAJOR may be used to provide the size
-of the contact area and approaching contact, respectively.
+of the contact area and approaching tool, respectively.
 
 The TOUCH and WIDTH parameters have a geometrical interpretation; imagine
 looking through a window at someone gently holding a finger against the
 glass.  You will see two regions, one inner region consisting of the part
 of the finger actually touching the glass, and one outer region formed by
-the perimeter of the finger. The diameter of the inner region is the
-ABS_MT_TOUCH_MAJOR, the diameter of the outer region is
-ABS_MT_WIDTH_MAJOR. Now imagine the person pressing the finger harder
-against the glass. The inner region will increase, and in general, the
-ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR, which is always smaller than
-unity, is related to the contact pressure. For pressure-based devices,
+the perimeter of the finger. The center of the touching region (a) is
+ABS_MT_POSITION_X/Y and the center of the approaching finger (b) is
+ABS_MT_TOOL_X/Y. The touch diameter is ABS_MT_TOUCH_MAJOR and the finger
+diameter is ABS_MT_WIDTH_MAJOR. Now imagine the person pressing the finger
+harder against the glass. The touch region will increase, and in general,
+the ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR, which is always smaller
+than unity, is related to the contact pressure. For pressure-based devices,
 ABS_MT_PRESSURE may be used to provide the pressure on the contact area
 instead. Devices capable of contact hovering can use ABS_MT_DISTANCE to
 indicate the distance between the contact and the surface.
 
-In addition to the MAJOR parameters, the oval shape of the contact can be
-described by adding the MINOR parameters, such that MAJOR and MINOR are the
-major and minor axis of an ellipse. Finally, the orientation of the oval
-shape can be describe with the ORIENTATION parameter.
+
+	  Linux MT                               Win8
+         __________                     _______________________
+        /          \                   |                       |
+       /            \                  |                       |
+      /     ____     \                 |                       |
+     /     /    \     \                |                       |
+     \     \  a  \     \               |       a               |
+      \     \____/      \              |                       |
+       \                 \             |                       |
+        \        b        \            |           b           |
+         \                 \           |                       |
+          \                 \          |                       |
+           \                 \         |                       |
+            \                /         |                       |
+             \              /          |                       |
+              \            /           |                       |
+               \__________/            |_______________________|
+
+
+In addition to the MAJOR parameters, the oval shape of the touch and finger
+regions can be described by adding the MINOR parameters, such that MAJOR
+and MINOR are the major and minor axis of an ellipse. The orientation of
+the touch ellipse can be described with the ORIENTATION parameter, and the
+direction of the finger ellipse is given by the vector (a - b).
 
 For type A devices, further specification of the touch shape is possible
 via ABS_MT_BLOB_ID.
@@ -224,7 +246,7 @@ tool. Omit if circular [4].
 The above four values can be used to derive additional information about
 the contact. The ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR approximates
 the notion of pressure. The fingers of the hand and the palm all have
-different characteristic widths [1].
+different characteristic widths.
 
 ABS_MT_PRESSURE
 
@@ -240,17 +262,24 @@ the contact is hovering above the surface.
 
 ABS_MT_ORIENTATION
 
-The orientation of the ellipse. The value should describe a signed quarter
-of a revolution clockwise around the touch center. The signed value range
-is arbitrary, but zero should be returned for a finger aligned along the Y
-axis of the surface, a negative value when finger is turned to the left, and
-a positive value when finger turned to the right. When completely aligned with
-the X axis, the range max should be returned.  Orientation can be omitted
-if the touching object is circular, or if the information is not available
-in the kernel driver. Partial orientation support is possible if the device
-can distinguish between the two axis, but not (uniquely) any values in
-between. In such cases, the range of ABS_MT_ORIENTATION should be [0, 1]
-[4].
+The orientation of the touching ellipse. The value should describe a signed
+quarter of a revolution clockwise around the touch center. The signed value
+range is arbitrary, but zero should be returned for an ellipse aligned with
+the Y axis of the surface, a negative value when the ellipse is turned to
+the left, and a positive value when the ellipse is turned to the
+right. When completely aligned with the X axis, the range max should be
+returned.
+
+Touch ellipsis are symmetrical by default. For devices capable of true 360
+degree orientation, the reported orientation must exceed the range max to
+indicate more than a quarter of a revolution. For an upside-down finger,
+range max * 2 should be returned.
+
+Orientation can be omitted if the touch area is circular, or if the
+information is not available in the kernel driver. Partial orientation
+support is possible if the device can distinguish between the two axis, but
+not (uniquely) any values in between. In such cases, the range of
+ABS_MT_ORIENTATION should be [0, 1] [4].
 
 ABS_MT_POSITION_X
 
@@ -260,6 +289,23 @@ ABS_MT_POSITION_Y
 
 The surface Y coordinate of the center of the touching ellipse.
 
+ABS_MT_TOOL_X
+
+The surface X coordinate of the center of the approaching tool. Omit if
+the device cannot distinguish between the intended touch point and the
+tool itself.
+
+ABS_MT_TOOL_Y
+
+The surface Y coordinate of the center of the approaching tool. Omit if the
+device cannot distinguish between the intended touch point and the tool
+itself.
+
+The four position values can be used to separate the position of the touch
+from the position of the tool. If both positions are present, the major
+tool axis points towards the touch point [1]. Otherwise, the tool axes are
+aligned with the touch axes.
+
 ABS_MT_TOOL_TYPE
 
 The type of approaching tool. A lot of kernel drivers cannot distinguish
@@ -305,6 +351,28 @@ The range of ABS_MT_ORIENTATION should be set to [0, 1], to indicate that
 the device can distinguish between a finger along the Y axis (0) and a
 finger along the X axis (1).
 
+For win8 devices with both T and C coordinates, the position mapping is
+
+   ABS_MT_POSITION_X := T_X
+   ABS_MT_POSITION_Y := T_Y
+   ABS_MT_TOOL_X := C_X
+   ABS_MT_TOOL_X := C_Y
+
+Unfortunately, there is not enough information to specify both the touching
+ellipse and the tool ellipse, so one has to resort to approximations.  One
+simple scheme, which is compatible with earlier usage, is:
+
+   ABS_MT_TOUCH_MAJOR := min(X, Y)
+   ABS_MT_TOUCH_MINOR := <not used>
+   ABS_MT_ORIENTATION := <not used>
+   ABS_MT_WIDTH_MAJOR := min(X, Y) + distance(T, C)
+   ABS_MT_WIDTH_MINOR := min(X, Y)
+
+Rationale: We have no information about the orientation of the touching
+ellipse, so approximate it with an inscribed circle instead. The tool
+ellipse should align with the the vector (T - C), so the diameter must
+increase with distance(T, C). Finally, assume that the touch diameter is
+equal to the tool thickness, and we arrive at the formulas above.
 
 Finger Tracking
 ---------------
@@ -338,9 +406,7 @@ subsequent events of the same type refer to different fingers.
 For example usage of the type A protocol, see the bcm5974 driver. For
 example usage of the type B protocol, see the hid-egalax driver.
 
-[1] With the extension ABS_MT_APPROACH_X and ABS_MT_APPROACH_Y, the
-difference between the contact position and the approaching tool position
-could be used to derive tilt.
+[1] Also, the difference (TOOL_X - POSITION_X) can be used to model tilt.
 [2] The list can of course be extended.
 [3] The mtdev project: http://bitmath.org/code/mtdev/.
 [4] See the section on event computation.
diff --git a/include/linux/input.h b/include/linux/input.h
index a816714..cacb953 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -806,18 +806,20 @@ struct input_keymap_entry {
 #define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
 #define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis (omit if circular) */
 #define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
-#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
-#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
+#define ABS_MT_POSITION_X	0x35	/* Center X touch position */
+#define ABS_MT_POSITION_Y	0x36	/* Center Y touch position */
 #define ABS_MT_TOOL_TYPE	0x37	/* Type of touching device */
 #define ABS_MT_BLOB_ID		0x38	/* Group a set of packets as a blob */
 #define ABS_MT_TRACKING_ID	0x39	/* Unique ID of initiated contact */
 #define ABS_MT_PRESSURE		0x3a	/* Pressure on contact area */
 #define ABS_MT_DISTANCE		0x3b	/* Contact hover distance */
+#define ABS_MT_TOOL_X		0x3c	/* Center X tool position */
+#define ABS_MT_TOOL_Y		0x3d	/* Center Y tool position */
 
 #ifdef __KERNEL__
 /* Implementation details, userspace should not care about these */
 #define ABS_MT_FIRST		ABS_MT_TOUCH_MAJOR
-#define ABS_MT_LAST		ABS_MT_DISTANCE
+#define ABS_MT_LAST		ABS_MT_TOOL_Y
 #endif
 
 #define ABS_MAX			0x3f
-- 
1.7.11

