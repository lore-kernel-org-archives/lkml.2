Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2IMHCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:02:00 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:47558 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103Ab2IMHB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:01:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: document semantics vs GPIO
Date: Thu, 13 Sep 2012 09:01:26 +0200
Message-ID: <1347519686-10170-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The semantics of the interactions between GPIO and pinctrl may be
unclear, e.g. which one do you request first? This amends the
documentation to make this clear.

Reported-by: Domenico Andreoli <cavokz@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
This is an attempt to write up some of the unclarities that surfaced
in recent discussions into the documentation proper.
---
 Documentation/pinctrl.txt | 52 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 1479aca..24c5995 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -289,6 +289,11 @@ Interaction with the GPIO subsystem
 The GPIO drivers may want to perform operations of various types on the same
 physical pins that are also registered as pin controller pins.
 
+First and foremost, the two subsystems can be used as completely orthogonal,
+see the section named "pin control requests from drivers" and
+"drivers needing both pin control and GPIOs" below for details. But in some
+situations a cross-subsystem mapping between pins and GPIOs is needed.
+
 Since the pin controller subsystem have its pinspace local to the pin
 controller we need a mapping so that the pin control subsystem can figure out
 which pin controller handles control of a certain GPIO pin. Since a single
@@ -359,6 +364,7 @@ will get an pin number into its handled number range. Further it is also passed
 the range ID value, so that the pin controller knows which range it should
 deal with.
 
+
 PINMUX interfaces
 =================
 
@@ -960,8 +966,8 @@ all get selected, and they all get enabled and disable simultaneously by the
 pinmux core.
 
 
-Pinmux requests from drivers
-============================
+Pin control requests from drivers
+=================================
 
 Generally it is discouraged to let individual drivers get and enable pin
 control. So if possible, handle the pin control in platform code or some other
@@ -969,6 +975,11 @@ place where you have access to all the affected struct device * pointers. In
 some cases where a driver needs to e.g. switch between different mux mappings
 at runtime this is not possible.
 
+A typical case is if a driver needs to switch bias of pins from normal
+operation and going to sleep, moving from the PINCTRL_STATE_DEFAULT to
+PINCTRL_STATE_SLEEP at runtime, re-biasing or even re-muxing pins to save
+current in sleep mode.
+
 A driver may request a certain control state to be activated, usually just the
 default state like this:
 
@@ -1058,6 +1069,43 @@ registered. Thus make sure that the error path in your driver gracefully
 cleans up and is ready to retry the probing later in the startup process.
 
 
+Drivers needing both pin control and GPIOs
+==========================================
+
+Again, it is discouraged to let drivers lookup and select pin control states
+themselves, but again sometimes this is unavoidable.
+
+So say that your driver is fetching its resources like this:
+
+#include <linux/pinctrl/consumer.h>
+#include <linux/gpio.h>
+
+struct pinctrl *pinctrl;
+int gpio;
+
+pinctrl = devm_pinctrl_get_select_default(&dev);
+gpio = devm_gpio_request(&dev, 14, "foo");
+
+Here we first request a certain pin state and then request GPIO 14 to be
+used. If you're using the subsystems orthogonally like this, always get
+your pinctrl handle and select the desired pinctrl state BEFORE requesting
+the GPIO. This is a semantic convention to avoid situations that can be
+electrically unpleasant, you will certainly want to mux in and bias pins
+in a certain way before the GPIO subsystems starts to deal with them.
+
+The above can be hidden: using pinctrl hogs, the driver may be setting
+up the config and muxing for the pins when the pinctrl driver is probing,
+nevertheless orthogonal to the GPIO subsystem.
+
+But there are also situations where it makes sense for the GPIO subsystem
+to communicate directly with with the pinctrl subsystem, using the latter
+as a back-end. This is when the GPIO driver may call out to the functions
+described in the section "Pin control interaction with the GPIO subsystem"
+above. This only involves per-pin multiplexing, and will be completely
+hidden behind the gpio_*() function namespace. In this case, the driver
+need not interact with the pin control subsystem at all.
+
+
 System pin control hogging
 ==========================
 
-- 
1.7.11.3

