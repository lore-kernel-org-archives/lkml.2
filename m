Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab2J3IwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:52:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36091 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab2J3IwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:52:07 -0400
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH v8 3/3] virtio_console: Remove buffers from out_vq at port removal
Date: Tue, 30 Oct 2012 09:51:53 +0100
Message-Id: <1351587113-2566-4-git-send-email-sjur@brendeland.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351587113-2566-1-git-send-email-sjur@brendeland.net>
References: <1351587113-2566-1-git-send-email-sjur@brendeland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Remove buffers from the out-queue when a rproc_serial device
is removed. Rproc_serial communicates with remote processors
that may crash and leave buffers in the out-queue. But the
virtio_console device is not supposed to leave buffers in the
out-queue when a port is removed, so in this case throw a
warning.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/char/virtio_console.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 9ebadcb..3fa036a 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1521,6 +1521,16 @@ static void remove_port_data(struct port *port)
 	/* Remove buffers we queued up for the Host to send us data in. */
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
 		free_buf(buf, true);
+
+	/*
+	 * Check the out-queue for buffers. For VIRTIO_CONSOLE it is a
+	 * bug if this happens. But for RPROC_SERIAL the remote processor
+	 * may have crashed, leaving buffers hanging in the out-queue.
+	 */
+	while ((buf = virtqueue_detach_unused_buf(port->out_vq))) {
+		WARN_ON_ONCE(!is_rproc_serial(port->portdev->vdev));
+		free_buf(buf, true);
+	}
 }
 
 /*
-- 
1.7.9.5

