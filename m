Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762418Ab2FVObw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:31:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57267 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762383Ab2FVOba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:31:30 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 3/4] remoteproc: Add API (header file) for kicking STE modems
Date: Fri, 22 Jun 2012 16:31:09 +0200
Message-Id: <1340375470-13097-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add the API definition for STE Modem interrupt mecanism (kicks).

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/stemod_kick.h |  113 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 drivers/remoteproc/stemod_kick.h

diff --git a/drivers/remoteproc/stemod_kick.h b/drivers/remoteproc/stemod_kick.h
new file mode 100644
index 0000000..dbfa909
--- /dev/null
+++ b/drivers/remoteproc/stemod_kick.h
@@ -0,0 +1,113 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2011
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef __INC_STEMOD_KICK_H
+#define __INC_STEMOD_KICK_H
+#include <linux/types.h>
+
+/**
+ * stemod_kick_subscribe - Subscribe for notification change from the modem.
+ *
+ * @notifyid:	The notification ID the callback is associated with.
+ *
+ * @notify_cb:	Callback function to be called when the requested notify-id
+ *		is set by the external device (modem).
+ *
+ * @data: Client data to be provided in the callback function.
+ *
+ * Install a callback function for a notification ID.
+ * Returns negative upon error.
+ *
+ * This function may block, and cannot be called from IRQ context.
+ * Precondition: @notifyid must be defined as as getter in
+ * stemod_kick_notifyid_alloc().
+ * Returns zero on success, and negative upon error.
+ *
+ * Callback context:
+ *		The "notify_cb" callback might be called from the
+ *		IRQ context. The callback function is not allowed to block
+ *		or spend much CPU time in the callback, It must defer
+ *		work to soft-IRQ or work queues.
+ */
+int stemod_kick_subscribe(int notifyid,
+			  void (*notify_cb)(int notifyid, void *data),
+			  void *data);
+
+/**
+ * stemod_kick_notifyid_alloc - Allocate the usage of notification IDs.
+ *
+ * @rx_mask:	Bit-mask defining the notifyids that can be
+ *			subscribed by stemod_kick_subscribe().
+ * @tx_mask:	Bit-mask defining the notifyids that can be set by
+ *			stemod_kick_set_notifyid()
+ *
+ * The @rx_mask defines the notification-id  that can be subscribed by
+ * the function stemod_kick_subscribe().
+ * The @tx_mask defines the notification-ids that can be set by the
+ * function stemod_kick_set_notifyid().
+ *
+ * This function may block.
+ *
+ * Returns zero on success, and negative upon error.
+ *
+ */
+int stemod_kick_notifyid_alloc(u32 rx_mask, u32 tx_mask);
+
+/**
+ * stemod_kick_register_errhandler - Register an error handler.
+ *
+ * @errhandler: error handler called from driver upon severe errors
+ *		that requires reset of the remote device.
+ */
+void stemod_kick_register_errhandler(void (*errhandler)(int errno));
+
+/**
+ * stemod_kick_reset() - Reset the C2C driver
+ *
+ * Reset the Kick Driver due to remote device (modem) restart.
+ * This shall reset state back to initial state, and should only
+ * be used when remote device (modem) has reset.
+ *
+ * All settings, subscriptions and state information in the driver is
+ * reset.
+ * This function may block.
+ *
+ * Returns zero on success, and negative upon error.
+ */
+int stemod_kick_reset(void);
+
+/**
+ * stemod_kick_notifyid() -	Genereate a notification to remote device.
+ *
+ * @notifyid:	The notification ID to generate interrupt for.
+ *
+ * This function is used to send notification to the remote
+ * processor (modem).
+ *
+ * This function is non-blocking, and can be called from Soft-IRQ context.
+ *
+ * Returns zero on success, and negative upon error.
+ *
+ * Precondition: @notifyid must be defined as as setter in
+ * stemod_kick_notifyid_alloc().
+ */
+int stemod_kick_notifyid(int notifyid);
+
+
+/**
+ * stemod_power() -	On/Off switch for modem
+ *
+ * @on:	Switch on or off
+ *
+ * This function is the power switch for the STE-Modem.
+ *
+ * Returns zero on success, and negative upon error.
+ *
+ */
+int stemod_power(bool on);
+
+#endif /*INC_STEMOD_KICK_H*/
-- 
1.7.5.4

