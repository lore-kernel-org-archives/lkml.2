Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0IZI7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 04:59:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59317 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab0IZI7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 04:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w0e4kS7jguA0yOsaTXDrw9FxCm1/xGtLU3WRW9JZoNsLL8a3ULTYRrd/LpoYm8uc3P
         5bfTsr7CdeJQ5DStxUNcNzWXwPbEKrB6Bql2hBbwpmsk7w2jIub9lpGraimrO6Cb07md
         Nnvf4zkfxAwSNlR3SOfx4UZtxjrTl0CCk9cH8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>, Sage Weil <sage@newdream.net>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] block: rbd: fixed may leaks
Date: Sun, 26 Sep 2010 12:59:37 +0400
Message-Id: <1285491578-32580-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rbd_client_create() doesn't free rbdc, this leads to many leaks.

seg_len in rbd_do_op() is unsigned, so (seg_len < 0) makes no sense.
Also if fixed check fails then seg_name is leaked.
---
 Compile tested.

 drivers/block/rbd.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index c42f305..83b15dd 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -241,6 +241,7 @@ static struct rbd_client *rbd_client_create(struct ceph_options *opt)
 	rbdc->client = ceph_create_client(opt, rbdc);
 	if (IS_ERR(rbdc->client))
 		goto out_rbdc;
+	opt = NULL; /* Now rbdc->client is responsible for opt */
 
 	ret = ceph_open_session(rbdc->client);
 	if (ret < 0)
@@ -255,13 +256,12 @@ static struct rbd_client *rbd_client_create(struct ceph_options *opt)
 
 out_err:
 	ceph_destroy_client(rbdc->client);
-	return ERR_PTR(ret);
-
 out_rbdc:
 	kfree(rbdc);
 out_opt:
-	ceph_destroy_options(opt);
-	return ERR_PTR(-ENOMEM);
+	if (opt)
+		ceph_destroy_options(opt);
+	return ERR_PTR(ret);
 }
 
 /*
@@ -889,8 +889,10 @@ static int rbd_do_op(struct request *rq,
 				  rbd_dev->header.block_name,
 				  ofs, len,
 				  seg_name, &seg_ofs);
-	if (seg_len < 0)
-		return seg_len;
+	if ((s64)seg_len < 0) {
+		ret = seg_len;
+		goto done;
+	}
 
 	payload_len = (flags & CEPH_OSD_FLAG_WRITE ? seg_len : 0);
 
-- 
1.7.0.4

