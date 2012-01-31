Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2AaSyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 13:54:32 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:34241 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2AaSya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 13:54:30 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjJNAJ84KE9V5qrvPGdsb2JhbABDiVKlDRkBAQEBHhkNJYJPEwEPGDBSChoTh3+5CROLKQYBBAEBCQQUBwQPgy0HgSiDKASbBoxv
X-IronPort-AV: E=Sophos;i="4.71,597,1320620400"; 
   d="scan'208";a="261300717"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Jussi Pakkanen <jussi.pakkanen@canonical.com>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: [PATCH v2] Input: Document the device properties
Date: Tue, 31 Jan 2012 19:55:11 +0100
Message-Id: <1328036111-2780-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a section which defines the input device properties and provides
guidelines on how to use them.

Cc: Jussi Pakkanen <jussi.pakkanen@canonical.com>
Cc: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/input/event-codes.txt |   72 +++++++++++++++++++++++++++++++----
 1 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
index 23fcb05..53305bd 100644
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
@@ -220,6 +220,56 @@ EV_PWR:
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
+For touchpads where the button is placed beneath the surface, such that
+pressing down on the pad causes a button click, this property should be
+set. Common in clickpad notebooks and macbooks from 2009 and onwards.
+
+Originally, the buttonpad property was coded into the bcm5974 driver
+version field under the name integrated button. For backwards
+compatibility, both methods need to be checked in userspace.
+
+INPUT_PROP_SEMI_MT:
+------------------
+Some touchpads, most common between 2008 and 2011, can detect the presence
+of multiple contacts without resolving the individual positions; only the
+number of contacts and a rectangular shape is known. For such
+touchpads, the semi-mt property should be set.
+
+Depending on the device, the rectangle may enclose all touches, like a
+bounding box, or just some of them, for instance the two most recent
+touches. The diversity makes the rectangle of limited use, but some
+gestures can normally be extracted from it.
+
+If INPUT_PROP_SEMI_MT is not set, the device is assumed to be a true MT
+device.
+
 Guidelines:
 ==========
 The guidelines below ensure proper single-touch and multi-finger functionality.
@@ -240,6 +290,8 @@ used to report when a touch is active on the screen.
 BTN_{MOUSE,LEFT,MIDDLE,RIGHT} must not be reported as the result of touch
 contact. BTN_TOOL_<name> events should be reported where possible.
 
+For new hardware, INPUT_PROP_DIRECT should be set.
+
 Trackpads:
 ----------
 Legacy trackpads that only provide relative position information must report
@@ -250,6 +302,8 @@ location of the touch. BTN_TOUCH should be used to report when a touch is active
 on the trackpad. Where multi-finger support is available, BTN_TOOL_<name> should
 be used to report the number of touches active on the trackpad.
 
+For new hardware, INPUT_PROP_POINTER should be set.
+
 Tablets:
 ----------
 BTN_TOOL_<name> events must be reported when a stylus or other tool is active on
@@ -260,3 +314,5 @@ button may be used for buttons on the tablet except BTN_{MOUSE,LEFT}.
 BTN_{0,1,2,etc} are good generic codes for unlabeled buttons. Do not use
 meaningful buttons, like BTN_FORWARD, unless the button is labeled for that
 purpose on the device.
+
+For new hardware, both INPUT_PROP_DIRECT and INPUT_PROP_POINTER should be set.
-- 
1.7.9

