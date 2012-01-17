Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2AQQjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:39:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40800 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755086Ab2AQQjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:39:02 -0500
Date: Tue, 17 Jan 2012 11:39:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation update for the driver model core
Message-ID: <Pine.LNX.4.44L0.1201171137430.1818-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1509) documents two important points regarding the use
of device structures in the driver model:

	Structures must be initialized to all 0's before they are
	passed to device_initialize().

	Structures must not be passed to device_add() or
	device_register() more than once.

Although these restrictions have applied ever since the driver model
was first created, they have not been mentioned anywhere.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

 drivers/base/core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: usb-3.2/drivers/base/core.c
===================================================================
--- usb-3.2.orig/drivers/base/core.c
+++ usb-3.2/drivers/base/core.c
@@ -582,6 +582,11 @@ static void klist_children_put(struct kl
  * may be used for reference counting of @dev after calling this
  * function.
  *
+ * All fields in @dev must be initialized by the caller to 0, except
+ * for those explicitly set to some other value.  The simplest
+ * approach is to use kzalloc() to allocate the structure containing
+ * @dev.
+ *
  * NOTE: Use put_device() to give up your reference instead of freeing
  * @dev directly once you have called this function.
  */
@@ -884,6 +889,13 @@ int device_private_init(struct device *d
  * to the global and sibling lists for the device, then
  * adds it to the other relevant subsystems of the driver model.
  *
+ * Do not call this routine or device_register() more than once for
+ * any device structure.  The driver model core is not designed to work
+ * with devices that get unregistered and then spring back to life.
+ * (Among other things, it's very hard to guarantee that all references
+ * to the previous incarnation of @dev have been dropped.)  Allocate
+ * and register a fresh new struct device instead.
+ *
  * NOTE: _Never_ directly free @dev after calling this function, even
  * if it returned an error! Always use put_device() to give up your
  * reference instead.
@@ -1037,6 +1049,9 @@ name_error:
  * have a clearly defined need to use and refcount the device
  * before it is added to the hierarchy.
  *
+ * For more information, see the kerneldoc for device_initialize()
+ * and device_add().
+ *
  * NOTE: _Never_ directly free @dev after calling this function, even
  * if it returned an error! Always use put_device() to give up the
  * reference initialized in this function instead.

