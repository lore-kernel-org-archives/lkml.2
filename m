Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0JRNfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:35:11 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60179 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754275Ab0JRNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:35:09 -0400
Date: Mon, 18 Oct 2010 08:35:08 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch] Incoming XPC channel messages can come in after the
 channel's partition structures have been torn down.
Message-ID: <20101018133508.GC14064@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Under some workloads, some channel messages have been observed being
delayed on the sending side past the point where the receiving side
has been able to tear down its partition structures.  This condition is
already detected in xpc_handle_activate_IRQ_uv(), but that information
is not given to xpc_handle_activate_mq_msg_uv().  As a result,
xpc_handle_activate_mq_msg_uv() assumes the structures still exist and
references them.

Signed-off-by: Robin Holt <holt@sgi.com>

---

 drivers/misc/sgi-xp/xpc_uv.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

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
