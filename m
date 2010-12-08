Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0LHAs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:48:28 -0500
Received: from kroah.org ([198.145.64.141]:58768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab0LHAs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:26 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:36 2010
Message-Id: <20101208004436.833626647@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:45:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [125/127] x86: uv: XPC receive message reuse triggers invalid BUG_ON()
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robin Holt <holt@sgi.com>

commit 046d6c563b1c6226bbf0f84e5b2413ad8ab921a1 upstream.

This was a difficult bug to trip.  XPC was in the middle of sending an
acknowledgement for a received message.

In xpc_received_payload_uv():
.
        ret = xpc_send_gru_msg(ch->sn.uv.cached_notify_gru_mq_desc, msg,
                               sizeof(struct xpc_notify_mq_msghdr_uv));
        if (ret != xpSuccess)
                XPC_DEACTIVATE_PARTITION(&xpc_partitions[ch->partid], ret);

        msg->hdr.msg_slot_number += ch->remote_nentries;

at the point in xpc_send_gru_msg() where the hardware has dispatched the
acknowledgement, the remote side is able to reuse the message structure
and send a message with a different slot number.  This problem is made
worse by interrupts.

The adjustment of msg_slot_number and the BUG_ON in
xpc_handle_notify_mq_msg_uv() which verifies the msg_slot_number is
consistent are only used for debug purposes.  Since a fix for this that
preserves the debug functionality would either have to infringe upon the
payload or allocate another structure just for debug, I decided to remove
it entirely.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-xp/xpc_uv.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -1441,7 +1441,6 @@ xpc_handle_notify_mq_msg_uv(struct xpc_p
 	msg_slot = ch_uv->recv_msg_slots +
 	    (msg->hdr.msg_slot_number % ch->remote_nentries) * ch->entry_size;
 
-	BUG_ON(msg->hdr.msg_slot_number != msg_slot->hdr.msg_slot_number);
 	BUG_ON(msg_slot->hdr.size != 0);
 
 	memcpy(msg_slot, msg, msg->hdr.size);
@@ -1665,8 +1664,6 @@ xpc_received_payload_uv(struct xpc_chann
 			       sizeof(struct xpc_notify_mq_msghdr_uv));
 	if (ret != xpSuccess)
 		XPC_DEACTIVATE_PARTITION(&xpc_partitions[ch->partid], ret);
-
-	msg->hdr.msg_slot_number += ch->remote_nentries;
 }
 
 static struct xpc_arch_operations xpc_arch_ops_uv = {


