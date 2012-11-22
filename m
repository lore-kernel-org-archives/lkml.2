Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab2KVVs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:48:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:49608 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab2KVSkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>,
        Yehuda Sadeh <yehuda@inktank.com>
Subject: [ 141/171] libceph: fix mutex coverage for ceph_con_close
Date: Wed, 21 Nov 2012 16:41:27 -0800
Message-Id: <20121122004047.498885164@linuxfoundation.org>
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

(cherry picked from commit 8c50c817566dfa4581f82373aac39f3e608a7dc8)

Hold the mutex while twiddling all of the state bits to avoid possible
races.  While we're here, make not of why we cannot close the socket
directly.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -503,6 +503,7 @@ static void reset_connection(struct ceph
  */
 void ceph_con_close(struct ceph_connection *con)
 {
+	mutex_lock(&con->mutex);
 	dout("con_close %p peer %s\n", con,
 	     ceph_pr_addr(&con->peer_addr.in_addr));
 	clear_bit(NEGOTIATING, &con->state);
@@ -515,11 +516,16 @@ void ceph_con_close(struct ceph_connecti
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


