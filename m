Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2KZSAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:00:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47485 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab2KZRGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 101/270] libceph: don't mark footer complete before it is
Date: Mon, 26 Nov 2012 14:56:31 -0200
Message-Id: <1353949160-26803-102-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit fd154f3c75465abd83b7a395033e3755908a1e6e upstream.

This is a nit, but prepare_write_message() sets the FOOTER_COMPLETE
flag before the CRC for the data portion (recorded in the footer)
has been completely computed.  Hold off setting the complete flag
until we've decided it's ready to send.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 434809c..bd36e59 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -592,6 +592,8 @@ static void prepare_write_message_footer(struct ceph_connection *con)
 	struct ceph_msg *m = con->out_msg;
 	int v = con->out_kvec_left;
 
+	m->footer.flags |= CEPH_MSG_FOOTER_COMPLETE;
+
 	dout("prepare_write_message_footer %p\n", con);
 	con->out_kvec_is_msg = true;
 	con->out_kvec[v].iov_base = &m->footer;
@@ -665,7 +667,7 @@ static void prepare_write_message(struct ceph_connection *con)
 	/* fill in crc (except data pages), footer */
 	crc = crc32c(0, &m->hdr, offsetof(struct ceph_msg_header, crc));
 	con->out_msg->hdr.crc = cpu_to_le32(crc);
-	con->out_msg->footer.flags = CEPH_MSG_FOOTER_COMPLETE;
+	con->out_msg->footer.flags = 0;
 
 	crc = crc32c(0, m->front.iov_base, m->front.iov_len);
 	con->out_msg->footer.front_crc = cpu_to_le32(crc);
-- 
1.7.9.5

