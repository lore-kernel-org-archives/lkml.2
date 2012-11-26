Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab2KZRIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:08:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134Ab2KZRH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 130/270] libceph: drop gratuitous socket close calls in con_work
Date: Mon, 26 Nov 2012 14:57:00 -0200
Message-Id: <1353949160-26803-131-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 2e8cb10063820af7ed7638e3fd9013eee21266e7 upstream.

If the state is CLOSED or OPENING, we shouldn't have a socket.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 20e60a8..32ab7cd 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2284,15 +2284,15 @@ restart:
 		dout("con_work %p STANDBY\n", con);
 		goto done;
 	}
-	if (test_bit(CLOSED, &con->state)) { /* e.g. if we are replaced */
-		dout("con_work CLOSED\n");
-		con_close_socket(con);
+	if (test_bit(CLOSED, &con->state)) {
+		dout("con_work %p CLOSED\n", con);
+		BUG_ON(con->sock);
 		goto done;
 	}
 	if (test_and_clear_bit(OPENING, &con->state)) {
 		/* reopen w/ new peer */
 		dout("con_work OPENING\n");
-		con_close_socket(con);
+		BUG_ON(con->sock);
 	}
 
 	ret = try_read(con);
-- 
1.7.9.5

