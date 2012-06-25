Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab2FYPNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:13:10 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:58968 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2FYPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:13:08 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsVAANF/6E9V5qg+PGdsb2JhbABEtisZAQEBATc0ghgBAQU6HBMBAQ4QCAMOAwMBAgEuFCUKDA4TCYgGB7hCFIsfBQ8HhQdgA4skigmFZl2MIIFU
X-IronPort-AV: E=Sophos;i="4.77,472,1336341600"; 
   d="scan'208";a="146239323"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 25 Jun 2012 17:16:15 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Fix the Kconfig option for generic device handling
Message-ID: <20120625151615.GA11770@polaris.bitmath.org>
References: <1340356390-4614-1-git-send-email-rydberg@euromail.se>
 <alpine.LNX.2.00.1206251537190.18612@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1206251537190.18612@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 03:38:40PM +0200, Jiri Kosina wrote:
> On Fri, 22 Jun 2012, Henrik Rydberg wrote:
> 
> > The generic HID driver is obviously not a special driver, so move
> > it outside of the special drivers menu. Explain the usage and make
> > the default follow the HID setting. This should simplify migration
> > from older kernels.
> > 
> > Reported-by: Jan Beulich <jbeulich@suse.com>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Hi Jiri,
> > 
> > As pointed out by Jan Beulich, the generic hid driver Kconfig option
> > is confusing. This patch ought to fix most of the concerns. For 3.5.
> 
> The change makes sense. I'd however propose to perhaps unify 
> CONFIG_HID_SUPPORT and CONFIG_HID, while we are at it ... ?

Here is a version putting together both patches sent previously, and in addition removing the HID_SUPPORT option.

Henrik

>From f3572333d6b5eac61645157cc88856458933cfb1 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Mon, 25 Jun 2012 16:55:41 +0200
Subject: [PATCH] HID: Fix the generic Kconfig options

The generic HID driver is obviously not a special driver, so move it
outside of the special drivers menu. Explain the usage and make the
default follow the HID setting. This should simplify migration from
older kernels. While at it, remove the redundant HID_SUPPORT option
and modify the HID and USB_HID entries to better explain the bus
structure.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/Kconfig        | 43 ++++++++++++++++++++-----------------------
 drivers/hid/usbhid/Kconfig |  8 ++++----
 net/bluetooth/hidp/Kconfig |  2 +-
 3 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 034c80a..bef04c1 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -1,20 +1,11 @@
 #
 # HID driver configuration
 #
-menuconfig HID_SUPPORT
-	bool "HID Devices"
-	depends on INPUT
-	default y
-	---help---
-	  Say Y here to get to see options for various computer-human interface
-	  device drivers. This option alone does not add any kernel code.
-
-	  If you say N, all options in this submenu will be skipped and disabled.
-
-if HID_SUPPORT
+menu "HID support"
+     depends on INPUT
 
 config HID
-	tristate "Generic HID support"
+	tristate "HID bus support"
 	depends on INPUT
 	default y
 	---help---
@@ -23,14 +14,17 @@ config HID
 	  most commonly used to refer to the USB-HID specification, but other
 	  devices (such as, but not strictly limited to, Bluetooth) are
 	  designed using HID specification (this involves certain keyboards,
-	  mice, tablets, etc). This option compiles into kernel the generic
-	  HID layer code (parser, usages, etc.), which can then be used by
-	  transport-specific HID implementation (like USB or Bluetooth).
+	  mice, tablets, etc). This option adds the HID bus to the kernel,
+	  together with generic HID layer code. The HID devices are added and
+	  removed from the HID bus by the transport-layer drivers, such as
+	  usbhid (USB_HID) and hidp (BT_HIDP).
 
 	  For docs and specs, see http://www.usb.org/developers/hidpage/
 
 	  If unsure, say Y.
 
+if HID
+
 config HID_BATTERY_STRENGTH
 	bool "Battery level reporting for HID devices"
 	depends on HID && POWER_SUPPLY && HID = POWER_SUPPLY
@@ -59,23 +53,22 @@ config HIDRAW
 
 	If unsure, say Y.
 
-source "drivers/hid/usbhid/Kconfig"
-
-menu "Special HID drivers"
-	depends on HID
-
 config HID_GENERIC
 	tristate "Generic HID driver"
 	depends on HID
-	default y
+	default HID
 	---help---
-	Support for generic HID devices.
+	Support for generic devices on the HID bus. This includes most
+	keyboards and mice, joysticks, tablets and digitizers.
 
 	To compile this driver as a module, choose M here: the module
 	will be called hid-generic.
 
 	If unsure, say Y.
 
+menu "Special HID drivers"
+	depends on HID
+
 config HID_A4TECH
 	tristate "A4 tech mice" if EXPERT
 	depends on USB_HID
@@ -662,4 +655,8 @@ config HID_ZYDACRON
 
 endmenu
 
-endif # HID_SUPPORT
+endif # HID
+
+source "drivers/hid/usbhid/Kconfig"
+
+endmenu
diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index 0f20fd1..0108c59 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -1,13 +1,13 @@
-comment "USB Input Devices"
+menu "USB HID support"
 	depends on USB
 
 config USB_HID
-	tristate "USB Human Interface Device (full HID) support"
+	tristate "USB HID transport layer"
 	default y
 	depends on USB && INPUT
 	select HID
 	---help---
-	  Say Y here if you want full HID support to connect USB keyboards,
+	  Say Y here if you want to connect USB keyboards,
 	  mice, joysticks, graphic tablets, or any other HID based devices
 	  to your computer via USB, as well as Uninterruptible Power Supply
 	  (UPS) and monitor control devices.
@@ -81,4 +81,4 @@ config USB_MOUSE
 
 endmenu
 
-
+endmenu
diff --git a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
index 4deaca7..9332bc7 100644
--- a/net/bluetooth/hidp/Kconfig
+++ b/net/bluetooth/hidp/Kconfig
@@ -1,6 +1,6 @@
 config BT_HIDP
 	tristate "HIDP protocol support"
-	depends on BT && INPUT && HID_SUPPORT
+	depends on BT && INPUT
 	select HID
 	help
 	  HIDP (Human Interface Device Protocol) is a transport layer
-- 
1.7.11

