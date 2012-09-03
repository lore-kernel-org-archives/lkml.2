Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2ICNuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:50:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54785 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2ICNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:50:16 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: [RFC 1/3] include/linux: Add API for kicking modem
Date: Mon,  3 Sep 2012 15:49:51 +0200
Message-Id: <1346680193-5443-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add an API for subscribing to and generating kicks
(interrupts) to the modem.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
cc: Linus Walleij <linus.walleij@linaro.org>
cc: Arun Murthy <arun.murthy@stericsson.com>
---
 include/linux/modem_kick.h |  126 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/modem_kick.h

diff --git a/include/linux/modem_kick.h b/include/linux/modem_kick.h
new file mode 100644
index 0000000..e650144
--- /dev/null
+++ b/include/linux/modem_kick.h
@@ -0,0 +1,126 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef __INC_MODEM_KICK_H
+#define __INC_MODEM_KICK_H
+#include <linux/types.h>
+
+struct modem_kick;
+
+/**
+ * modem_kick_get- Get the handle for the modem kick API.
+ * @modem_name:	Name of the modem.
+ *
+ * Get a handle to the modem kick API. This API provides
+ * functionality to generate "kicks" between modem and host.
+ *
+ * This function may block.
+ * Returns zero on success, and negative upon error.
+ */
+struct modem_kick *modem_kick_get(const char *modem_name);
+
+/**
+ * modem_kick_put - Release the instance of the modem kick API.
+ * @kick:	The API handle return by @modem_get.
+ *
+ * Releases the modem kick API.
+ *
+ * This function may block.
+ * Returns zero on success, and negative upon error.
+ */
+void modem_kick_put(struct modem_kick *kick);
+
+/**
+ * modem_kick_subscribe - Subscribe for notifications from the modem.
+ * @kick:	The API handle return by @modem_get.
+ * @notifyid:	The identification of the notification.
+ * @notify_cb:	Callback function to be called when modem kicks.
+ * @data: Client data to be provided in the notification callback function.
+ *
+ * Installs a callback function for a specific notification ID.
+ *
+ * Precondition: modem_kick_alloc_notifyid() must have declared
+ * the @notifyid in the rx_mask.
+ * This function may block.
+ * Returns zero on success, and negative upon error.
+ *
+ * Callback context:
+ *		The callback might be called from a IRQ context.
+ *		The callback function is not allowed to block
+ *		or spend much CPU time in the callback.
+ */
+int modem_kick_subscribe(struct modem_kick *kick, int notifyid,
+			  void (*notify_cb)(int notifyid, void *data),
+			  void *data);
+
+/**
+ * modem_kick_alloc_notifyid - Allocate the usage of notification IDs.
+ *
+ * @kick:	The API handle return by @modem_get.
+ * @rx_mask:	Bit-mask defining the notification IDs that can be
+ *			subscribed to by modem_kick_subscribe().
+ * @tx_mask:	Bit-mask defining the notification IDs that can be
+ *			set by modem_kick_set_notifyid()
+ *
+ * This function allocates the Notification IDs to be used for
+ * RX and TX direction towards the modem.
+ *
+ * This function may block.
+ *
+ * Returns zero on success, and negative upon error.
+ *
+ */
+int modem_kick_alloc_notifyid(struct modem_kick *kick,
+			      u32 rx_mask, u32 tx_mask);
+
+/**
+ * modem_kick_register_errhandler - Register an error handler.
+ * @kick:	The API handle return by @modem_get.
+ * @userdata:	User data will be used as argument to the errorhandler
+ * @errhandler: Error handler called from driver upon severe errors
+ *		that requires reset of the remote device.
+ *
+ * This routine installs an error callback function to be used if
+ * non recoverable errors are detected in the driver implementing
+ * the kick API.
+ * Callback context:
+ *		The callback function is not allowed to block
+ *		or spend much CPU time in the callback.
+ */
+void modem_kick_register_errhandler(struct modem_kick *kick, void *userdata,
+				    void (*errhandler)(void *userdata,
+						       int errno));
+
+/**
+ * modem_kick_reset() - Reset the driver
+ * @kick:	The API handle return by @modem_get.
+ *
+ * Reset the Kick Driver. This shall reset state back to
+ * initial state, and should only be used when the modem has
+ * been reset.
+ *
+ * This function may block.
+ * Returns zero on success, and negative upon error.
+ */
+int modem_kick_reset(struct modem_kick *kick);
+
+/**
+ * modem_kick_trigger() - Kick the modem.
+ * @kick:	The API handle return by @modem_get.
+ * @notifyid:	The notification ID for this kick.
+ *
+ * This function is used to trigger a notification to the modem.
+ *
+ * This function is non-blocking, and can be called from a IRQ context.
+ * Returns zero on success, and negative upon error.
+ *
+ * Precondition: modem_kick_alloc_notifyid() must have declared
+ * the @notifyid in the tx_mask.
+ */
+int modem_kick_trigger(struct modem_kick *kick, int notifyid);
+
+#endif /*INC_MODEM_KICK_H*/
-- 
1.7.5.4

