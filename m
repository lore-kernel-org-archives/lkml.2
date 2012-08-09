Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab2HIMbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:31:17 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47193 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab2HIMbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:31:14 -0400
X-AuditID: b753bd60-9fe84ba000000655-f0-5023ad8f4da3
X-AuditID: b753bd60-9fe84ba000000655-f0-5023ad8f4da3
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH V2 3/6] virtio/console: Wait until the port is ready on splice
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
Date: Thu, 09 Aug 2012 21:31:00 +0900
Message-ID: <20120809123100.8542.63507.stgit@ltc189.sdl.hitachi.co.jp>
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

Wait if the port is not connected or full on splice
like as write is doing.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 drivers/char/virtio_console.c |   39 +++++++++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 22b7373..b2fc2ab 100644
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


