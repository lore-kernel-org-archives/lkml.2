Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab2LTUYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:24:19 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46481 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LTUYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:24:08 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Simon Glass <sjg@chromium.org>, linux-input@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, Roland Stigge <stigge@antcom.de>,
        linux-doc@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Dmitry Torokhov <dtor@mail.ru>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] RFC: input: Extend matrix-keypad device tree binding
Date: Thu, 20 Dec 2012 12:23:58 -0800
Message-Id: <1356035039-21653-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some matrix keypad drivers can support different numbers of rows and
columns. Add a generic binding for these.

Also define properties for the repeat rate, to allow a sane baseline to
be set up for the driver.

Implementation note:

In order to implement this binding in the kernel, we will need to modify
matrix_keypad_() to look up the number of rows and cols in
the keymap. Perhaps this could be done by passing 0 for these parameters?
Many of the parameters can already be set to NULL. Ick.

For the key repeat feature, we need to set this after the input device
is registered. So we would need to add a matrix_keypad_setup_input() or
similar to be called by the driver after input_register_device(). I am
less keen on that idea, and less again on the alternative of perhaps
matrix_keypad_register_device() which does input_register_device() and
then sets up the key repeat. Thoughts?

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 .../devicetree/bindings/input/matrix-keymap.txt    |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/matrix-keymap.txt b/Documentation/devicetree/bindings/input/matrix-keymap.txt
index 3cd8b98..b953d27 100644
--- a/Documentation/devicetree/bindings/input/matrix-keymap.txt
+++ b/Documentation/devicetree/bindings/input/matrix-keymap.txt
@@ -9,6 +9,16 @@ Required properties:
 	row << 24 | column << 16 | key-code
 
 Optional properties:
+Properties for the number of rows and columns are optional because some
+drivers will use fixed values for these.
+- keypad,num-rows: Number of row lines connected to the keypad controller.
+- keypad,num-columns: Number of column lines connected to the keypad
+  controller.
+- keypad,repeat-delay-ms: Number of milliseconds of delay before the first
+  keyboard repeat when a key is held down.
+- keypad,repeat-rate-ms: Number of milliseconds between each subsequent
+  keyboard repeat when a key is held down.
+
 Some users of this binding might choose to specify secondary keymaps for
 cases where there is a modifier key such as a Fn key. Proposed names
 for said properties are "linux,fn-keymap" or with another descriptive
@@ -17,3 +27,7 @@ word for the modifier other from "Fn".
 Example:
 	linux,keymap = < 0x00030012
 			 0x0102003a >;
+	keypad,num-rows = <2>;
+	keypad,num-columns = <8>;
+	keypad,repeat-delay-ms = <600>;
+	keypad,repeat-rate-ms = <60>;
-- 
1.7.7.3

