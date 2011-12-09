Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1LIOHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:07:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41606 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab1LIOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:07:44 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 02/10] xshm: Channel config definitions for ST-E M7400 driver.
Date: Fri,  9 Dec 2011 15:07:20 +0100
Message-Id: <1323439648-22697-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netlink parameters used for configuring channels from user space.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 include/linux/Kbuild              |    1 +
 include/linux/xshm/Kbuild         |    1 +
 include/linux/xshm/xshm_netlink.h |   95 +++++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/xshm/Kbuild
 create mode 100644 include/linux/xshm/xshm_netlink.h

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index f6ae2fa..504e113 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -18,6 +18,7 @@ header-y += netfilter_bridge/
 header-y += netfilter_ipv4/
 header-y += netfilter_ipv6/
 header-y += usb/
+header-y += xshm/
 header-y += wimax/
 
 objhdr-y += version.h
diff --git a/include/linux/xshm/Kbuild b/include/linux/xshm/Kbuild
new file mode 100644
index 0000000..4315a21
--- /dev/null
+++ b/include/linux/xshm/Kbuild
@@ -0,0 +1 @@
+header-y += xshm_netlink.h
diff --git a/include/linux/xshm/xshm_netlink.h b/include/linux/xshm/xshm_netlink.h
new file mode 100644
index 0000000..80b01de
--- /dev/null
+++ b/include/linux/xshm/xshm_netlink.h
@@ -0,0 +1,95 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2011
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef XSHM_NL_H_
+#define XSHM_NL_H_
+
+#define XSHM_PROTO_VERSION 1
+#define XSHM_PROTO_SUB_VERSION 0
+#define XSHM_NETLINK_VERSION 1
+/**
+ * enum XSHM_COMMANDS - Attributes used for configuring XSHM device.
+ *
+ * @XSHM_C_ADD_STREAM_CHANNEL: Adds a Stream Channel.
+ * This will cause an instance of XSHM-CHR to be created.
+ * @XSHM_C_ADD_PACKET_CHANNEL: Adds a Packet Channel.
+ * This will cause an instance of CAIF-SHM to be created.
+ * @XSHM_C_COMMIT: formats and write Channel configuration data to
+ *	Shared Memory.
+ * @XSHM_C_SET_ADDR: Writes the TOC address to GENO register.
+ * @XSHM_C_REGISTER:  Initiates registration of the channel devices.
+ *	This will cause xshm - character devices or
+ *	CAIF network instances to be created.
+ * @XSHM_C_RESET:  Reset the configuration data and removes the
+ *	platform devices and their associated channel configuration.
+ *	ipc_ready and caif_ready is set to false.
+ *
+ * A normal sequence of events is: [XSHM_C_RESET], [XSHM_C_ADD_X_CHANNEL],
+ *	XSHM_C_COMMIT, XSHM_C_REGISTER, XSHM_C_SET_ADDR.
+ */
+enum XSHM_COMMANDS {
+	XSHM_C_ADD_STREAM_CHANNEL = 1,
+	XSHM_C_ADD_PACKET_CHANNEL,
+	XSHM_C_RESET,
+	XSHM_C_SET_ADDR,
+	XSHM_C_COMMIT,
+	XSHM_C_REGISTER,
+	__XSHM_C_VERIFY,
+	__XSHM_C_MAX
+};
+
+/**
+ * enum XSHM_ATTRIBUTES - Attributes used for configuring XSHM device.
+ * @XSHM_A_VERSION: Version of XSHM netlink protocol. Type NLA_U8
+ * @XSHM_A_SUB_VERSION: Sub-version of XSHM netlink protocol. Type NLA_U8
+ * @XSHM_A_NAME: Name of the channel, max 15 characters. Type NLA_NUL_STRING
+ * @XSHM_A_EXCL_GROUP: Devices may be part of a group. Devices from the
+ *	same group are allowed to be open simultaneously,
+ *	but devices from different groups cannot be opened
+ *	at the same time. Type NLA_U8.
+ * @XSHM_A_RX_CHANNEL: The RX direction attributes. Type NLA_NESTED.
+ *	Each channel may contain the attributes - XSHM_A_CHANNEL_SIZE,
+ *	XSHM_A_CHANNEL_BUFFERS, XSHM_A_ALIGNMENT, XSHM_A_MTU.
+ *
+ * @XSHM_A_TX_CHANNEL: The TX direction attributes. Type NLA_NESTED.
+ *
+ * @XSHM_A_CHANNEL_SIZE: Size of the data area for a channel. Specified
+ *	for RX, TX. Type NLA_U32,
+ * @XSHM_A_CHANNEL_BUFFERS: Numer of buffers for a packet channel.
+ *	This attribute is only used for packet channels.  Specified for RX, TX.
+ *	Type NLA_U32,
+ * @XSHM_A_ALIGNMENT: Alignment for each packet in a buffer. This attribute
+ *	 is only used for packet channels.  Specified for RX, TX.Type NLA_U8,
+ * @XSHM_A_MTU: Maximum Transfer Unit for packets in a buffer.
+ *	This is only appplicable for packet channels.
+ *	Specified for RX, TX.Type NLA_U16,
+ * @XSHM_A_PACKETS: Maximum number of packets in a buffer. Type NLA_U8
+ * @XSHM_A_PRIORITY: Priority of the channel, legal range is 0-7 where
+ *	0 is lowest priority. Type NLA_U8.
+ * @XSHM_A_LATENCY: Latency for channel, value:0 means low latency
+ *	 and low bandwidth,
+ *	 value 1 means high latency and high bandwidth. Type NLA_U8.
+ */
+enum XSHM_ATTRIBUTES {
+	__XSHM_A_FLAGS = 1,		/* Test flags: NLA_U32 */
+	XSHM_A_VERSION,
+	XSHM_A_SUB_VERSION,
+	XSHM_A_NAME,
+	XSHM_A_EXCL_GROUP,
+	XSHM_A_RX_CHANNEL,
+	XSHM_A_TX_CHANNEL,
+	XSHM_A_CHANNEL_SIZE,
+	XSHM_A_CHANNEL_BUFFERS,
+	XSHM_A_ALIGNMENT,
+	XSHM_A_MTU,
+	XSHM_A_PACKETS,
+	XSHM_A_PRIORITY,
+	XSHM_A_LATENCY,
+	__XSHM_A_MAX,
+};
+#define XSHM_A_MAX (__XSHM_A_MAX - 1)
+
+#endif /* XSHM_NL_H_ */
-- 
1.7.0.4

