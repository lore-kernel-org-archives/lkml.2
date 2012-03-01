Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738Ab2CAVw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:52:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46239 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab2CAVux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.228.103 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213922.870774296@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 04/34] relay: prevent integer overflow in relay_open()
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
@@ -171,10 +171,14 @@ depopulate:
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
@@ -581,6 +585,8 @@ struct rchan *relay_open(const char *bas
 
 	if (!(subbuf_size && n_subbufs))
 		return NULL;
+	if (subbuf_size > UINT_MAX / n_subbufs)
+		return NULL;
 
 	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
 	if (!chan)


