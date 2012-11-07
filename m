Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2KGNoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:44:09 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38791 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2KGNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:44:07 -0500
From: sjur.brandeland@stericsson.com
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH resend] virtio_console: Free buffers from out-queue upon close
Date: Wed,  7 Nov 2012 14:43:42 +0100
Message-Id: <1352295822-22906-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com> <1350287856-5284-5-git-send-email-sjur.brandeland@stericsson.com> <878vayhsca.fsf@rustcorp.com.au> <20121101073951.GA17012@amit.redhat.com> <87r4oc52ov.fsf@rustcorp.com.au> <20121102102047.GE10483@amit.redhat.com> <81C3A93C17462B4BBD7E272753C1057923BE98E5C6@EXDCVYMBSTM005.EQ1STM.local> <1352298171-21869-1-git-send-email-sjur.brandeland@stericsson.com>
In-Reply-To: <20121102102047.GE10483@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Free pending output buffers from the virtio out-queue when
host has acknowledged port_close. Also removed WARN_ON()
in remove_port_data().

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---

Resending, this time including a proper "Subject"...
--

Hi Amit,

Note: This patch is compile tested only. I have done the removal
of buffers from out-queue in handle_control_message()
when host has acked the close request. This seems less
racy than doing it in the release function.

I you want to change this further, feel free to take over from
here and refine this.

Thanks,
Sjur

 drivers/char/virtio_console.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 3fa036a..3a5831d 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1522,15 +1522,9 @@ static void remove_port_data(struct port *port)
 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
 		free_buf(buf, true);
 
-	/*
-	 * Check the out-queue for buffers. For VIRTIO_CONSOLE it is a
-	 * bug if this happens. But for RPROC_SERIAL the remote processor
-	 * may have crashed, leaving buffers hanging in the out-queue.
-	 */
-	while ((buf = virtqueue_detach_unused_buf(port->out_vq))) {
-		WARN_ON_ONCE(!is_rproc_serial(port->portdev->vdev));
+	/* Free pending buffers from the out-queue. */
+	while ((buf = virtqueue_detach_unused_buf(port->out_vq)))
 		free_buf(buf, true);
-	}
 }
 
 /*
@@ -1655,6 +1649,10 @@ static void handle_control_message(struct ports_device *portdev,
 		 */
 		spin_lock_irq(&port->outvq_lock);
 		reclaim_consumed_buffers(port);
+
+		/* Free pending buffers from the out-queue. */
+		while ((buf = virtqueue_detach_unused_buf(port->out_vq)))
+			free_buf(buf, true);
 		spin_unlock_irq(&port->outvq_lock);
 
 		/*
-- 
1.7.5.4

