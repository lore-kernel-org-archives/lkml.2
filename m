Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab2BIKov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:44:51 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17775 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2BIKot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:44:49 -0500
Date: Thu, 9 Feb 2012 13:44:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] relay: prevent integer overflow in relay_open()
Message-ID: <20120209104433.GA5540@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F323388.7040902@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F33A39E.004B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"subbuf_size" and "n_subbufs" come from the user and they need to be
capped to prevent an integer overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/relay.c b/kernel/relay.c
index 4335e1d..ab56a17 100644
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
@@ -574,6 +578,8 @@ struct rchan *relay_open(const char *base_filename,
 
 	if (!(subbuf_size && n_subbufs))
 		return NULL;
+	if (subbuf_size > UINT_MAX / n_subbufs)
+		return NULL;
 
 	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
 	if (!chan)
