Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763010Ab2KBRHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:07:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:33350 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab2KBRHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 10/24] libceph: avoid NULL kref_put when osd reset races with alloc_msg
Date: Fri,  2 Nov 2012 10:06:58 -0700
Message-Id: <20121102170248.163599043@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 9bd952615a42d7e2ce3fa2c632e808e804637a1a upstream.

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
@@ -2750,7 +2750,8 @@ static int ceph_con_in_msg_alloc(struct
 		msg = con->ops->alloc_msg(con, hdr, skip);
 		mutex_lock(&con->mutex);
 		if (con->state != CON_STATE_OPEN) {
-			ceph_msg_put(msg);
+			if (msg)
+				ceph_msg_put(msg);
 			return -EAGAIN;
 		}
 		con->in_msg = msg;


