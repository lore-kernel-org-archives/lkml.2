Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1LGJbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:31:32 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52339 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042Ab1LGJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:28:23 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Paul Bolle <pebolle@tiscali.nl>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 1/9] xshm: Shared Memory layout for ST-E M7400 driver.
Date: Wed,  7 Dec 2011 10:28:00 +0100
Message-Id: <1323250088-1729-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add structures defining the channel configuration and the
shared memory layout used for ST-Ericsson M7400.

These data structures are shared between the Linux host and the
M7400 modem.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 include/linux/xshm/xshm_ipctoc.h |  160 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 160 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/xshm/xshm_ipctoc.h

diff --git a/include/linux/xshm/xshm_ipctoc.h b/include/linux/xshm/xshm_ipctoc.h
new file mode 100644
index 0000000..73ea25b
--- /dev/null
+++ b/include/linux/xshm/xshm_ipctoc.h
@@ -0,0 +1,160 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2010
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef XSHM_TOC
+#define XSHM_TOC
+
+/**
+ * DOC: XSHM Shared Memory Layout
+ *
+ * XSHM defines a set of structures describing the memory layout used
+ * for the Shared Memory IPC. In short &toc_entry points out &ipc_toc,
+ * which points out the &xshm_ipctoc_channel. &xshm_ipctoc_channel defines
+ * the channels used to communicate between host and external device (modem).
+ *
+ *  &xshm_ipctoc_channel can be used in packet-mode or stream-mode,
+ *  and points out &xshm_bufidx holding information about cirular
+ *  buffers, andtheir read/write indices etc.
+ */
+
+#pragma pack(1)
+struct _xshm_offsets {
+	__le32 rx;
+	__le32 tx;
+};
+
+/**
+ * struct xshm_ipctoc - Table Of Content definition for IPC.
+ *
+ * @magic:	Magic shall always be set to Ascii coded string "TC" (2 bytes)
+ * @version:	Main version of the TOC header.
+ * @subver:	Sub version of the TOC header.
+ * @channel_offsets: Offset to both rx and tx direction must be set.
+ *			The array must be terminated by a zero value.
+ *
+ * This struct is stored at the start of the External Shared memory, and
+ * serves as a extended table of contents defining the channel configurations
+ * for the external shared memory protocol between a modem and host.
+ *
+ * This extended table of content (ipctoc) is written to a predefine memory
+ * location and the modem will read this ipctoc during start-up and use this
+ * for setting up the IPC channels and it's buffers.
+ *
+ */
+
+struct xshm_ipctoc {
+	__u8 magic[2];
+	__u8 version;
+	__u8 subver;
+	struct _xshm_offsets channel_offsets[8];
+};
+#define XSHM_PACKET_MODE 0x1
+#define XSHM_STREAM_MODE 0x2
+#define XSHM_LOOP_MODE	 0x4
+#define XSHM_PAIR_MODE	 0x8
+#define XSHM_MODE_MASK	 0x3
+
+#define XSHM_IPCTOC_MAGIC1 'T'
+#define XSHM_IPCTOC_MAGIC2 'C'
+
+/**
+ * struct xshm_ipctoc_channel - Channel descriptor for External Shared memory.
+ *
+ * @offset: Relative address to channel data area.
+ * @size: Total size of a SHM channel area partition.
+ * @mtu: Maximum Transfer Unit for packets in a buffer (packet mode).
+ * @packets: Maximum Number of packets in a buffer (packet mode).
+ * @mode: Mode of channel: Packet mode=1, Stream mode (shm_channel_mode = 2).
+ * @buffers: Number of buffers for the channel.
+ * @ipc: Offset to IPC message location (of type struct xshm_bufidx).
+ * @read_bit: GENI/O bit used to indicate update of the read pointer for
+ *	this channel (at offset ipc).
+ * @write_bit: GENI/O bit used to indicate update of the write pointer for
+ *	this channel (at offset ipc).
+ * @alignment: Protocol specific options for the protocol,
+ *	e.g. packet alignment.
+ *
+ * This struct defines the channel configuration for a single direction.
+ *
+ * This structure is pointed out by the &xshm_toc and is written by
+ * host during start-up and read by modem at firmware boot.
+ *
+ */
+
+struct xshm_ipctoc_channel {
+	__le32 offset;
+	__le32 size;
+/* private: */
+	__u8 unused[3];
+/* public: */
+	__u8 mode;
+	__le32 buffers;
+	__le32 ipc;
+	__le16 write_bit;
+	__le16 read_bit;
+	__u16 mtu;
+	__u8 packets;
+	__u8 alignment;
+};
+
+/**
+ * struct xshm_bufidx - Indices's for a uni-directional xshm channel.
+ *
+ * @read_index: Specify the read index for a channel. This field can
+ *	have value in range of [0.. xshm_ipctoc_channel.buffers -1].
+ *	In stream mode - this is the read index in the ringbuffer.
+ *	In packet mode - this index will at any time refer to the next
+ *	buffer available for read.
+ *
+ * @write_index: Specify the write index for a channel.
+ *	This field can have value in range of [0.. buffers -1].
+ *	In stream mode - this is the write index in the ringbuffer.
+ *	In packet mode - this index will at any time refer to the next
+ *	buffer available for write.
+ *
+ * @size: The actual number of bytes for a buffer at each index.
+ *	  This array has xshm_ipctoc_channel.buffers slots, one for each buffer.
+ *	  The size is updated every time data is written to the buffer.
+ *
+ * @state: The state of the channel, 0 - Closed, 1 - Open
+ *
+ *
+ * This structure contains data for the ring-buffer used in packet and stream
+ * mode, for the external shared memory protocol.
+ * Note that the read_buf_index and the write_buf_index
+ * refer to two different channels. So for a ring buffer used to communicate
+ * from modem, the modem will update the write_buf_index while Linux host
+ * will update read_buf_index.
+ */
+struct xshm_bufidx {
+	__le32 state;
+	__le32 read_index;
+	__le32 write_index;
+	__le32 size[0];
+};
+
+/** struct toc_entry - Points out the boot imiages
+ *
+ * @start: Offset counting from start of memory area to the image data.
+ * @size:  Size of the images in bytes.
+ * @flags: Use 0 if no flags are in use.
+ * @entry: Where to jump to start exeuting. Only applicable
+ *		when using SDRAM. Set to 0xffffffff if unused.
+ * @load_addr: Location in SDRAM to move image. Set to 0xffffffff if
+ *		not applicable.
+ * @name: Name of image.
+ */
+struct toc_entry {
+	__le32 start;
+	__le32 size;
+	__le32 flags;
+	__le32 entry_point;
+	__le32 load_addr;
+	char name[12];
+};
+#pragma pack()
+
+#endif
-- 
1.7.0.4

