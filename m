Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2CFAWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 19:22:31 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14617 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab2CFAW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 19:22:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 05 Mar 2012 16:22:22 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>
CC: Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Randy Dunlap <rdunlap@xenotime.net>, <linux-doc@vger.kernel.org>
Subject: [PATCH V2 1/3] Documentation/gpio.txt: Explain expected pinctrl interaction
Date: Mon, 5 Mar 2012 17:22:14 -0700
Message-ID: <1330993336-9538-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update gpio.txt based on recent discussions regarding interaction with the
pinctrl subsystem.

Previously, gpio_request() was described as explicitly not performing any
required mux setup operations etc.

Now, gpio_request() is explicitly as explicitly performing any required mux
setup operations where possible. In the case it isn't, platform code is
required to have set up any required muxing or other configuration prior to
gpio_request() being called, in order to maintain the same semantics.

This is achieved by gpiolib drivers calling e.g. pinctrl_request_gpio() in
their .request() operation.

Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Modified to state that pin multiplexing should be performed within
direction_input()/output() rather than request(), to address Russell King's
need for glitchless transition between special function and GPIO usage of
a pin. Various rewording and cleanup due to this.
---
 Documentation/gpio.txt |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 792faa3..e0f8799 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -271,9 +271,26 @@ Some platforms may also use knowledge about what GPIOs are active for
 power management, such as by powering down unused chip sectors and, more
 easily, gating off unused clocks.
 
-Note that requesting a GPIO does NOT cause it to be configured in any
-way; it just marks that GPIO as in use.  Separate code must handle any
-pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
+For GPIOs that use pins known to the pinctrl subsystem, that subsystem should
+be informed of their use; a gpiolib driver's .request() operation may call
+pinctrl_request_gpio(), and a gpiolib driver's .free() operation may call
+pinctrl_free_gpio(). The pinctrl subsystem allows a pinctrl_request_gpio()
+to succeed concurrently with a pin or pingroup being "owned" by a device for
+pin multiplexing.
+
+Any programming of pin multiplexing hardware that is needed to route the
+GPIO signal to the appropriate pin should occur within a GPIO driver's
+.direction_input() or .direction_output() operations, and occur after any
+setup of an output GPIO's value. This allows a glitch-free migration from a
+pin's special function to GPIO. This is sometimes required when using a GPIO
+to implement a workaround on signals typically driven by a non-GPIO HW block.
+
+Some platforms allow some or all GPIO signals to be routed to different pins.
+Similarly, other aspects of the GPIO or pin may need to be configured, such as
+pullup/pulldown. Platform software should arrange that any such details are
+configured prior to gpio_request() being called for those GPIOs, e.g. using
+the pinctrl subsystem's mapping table, so that GPIO users need not be aware
+of these details.
 
 Also note that it's your responsibility to have stopped using a GPIO
 before you free it.
-- 
1.7.0.4

