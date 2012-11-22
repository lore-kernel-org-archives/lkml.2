Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab2KVWd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:33:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:49009 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab2KVSdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 150/171] libceph: close socket directly from ceph_con_close()
Date: Wed, 21 Nov 2012 16:41:36 -0800
Message-Id: <20121122004048.409339026@linuxfoundation.org>
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

(cherry picked from commit ee76e0736db8455e3b11827d6899bd2a4e1d0584)

It is simpler to do this immediately, since we already hold the con mutex.
It also avoids the need to deal with a not-quite-CLOSED socket in con_work.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -519,14 +519,8 @@ void ceph_con_close(struct ceph_connecti
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
 


