Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab2KZRIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:08:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280Ab2KZRIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 141/270] libceph: recheck con state after allocating incoming message
Date: Mon, 26 Nov 2012 14:57:11 -0200
Message-Id: <1353949160-26803-142-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 6139919133377652992a5fe134e22abce3e9c25e upstream.

We drop the lock when calling the ->alloc_msg() con op, which means
we need to (a) not clobber con->in_msg without the mutex held, and (b)
we need to verify that we are still in the OPEN state when we retake
it to avoid causing any mayhem.  If the state does change, -EAGAIN
will get us back to con_work() and loop.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 13b549b..b6655b1 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2735,9 +2735,16 @@ static int ceph_con_in_msg_alloc(struct ceph_connection *con, int *skip)
 	BUG_ON(con->in_msg != NULL);
 
 	if (con->ops->alloc_msg) {
+		struct ceph_msg *msg;
+
 		mutex_unlock(&con->mutex);
-		con->in_msg = con->ops->alloc_msg(con, hdr, skip);
+		msg = con->ops->alloc_msg(con, hdr, skip);
 		mutex_lock(&con->mutex);
+		if (con->state != CON_STATE_OPEN) {
+			ceph_msg_put(msg);
+			return -EAGAIN;
+		}
+		con->in_msg = msg;
 		if (con->in_msg) {
 			con->in_msg->con = con->ops->get(con);
 			BUG_ON(con->in_msg->con == NULL);
-- 
1.7.9.5

