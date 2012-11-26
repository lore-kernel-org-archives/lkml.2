Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab2KZRGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab2KZRGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 109/270] libceph: clear CONNECTING in ceph_con_close()
Date: Mon, 26 Nov 2012 14:56:39 -0200
Message-Id: <1353949160-26803-110-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit bb9e6bba5d8b85b631390f8dbe8a24ae1ff5b48a upstream.

A connection that is closed will no longer be connecting.  So
clear the CONNECTING state bit in ceph_con_close().  Similarly,
if the socket has been closed we no longer are in connecting
state (a new connect sequence will need to be initiated).

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index dfff350..5e8033f 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -462,6 +462,7 @@ void ceph_con_close(struct ceph_connection *con)
 	dout("con_close %p peer %s\n", con,
 	     ceph_pr_addr(&con->peer_addr.in_addr));
 	clear_bit(NEGOTIATING, &con->state);
+	clear_bit(CONNECTING, &con->state);
 	clear_bit(STANDBY, &con->state);  /* avoid connect_seq bump */
 	set_bit(CLOSED, &con->state);
 
@@ -2189,7 +2190,7 @@ static void con_work(struct work_struct *work)
 	mutex_lock(&con->mutex);
 restart:
 	if (test_and_clear_bit(SOCK_CLOSED, &con->flags)) {
-		if (test_bit(CONNECTING, &con->state))
+		if (test_and_clear_bit(CONNECTING, &con->state))
 			con->error_msg = "connection failed";
 		else
 			con->error_msg = "socket closed";
-- 
1.7.9.5

