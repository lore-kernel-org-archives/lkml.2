Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab2KZR7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:59:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47490 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846Ab2KZRGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 102/270] libceph: move init_bio_*() functions up
Date: Mon, 26 Nov 2012 14:56:32 -0200
Message-Id: <1353949160-26803-103-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit df6ad1f97342ebc4270128222e896541405eecdb upstream.

Move init_bio_iter() and iter_bio_next() up in their source file so
the'll be defined before they're needed.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index bd36e59..5e8dbc0d 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -565,6 +565,31 @@ static void con_out_kvec_add(struct ceph_connection *con,
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
-- 
1.7.9.5

