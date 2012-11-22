Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab2KVVbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:31:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:49648 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab2KVSki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 069/171] ceph: dont set WRITE_PENDING too early
Date: Wed, 21 Nov 2012 16:40:15 -0800
Message-Id: <20121122004040.304770722@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit e10c758e4031a801ea4d2f8fb39bf14c2658d74b)

prepare_write_connect() prepares a connect message, then sets
WRITE_PENDING on the connection.  Then *after* this, it calls
prepare_connect_authorizer(), which updates the content of the
connection buffer already queued for sending.  It's also possible it
will result in prepare_write_connect() returning -EAGAIN despite the
WRITE_PENDING big getting set.

Fix this by preparing the connect authorizer first, setting the
WRITE_PENDING bit only after that is done.

Partially addresses http://tracker.newdream.net/issues/2424

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -697,6 +697,7 @@ static int prepare_write_connect(struct
 {
 	unsigned global_seq = get_global_seq(con->msgr, 0);
 	int proto;
+	int ret;
 
 	switch (con->peer_name.type) {
 	case CEPH_ENTITY_TYPE_MON:
@@ -723,11 +724,14 @@ static int prepare_write_connect(struct
 	con->out_connect.flags = 0;
 
 	ceph_con_out_kvec_add(con, sizeof (con->out_connect), &con->out_connect);
+	ret = prepare_connect_authorizer(con);
+	if (ret)
+		return ret;
 
 	con->out_more = 0;
 	set_bit(WRITE_PENDING, &con->state);
 
-	return prepare_connect_authorizer(con);
+	return 0;
 }
 
 /*


