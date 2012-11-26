Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab2KZRu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:50:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47650 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab2KZRIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 139/270] libceph: avoid dropping con mutex before fault
Date: Mon, 26 Nov 2012 14:57:09 -0200
Message-Id: <1353949160-26803-140-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 8636ea672f0c5ab7478c42c5b6705ebd1db7eb6a upstream.

The ceph_fault() function takes the con mutex, so we should avoid
dropping it before calling it.  This fixes a potential race with
another thread calling ceph_con_close(), or _open(), or similar (we
don't reverify con->state after retaking the lock).

Add annotation so that lockdep realizes we will drop the mutex before
returning.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index feb5a2a..c3b628c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2336,7 +2336,6 @@ done_unlocked:
 	return;
 
 fault:
-	mutex_unlock(&con->mutex);
 	ceph_fault(con);     /* error/fault path */
 	goto done_unlocked;
 }
@@ -2347,9 +2346,8 @@ fault:
  * exponential backoff
  */
 static void ceph_fault(struct ceph_connection *con)
+	__releases(con->mutex)
 {
-	mutex_lock(&con->mutex);
-
 	pr_err("%s%lld %s %s\n", ENTITY_NAME(con->peer_name),
 	       ceph_pr_addr(&con->peer_addr.in_addr), con->error_msg);
 	dout("fault %p state %lu to peer %s\n",
-- 
1.7.9.5

