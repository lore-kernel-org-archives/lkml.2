Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab2JOH6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:58:08 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40260 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2JOH6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:58:04 -0400
From: sjur.brandeland@stericsson.com
To: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv7 3/4] virtio_console: Merge struct buffer_token into struct port_buffer
Date: Mon, 15 Oct 2012 09:57:35 +0200
Message-Id: <1350287856-5284-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Refactoring the splice functionality by unifying the approach for
sending scatter-lists and regular buffers. This simplifies
buffer handling and reduces code size. Splice will now allocate
a port_buffer and send_buf() and free_buf() can always be used
for any buffer.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/char/virtio_console.c |  131 +++++++++++++++++------------------------
 1 files changed, 55 insertions(+), 76 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 301d17e..917cc830 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -111,6 +111,12 @@ struct port_buffer {
 	size_t len;
 	/* offset in the buf from which to consume data */
 	size_t offset;
+
+	/* If sgpages == 0 then buf is used */
+	unsigned int sgpages;
+
+	/* sg is used if spages > 0. sg must be the last in is struct */
+	struct scatterlist sg[0];
 };
 
 /*
@@ -338,17 +344,39 @@ static inline bool use_multiport(struct ports_device *portdev)
 
 static void free_buf(struct port_buffer *buf)
 {
+	unsigned int i;
+
 	kfree(buf->buf);
+	for (i = 0; i < buf->sgpages; i++) {
+		struct page *page = sg_page(&buf->sg[i]);
+		if (!page)
+			break;
+		put_page(page);
+	}
+
 	kfree(buf);
 }
 
-static struct port_buffer *alloc_buf(size_t buf_size)
+static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
+				     int pages)
 {
 	struct port_buffer *buf;
 
-	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	/*
+	 * Allocate buffer and the sg list. The sg list array is allocated
+	 * directly after the port_buffer struct.
+	 */
+	buf = kmalloc(sizeof(*buf) + sizeof(struct scatterlist) * pages,
+		      GFP_KERNEL);
 	if (!buf)
 		goto fail;
+
+	buf->sgpages = pages;
+	if (pages > 0) {
+		buf->buf = NULL;
+		return buf;
+	}
+
 	buf->buf = kmalloc(buf_size, GFP_KERNEL);
 	if (!buf->buf)
 		goto free_buf;
@@ -476,52 +504,26 @@ static ssize_t send_control_msg(struct port *port, unsigned int event,
 	return 0;
 }
 
-struct buffer_token {
-	union {
-		void *buf;
-		struct scatterlist *sg;
-	} u;
-	/* If sgpages == 0 then buf is used, else sg is used */
-	unsigned int sgpages;
-};
-
-static void reclaim_sg_pages(struct scatterlist *sg, unsigned int nrpages)
-{
-	int i;
-	struct page *page;
-
-	for (i = 0; i < nrpages; i++) {
-		page = sg_page(&sg[i]);
-		if (!page)
-			break;
-		put_page(page);
-	}
-	kfree(sg);
-}
 
 /* Callers must take the port->outvq_lock */
 static void reclaim_consumed_buffers(struct port *port)
 {
-	struct buffer_token *tok;
+	struct port_buffer *buf;
 	unsigned int len;
 
 	if (!port->portdev) {
 		/* Device has been unplugged.  vqs are already gone. */
 		return;
 	}
-	while ((tok = virtqueue_get_buf(port->out_vq, &len))) {
-		if (tok->sgpages)
-			reclaim_sg_pages(tok->u.sg, tok->sgpages);
-		else
-			kfree(tok->u.buf);
-		kfree(tok);
+	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
+		free_buf(buf);
 		port->outvq_full = false;
 	}
 }
 
 static ssize_t __send_to_port(struct port *port, struct scatterlist *sg,
 			      int nents, size_t in_count,
-			      struct buffer_token *tok, bool nonblock)
+			      void *data, bool nonblock)
 {
 	struct virtqueue *out_vq;
 	ssize_t ret;
@@ -534,7 +536,7 @@ static ssize_t __send_to_port(struct port *port, struct scatterlist *sg,
 
 	reclaim_consumed_buffers(port);
 
-	ret = virtqueue_add_buf(out_vq, sg, nents, 0, tok, GFP_ATOMIC);
+	ret = virtqueue_add_buf(out_vq, sg, nents, 0, data, GFP_ATOMIC);
 
 	/* Tell Host to go! */
 	virtqueue_kick(out_vq);
@@ -572,37 +574,6 @@ done:
 	return in_count;
 }
 
-static ssize_t send_buf(struct port *port, void *in_buf, size_t in_count,
-			bool nonblock)
-{
-	struct scatterlist sg[1];
-	struct buffer_token *tok;
-
-	tok = kmalloc(sizeof(*tok), GFP_ATOMIC);
-	if (!tok)
-		return -ENOMEM;
-	tok->sgpages = 0;
-	tok->u.buf = in_buf;
-
-	sg_init_one(sg, in_buf, in_count);
-
-	return __send_to_port(port, sg, 1, in_count, tok, nonblock);
-}
-
-static ssize_t send_pages(struct port *port, struct scatterlist *sg, int nents,
-			  size_t in_count, bool nonblock)
-{
-	struct buffer_token *tok;
-
-	tok = kmalloc(sizeof(*tok), GFP_ATOMIC);
-	if (!tok)
-		return -ENOMEM;
-	tok->sgpages = nents;
-	tok->u.sg = sg;
-
-	return __send_to_port(port, sg, nents, in_count, tok, nonblock);
-}
-
 /*
  * Give out the data that's requested from the buffer that we have
  * queued up.
@@ -748,9 +719,10 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 			       size_t count, loff_t *offp)
 {
 	struct port *port;
-	char *buf;
+	struct port_buffer *buf;
 	ssize_t ret;
 	bool nonblock;
+	struct scatterlist sg[1];
 
 	/* Userspace could be out to fool us */
 	if (!count)
@@ -766,11 +738,11 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 
 	count = min((size_t)(32 * 1024), count);
 
-	buf = kmalloc(count, GFP_KERNEL);
+	buf = alloc_buf(port->out_vq, count, 0);
 	if (!buf)
 		return -ENOMEM;
 
-	ret = copy_from_user(buf, ubuf, count);
+	ret = copy_from_user(buf->buf, ubuf, count);
 	if (ret) {
 		ret = -EFAULT;
 		goto free_buf;
@@ -784,13 +756,14 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 	 * through to the host.
 	 */
 	nonblock = true;
-	ret = send_buf(port, buf, count, nonblock);
+	sg_init_one(sg, buf->buf, count);
+	ret = __send_to_port(port, sg, 1, count, buf, nonblock);
 
 	if (nonblock && ret > 0)
 		goto out;
 
 free_buf:
-	kfree(buf);
+	free_buf(buf);
 out:
 	return ret;
 }
@@ -856,6 +829,7 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
 	struct port *port = filp->private_data;
 	struct sg_list sgl;
 	ssize_t ret;
+	struct port_buffer *buf;
 	struct splice_desc sd = {
 		.total_len = len,
 		.flags = flags,
@@ -867,17 +841,18 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
 	if (ret < 0)
 		return ret;
 
+	buf = alloc_buf(port->out_vq, 0, pipe->nrbufs);
+	if (!buf)
+		return -ENOMEM;
+
 	sgl.n = 0;
 	sgl.len = 0;
 	sgl.size = pipe->nrbufs;
-	sgl.sg = kmalloc(sizeof(struct scatterlist) * sgl.size, GFP_KERNEL);
-	if (unlikely(!sgl.sg))
-		return -ENOMEM;
-
+	sgl.sg = buf->sg;
 	sg_init_table(sgl.sg, sgl.size);
 	ret = __splice_from_pipe(pipe, &sd, pipe_to_sg);
 	if (likely(ret > 0))
-		ret = send_pages(port, sgl.sg, sgl.n, sgl.len, true);
+		ret = __send_to_port(port, buf->sg, sgl.n, sgl.len, buf, true);
 
 	if (unlikely(ret <= 0))
 		kfree(sgl.sg);
@@ -1033,6 +1008,8 @@ static const struct file_operations port_fops = {
 static int put_chars(u32 vtermno, const char *buf, int count)
 {
 	struct port *port;
+	struct scatterlist sg[1];
+
 
 	if (unlikely(early_put_chars))
 		return early_put_chars(vtermno, buf, count);
@@ -1041,7 +1018,9 @@ static int put_chars(u32 vtermno, const char *buf, int count)
 	if (!port)
 		return -EPIPE;
 
-	return send_buf(port, (void *)buf, count, false);
+	sg_init_one(sg, buf, count);
+	return __send_to_port(port, sg, 1, count, (void *)buf, false);
+
 }
 
 /*
@@ -1262,7 +1241,7 @@ static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
 
 	nr_added_bufs = 0;
 	do {
-		buf = alloc_buf(PAGE_SIZE);
+		buf = alloc_buf(vq, PAGE_SIZE, 0);
 		if (!buf)
 			break;
 
-- 
1.7.5.4

