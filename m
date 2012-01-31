Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2AaIuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:50:51 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64111 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299Ab2AaItB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:49:01 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RESEND PATCHv5 04/11] modem_shm: geni/geno driver interface.
Date: Tue, 31 Jan 2012 09:48:39 +0100
Message-Id: <1327999726-8774-5-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add C2C drivers interface. The Shared Memory driver is using two
paired registers called GENI and GENO in for triggering
events/interrupts on modem and Linux host.

It's primary use is notification about read and write indexes changes
on each channel. But GENI/GENO are also used for communicating the
address of the shared memory upon modem boot and to notify about start-up
event such as when IPC channels and CAIF is ready for use.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 include/linux/c2c_genio.h |  195 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 195 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/c2c_genio.h

diff --git a/include/linux/c2c_genio.h b/include/linux/c2c_genio.h
new file mode 100644
index 0000000..42d22ab
--- /dev/null
+++ b/include/linux/c2c_genio.h
@@ -0,0 +1,195 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brændeland / sjur.brandeland@stericsson.com
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef __INC_GENIO_H
+#define __INC_GENIO_H
+#include <linux/types.h>
+
+/**
+ * DOC: C2C GENI/GENO interface.
+ *
+ * This API defines the API for the C2C driver and the GENI/GENO registers.
+ */
+
+/**
+ * enum GENIO_BITS - Definition of special GENIO BITS.
+ * @READY_FOR_IPC_BIT:  Remote side is ready for IPC.
+ * This GENI/GENO bit is triggered when ring-buffer protocol
+ * is enabled from the remote end (modem)
+ *
+ * @READY_FOR_CAIF_BIT: Remote side is ready for CAIF.
+ * This GENI/GENO bit is triggered when CAIF protocol
+ * is enabled from the remote end (modem)
+ */
+enum GENIO_BITS {
+	READY_FOR_CAIF_BIT = 28,
+	READY_FOR_IPC_BIT = 29
+};
+
+/**
+ * genio_subscribe - Subscribe for notifications on bit-change of GENI/O bits.
+ *
+ * @bit:	The GENI/O bit where we want to be called back when it changes.
+ *
+ * @bit_set_cb:	Callback function to be called when the requested GENI/O bit
+ *		is set by the external device (modem).
+ *
+ * @data: Client data to be provided in the callback function.
+ *
+ * Install a callback function for a GENI/O bit. Returns negative upon error.
+ *
+ * The genio driver is expected to handle the 4-state handshake for geni/geno
+ * update, for the bit this function subscribe to. This function may block,
+ * and cannot be called from IRQ context.
+ *
+ * Returns zero on success, and negative upon error.
+ *
+ * Precondition: This function is called after genio_set_shm_addr() and
+ * genio_bit_alloc(). @bit must be defined as as getter in genio_bit_alloc().
+ *
+ * Callback context:
+ *		The "bit_set_cb" callback must be called from the
+ *		IRQ context. The callback function is not allowed to block
+ *		or spend much CPU time in the callback, It must defer
+ *		work to soft-IRQ or work queues.
+ */
+int genio_subscribe(int bit, void (*bit_set_cb)(void *data), void *data);
+
+/**
+ * genio_unsubscribe - Unsubscribe for callback  GENI/O bit.
+ * @bit:       The GENI/O bit to we want release.
+ *
+ * This function may block. It returns zero on success, and negative upon error.
+ *
+ * Precondition: @bit must be defined as as getter in genio_bit_alloc().
+ */
+int genio_unsubscribe(int bit);
+
+/**
+ * genio_bit_alloc - Allocate the usage of GENI/O bits.
+ *
+ * @setter_mask:	Bit-mask defining the bits that can be set by
+ *			genio_set_bit()
+ * @getter_mask:	Bit-mask defining the bits that can be subscribed by
+ *			genio_subscribe().
+ *
+ * The @getter_mask defines the bit for RX direction, i.e. bits that can
+ * be subscribed by the function genio_subscribe().
+ * The @setter_mask defines the bit for TX direction, i.e. bits that can
+ * be set by the function genio_set_bit().
+ * This function may block.
+ *
+ * Returns zero on success, and negative upon error.
+ *
+ * Precondition:
+ * This function cannot be called before ipc_ready_cb() has been called,
+ * and must be called prior to any call on genio_subscribe() or genio_set_bit().
+ *
+ */
+int genio_bit_alloc(u32 setter_mask, u32 getter_mask);
+
+/**
+ * genio_set_shm_addr - Inform remote device about the shared memory address.
+ * @addr:		The shared memory address.
+ * @ipc_ready_cb:	The callback function indicating IPC is ready.
+ *
+ * Description:
+ * Implements the setting of shared memory address involving the
+ * READY_FOR_IPC GENIO bits, and READY_FOR_IPC handshaking.
+ * When handshaking is done ipc_ready_cb is called.
+ * The usage of this bit is during start/restart.
+ * This function may block.
+ *
+ * When the ipc_ready_cb() with @ready=%true, Stream channels can be opened.
+ *
+ * Sequence:
+ * (1) Write the address to the GENO register,
+ *
+ * (2) wait for interrupt on IPC_READY (set to one in GENI register)
+ *
+ * (3) write zero to the GENO register
+ *
+ * (4) wait for interrupt on IPC_READY (set to zero)
+ *
+ * (5) call the callback function for IPC_READY
+ *
+ * Returns zero on success, and negative upon error.
+ *
+ * Precondition:
+ * This function must be called initially upon start, or after remote device
+ * has been reset.
+ */
+int genio_set_shm_addr(u32 addr, void (*ipc_ready_cb) (void));
+
+/**
+ * genio_subscribe_caif_ready - Notify that CAIF channels can be
+ * opened.
+ *
+ * @caif_ready_cb: is called with @ready = %true in the start up sequence,
+ * when the remote side is ready for CAIF enumeration. Upon reset,
+ * caif_ready_cb() will be called with @ready = %false.
+ *
+ * The %READY_FOR_CAIF_BIT is set to %one as long as the
+ * modem is able to run CAIF traffic. Upon modem restart/crash it will
+ * be set back to %zero.
+ * This function may block.
+ *
+ * Returns zero on success, and negative upon error.
+ */
+int genio_subscribe_caif_ready(void (*caif_ready_cb) (bool ready));
+
+/**
+ * genio_register_errhandler - Register an error handler.
+ *
+ * @errhandler: error handler called from driver upon severe errors
+ *		that requires reset of the remote device.
+ */
+void genio_register_errhandler(void (*errhandler)(int errno));
+
+/**
+ * genio_reset() - Reset the C2C driver
+ *
+ * Reset the C2C Driver due to remote device restart.
+ * This shall reset state back to initial state, and should only
+ * be used when remote device (modem) has reset.
+ *
+ * All settings, subscriptions and state information in the driver must
+ * be reset. GENIO client must do all subscriptions again.
+ * This function may block.
+ *
+ * Returns zero on success, and negative upon error.
+ */
+int genio_reset(void);
+
+/**
+ * genio_set_bit() -	Set a single GENI/O bit.
+ *
+ * @bit:	The GENI/O bit to set
+ *
+ * This function is used to signal over GENI/GENO the driver must
+ * perform the 4-state protocol to signal the change to remote device.
+ * This function is non-blocking, and can be called from Soft-IRQ context.
+ *
+ * Returns zero on success, and negative upon error.
+ *
+ * Precondition: @bit must be defined as as setter in genio_bit_alloc().
+ */
+int genio_set_bit(int bit);
+
+/**
+ * genio_power_req() -	Request power on on remote C2C block.
+ *
+ * @state:	1 - power-on request , 0 - power-off request
+ *
+ * This function will request power on of remote C2C block.
+ * This function is non-blocking, and can be called from Soft-IRQ context.
+ *
+ * Returns zero on success, and negative upon error.
+ */
+int genio_power_req(int state);
+
+#endif /*INC_GENIO_H*/
-- 
1.7.0.4

