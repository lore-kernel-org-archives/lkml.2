Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2KVWmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:42:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:49020 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab2KVSdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 070/171] ceph: messenger: check prepare_write_connect() result
Date: Wed, 21 Nov 2012 16:40:16 -0800
Message-Id: <20121122004040.409620744@linuxfoundation.org>
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

(cherry picked from commit 5a0f8fdd8a0ebe320952a388331dc043d7e14ced)

prepare_write_connect() can return an error, but only one of its
callers checks for it.  All the rest are in functions that already
return errors, so it should be fine to return the error if one
gets returned.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1409,7 +1409,9 @@ static int process_connect(struct ceph_c
 		       ceph_pr_addr(&con->peer_addr.in_addr));
 		reset_connection(con);
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(con);
+		ret = prepare_write_connect(con);
+		if (ret < 0)
+			return ret;
 		prepare_read_connect(con);
 
 		/* Tell ceph about it. */
@@ -1433,7 +1435,9 @@ static int process_connect(struct ceph_c
 		     le32_to_cpu(con->in_connect.connect_seq));
 		con->connect_seq = le32_to_cpu(con->in_connect.connect_seq);
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(con);
+		ret = prepare_write_connect(con);
+		if (ret < 0)
+			return ret;
 		prepare_read_connect(con);
 		break;
 
@@ -1448,7 +1452,9 @@ static int process_connect(struct ceph_c
 		get_global_seq(con->msgr,
 			       le32_to_cpu(con->in_connect.global_seq));
 		ceph_con_out_kvec_reset(con);
-		prepare_write_connect(con);
+		ret = prepare_write_connect(con);
+		if (ret < 0)
+			return ret;
 		prepare_read_connect(con);
 		break;
 
@@ -1854,7 +1860,9 @@ more:
 	if (con->sock == NULL) {
 		ceph_con_out_kvec_reset(con);
 		prepare_write_banner(con);
-		prepare_write_connect(con);
+		ret = prepare_write_connect(con);
+		if (ret < 0)
+			goto out;
 		prepare_read_banner(con);
 		set_bit(CONNECTING, &con->state);
 		clear_bit(NEGOTIATING, &con->state);


