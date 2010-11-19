Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab0KSVqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:46:36 -0500
Received: from kroah.org ([198.145.64.141]:51924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab0KSVpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:45 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:13 2010
Message-Id: <20101119214413.124737209@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:43:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robin Holt <holt@sgi.com>
Subject: [45/45] sgi-xp: incoming XPC channel messages can come in after the channels partition structures have been torn down
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-xp/xpc_uv.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -409,6 +409,7 @@ xpc_process_activate_IRQ_rcvd_uv(void)
 static void
 xpc_handle_activate_mq_msg_uv(struct xpc_partition *part,
 			      struct xpc_activate_mq_msghdr_uv *msg_hdr,
+			      int part_setup,
 			      int *wakeup_hb_checker)
 {
 	unsigned long irq_flags;
@@ -473,6 +474,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV: {
 		struct xpc_activate_mq_msg_chctl_closerequest_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_closerequest_uv,
 				   hdr);
@@ -489,6 +493,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV: {
 		struct xpc_activate_mq_msg_chctl_closereply_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_closereply_uv,
 				   hdr);
@@ -503,6 +510,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV: {
 		struct xpc_activate_mq_msg_chctl_openrequest_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_openrequest_uv,
 				   hdr);
@@ -520,6 +530,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV: {
 		struct xpc_activate_mq_msg_chctl_openreply_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				   xpc_activate_mq_msg_chctl_openreply_uv, hdr);
 		args = &part->remote_openclose_args[msg->ch_number];
@@ -537,6 +550,9 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 	case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENCOMPLETE_UV: {
 		struct xpc_activate_mq_msg_chctl_opencomplete_uv *msg;
 
+		if (!part_setup)
+			break;
+
 		msg = container_of(msg_hdr, struct
 				xpc_activate_mq_msg_chctl_opencomplete_uv, hdr);
 		spin_lock_irqsave(&part->chctl_lock, irq_flags);
@@ -613,6 +629,7 @@ xpc_handle_activate_IRQ_uv(int irq, void
 
 			part_referenced = xpc_part_ref(part);
 			xpc_handle_activate_mq_msg_uv(part, msg_hdr,
+						      part_referenced,
 						      &wakeup_hb_checker);
 			if (part_referenced)
 				xpc_part_deref(part);


