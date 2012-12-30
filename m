Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2L3Vm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 16:42:56 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:33403 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2L3Vmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 16:42:54 -0500
Date: Sun, 30 Dec 2012 22:42:51 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Eric Dumazet <edumazet@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] relay: use sizeof(size_t), not sizeof(size_t *) in
 relay_create_buf()
Message-ID: <alpine.LNX.2.00.1212302241100.17742@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of size_t's is what we want to allocate memory for, not a
number of size_t pointers (at least as far as I can tell).
Now, depending on platform, sizeof(size_t *) may be >= sizeof(size_t)
so things actually work, but that's not really a portable assumption,
so let's use the value we actually mean.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 kernel/relay.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index e8cd202..806931b 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -166,13 +166,13 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 {
 	struct rchan_buf *buf;
 
-	if (chan->n_subbufs > UINT_MAX / sizeof(size_t *))
+	if (chan->n_subbufs > UINT_MAX / sizeof(size_t))
 		return NULL;
 
 	buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
-	buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
+	buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t), GFP_KERNEL);
 	if (!buf->padding)
 		goto free_buf;
 
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

