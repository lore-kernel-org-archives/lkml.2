Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab2KZRIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:08:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47615 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134Ab2KZRIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 131/270] libceph: close socket directly from ceph_con_close()
Date: Mon, 26 Nov 2012 14:57:01 -0200
Message-Id: <1353949160-26803-132-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit ee76e0736db8455e3b11827d6899bd2a4e1d0584 upstream.

It is simpler to do this immediately, since we already hold the con mutex.
It also avoids the need to deal with a not-quite-CLOSED socket in con_work.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 32ab7cd..46ce113 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -519,14 +519,8 @@ void ceph_con_close(struct ceph_connection *con)
 	reset_connection(con);
 	con->peer_global_seq = 0;
 	cancel_delayed_work(&con->work);
+	con_close_socket(con);
 	mutex_unlock(&con->mutex);
-
-	/*
-	 * We cannot close the socket directly from here because the
-	 * work threads use it without holding the mutex.  Instead, let
-	 * con_work() do it.
-	 */
-	queue_con(con);
 }
 EXPORT_SYMBOL(ceph_con_close);
 
-- 
1.7.9.5

