Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1ABH0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:26:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:37267 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1ABH02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:26:28 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Robin Holt <holt@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 260/260] sgi-xp: incoming XPC channel messages can come in after the channel's partition structures have been torn down
Date: Sun,  2 Jan 2011 02:19:16 -0500
Message-Id: <1293952756-15010-261-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:53.0730 (UTC) FILETIME=[26527420:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>

commit 09358972bff5ce99de496bbba97c85d417b3c054 upstream.

Under some workloads, some channel messages have been observed being
delayed on the sending side past the point where the receiving side has
been able to tear down its partition structures.

This condition is already detected in xpc_handle_activate_IRQ_uv(), but
that information is not given to xpc_handle_activate_mq_msg_uv().  As a
result, xpc_handle_activate_mq_msg_uv() assumes the structures still exist
and references them, causing a NULL-pointer deref.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/misc/sgi-xp/xpc_uv.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 1f59ee2..17bbacb 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -417,6 +417,7 @@ xpc_process_activate_IRQ_rcvd_uv(void)
 static void
 xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 			      struct xpc_activate_mq_msghdr_uv *msg_hdr,
+			      int part_setup,
 			      int *wakeup_hb_checker)
 {
 	unsigned long irq_flags;
@@ -481,6 +482,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV: {
 		struct xpc_activate_mq_msg_chctl_closerequest_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_closerequest_uv,
 				   hdr);
@@ -497,6 +501,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV: {
 		struct xpc_activate_mq_msg_chctl_closereply_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_closereply_uv,
 				   hdr);
@@ -511,6 +518,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV: {
 		struct xpc_activate_mq_msg_chctl_openrequest_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_openrequest_uv,
 				   hdr);
@@ -528,6 +538,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV: {
 		struct xpc_activate_mq_msg_chctl_openreply_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_openreply_uv, hdr);
 		args = &part->remote_openclose_args[msg->ch_number];
@@ -545,6 +558,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENCOMPLETE_UV: {
 		struct xpc_activate_mq_msg_chctl_opencomplete_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				xpc_activate_mq_msg_chctl_opencomplete_uv, hdr);
 		spin_lock_irqsave(&part->chctl_lock, irq_flags);
@@ -621,6 +637,7 @@ xpc_handle_activate_IRQ_uv(int irq, void *dev_id)
 
 			part_referenced = xpc_part_ref(part);
 			xpc_handle_activate_mq_msg_uv(part, msg_hdr,
+						      part_referenced,
 						      &wakeup_hb_checker);
 			if (part_referenced)
 				xpc_part_deref(part);
-- 
1.7.3.3

