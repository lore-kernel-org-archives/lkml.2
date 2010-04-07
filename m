Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab0DGNmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 09:42:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60839 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab0DGNmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:42:19 -0400
Date: Wed, 07 Apr 2010 15:41:28 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 1/8] USB: composite: allow optional removal of __init and
 __exit tags
In-reply-to: <cover.1270644740.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1270644740.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The composite framework has been written using __init and __exit tags
to mark init and exit functions as such.  This works with most of the
composite gadgets however some may need to call init/exit functions
during normal operations.  One example is mass storage gadget which
needs to call exit functions.

This patch allows gadgets to define USB_NO_INIT_SEGMENT or
USB_NO_EXIT_SEGMENT to remove the __init and __exit declarations
from composite framework.

For example see mass_storage.c.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/usb/gadget/composite.c     |   25 +++++++++++++------------
 drivers/usb/gadget/config.c        |    6 ++++--
 drivers/usb/gadget/epautoconf.c    |   13 +++++++------
 drivers/usb/gadget/mass_storage.c  |    4 ++++
 drivers/usb/gadget/usb-init-exit.h |   23 +++++++++++++++++++++++
 5 files changed, 51 insertions(+), 20 deletions(-)
 create mode 100644 drivers/usb/gadget/usb-init-exit.h

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 09289bb..0039aba 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -27,6 +27,8 @@
 
 #include <linux/usb/composite.h>
 
+#include "usb-init-exit.h"
+
 
 /*
  * The code in this file is utility code, used to build a gadget driver
@@ -85,7 +87,7 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
  * This function returns the value of the function's bind(), which is
  * zero for success else a negative errno value.
  */
-int __init usb_add_function(struct usb_configuration *config,
+int __usb_init usb_add_function(struct usb_configuration *config,
 		struct usb_function *function)
 {
 	int	value = -EINVAL;
@@ -215,7 +217,7 @@ int usb_function_activate(struct usb_function *function)
  * Returns the interface ID which was allocated; or -ENODEV if no
  * more interface IDs can be allocated.
  */
-int __init usb_interface_id(struct usb_configuration *config,
+int __usb_init usb_interface_id(struct usb_configuration *config,
 		struct usb_function *function)
 {
 	unsigned id = config->next_interface_id;
@@ -480,7 +482,7 @@ done:
  * assigns global resources including string IDs, and per-configuration
  * resources such as interface IDs and endpoints.
  */
-int __init usb_add_config(struct usb_composite_dev *cdev,
+int __usb_init usb_add_config(struct usb_composite_dev *cdev,
 		struct usb_configuration *config)
 {
 	int				status = -EINVAL;
@@ -677,7 +679,7 @@ static int get_string(struct usb_composite_dev *cdev,
  * ensure that for example different functions don't wrongly assign
  * different meanings to the same identifier.
  */
-int __init usb_string_id(struct usb_composite_dev *cdev)
+int __usb_init usb_string_id(struct usb_composite_dev *cdev)
 {
 	if (cdev->next_string_id < 254) {
 		/* string id 0 is reserved */
@@ -898,7 +900,7 @@ static void composite_disconnect(struct usb_gadget *gadget)
 
 /*-------------------------------------------------------------------------*/
 
-static void /* __init_or_exit */
+static void __usb_init_or_exit
 composite_unbind(struct usb_gadget *gadget)
 {
 	struct usb_composite_dev	*cdev = get_gadget_data(gadget);
@@ -947,7 +949,7 @@ composite_unbind(struct usb_gadget *gadget)
 	composite = NULL;
 }
 
-static void __init
+static void __usb_init
 string_override_one(struct usb_gadget_strings *tab, u8 id, const char *s)
 {
 	struct usb_string		*str = tab->strings;
@@ -960,7 +962,7 @@ string_override_one(struct usb_gadget_strings *tab, u8 id, const char *s)
 	}
 }
 
-static void __init
+static void __usb_init
 string_override(struct usb_gadget_strings **tab, u8 id, const char *s)
 {
 	while (*tab) {
@@ -969,7 +971,7 @@ string_override(struct usb_gadget_strings **tab, u8 id, const char *s)
 	}
 }
 
-static int __init composite_bind(struct usb_gadget *gadget)
+static int __usb_init composite_bind(struct usb_gadget *gadget)
 {
 	struct usb_composite_dev	*cdev;
 	int				status = -ENOMEM;
@@ -1092,8 +1094,7 @@ static struct usb_gadget_driver composite_driver = {
 	.speed		= USB_SPEED_HIGH,
 
 	.bind		= composite_bind,
-	/* .unbind		= __exit_p(composite_unbind), */
-	.unbind		= composite_unbind,
+	.unbind		= __usb_exit_p(composite_unbind),
 
 	.setup		= composite_setup,
 	.disconnect	= composite_disconnect,
@@ -1121,7 +1122,7 @@ static struct usb_gadget_driver composite_driver = {
  * while it was binding.  That would usually be done in order to wait for
  * some userspace participation.
  */
-int __init usb_composite_register(struct usb_composite_driver *driver)
+int __usb_init usb_composite_register(struct usb_composite_driver *driver)
 {
 	if (!driver || !driver->dev || !driver->bind || composite)
 		return -EINVAL;
@@ -1142,7 +1143,7 @@ int __init usb_composite_register(struct usb_composite_driver *driver)
  * This function is used to unregister drivers using the composite
  * driver framework.
  */
-void /* __exit */ usb_composite_unregister(struct usb_composite_driver *driver)
+void __usb_exit usb_composite_unregister(struct usb_composite_driver *driver)
 {
 	if (composite != driver)
 		return;
diff --git a/drivers/usb/gadget/config.c b/drivers/usb/gadget/config.c
index 47e8e72..2f15ee7 100644
--- a/drivers/usb/gadget/config.c
+++ b/drivers/usb/gadget/config.c
@@ -28,6 +28,8 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 
+#include "usb-init-exit.h"
+
 
 /**
  * usb_descriptor_fillbuf - fill buffer with descriptors
@@ -128,7 +130,7 @@ int usb_gadget_config_buf(
  * with identifiers (for interfaces, strings, endpoints, and more)
  * as needed by a given function instance.
  */
-struct usb_descriptor_header **__init
+struct usb_descriptor_header **__usb_init
 usb_copy_descriptors(struct usb_descriptor_header **src)
 {
 	struct usb_descriptor_header **tmp;
@@ -175,7 +177,7 @@ usb_copy_descriptors(struct usb_descriptor_header **src)
  * intended use is to help remembering the endpoint descriptor to use
  * when enabling a given endpoint.
  */
-struct usb_endpoint_descriptor *__init
+struct usb_endpoint_descriptor *__usb_init
 usb_find_endpoint(
 	struct usb_descriptor_header **src,
 	struct usb_descriptor_header **copy,
diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index 3568de2..706af4c 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -31,15 +31,16 @@
 #include <linux/usb/gadget.h>
 
 #include "gadget_chips.h"
+#include "usb-init-exit.h"
 
 
 /* we must assign addresses for configurable endpoints (like net2280) */
-static __initdata unsigned epnum;
+static __usb_initdata unsigned epnum;
 
 // #define MANY_ENDPOINTS
 #ifdef MANY_ENDPOINTS
 /* more than 15 configurable endpoints */
-static __initdata unsigned in_epnum;
+static __usb_initdata unsigned in_epnum;
 #endif
 
 
@@ -59,7 +60,7 @@ static __initdata unsigned in_epnum;
  * NOTE:  each endpoint is unidirectional, as specified by its USB
  * descriptor; and isn't specific to a configuration or altsetting.
  */
-static int __init
+static int __usb_init
 ep_matches (
 	struct usb_gadget		*gadget,
 	struct usb_ep			*ep,
@@ -187,7 +188,7 @@ ep_matches (
 	return 1;
 }
 
-static struct usb_ep * __init
+static struct usb_ep * __usb_init
 find_ep (struct usb_gadget *gadget, const char *name)
 {
 	struct usb_ep	*ep;
@@ -229,7 +230,7 @@ find_ep (struct usb_gadget *gadget, const char *name)
  *
  * On failure, this returns a null endpoint descriptor.
  */
-struct usb_ep * __init usb_ep_autoconfig (
+struct usb_ep * __usb_init usb_ep_autoconfig (
 	struct usb_gadget		*gadget,
 	struct usb_endpoint_descriptor	*desc
 )
@@ -304,7 +305,7 @@ struct usb_ep * __init usb_ep_autoconfig (
  * state such as ep->driver_data and the record of assigned endpoints
  * used by usb_ep_autoconfig().
  */
-void __init usb_ep_autoconfig_reset (struct usb_gadget *gadget)
+void __usb_init usb_ep_autoconfig_reset (struct usb_gadget *gadget)
 {
 	struct usb_ep	*ep;
 
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 705cc1f..438a395 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -57,6 +57,10 @@
  * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
  */
 
+/* Do not mark composite_unbind() and usb_composite_unregister() as
+ * __exit, we may need it even if we are not unloaded. */
+#define USB_NO_EXIT_SEGMENT 1
+
 #include "composite.c"
 #include "usbstring.c"
 #include "config.c"
diff --git a/drivers/usb/gadget/usb-init-exit.h b/drivers/usb/gadget/usb-init-exit.h
new file mode 100644
index 0000000..04cd624
--- /dev/null
+++ b/drivers/usb/gadget/usb-init-exit.h
@@ -0,0 +1,23 @@
+#ifndef __usb_init
+#  if defined USB_NO_INIT_SEGMENT
+#    define __usb_init          __cold
+#    define __usb_initdata
+#  else
+#    define __usb_init          __init
+#    define __usb_initdata      __initdata
+#  endif
+#  if defined USB_NO_EXIT_SEGMENT
+#    define __usb_exit          __cold
+#    define __usb_exit_p(func)  func
+#    define __usb_exitdata
+#  else
+#    define __usb_exit          __exit
+#    define __usb_exit_p(func)  __exit_p(func)
+#    define __usb_exitdata      __exitdata
+#  endif
+#  if defined USB_NO_INIT_SEGMENT || defined USB_NO_EXIT_SEGMENT
+#    define __usb_init_or_exit  __cold
+#  else
+#    define __usb_init_or_exit  /* __init_or_exit */
+#  endif
+#endif
-- 
1.7.0

