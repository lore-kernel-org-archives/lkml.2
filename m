Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab2KZRHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:07:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47578 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab2KZRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 122/270] libceph: fix mutex coverage for ceph_con_close
Date: Mon, 26 Nov 2012 14:56:52 -0200
Message-Id: <1353949160-26803-123-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 8c50c817566dfa4581f82373aac39f3e608a7dc8 upstream.

Hold the mutex while twiddling all of the state bits to avoid possible
races.  While we're here, make not of why we cannot close the socket
directly.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 6e2f678..e65b15d 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -503,6 +503,7 @@ static void reset_connection(struct ceph_connection *con)
  */
 void ceph_con_close(struct ceph_connection *con)
 {
+	mutex_lock(&con->mutex);
 	dout("con_close %p peer %s\n", con,
 	     ceph_pr_addr(&con->peer_addr.in_addr));
 	clear_bit(NEGOTIATING, &con->state);
@@ -515,11 +516,16 @@ void ceph_con_close(struct ceph_connection *con)
 	clear_bit(KEEPALIVE_PENDING, &con->flags);
 	clear_bit(WRITE_PENDING, &con->flags);
 
-	mutex_lock(&con->mutex);
 	reset_connection(con);
 	con->peer_global_seq = 0;
 	cancel_delayed_work(&con->work);
 	mutex_unlock(&con->mutex);
+
+	/*
+	 * We cannot close the socket directly from here because the
+	 * work threads use it without holding the mutex.  Instead, let
+	 * con_work() do it.
+	 */
 	queue_con(con);
 }
 EXPORT_SYMBOL(ceph_con_close);
-- 
1.7.9.5

