Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2GXCji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 22:39:38 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:53380 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab2GXCjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 22:39:35 -0400
X-AuditID: b753bd60-95ef6ba000004f2e-e6-500e0a5e3e8a
X-AuditID: b753bd60-95ef6ba000004f2e-e6-500e0a5e3e8a
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH 1/6] virtio/console: Add splice_write support
To: linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Amit Shah <amit.shah@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 24 Jul 2012 11:37:07 +0900
Message-ID: <20120724023707.6600.69536.stgit@ltc189.sdl.hitachi.co.jp>
In-Reply-To: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Enable to use splice_write from pipe to virtio-console port.
This steals pages from pipe and directly send it to host.

Note that this may accelerate only the guest to host path.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 drivers/char/virtio_console.c |  136 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 128 insertions(+), 8 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index cdf2f54..fe31b2f 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -24,6 +24,8 @@
 #include <linux/err.h>
 #include <linux/freezer.h>
 #include <linux/fs.h>
+#include <linux/splice.h>
+#include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/poll.h>
@@ -227,6 +229,7 @@ struct port {
 	bool guest_connected;
 };
 
+#define MAX_SPLICE_PAGES	32
 /* This is the very early arch-specified put chars function. */
 static int (*early_put_chars)(u32, const char *, int);
 
@@ -474,26 +477,52 @@ static ssize_t send_control_msg(struct port *port, unsigned int event,
 	return 0;
 }
 
+struct buffer_token {
+	union {
+		void *buf;
+		struct scatterlist *sg;
+	} u;
+	bool sgpages;
+};
+
+static void reclaim_sg_pages(struct scatterlist *sg)
+{
+	int i;
+	struct page *page;
+
+	for (i = 0; i < MAX_SPLICE_PAGES; i++) {
+		page = sg_page(&sg[i]);
+		if (!page)
+			break;
+		put_page(page);
+	}
+	kfree(sg);
+}
+
 /* Callers must take the port->outvq_lock */
 static void reclaim_consumed_buffers(struct port *port)
 {
-	void *buf;
+	struct buffer_token *tok;
 	unsigned int len;
 
 	if (!port->portdev) {
 		/* Device has been unplugged.  vqs are already gone. */
 		return;
 	}
-	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
-		kfree(buf);
+	while ((tok = virtqueue_get_buf(port->out_vq, &len))) {
+		if (tok->sgpages)
+			reclaim_sg_pages(tok->u.sg);
+		else
+			kfree(tok->u.buf);
+		kfree(tok);
 		port->outvq_full = false;
 	}
 }
 
-static ssize_t send_buf(struct port *port, void *in_buf, size_t in_count,
-			bool nonblock)
+static ssize_t __send_to_port(struct port *port, struct scatterlist *sg,
+			      int nents, size_t in_count,
+			      struct buffer_token *tok, bool nonblock)
 {
-	struct scatterlist sg[1];
 	struct virtqueue *out_vq;
 	ssize_t ret;
 	unsigned long flags;
@@ -505,8 +534,7 @@ static ssize_t send_buf(struct port *port, void *in_buf, size_t in_count,
 
 	reclaim_consumed_buffers(port);
 
-	sg_init_one(sg, in_buf, in_count);
-	ret = virtqueue_add_buf(out_vq, sg, 1, 0, in_buf, GFP_ATOMIC);
+	ret = virtqueue_add_buf(out_vq, sg, nents, 0, tok, GFP_ATOMIC);
 
 	/* Tell Host to go! */
 	virtqueue_kick(out_vq);
@@ -544,6 +572,37 @@ done:
 	return in_count;
 }
 
+static ssize_t send_buf(struct port *port, void *in_buf, size_t in_count,
+			bool nonblock)
+{
+	struct scatterlist sg[1];
+	struct buffer_token *tok;
+
+	tok = kmalloc(sizeof(*tok), GFP_ATOMIC);
+	if (!tok)
+		return -ENOMEM;
+	tok->sgpages = false;
+	tok->u.buf = in_buf;
+
+	sg_init_one(sg, in_buf, in_count);
+
+	return __send_to_port(port, sg, 1, in_count, tok, nonblock);
+}
+
+static ssize_t send_pages(struct port *port, struct scatterlist *sg, int nents,
+			  size_t in_count, bool nonblock)
+{
+	struct buffer_token *tok;
+
+	tok = kmalloc(sizeof(*tok), GFP_ATOMIC);
+	if (!tok)
+		return -ENOMEM;
+	tok->sgpages = true;
+	tok->u.sg = sg;
+
+	return __send_to_port(port, sg, nents, in_count, tok, nonblock);
+}
+
 /*
  * Give out the data that's requested from the buffer that we have
  * queued up.
@@ -725,6 +784,66 @@ out:
 	return ret;
 }
 
+struct sg_list {
+	unsigned int n;
+	size_t len;
+	struct scatterlist *sg;
+};
+
+static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+			struct splice_desc *sd)
+{
+	struct sg_list *sgl = sd->u.data;
+	unsigned int len = 0;
+
+	if (sgl->n == MAX_SPLICE_PAGES)
+		return 0;
+
+	/* Try lock this page */
+	if (buf->ops->steal(pipe, buf) == 0) {
+		/* Get reference and unlock page for moving */
+		get_page(buf->page);
+		unlock_page(buf->page);
+
+		len = min(buf->len, sd->len);
+		sg_set_page(&(sgl->sg[sgl->n]), buf->page, len, buf->offset);
+		sgl->n++;
+		sgl->len += len;
+	}
+
+	return len;
+}
+
+/* Faster zero-copy write by splicing */
+static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
+				      struct file *filp, loff_t *ppos,
+				      size_t len, unsigned int flags)
+{
+	struct port *port = filp->private_data;
+	struct sg_list sgl;
+	ssize_t ret;
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags,
+		.pos = *ppos,
+		.u.data = &sgl,
+	};
+
+	sgl.n = 0;
+	sgl.len = 0;
+	sgl.sg = kmalloc(sizeof(struct scatterlist) * MAX_SPLICE_PAGES,
+			 GFP_ATOMIC);
+	if (unlikely(!sgl.sg))
+		return -ENOMEM;
+
+	sg_init_table(sgl.sg, MAX_SPLICE_PAGES);
+	ret = __splice_from_pipe(pipe, &sd, pipe_to_sg);
+	if (likely(ret > 0))
+		ret = send_pages(port, sgl.sg, sgl.n, sgl.len, true);
+
+	return ret;
+}
+
 static unsigned int port_fops_poll(struct file *filp, poll_table *wait)
 {
 	struct port *port;
@@ -856,6 +975,7 @@ static const struct file_operations port_fops = {
 	.open  = port_fops_open,
 	.read  = port_fops_read,
 	.write = port_fops_write,
+	.splice_write = port_fops_splice_write,
 	.poll  = port_fops_poll,
 	.release = port_fops_release,
 	.fasync = port_fops_fasync,


