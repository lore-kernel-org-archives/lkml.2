Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2KVSeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:34:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:49006 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab2KVSd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 120/171] libceph: dont mark footer complete before it is
Date: Wed, 21 Nov 2012 16:41:06 -0800
Message-Id: <20121122004045.394241870@linuxfoundation.org>
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

(cherry picked from commit fd154f3c75465abd83b7a395033e3755908a1e6e)

This is a nit, but prepare_write_message() sets the FOOTER_COMPLETE
flag before the CRC for the data portion (recorded in the footer)
has been completely computed.  Hold off setting the complete flag
until we've decided it's ready to send.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -592,6 +592,8 @@ static void prepare_write_message_footer
 	struct ceph_msg *m = con->out_msg;
 	int v = con->out_kvec_left;
 
+	m->footer.flags |= CEPH_MSG_FOOTER_COMPLETE;
+
 	dout("prepare_write_message_footer %p\n", con);
 	con->out_kvec_is_msg = true;
 	con->out_kvec[v].iov_base = &m->footer;
@@ -665,7 +667,7 @@ static void prepare_write_message(struct
 	/* fill in crc (except data pages), footer */
 	crc = crc32c(0, &m->hdr, offsetof(struct ceph_msg_header, crc));
 	con->out_msg->hdr.crc = cpu_to_le32(crc);
-	con->out_msg->footer.flags = CEPH_MSG_FOOTER_COMPLETE;
+	con->out_msg->footer.flags = 0;
 
 	crc = crc32c(0, m->front.iov_base, m->front.iov_len);
 	con->out_msg->footer.front_crc = cpu_to_le32(crc);


