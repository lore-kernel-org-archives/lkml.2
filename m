Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2GXCjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 22:39:47 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:53383 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2GXCjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 22:39:45 -0400
X-AuditID: 0ac90646-982c3ba000003485-a3-500e0a684042
X-AuditID: 0ac90646-982c3ba000003485-a3-500e0a684042
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH 2/6] virtio/console: Add a failback for unstealable pipe
 buffer
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
Date: Tue, 24 Jul 2012 11:37:18 +0900
Message-ID: <20120724023718.6600.68836.stgit@ltc189.sdl.hitachi.co.jp>
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

Add a failback memcpy path for unstealable pipe buffer.
If buf->ops->steal() fails, virtio-serial tries to
copy the page contents to an allocated page, instead
of just failing splice().

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 drivers/char/virtio_console.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index fe31b2f..911cb3e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -794,7 +794,7 @@ static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 			struct splice_desc *sd)
 {
 	struct sg_list *sgl = sd->u.data;
-	unsigned int len = 0;
+	unsigned int offset, len;
 
 	if (sgl->n == MAX_SPLICE_PAGES)
 		return 0;
@@ -807,9 +807,31 @@ static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 
 		len = min(buf->len, sd->len);
 		sg_set_page(&(sgl->sg[sgl->n]), buf->page, len, buf->offset);
-		sgl->n++;
-		sgl->len += len;
+	} else {
+		/* Failback to copying a page */
+		struct page *page = alloc_page(GFP_KERNEL);
+		char *src = buf->ops->map(pipe, buf, 1);
+		char *dst;
+
+		if (!page)
+			return -ENOMEM;
+		dst = kmap(page);
+
+		offset = sd->pos & ~PAGE_MASK;
+
+		len = sd->len;
+		if (len + offset > PAGE_SIZE)
+			len = PAGE_SIZE - offset;
+
+		memcpy(dst + offset, src + buf->offset, len);
+
+		kunmap(page);
+		buf->ops->unmap(pipe, buf, src);
+
+		sg_set_page(&(sgl->sg[sgl->n]), page, len, offset);
 	}
+	sgl->n++;
+	sgl->len += len;
 
 	return len;
 }


