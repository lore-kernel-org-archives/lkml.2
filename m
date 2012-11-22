Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab2KVWi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:38:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:49008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab2KVSdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 062/171] ceph: messenger: use read_partial() in read_partial_message()
Date: Wed, 21 Nov 2012 16:40:08 -0800
Message-Id: <20121122004039.600989880@linuxfoundation.org>
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

(cherry picked from commit 57dac9d1620942608306d8c17c98a9d1568ffdf4)

There are two blocks of code in read_partial_message()--those that
read the header and footer of the message--that can be replaced by a
call to read_partial().  Do that.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1628,7 +1628,7 @@ static int read_partial_message(struct c
 {
 	struct ceph_msg *m = con->in_msg;
 	int ret;
-	int to, left;
+	int to;
 	unsigned front_len, middle_len, data_len;
 	bool do_datacrc = !con->msgr->nocrc;
 	int skip;
@@ -1638,15 +1638,10 @@ static int read_partial_message(struct c
 	dout("read_partial_message con %p msg %p\n", con, m);
 
 	/* header */
-	while (con->in_base_pos < sizeof(con->in_hdr)) {
-		left = sizeof(con->in_hdr) - con->in_base_pos;
-		ret = ceph_tcp_recvmsg(con->sock,
-				       (char *)&con->in_hdr + con->in_base_pos,
-				       left);
-		if (ret <= 0)
-			return ret;
-		con->in_base_pos += ret;
-	}
+	to = 0;
+	ret = read_partial(con, &to, sizeof (con->in_hdr), &con->in_hdr);
+	if (ret <= 0)
+		return ret;
 
 	crc = crc32c(0, &con->in_hdr, offsetof(struct ceph_msg_header, crc));
 	if (cpu_to_le32(crc) != con->in_hdr.crc) {
@@ -1759,16 +1754,11 @@ static int read_partial_message(struct c
 	}
 
 	/* footer */
-	to = sizeof(m->hdr) + sizeof(m->footer);
-	while (con->in_base_pos < to) {
-		left = to - con->in_base_pos;
-		ret = ceph_tcp_recvmsg(con->sock, (char *)&m->footer +
-				       (con->in_base_pos - sizeof(m->hdr)),
-				       left);
-		if (ret <= 0)
-			return ret;
-		con->in_base_pos += ret;
-	}
+	to = sizeof (m->hdr);
+	ret = read_partial(con, &to, sizeof (m->footer), &m->footer);
+	if (ret <= 0)
+		return ret;
+
 	dout("read_partial_message got msg %p %d (%u) + %d (%u) + %d (%u)\n",
 	     m, front_len, m->footer.front_crc, middle_len,
 	     m->footer.middle_crc, data_len, m->footer.data_crc);


