Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab2KVVyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:54:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:49636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab2KVSkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 149/171] libceph: drop gratuitous socket close calls in con_work
Date: Wed, 21 Nov 2012 16:41:35 -0800
Message-Id: <20121122004048.313472735@linuxfoundation.org>
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

(cherry picked from commit 2e8cb10063820af7ed7638e3fd9013eee21266e7)

If the state is CLOSED or OPENING, we shouldn't have a socket.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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


