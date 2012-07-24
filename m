Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2GXCjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 22:39:54 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:53385 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2GXCjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 22:39:52 -0400
X-AuditID: b753bd60-91ec3ba0000047ca-85-500e0a73a7d0
X-AuditID: b753bd60-91ec3ba0000047ca-85-500e0a73a7d0
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH 3/6] virtio/console: Wait until the port is ready on splice
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
Date: Tue, 24 Jul 2012 11:37:28 +0900
Message-ID: <20120724023728.6600.36390.stgit@ltc189.sdl.hitachi.co.jp>
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

Wait if the port is not connected or full on splice
like as write is doing.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 drivers/char/virtio_console.c |   39 +++++++++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 911cb3e..e49d435 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -724,6 +724,26 @@ static ssize_t port_fops_read(struct file *filp, char __user *ubuf,
 	return fill_readbuf(port, ubuf, count, true);
 }
 
+static int wait_port_writable(struct port *port, bool nonblock)
+{
+	int ret;
+
+	if (will_write_block(port)) {
+		if (nonblock)
+			return -EAGAIN;
+
+		ret = wait_event_freezable(port->waitqueue,
+					   !will_write_block(port));
+		if (ret < 0)
+			return ret;
+	}
+	/* Port got hot-unplugged. */
+	if (!port->guest_connected)
+		return -ENODEV;
+
+	return 0;
+}
+
 static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 			       size_t count, loff_t *offp)
 {
@@ -740,18 +760,9 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
 
 	nonblock = filp->f_flags & O_NONBLOCK;
 
-	if (will_write_block(port)) {
-		if (nonblock)
-			return -EAGAIN;
-
-		ret = wait_event_freezable(port->waitqueue,
-					   !will_write_block(port));
-		if (ret < 0)
-			return ret;
-	}
-	/* Port got hot-unplugged. */
-	if (!port->guest_connected)
-		return -ENODEV;
+	ret = wait_port_writable(port, nonblock);
+	if (ret < 0)
+		return ret;
 
 	count = min((size_t)(32 * 1024), count);
 
@@ -851,6 +862,10 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
 		.u.data = &sgl,
 	};
 
+	ret = wait_port_writable(port, filp->f_flags & O_NONBLOCK);
+	if (ret < 0)
+		return ret;
+
 	sgl.n = 0;
 	sgl.len = 0;
 	sgl.sg = kmalloc(sizeof(struct scatterlist) * MAX_SPLICE_PAGES,


