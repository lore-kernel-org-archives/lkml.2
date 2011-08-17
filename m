Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1HQQ4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:56:13 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58986 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab1HQQ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:56:11 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2] net/9p: Fix kernel crash with msize 512K
Date: Wed, 17 Aug 2011 22:26:04 +0530
Message-Id: <1313600164-24676-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With msize equal to 512K (PAGE_SIZE * VIRTQUEUE_NUM), we hit multiple
crashes. This patch fix those.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/trans_virtio.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 175b513..e317583 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -263,7 +263,6 @@ p9_virtio_request(struct p9_client *client, struct p9_req_t *req)
 {
 	int in, out, inp, outp;
 	struct virtio_chan *chan = client->trans;
-	char *rdata = (char *)req->rc+sizeof(struct p9_fcall);
 	unsigned long flags;
 	size_t pdata_off = 0;
 	struct trans_rpage_info *rpinfo = NULL;
@@ -346,7 +345,8 @@ req_retry_pinned:
 		 * Arrange in such a way that server places header in the
 		 * alloced memory and payload onto the user buffer.
 		 */
-		inp = pack_sg_list(chan->sg, out, VIRTQUEUE_NUM, rdata, 11);
+		inp = pack_sg_list(chan->sg, out,
+				   VIRTQUEUE_NUM, req->rc->sdata, 11);
 		/*
 		 * Running executables in the filesystem may result in
 		 * a read request with kernel buffer as opposed to user buffer.
@@ -366,8 +366,8 @@ req_retry_pinned:
 		}
 		in += inp;
 	} else {
-		in = pack_sg_list(chan->sg, out, VIRTQUEUE_NUM, rdata,
-				req->rc->capacity);
+		in = pack_sg_list(chan->sg, out, VIRTQUEUE_NUM,
+				  req->rc->sdata, req->rc->capacity);
 	}
 
 	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc);
@@ -592,7 +592,14 @@ static struct p9_trans_module p9_virtio_trans = {
 	.close = p9_virtio_close,
 	.request = p9_virtio_request,
 	.cancel = p9_virtio_cancel,
-	.maxsize = PAGE_SIZE*VIRTQUEUE_NUM,
+
+	/*
+	 * We leave one entry for input and one entry for response
+	 * headers. We also skip one more entry to accomodate, address
+	 * that are not at page boundary, that can result in an extra
+	 * page in zero copy.
+	 */
+	.maxsize = PAGE_SIZE * (VIRTQUEUE_NUM - 3),
 	.pref = P9_TRANS_PREF_PAYLOAD_SEP,
 	.def = 0,
 	.owner = THIS_MODULE,
-- 
1.7.4.1

