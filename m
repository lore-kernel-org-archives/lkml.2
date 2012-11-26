Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab2KZRJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:09:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47686 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab2KZRJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 147/270] libceph: avoid NULL kref_put when osd reset races with alloc_msg
Date: Mon, 26 Nov 2012 14:57:17 -0200
Message-Id: <1353949160-26803-148-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 0de041f..692243a 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2746,7 +2746,8 @@ static int ceph_con_in_msg_alloc(struct ceph_connection *con, int *skip)
 		msg = con->ops->alloc_msg(con, hdr, skip);
 		mutex_lock(&con->mutex);
 		if (con->state != CON_STATE_OPEN) {
-			ceph_msg_put(msg);
+			if (msg)
+				ceph_msg_put(msg);
 			return -EAGAIN;
 		}
 		con->in_msg = msg;
-- 
1.7.9.5

