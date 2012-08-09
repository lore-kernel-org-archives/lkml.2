Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2HIMbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:31:06 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41867 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab2HIMbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:31:04 -0400
X-AuditID: b753bd60-9f483ba000000655-c1-5023ad84ae78
X-AuditID: b753bd60-9f483ba000000655-c1-5023ad84ae78
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH V2 2/6] virtio/console: Add a failback for unstealable pipe
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
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Thu, 09 Aug 2012 21:30:50 +0900
Message-ID: <20120809123049.8542.21179.stgit@ltc189.sdl.hitachi.co.jp>
In-Reply-To: <20120809123029.8542.38311.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120809123029.8542.38311.stgit@ltc189.sdl.hitachi.co.jp>
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
---

 drivers/char/virtio_console.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 730816c..22b7373 100644
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


