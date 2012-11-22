Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2KVW2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:28:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:49005 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab2KVSd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 121/171] libceph: move init_bio_*() functions up
Date: Wed, 21 Nov 2012 16:41:07 -0800
Message-Id: <20121122004045.497806752@linuxfoundation.org>
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

(cherry picked from commit df6ad1f97342ebc4270128222e896541405eecdb)

Move init_bio_iter() and iter_bio_next() up in their source file so
the'll be defined before they're needed.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -565,6 +565,31 @@ static void con_out_kvec_add(struct ceph
 	con->out_kvec_bytes += size;
 }
 
+#ifdef CONFIG_BLOCK
+static void init_bio_iter(struct bio *bio, struct bio **iter, int *seg)
+{
+	if (!bio) {
+		*iter = NULL;
+		*seg = 0;
+		return;
+	}
+	*iter = bio;
+	*seg = bio->bi_idx;
+}
+
+static void iter_bio_next(struct bio **bio_iter, int *seg)
+{
+	if (*bio_iter == NULL)
+		return;
+
+	BUG_ON(*seg >= (*bio_iter)->bi_vcnt);
+
+	(*seg)++;
+	if (*seg == (*bio_iter)->bi_vcnt)
+		init_bio_iter((*bio_iter)->bi_next, bio_iter, seg);
+}
+#endif
+
 static void prepare_write_message_data(struct ceph_connection *con)
 {
 	struct ceph_msg *msg = con->out_msg;
@@ -868,31 +893,6 @@ out:
 	return ret;  /* done! */
 }
 
-#ifdef CONFIG_BLOCK
-static void init_bio_iter(struct bio *bio, struct bio **iter, int *seg)
-{
-	if (!bio) {
-		*iter = NULL;
-		*seg = 0;
-		return;
-	}
-	*iter = bio;
-	*seg = bio->bi_idx;
-}
-
-static void iter_bio_next(struct bio **bio_iter, int *seg)
-{
-	if (*bio_iter == NULL)
-		return;
-
-	BUG_ON(*seg >= (*bio_iter)->bi_vcnt);
-
-	(*seg)++;
-	if (*seg == (*bio_iter)->bi_vcnt)
-		init_bio_iter((*bio_iter)->bi_next, bio_iter, seg);
-}
-#endif
-
 static void out_msg_pos_next(struct ceph_connection *con, struct page *page,
 			size_t len, size_t sent, bool in_trail)
 {


