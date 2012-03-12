Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2CLAuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:50:52 -0400
Received: from 1wt.eu ([62.212.114.60]:63115 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab2CLAs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:58 -0400
Message-Id: <20120312004411.805542352@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:23 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 12/13] relay: prevent integer overflow in relay_open()
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

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
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 760c262..bf343f5 100644
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
@@ -581,6 +585,8 @@ struct rchan *relay_open(const char *base_filename,
 
 	if (!(subbuf_size && n_subbufs))
 		return NULL;
+	if (subbuf_size > UINT_MAX / n_subbufs)
+		return NULL;
 
 	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
 	if (!chan)
-- 
1.7.2.1.45.g54fbc



