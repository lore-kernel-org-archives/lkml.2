Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0LHAsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:48:32 -0500
Received: from kroah.org ([198.145.64.141]:58773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab0LHAs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:27 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:37 2010
Message-Id: <20101208004436.927657461@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:45:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [126/127] X86: uv: xpc_make_first_contact hang due to not accepting ACTIVE state
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robin Holt <holt@sgi.com>

commit dbd2918ec65c35f36bb102c88eafe87be0552f6f upstream.

Many times while the initial connection is being made, the contacted
partition will send back both the ACTIVATING and the ACTIVE
remote_act_state changes in very close succescion.  The 1/4 second delay
in the make first contact loop is large enough to nearly always miss the
ACTIVATING state change.

Since either state indicates the remote partition has acknowledged our
state change, accept either.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-xp/xpc_uv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -1038,7 +1038,8 @@ xpc_make_first_contact_uv(struct xpc_par
 	xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
 				      XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV);
 
-	while (part->sn.uv.remote_act_state != XPC_P_AS_ACTIVATING) {
+	while (!((part->sn.uv.remote_act_state == XPC_P_AS_ACTIVATING) ||
+		 (part->sn.uv.remote_act_state == XPC_P_AS_ACTIVE))) {
 
 		dev_dbg(xpc_part, "waiting to make first contact with "
 			"partition %d\n", XPC_PARTID(part));


