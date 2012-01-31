Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2AaI4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:56:44 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38462 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479Ab2AaI4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:56:43 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RESEND PATCHv5 02/11] modem_shm: Channel config definitions for ST-E M7400 driver.
Date: Tue, 31 Jan 2012 09:48:37 +0100
Message-Id: <1327999726-8774-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add definitions of netlink commands for setting the channel
configuration and shared memory layout for ST-Ericsson M7400.
The netlink commands are use to configure channels, reset configuration,
making channel configuration available to modem, etc.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 include/linux/Kbuild                        |    1 +
 include/linux/modem_shm/Kbuild              |    1 +
 include/linux/modem_shm/modem_shm_netlink.h |   95 +++++++++++++++++++++++++++
 3 files changed, 97 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/modem_shm/Kbuild
 create mode 100644 include/linux/modem_shm/modem_shm_netlink.h

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index c94e717..2ddddd3 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -17,6 +17,7 @@ header-y += netfilter_bridge/
 header-y += netfilter_ipv4/
 header-y += netfilter_ipv6/
 header-y += usb/
+header-y += shm/
 header-y += wimax/
 
 objhdr-y += version.h
diff --git a/include/linux/modem_shm/Kbuild b/include/linux/modem_shm/Kbuild
new file mode 100644
index 0000000..165b66c
--- /dev/null
+++ b/include/linux/modem_shm/Kbuild
@@ -0,0 +1 @@
+header-y += modem_shm_netlink.h
diff --git a/include/linux/modem_shm/modem_shm_netlink.h b/include/linux/modem_shm/modem_shm_netlink.h
new file mode 100644
index 0000000..fedeab5
--- /dev/null
+++ b/include/linux/modem_shm/modem_shm_netlink.h
@@ -0,0 +1,95 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author: Sjur Brændeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef SHM_NL_H_
+#define SHM_NL_H_
+
+#define SHM_PROTO_VERSION 1
+#define SHM_PROTO_SUB_VERSION 0
+#define SHM_NETLINK_VERSION 1
+/**
+ * enum SHM_COMMANDS - Attributes used for configuring SHM device.
+ *
+ * @SHM_C_ADD_STREAM_CHANNEL: Adds a Stream Channel.
+ * This will cause an instance of SHM-CHR to be created.
+ * @SHM_C_ADD_PACKET_CHANNEL: Adds a Packet Channel.
+ * This will cause an instance of CAIF-SHM to be created.
+ * @SHM_C_COMMIT: formats and write Channel configuration data to
+ *	Shared Memory.
+ * @SHM_C_SET_ADDR: Writes the TOC address to GENO register.
+ * @SHM_C_REGISTER:  Initiates registration of the channel devices.
+ *	This will cause shm - character devices or
+ *	CAIF network instances to be created.
+ * @SHM_C_RESET:  Reset the configuration data and removes the
+ *	platform devices and their associated channel configuration.
+ *	ipc_ready and caif_ready is set to false.
+ *
+ * A normal sequence of events is: [SHM_C_RESET], [SHM_C_ADD_X_CHANNEL],
+ *	SHM_C_COMMIT, SHM_C_REGISTER, SHM_C_SET_ADDR.
+ */
+enum SHM_COMMANDS {
+	SHM_C_ADD_STREAM_CHANNEL = 1,
+	SHM_C_ADD_PACKET_CHANNEL,
+	SHM_C_RESET,
+	SHM_C_SET_ADDR,
+	SHM_C_COMMIT,
+	SHM_C_REGISTER,
+	__SHM_C_VERIFY,
+	__SHM_C_MAX
+};
+
+/**
+ * enum SHM_ATTRIBUTES - Attributes used for configuring SHM device.
+ * @SHM_A_VERSION: Version of SHM netlink protocol. Type NLA_U8
+ * @SHM_A_SUB_VERSION: Sub-version of SHM netlink protocol. Type NLA_U8
+ * @SHM_A_NAME: Name of the channel, max 15 characters. Type NLA_NUL_STRING
+ * @SHM_A_EXCL_GROUP: Devices may be part of a group. Devices from the
+ *	same group are allowed to be open simultaneously,
+ *	but devices from different groups cannot be opened
+ *	at the same time. Type NLA_U8.
+ * @SHM_A_RX_CHANNEL: The RX direction attributes. Type NLA_NESTED.
+ *	Each channel may contain the attributes - SHM_A_CHANNEL_SIZE,
+ *	SHM_A_CHANNEL_BUFFERS, SHM_A_ALIGNMENT, SHM_A_MTU.
+ *
+ * @SHM_A_TX_CHANNEL: The TX direction attributes. Type NLA_NESTED.
+ *
+ * @SHM_A_CHANNEL_SIZE: Size of the data area for a channel. Specified
+ *	for RX, TX. Type NLA_U32,
+ * @SHM_A_CHANNEL_BUFFERS: Numer of buffers for a packet channel.
+ *	This attribute is only used for packet channels.  Specified for RX, TX.
+ *	Type NLA_U32,
+ * @SHM_A_ALIGNMENT: Alignment for each packet in a buffer. This attribute
+ *	 is only used for packet channels.  Specified for RX, TX.Type NLA_U8,
+ * @SHM_A_MTU: Maximum Transfer Unit for packets in a buffer.
+ *	This is only appplicable for packet channels.
+ *	Specified for RX, TX.Type NLA_U16,
+ * @SHM_A_PACKETS: Maximum number of packets in a buffer. Type NLA_U8
+ * @SHM_A_PRIORITY: Priority of the channel, legal range is 0-7 where
+ *	0 is lowest priority. Type NLA_U8.
+ * @SHM_A_LATENCY: Latency for channel, value:0 means low latency
+ *	 and low bandwidth,
+ *	 value 1 means high latency and high bandwidth. Type NLA_U8.
+ */
+enum SHM_ATTRIBUTES {
+	__SHM_A_FLAGS = 1,		/* Test flags: NLA_U32 */
+	SHM_A_VERSION,
+	SHM_A_SUB_VERSION,
+	SHM_A_NAME,
+	SHM_A_EXCL_GROUP,
+	SHM_A_RX_CHANNEL,
+	SHM_A_TX_CHANNEL,
+	SHM_A_CHANNEL_SIZE,
+	SHM_A_CHANNEL_BUFFERS,
+	SHM_A_ALIGNMENT,
+	SHM_A_MTU,
+	SHM_A_PACKETS,
+	SHM_A_PRIORITY,
+	SHM_A_LATENCY,
+	__SHM_A_MAX,
+};
+#define SHM_A_MAX (__SHM_A_MAX - 1)
+
+#endif /* SHM_NL_H_ */
-- 
1.7.0.4

