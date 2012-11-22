Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2KVWCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:02:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:49626 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab2KVSkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 147/171] libceph: move msgr clear_standby under con mutex protection
Date: Wed, 21 Nov 2012 16:41:33 -0800
Message-Id: <20121122004048.106400097@linuxfoundation.org>
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

(cherry picked from commit 00650931e52e97fe64096bec167f5a6780dfd94a)

Avoid dropping and retaking con->mutex in the ceph_con_send() case by
leaving locking up to the caller.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2441,12 +2441,10 @@ static void clear_standby(struct ceph_co
 {
 	/* come back from STANDBY? */
 	if (test_and_clear_bit(STANDBY, &con->state)) {
-		mutex_lock(&con->mutex);
 		dout("clear_standby %p and ++connect_seq\n", con);
 		con->connect_seq++;
 		WARN_ON(test_bit(WRITE_PENDING, &con->flags));
 		WARN_ON(test_bit(KEEPALIVE_PENDING, &con->flags));
-		mutex_unlock(&con->mutex);
 	}
 }
 
@@ -2483,11 +2481,12 @@ void ceph_con_send(struct ceph_connectio
 	     le32_to_cpu(msg->hdr.front_len),
 	     le32_to_cpu(msg->hdr.middle_len),
 	     le32_to_cpu(msg->hdr.data_len));
+
+	clear_standby(con);
 	mutex_unlock(&con->mutex);
 
 	/* if there wasn't anything waiting to send before, queue
 	 * new work */
-	clear_standby(con);
 	if (test_and_set_bit(WRITE_PENDING, &con->flags) == 0)
 		queue_con(con);
 }
@@ -2574,7 +2573,9 @@ void ceph_msg_revoke_incoming(struct cep
 void ceph_con_keepalive(struct ceph_connection *con)
 {
 	dout("con_keepalive %p\n", con);
+	mutex_lock(&con->mutex);
 	clear_standby(con);
+	mutex_unlock(&con->mutex);
 	if (test_and_set_bit(KEEPALIVE_PENDING, &con->flags) == 0 &&
 	    test_and_set_bit(WRITE_PENDING, &con->flags) == 0)
 		queue_con(con);


