Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2A3IgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:36:01 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:50268 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2A3If7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:35:59 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtFCACxWJk9V5qrvPGdsb2JhbABDiVKlBBkBAQEBNzKCTxMBDxgwUgoaE4d/uCYTiFMDBAQBCgQNCwgBCQeDKgWBJ4MoBJp/jG0
X-IronPort-AV: E=Sophos;i="4.71,591,1320620400"; 
   d="scan'208";a="40490954"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: [PATCH] Input: Document the device properties
Date: Mon, 30 Jan 2012 09:35:46 +0100
Message-Id: <1327912546-16960-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a section which defines the input device properties and provides
guidelines on how to use them.

Cc: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/event-codes.txt |   67 ++++++++++++++++++++++++++++++----
 1 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
index 23fcb05..856eb0e 100644
--- a/Documentation/input/event-codes.txt
+++ b/Documentation/input/event-codes.txt
@@ -17,11 +17,11 @@ reports supported by a device are also provided by sysfs in
 class/input/event*/device/capabilities/, and the properties of a device are
 provided in class/input/event*/device/properties.
 
-Types:
-==========
-Types are groupings of codes under a logical input construct. Each type has a
-set of applicable codes to be used in generating events. See the Codes section
-for details on valid codes for each type.
+Event types:
+===========
+Event types are groupings of codes under a logical input construct. Each
+type has a set of applicable codes to be used in generating events. See the
+Codes section for details on valid codes for each type.
 
 * EV_SYN:
   - Used as markers to separate events. Events may be separated in time or in
@@ -63,9 +63,9 @@ for details on valid codes for each type.
 * EV_FF_STATUS:
   - Used to receive force feedback device status.
 
-Codes:
-==========
-Codes define the precise type of event.
+Event codes:
+===========
+Event codes define the precise type of event.
 
 EV_SYN:
 ----------
@@ -220,6 +220,51 @@ EV_PWR:
 EV_PWR events are a special type of event used specifically for power
 mangement. Its usage is not well defined. To be addressed later.
 
+Device properties:
+=================
+Normally, userspace sets up an input device based on the data it emits,
+i.e., the event types. In the case of two devices emitting the same event
+types, additional information can be provided in the form of device
+properties.
+
+INPUT_PROP_DIRECT + INPUT_PROP_POINTER:
+--------------------------------------
+The INPUT_PROP_DIRECT property indicates that device coordinates should be
+directly mapped to screen coordinates (not taking into account trivial
+transformations, such as scaling, flipping and rotating). Non-direct input
+devices require non-trivial transformation, such as absolute to relative
+transformation for touchpads. Typical direct input devices: touchscreens,
+drawing tablets; non-direct devices: touchpads, mice.
+
+The INPUT_PROP_POINTER property indicates that the device is not transposed
+on the screen and thus requires use of an on-screen pointer to trace user's
+movements.  Typical pointer devices: touchpads, tablets, mice; non-pointer
+device: touchscreen.
+
+If neither INPUT_PROP_DIRECT or INPUT_PROP_POINTER are set, the property is
+considered undefined and the device type should be deduced in the
+traditional way, using emitted event types.
+
+INPUT_PROP_BUTTONPAD:
+--------------------
+For touchpads where the button is placed under the touchpad, such as
+clickpads and macbooks, this property should be set. Common in devices from
+2009 and onwards.
+
+Originally, the buttonpad property was coded into the bcm5974 driver
+version field under the name integrated button. For backwards
+compatibility, both methods need to be checked in userspace.
+
+INPUT_PROP_SEMI_MT:
+------------------
+Some touchpads, most common between 2008 and 2011, can detect the presence
+of multiple contacts without resolving the individual positions; only the
+number of contacts and the corresponding bounding box is known. For such
+touchpads, the semi-mt property should be set.
+
+If INPUT_PROP_SEMI_MT is not set, the device is assumed to be a true MT
+device.
+
 Guidelines:
 ==========
 The guidelines below ensure proper single-touch and multi-finger functionality.
@@ -240,6 +285,8 @@ used to report when a touch is active on the screen.
 BTN_{MOUSE,LEFT,MIDDLE,RIGHT} must not be reported as the result of touch
 contact. BTN_TOOL_<name> events should be reported where possible.
 
+For new hardware, INPUT_PROP_DIRECT should be set.
+
 Trackpads:
 ----------
 Legacy trackpads that only provide relative position information must report
@@ -250,6 +297,8 @@ location of the touch. BTN_TOUCH should be used to report when a touch is active
 on the trackpad. Where multi-finger support is available, BTN_TOOL_<name> should
 be used to report the number of touches active on the trackpad.
 
+For new hardware, INPUT_PROP_POINTER should be set.
+
 Tablets:
 ----------
 BTN_TOOL_<name> events must be reported when a stylus or other tool is active on
@@ -260,3 +309,5 @@ button may be used for buttons on the tablet except BTN_{MOUSE,LEFT}.
 BTN_{0,1,2,etc} are good generic codes for unlabeled buttons. Do not use
 meaningful buttons, like BTN_FORWARD, unless the button is labeled for that
 purpose on the device.
+
+For new hardware, both INPUT_PROP_DIRECT and INPUT_PROP_POINTER should be set.
-- 
1.7.8.4

