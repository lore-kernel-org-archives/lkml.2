Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2KVVZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:25:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:49621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218Ab2KVSkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>,
        Yehuda Sadeh <yehuda@inktank.com>
Subject: [ 143/171] libceph: (re)initialize bio_iter on start of message receive
Date: Wed, 21 Nov 2012 16:41:29 -0800
Message-Id: <20121122004047.699116048@linuxfoundation.org>
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

(cherry picked from commit a4107026976f06c9a6ce8cc84a763564ee39d901)

Previously, we were opportunistically initializing the bio_iter if it
appeared to be uninitialized in the middle of the read path.  The problem
is that a sequence like:

 - start reading message
 - initialize bio_iter
 - read half a message
 - messenger fault, reconnect
 - restart reading message
 - ** bio_iter now non-NULL, not reinitialized **
 - read past end of bio, crash

Instead, initialize the bio_iter unconditionally when we allocate/claim
the message for read.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1872,6 +1872,11 @@ static int read_partial_message(struct c
 		else
 			con->in_msg_pos.page_pos = 0;
 		con->in_msg_pos.data_pos = 0;
+
+#ifdef CONFIG_BLOCK
+		if (m->bio)
+			init_bio_iter(m->bio, &m->bio_iter, &m->bio_seg);
+#endif
 	}
 
 	/* front */
@@ -1888,10 +1893,6 @@ static int read_partial_message(struct c
 		if (ret <= 0)
 			return ret;
 	}
-#ifdef CONFIG_BLOCK
-	if (m->bio && !m->bio_iter)
-		init_bio_iter(m->bio, &m->bio_iter, &m->bio_seg);
-#endif
 
 	/* (page) data */
 	while (con->in_msg_pos.data_pos < data_len) {
@@ -1902,7 +1903,7 @@ static int read_partial_message(struct c
 				return ret;
 #ifdef CONFIG_BLOCK
 		} else if (m->bio) {
-
+			BUG_ON(!m->bio_iter);
 			ret = read_partial_message_bio(con,
 						 &m->bio_iter, &m->bio_seg,
 						 data_len, do_datacrc);


