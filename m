Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1AGV2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:28:23 -0500
Received: from adelie.canonical.com ([91.189.90.139]:57518 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1AGV2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:28:21 -0500
From: Chase Douglas <chase.douglas@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Nikolai Kondrashov <spbnick@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] Documentation: Add evdev type and code definitions
Date: Fri,  7 Jan 2011 16:28:15 -0500
Message-Id: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds the file Documentation/input/evdev-codes.txt.

Cc: Henrik Rydberg <rydberg@euromail.se>
Cc: Chris Bagwell <chris@cnpbagwell.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Nikolai Kondrashov <spbnick@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 Documentation/input/evdev-codes.txt |  206 +++++++++++++++++++++++++++++++++++
 1 files changed, 206 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/input/evdev-codes.txt

diff --git a/Documentation/input/evdev-codes.txt b/Documentation/input/evdev-codes.txt
new file mode 100644
index 0000000..8d7262c
--- /dev/null
+++ b/Documentation/input/evdev-codes.txt
@@ -0,0 +1,206 @@
+The evdev protocol uses a map of types and codes to express input device values
+to userspace. This document describes the types and codes and how and when they
+may be used.
+
+The evdev protocol is a stateful protocol. Events are emitted only when values
+of evdev codes have changed. However, the state is maintained within the Linux
+input subsystem; drivers do not need to maintain the state and may attempt to
+emit unchanged values without harm. Userspace may obtain the current state of
+evdev code values using the EVIOCGABS ioctl defined in linux/input.h.
+
+Types:
+==========
+Types are groupings of codes under a logical input construct. Each type has a
+set of applicable codes to be used in generating events. See the Codes section
+for details on valid codes for each type.
+
+* EV_SYN:
+  - Used as markers to separate events. Events may be separated in time or in
+    space, such as with the multitouch protocol.
+
+* EV_KEY:
+  - Used to describe keyboard and other key-like input events.
+
+* EV_REL:
+  - Used to describe relative input events, e.g. moving the mouse 5 units to the
+    left.
+
+* EV_ABS:
+  - Used to describe absolute input events, e.g. describing the coordinates of a
+    touch on a touchscreen.
+
+* EV_MSC:
+  - Used to describe miscellaneous input events that do not fit into other
+    types.
+
+* EV_SW:
+  - Used to describe binary state input switches.
+
+* EV_LED:
+  - Used to turn LEDs on devices on and off.
+
+* EV_SND:
+  - Used to output sound to devices.
+
+* EV_REP:
+  - Used for autorepeating devices.
+
+* EV_FF:
+  - Used to send force feedback commands to an input device.
+
+* EV_PWR:
+  - A special type for power button and switch input.
+
+* EV_FF_STATUS:
+  - Used to receive force feedback device status.
+
+Codes:
+==========
+Codes define the precise type of event.
+
+EV_SYN:
+----------
+EV_SYN event values are undefined. Their usage is
+defined only by when they are sent in the evdev event stream.
+
+* SYN_REPORT:
+  - Used to synchronize and separate events into frames of time. For example,
+    motion of a mouse may set the REL_X and REL_Y values for one motion, then
+    emit a SYN_REPORT. The next motion will emit more REL_X and REL_Y values and
+    send another SYN_REPORT.
+
+* SYN_CONFIG:
+  - TBD
+
+* SYN_MT_REPORT:
+  - Used to synchronize and separate touch events. See the
+    multi-touch-protocol.txt document for more information.
+
+EV_KEY:
+----------
+EV_KEY events take the form KEY_<name> or BTN_<name>. For example, KEY_A is used
+to represent the 'A' key on a keyboard. When a key is depressed, an event with
+the key's code is emitted with value 1. When the key is released, an event is
+emitted with value 0. Some hardware send events when a key is repeated. These
+events have a value of 2. In general, KEY_<name> is used for keyboard keys, and
+BTN_<name> is used for other types of momentary switch events.
+
+A few EV_KEY codes have special meanings:
+
+* BTN_TOOL_<name>:
+  - These codes are used in conjunction with input trackpads, tablets, and
+    touchscreens. These devices may be used with fingers, pens, or other tools.
+    When an event occurs and a tool is used, the corresponding BTN_TOOL_<name>
+    code should be set to a value of 1. When the tool is no longer interacting
+    with the input device, the BTN_TOOL_<name> code should be reset to 0. All
+    trackpads, tablets, and touchscreens should use at least one BTN_TOOL_<name>
+    code when events are generated.
+
+* BTN_TOUCH:
+    BTN_TOUCH is used for touch contact. While an input tool is determined to be
+    within meaningful physical contact, the value of this property must be set
+    to 1. Meaningful physical contact may mean any contact, or it may mean
+    contact conditioned by an implementation defined property. For example, a
+    touchpad may set the value to 1 only when the touch pressure rises above a
+    certain value. BTN_TOUCH may be combined with BTN_TOOL_<name> codes. For
+    example, a pen tablet may set BTN_TOOL_PEN to 1 and BTN_TOUCH to 0 while the
+    pen is hovering over but not touching the tablet surface.
+
+Note: For appropriate function of the legacy mousedev emulation driver,
+BTN_TOUCH must be the first evdev code emitted in a synchronization frame.
+
+Note: Historically a touch device with BTN_TOOL_FINGER and BTN_TOUCH was
+interpreted as a touchpad by userspace, while a similar device without
+BTN_TOOL_FINGER was interpreted as a touchscreen. For backwards compatibility
+with current userspace it is recommended to follow this distinction. In the
+future, this distinction will be deprecated and the device properties ioctl
+EVIOCGPROP, defined in linux/input.h, will be used to convey the device type.
+
+* BTN_TOOL_FINGER, BTN_TOOL_DOUBLETAP, BTN_TOOL_TRIPLETAP, BTN_TOOL_QUADTAP:
+  - These codes denote one, two, three, and four finger interaction on a
+    trackpad or touchscreen. For example, if the user uses two fingers and moves
+    them on the touchpad in an effort to scroll content on screen,
+    BTN_TOOL_DOUBLETAP should be set to value 1 for the duration of the motion.
+    Note that these codes and the BTN_TOOL_<name> and BTN_TOUCH codes are
+    orthogonal in purpose. A trackpad event generated by finger touches should
+    generate events for one code from each group. At most only one of these
+    codes should have a value of 1 during any synchronization frame.
+
+Note: Historically some drivers emitted multiple of the finger count codes with
+a value of 1 in the same synchronization frame. This usage is deprecated.
+
+Note: In multitouch drivers, the input_mt_report_finger_count() function should
+be used to emit these codes. Please see multi-touch-protocol.txt for details.
+
+* KEY_SUSPEND, KEY_POWER:
+  - These codes are reserved for the EV_PWR type.
+
+EV_REL:
+----------
+EV_REL events describe relative changes in a property. For example, a mouse may
+move to the left by a certain number of units, but its absolute position in
+space is unknown. If the absolute position is known, EV_ABS codes should be used
+instead of EV_REL codes.
+
+A few EV_REL codes have special meanings:
+
+* REL_WHEEL, REL_HWHEEL:
+  - These codes are used for vertical and horizontal scroll wheels,
+    respectively.
+
+EV_ABS:
+----------
+EV_ABS events describe absolute changes in a property. For example, a touchpad
+may emit coordinates for a touch location.
+
+A few EV_ABS codes have special meanings:
+
+* ABS_DISTANCE:
+  - Used to describe the distance of a tool from an interaction surface. This
+    should only be used while the tool is hovering, meaning in close proximity
+    of the device. If the input device may be used freely in three dimensions,
+    consider ABS_Z instead.
+
+* ABS_MT_<name>:
+  - Used to describe multitouch input events. Please see
+    multi-touch-protocol.txt for details.
+
+EV_SW:
+----------
+EV_SW events describe stateful binary switches. For example, the SW_LID code is
+used to denote when a laptop lid is closed.
+
+EV_MSC:
+----------
+EV_MSC events are used for input and output events that do not fall under other
+categories.
+
+EV_LED:
+----------
+EV_LED events are used for input and output to set and query the state of
+various LEDs on devices.
+
+EV_REP:
+----------
+EV_REP events are used for specifying autorepeating events.
+
+EV_SND:
+----------
+EV_SND events are used for sending sound commands to simple sound output
+devices.
+
+EV_FF:
+----------
+EV_FF events are used to initialize a force feedback capable device and to cause
+such device to feedback.
+
+EV_PWR:
+----------
+EV_PWR events are a special type of key event used specifically for monitoring
+power buttons and switches. The two codes in use are:
+
+* KEY_POWER:
+  - Used to denote a power button event.
+
+* KEY_SUSPEND:
+  - Used to denote a suspend button event.
-- 
1.7.1

