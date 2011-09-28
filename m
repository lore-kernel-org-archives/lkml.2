Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab1I1XOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:14:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605Ab1I1Wnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:35 2011
Message-Id: <20110928220135.478881730@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [096/244] net/9p: Fix kernel crash with msize 512K
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit b49d8b5d7007a673796f3f99688b46931293873e upstream.

With msize equal to 512K (PAGE_SIZE * VIRTQUEUE_NUM), we hit multiple
crashes. This patch fix those.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/9p/trans_virtio.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -263,7 +263,6 @@ p9_virtio_request(struct p9_client *clie
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
@@ -592,7 +592,14 @@ static struct p9_trans_module p9_virtio_
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


