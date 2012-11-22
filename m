Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab2KVW3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:29:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:49022 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab2KVSdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 166/171] libceph: avoid NULL kref_put when osd reset races with alloc_msg
Date: Wed, 21 Nov 2012 16:41:52 -0800
Message-Id: <20121122004050.001251870@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit 9bd952615a42d7e2ce3fa2c632e808e804637a1a)

The ceph_on_in_msg_alloc() method drops con->mutex while it allocates a
message.  If that races with a timeout that resends a zillion messages and
resets the connection, and the ->alloc_msg() method returns a NULL message,
it will call ceph_msg_put(NULL) and BUG.

Fix by only calling put if msg is non-NULL.

Fixes http://tracker.newdream.net/issues/3142

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2746,7 +2746,8 @@ static int ceph_con_in_msg_alloc(struct
 		msg = con->ops->alloc_msg(con, hdr, skip);
 		mutex_lock(&con->mutex);
 		if (con->state != CON_STATE_OPEN) {
-			ceph_msg_put(msg);
+			if (msg)
+				ceph_msg_put(msg);
 			return -EAGAIN;
 		}
 		con->in_msg = msg;


