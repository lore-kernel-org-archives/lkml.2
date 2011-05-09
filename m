Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab1EJIoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:44:13 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35393
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756046Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 203/206] Staging: hv: Get rid of vmbus_packet_format.h
Date: Mon,  9 May 2011 14:58:05 -0700
Message-Id: <1304978288-22999-203-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of vmbus_packet_format.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_packet_format.h |  161 ------------------------------
 1 files changed, 0 insertions(+), 161 deletions(-)
 delete mode 100644 drivers/staging/hv/vmbus_packet_format.h

diff --git a/drivers/staging/hv/vmbus_packet_format.h b/drivers/staging/hv/vmbus_packet_format.h
deleted file mode 100644
index c0b2c2b..0000000
--- a/drivers/staging/hv/vmbus_packet_format.h
+++ /dev/null
@@ -1,161 +0,0 @@
-/*
- *
- * Copyright (c) 2009, Microsoft Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
- * Authors:
- *   Haiyang Zhang <haiyangz@microsoft.com>
- *   Hank Janssen  <hjanssen@microsoft.com>
- *
- */
-
-#ifndef _VMBUSPACKETFORMAT_H_
-#define _VMBUSPACKETFORMAT_H_
-
-struct vmpacket_descriptor {
-	u16 type;
-	u16 offset8;
-	u16 len8;
-	u16 flags;
-	u64 trans_id;
-} __packed;
-
-struct vmpacket_header {
-	u32 prev_pkt_start_offset;
-	struct vmpacket_descriptor descriptor;
-} __packed;
-
-struct vmtransfer_page_range {
-	u32 byte_count;
-	u32 byte_offset;
-} __packed;
-
-struct vmtransfer_page_packet_header {
-	struct vmpacket_descriptor d;
-	u16 xfer_pageset_id;
-	bool sender_owns_set;
-	u8 reserved;
-	u32 range_cnt;
-	struct vmtransfer_page_range ranges[1];
-} __packed;
-
-struct vmgpadl_packet_header {
-	struct vmpacket_descriptor d;
-	u32 gpadl;
-	u32 reserved;
-} __packed;
-
-struct vmadd_remove_transfer_page_set {
-	struct vmpacket_descriptor d;
-	u32 gpadl;
-	u16 xfer_pageset_id;
-	u16 reserved;
-} __packed;
-
-/*
- * This structure defines a range in guest physical space that can be made to
- * look virtually contiguous.
- */
-struct gpa_range {
-	u32 byte_count;
-	u32 byte_offset;
-	u64 pfn_array[0];
-};
-
-/*
- * This is the format for an Establish Gpadl packet, which contains a handle by
- * which this GPADL will be known and a set of GPA ranges associated with it.
- * This can be converted to a MDL by the guest OS.  If there are multiple GPA
- * ranges, then the resulting MDL will be "chained," representing multiple VA
- * ranges.
- */
-struct vmestablish_gpadl {
-	struct vmpacket_descriptor d;
-	u32 gpadl;
-	u32 range_cnt;
-	struct gpa_range range[1];
-} __packed;
-
-/*
- * This is the format for a Teardown Gpadl packet, which indicates that the
- * GPADL handle in the Establish Gpadl packet will never be referenced again.
- */
-struct vmteardown_gpadl {
-	struct vmpacket_descriptor d;
-	u32 gpadl;
-	u32 reserved;	/* for alignment to a 8-byte boundary */
-} __packed;
-
-/*
- * This is the format for a GPA-Direct packet, which contains a set of GPA
- * ranges, in addition to commands and/or data.
- */
-struct vmdata_gpa_direct {
-	struct vmpacket_descriptor d;
-	u32 reserved;
-	u32 range_cnt;
-	struct gpa_range range[1];
-} __packed;
-
-/* This is the format for a Additional Data Packet. */
-struct vmadditional_data {
-	struct vmpacket_descriptor d;
-	u64 total_bytes;
-	u32 offset;
-	u32 byte_cnt;
-	unsigned char data[1];
-} __packed;
-
-union vmpacket_largest_possible_header {
-	struct vmpacket_descriptor simple_hdr;
-	struct vmtransfer_page_packet_header xfer_page_hdr;
-	struct vmgpadl_packet_header gpadl_hdr;
-	struct vmadd_remove_transfer_page_set add_rm_xfer_page_hdr;
-	struct vmestablish_gpadl establish_gpadl_hdr;
-	struct vmteardown_gpadl teardown_gpadl_hdr;
-	struct vmdata_gpa_direct data_gpa_direct_hdr;
-};
-
-#define VMPACKET_DATA_START_ADDRESS(__packet)	\
-	(void *)(((unsigned char *)__packet) +	\
-	 ((struct vmpacket_descriptor)__packet)->offset8 * 8)
-
-#define VMPACKET_DATA_LENGTH(__packet)		\
-	((((struct vmpacket_descriptor)__packet)->len8 -	\
-	  ((struct vmpacket_descriptor)__packet)->offset8) * 8)
-
-#define VMPACKET_TRANSFER_MODE(__packet)	\
-	(((struct IMPACT)__packet)->type)
-
-enum vmbus_packet_type {
-	VM_PKT_INVALID				= 0x0,
-	VM_PKT_SYNCH				= 0x1,
-	VM_PKT_ADD_XFER_PAGESET			= 0x2,
-	VM_PKT_RM_XFER_PAGESET			= 0x3,
-	VM_PKT_ESTABLISH_GPADL			= 0x4,
-	VM_PKT_TEARDOWN_GPADL			= 0x5,
-	VM_PKT_DATA_INBAND			= 0x6,
-	VM_PKT_DATA_USING_XFER_PAGES		= 0x7,
-	VM_PKT_DATA_USING_GPADL			= 0x8,
-	VM_PKT_DATA_USING_GPA_DIRECT		= 0x9,
-	VM_PKT_CANCEL_REQUEST			= 0xa,
-	VM_PKT_COMP				= 0xb,
-	VM_PKT_DATA_USING_ADDITIONAL_PKT	= 0xc,
-	VM_PKT_ADDITIONAL_DATA			= 0xd
-};
-
-#define VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED	1
-
-#endif
-- 
1.7.4.1

