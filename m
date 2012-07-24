Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2GXCkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 22:40:17 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:53391 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2GXCkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 22:40:14 -0400
X-AuditID: b753bd60-918efba000004f2e-f7-500e0a8719df
X-AuditID: b753bd60-918efba000004f2e-f7-500e0a8719df
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH 5/6] virtio/console: Allocate scatterlist according to the
 current pipe size
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
Date: Tue, 24 Jul 2012 11:37:48 +0900
Message-ID: <20120724023748.6600.25898.stgit@ltc189.sdl.hitachi.co.jp>
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

Allocate scatterlist according to the current pipe size.
This allows splicing bigger buffer if the pipe size has
been changed by fcntl.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 drivers/char/virtio_console.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index e49d435..f5063d5 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -229,7 +229,6 @@ struct port {
 	bool guest_connected;
 };
 
-#define MAX_SPLICE_PAGES	32
 /* This is the very early arch-specified put chars function. */
 static int (*early_put_chars)(u32, const char *, int);
 
@@ -482,15 +481,16 @@ struct buffer_token {
 		void *buf;
 		struct scatterlist *sg;
 	} u;
-	bool sgpages;
+	/* If sgpages == 0 then buf is used, else sg is used */
+	unsigned int sgpages;
 };
 
-static void reclaim_sg_pages(struct scatterlist *sg)
+static void reclaim_sg_pages(struct scatterlist *sg, unsigned int nrpages)
 {
 	int i;
 	struct page *page;
 
-	for (i = 0; i < MAX_SPLICE_PAGES; i++) {
+	for (i = 0; i < nrpages; i++) {
 		page = sg_page(&sg[i]);
 		if (!page)
 			break;
@@ -511,7 +511,7 @@ static void reclaim_consumed_buffers(struct port *port)
 	}
 	while ((tok = virtqueue_get_buf(port->out_vq, &len))) {
 		if (tok->sgpages)
-			reclaim_sg_pages(tok->u.sg);
+			reclaim_sg_pages(tok->u.sg, tok->sgpages);
 		else
 			kfree(tok->u.buf);
 		kfree(tok);
@@ -581,7 +581,7 @@ static ssize_t send_buf(struct port *port, void *in_buf, size_t in_count,
 	tok = kmalloc(sizeof(*tok), GFP_ATOMIC);
 	if (!tok)
 		return -ENOMEM;
-	tok->sgpages = false;
+	tok->sgpages = 0;
 	tok->u.buf = in_buf;
 
 	sg_init_one(sg, in_buf, in_count);
@@ -597,7 +597,7 @@ static ssize_t send_pages(struct port *port, struct scatterlist *sg, int nents,
 	tok = kmalloc(sizeof(*tok), GFP_ATOMIC);
 	if (!tok)
 		return -ENOMEM;
-	tok->sgpages = true;
+	tok->sgpages = nents;
 	tok->u.sg = sg;
 
 	return __send_to_port(port, sg, nents, in_count, tok, nonblock);
@@ -797,6 +797,7 @@ out:
 
 struct sg_list {
 	unsigned int n;
+	unsigned int size;
 	size_t len;
 	struct scatterlist *sg;
 };
@@ -807,7 +808,7 @@ static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct sg_list *sgl = sd->u.data;
 	unsigned int offset, len;
 
-	if (sgl->n == MAX_SPLICE_PAGES)
+	if (sgl->n == sgl->size)
 		return 0;
 
 	/* Try lock this page */
@@ -868,12 +869,12 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
 
 	sgl.n = 0;
 	sgl.len = 0;
-	sgl.sg = kmalloc(sizeof(struct scatterlist) * MAX_SPLICE_PAGES,
-			 GFP_ATOMIC);
+	sgl.size = pipe->nrbufs;
+	sgl.sg = kmalloc(sizeof(struct scatterlist) * sgl.size, GFP_ATOMIC);
 	if (unlikely(!sgl.sg))
 		return -ENOMEM;
 
-	sg_init_table(sgl.sg, MAX_SPLICE_PAGES);
+	sg_init_table(sgl.sg, sgl.size);
 	ret = __splice_from_pipe(pipe, &sd, pipe_to_sg);
 	if (likely(ret > 0))
 		ret = send_pages(port, sgl.sg, sgl.n, sgl.len, true);


