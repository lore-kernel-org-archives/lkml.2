Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab2BQBGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:06:21 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47043 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756609Ab2BQA7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:53 -0500
X-Sasl-enc: ghCYTd9TF6n8t6CehmsUfK1BoITJ8EluGXmtSs/8drnI 1329440392
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:35 2012
Message-Id: <20120217005535.860691979@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [13/28] relay: prevent integer overflow in relay_open()
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f6302f1bcd75a042df69866d98b8d775a668f8f1 upstream.

"subbuf_size" and "n_subbufs" come from the user and they need to be
capped to prevent an integer overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/relay.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -164,10 +164,14 @@ depopulate:
  */
 static struct rchan_buf *relay_create_buf(struct rchan *chan)
 {
-	struct rchan_buf *buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
-	if (!buf)
+	struct rchan_buf *buf;
+
+	if (chan->n_subbufs > UINT_MAX / sizeof(size_t *))
 		return NULL;
 
+	buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
+	if (!buf)
+		return NULL;
 	buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
 	if (!buf->padding)
 		goto free_buf;
@@ -574,6 +578,8 @@ struct rchan *relay_open(const char *bas
 
 	if (!(subbuf_size && n_subbufs))
 		return NULL;
+	if (subbuf_size > UINT_MAX / n_subbufs)
+		return NULL;
 
 	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
 	if (!chan)


