Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2KHJRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:17:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab2KHJRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:17:30 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: sjur@brendeland.net, "Michael S. Tsirkin" <mst@redhat.com>,
        linus.walleij@linaro.org, masami.hiramatsu.pt@hitachi.com,
        ohad@wizery.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [[PATCH v9 3/3] 1/1] virtio_console: Remove buffers from out_vq at port removal
Date: Thu,  8 Nov 2012 10:17:03 +0100
Message-Id: <029d7029bc1186fbd2ec74123dc88922b9600660.1352366215.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Remove buffers from the out-queue when a port is removed. Rproc_serial
communicates with remote processors that may crash and leave buffers in
the out-queue. The virtio serial ports may have buffers in the out-queue
as well, e.g. for non-blocking ports and the host didn't consume them
yet.

[Amit: Remove WARN_ON for generic ports case.]

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/virtio_console.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 9ebadcb..5ff3b3e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1521,6 +1521,10 @@ static void remove_port_data(struct port *port)
 	/* Remove buffers we queued up for the Host to send us data in. */
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
 		free_buf(buf, true);
+
+	/* Remove buffers we queued up for the Host to consume */
+	while ((buf = virtqueue_detach_unused_buf(port->out_vq)))
+		free_buf(buf, true);
 }
 
 /*
-- 
1.7.7.6

