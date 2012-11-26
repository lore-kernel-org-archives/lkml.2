Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab2KZRIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:08:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47646 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab2KZRI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 138/270] libceph: verify state after retaking con lock after dispatch
Date: Mon, 26 Nov 2012 14:57:08 -0200
Message-Id: <1353949160-26803-139-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 7b862e07b1a4d5c963d19027f10ea78085f27f9b upstream.

We drop the con mutex when delivering a message.  When we retake the
lock, we need to verify we are still in the OPEN state before
preparing to read the next tag, or else we risk stepping on a
connection that has been closed.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index a6a0c7a..feb5a2a 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2003,7 +2003,6 @@ static void process_message(struct ceph_connection *con)
 	con->ops->dispatch(con, msg);
 
 	mutex_lock(&con->mutex);
-	prepare_read_tag(con);
 }
 
 
@@ -2213,6 +2212,8 @@ more:
 		if (con->in_tag == CEPH_MSGR_TAG_READY)
 			goto more;
 		process_message(con);
+		if (con->state == CON_STATE_OPEN)
+			prepare_read_tag(con);
 		goto more;
 	}
 	if (con->in_tag == CEPH_MSGR_TAG_ACK) {
-- 
1.7.9.5

