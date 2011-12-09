Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1LIOHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:07:52 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40892 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1LIOHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:07:47 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 03/10] xshm: Configuration for XSHM Channel an devices.
Date: Fri,  9 Dec 2011 15:07:21 +0100
Message-Id: <1323439648-22697-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines the configuration data needed to operate
on a channel. Each channel is represented as a xshm device
containing the necessary configuration data to operate on the channel.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 include/linux/xshm/xshm_dev.h |  253 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 253 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/xshm/xshm_dev.h

diff --git a/include/linux/xshm/xshm_dev.h b/include/linux/xshm/xshm_dev.h
new file mode 100644
index 0000000..bc9e7fa
--- /dev/null
+++ b/include/linux/xshm/xshm_dev.h
@@ -0,0 +1,253 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2011
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef XSHM_DEV_H_
+#define XSHM_DEV_H_
+
+#include <linux/device.h>
+
+#define XSHM_NAMESZ 16
+#define XSHM_MAX_CHANNELS 7
+
+/**
+ * struct xshm_udchannel - Unidirectional channel for xshm driver.
+ *
+ * @addr: Base address of the channel, address must be
+ *		  a kernel logical address.
+ * @buffers: The number of buffers in the channel.
+ * @ch_size: The size of data area for the channel in one direction.
+ * @xfer_bit: GENI/O bit used when sending data (write pointer move)
+ * @xfer_done_bit: GENI/O bit used to indicate avilable buffers
+ *	(read pointer move).
+ * @alignment: Alignment used in payload protocol.
+ * @mtu: Maxium Transfer Unit used for packet in a buffer (Packet mode).
+ * @packets: Maxium number of packets in a buffer (Packet mode).
+ * @state: State of the device 0 - Closed, 1 - Open
+ * @read: Specify the read index for a channel. In packed mode
+ *	this index will at any time refer to the next buffer available for read.
+ *	In stream mode, this will be the read index in the ring-buffer.
+ * @write: Specify the write index for a channel. In packed mode
+ *	this index will at any time refer to the next buffer available for
+ *	write. In stream mode, this will be the write index in the ring-buffer.
+ * @buf_size: In packet mode, this array contains the size of each buffer.
+ *	In stream mode this is unused.
+ *
+ * This external shared memory channel configuration is exported from the
+ * xshm device. It gives the xshm driver the necessary information for
+ * running the shared memory protocol between modem and host.
+ *
+ * Note that two instances of this configuration is needed in order to run a
+ * bi-directional channel.
+ */
+struct xshm_udchannel {
+	void *addr;
+	u32 buffers;
+	u32 ch_size;
+	u8 xfer_done_bit;
+	u8 xfer_bit;
+	u32 mtu;
+	u32 alignment;
+	u32 packets;
+	__le32 *state;
+	__le32 *read;
+	__le32 *write;
+	__le32 *buf_size;
+/* private: */
+	struct kobject kobj; /* kobj must be located at the end */
+};
+
+/**
+ * struct xshm_channel - Channel definition for xshm driver.
+ * @rx: Configuration for RX channel
+ * @tx: Configuration for TX channel
+ * @excl_group: Only channels with the same group ID can be open simultaneously.
+ * @mode: Configuring type of channel PACKET(1), STREAM(2)
+ * @name: Name of interface.
+ * @priority: Priority of the channel.
+ * @latency: Latency of the channel.
+ */
+struct xshm_channel {
+	struct xshm_udchannel rx, tx;
+	u32 excl_group;
+	u32 mode;
+	char name[XSHM_NAMESZ];
+	u32 priority;
+	u32 latency;
+};
+
+#define XSHM_OPEN   1
+#define XSHM_CLOSED 0
+
+enum xshm_dev_state {
+	XSHM_DEV_CLOSED = 0,
+	XSHM_DEV_OPENING,
+	XSHM_DEV_OPEN,
+	XSHM_DEV_ACTIVE,
+};
+
+/**
+ * struct xshm_dev - Device definition for xshm device.
+ *
+ * @dev: Reference to device
+ * @cfg: Configuration for the Channel
+ * @state: State of the device: Closed - No user space client is using it,
+ *	Open - Open but no payload queued, Active - Payload queued on device.
+ *
+ * @open: The driver calls open() when channel is taken into use.
+ *	This function will fail if channel configuration is inconsistent,
+ *	or upon resource conflicts with other channels.
+ *
+ * @open_cb: The device calls open_cb() when is ready for use.
+ *
+ * @close: Called by the driver when a channel is no longer in use.
+ *
+ * @close_cb: The device calls close_cb() to notify about remote side closure.
+ *
+ * @ipc_tx_release_cb: This callback is triggered by the modem when a
+ *	transmit operation has completed and the buffer can be reused.
+ *	This function must be set by the driver upon device registration.
+ *	The "more" flag is set if ipc_rx_cb() call is coming immediately
+ *	after this call to ipc_tx_release_cb().
+ *
+ * @ipc_rx_cb: The driver gets this callback when the modem sends a buffer
+ *	from the modem. The driver must call ipc_rx_release()
+ *	to make the buffer available again when the received buffer has been
+ *	processed.
+ *	This function pointer must be set by the driver upon device
+ *	registration.
+ *
+ * @ipc_rx_release: Called by the driver when a RX operation has completed
+ *	and that the rx-buffer is released.
+ *
+ * @ipc_tx: Called by the driver when a TX buffer shall be sent to the modem.
+ *
+ * @driver_data: pointer to driver specific data.
+ *
+ * When communicating between two systems (e.g. modem and host),
+ * external shared memory can bused (e.g. C2C or DPRAM).
+ *
+ * This structure is used by the xshm device representing the
+ * External Shared Memory.
+ *
+ * The this structure contains configuration data for the xshm device and
+ * functions pointers for IPC communication between Linux host and modem.
+ * The external shared memory protocol memory e.g. C2C or DPRAM
+ * together is a IPC mechanism for transporting small commands such as
+ * Mailbox or GENI/O.
+ *
+ * This data structure is initiated by the xshm device, except
+ * for the functions ipc_rx_cb() and ipc_tx_release_cb(). They must be set by
+ * the xshm-driver when device is registering.
+ */
+
+struct xshm_dev {
+	struct device dev;
+	struct xshm_channel cfg;
+	enum xshm_dev_state state;
+	int (*open)(struct xshm_dev *dev);
+	void (*close)(struct xshm_dev *dev);
+	int (*ipc_rx_release)(struct xshm_dev *dev, bool more);
+	int (*ipc_tx)(struct xshm_dev *dev);
+	int (*open_cb)(void *drv);
+	void (*close_cb)(void *drv);
+	int (*ipc_rx_cb)(void *drv);
+	int (*ipc_tx_release_cb)(void *drv);
+	void *driver_data;
+	/* private: */
+	struct list_head node;
+	void *priv;
+};
+
+/**
+ * xshm_driver - operations for a xshm I/O driver
+ * @driver: underlying device driver (populate name and owner).
+ * @mode: Type of channel for driver: PACKET(1), STREAM(2)
+ * @probe: the function to call when a device is found.  Returns 0 or -errno.
+ * @remove: the function when a device is removed.
+ */
+struct xshm_driver {
+	struct device_driver driver;
+	u32 mode;
+	int (*probe)(struct xshm_dev *dev);
+	void (*remove)(struct xshm_dev *dev);
+};
+
+/**
+ * xshm_register_devices() - Register an array of xshm devices.
+ * @devs: XSHM devices to register
+ * @devices: Number of devices in array
+ * @attr: Firmware file attribute
+ */
+int xshm_register_devices(struct xshm_dev *devs[], int devices,
+				const struct bin_attribute *attr);
+
+/**
+ * xshm_register_driver() - Register an xshm driver.
+ * @driver: XSHM driver instance
+ */
+
+int xshm_register_driver(struct xshm_driver *driver);
+/**
+ * xshm_unregister_driver() - Unregister an xshm driver.
+ * @driver: XSHM driver instance
+ */
+void xshm_unregister_driver(struct xshm_driver *driver);
+
+/**
+ * xshm_register_device() - Register an xshm device.
+ * @dev: XSHM device instance
+ */
+int xshm_register_device(struct xshm_dev *dev);
+
+/**
+ * xshm_unregister_device() - Unregister an xshm device.
+ * @dev: XSHM device instance
+ */
+void xshm_unregister_device(struct xshm_dev *dev);
+
+/**
+ * xshm_foreach_dev - device iterator.
+ * @data: data for the callback.
+ * @fn: function to be called for each device.
+ *
+ * Iterate over xshm bus's list of devices, and call @fn for each,
+ * passing it @data.
+ */
+void xshm_foreach_dev(void fn(struct xshm_dev*, void *data), void *data);
+
+/**
+ * xshm_ipc_ready() - Notify that GENO bit READY_FOR_IPC is set
+*/
+void xshm_ipc_ready(void);
+
+/**
+ * xshm_caif_ready() - Notify that GENO bit READY_FOR_CAIF is set
+*/
+void xshm_caif_ready(void);
+
+/**
+ * ready_for_ipc - XSHM stream device can be connected
+*/
+extern bool ready_for_ipc;
+
+/**
+ * ready_for_caif - XSHM packet device can be connected
+*/
+extern bool ready_for_caif;
+
+/**
+ * xshm_reset() - XSHM unregister and remove all XSHM devices
+*/
+void xshm_reset(void);
+
+/**
+ * genio_ipc_ready_cb() - Callback for CAIF_READY notification.
+*/
+void genio_ipc_ready_cb(void);
+
+void xshm_boot_exit(void);
+int xshm_boot_init(void);
+#endif
-- 
1.7.0.4

