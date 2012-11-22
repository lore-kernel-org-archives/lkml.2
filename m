Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2KVWO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:14:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:49372 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab2KVSif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 148/171] libceph: move ceph_con_send() closed check under the con mutex
Date: Wed, 21 Nov 2012 16:41:34 -0800
Message-Id: <20121122004048.202999398@linuxfoundation.org>
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

(cherry picked from commit a59b55a602b6c741052d79c1e3643f8440cddd27)

Take the con mutex before checking whether the connection is closed to
avoid racing with someone else closing it.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2453,22 +2453,20 @@ static void clear_standby(struct ceph_co
  */
 void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 {
-	if (test_bit(CLOSED, &con->state)) {
-		dout("con_send %p closed, dropping %p\n", con, msg);
-		ceph_msg_put(msg);
-		return;
-	}
-
 	/* set src+dst */
 	msg->hdr.src = con->msgr->inst.name;
-
 	BUG_ON(msg->front.iov_len != le32_to_cpu(msg->hdr.front_len));
-
 	msg->needs_out_seq = true;
 
-	/* queue */
 	mutex_lock(&con->mutex);
 
+	if (test_bit(CLOSED, &con->state)) {
+		dout("con_send %p closed, dropping %p\n", con, msg);
+		ceph_msg_put(msg);
+		mutex_unlock(&con->mutex);
+		return;
+	}
+
 	BUG_ON(msg->con != NULL);
 	msg->con = con->ops->get(con);
 	BUG_ON(msg->con == NULL);


