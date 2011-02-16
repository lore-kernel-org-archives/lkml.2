Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab1BPAuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:50:22 -0500
Received: from kroah.org ([198.145.64.141]:45901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933116Ab1BPAuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:10 2011
Message-Id: <20110216002110.165937003@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 111/176] virtio: console: Wake up outvq on host notifications
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit 2770c5ea501be69989a7acf54ec4cb3554c47191 upstream.

The outvq needs to be woken up on host notifications so that buffers
consumed by the host can be reclaimed, outvq freed, and application
writes may proceed again.

The need for this is now finally noticed when I have qemu patches ready
to use nonblocking IO and flow control.

CC: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/virtio_console.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1314,6 +1314,17 @@ static void control_work_handler(struct
 	spin_unlock(&portdev->cvq_lock);
 }
 
+static void out_intr(struct virtqueue *vq)
+{
+	struct port *port;
+
+	port = find_port_by_vq(vq->vdev->priv, vq);
+	if (!port)
+		return;
+
+	wake_up_interruptible(&port->waitqueue);
+}
+
 static void in_intr(struct virtqueue *vq)
 {
 	struct port *port;
@@ -1430,7 +1441,7 @@ static int init_vqs(struct ports_device
 	 */
 	j = 0;
 	io_callbacks[j] = in_intr;
-	io_callbacks[j + 1] = NULL;
+	io_callbacks[j + 1] = out_intr;
 	io_names[j] = "input";
 	io_names[j + 1] = "output";
 	j += 2;
@@ -1444,7 +1455,7 @@ static int init_vqs(struct ports_device
 		for (i = 1; i < nr_ports; i++) {
 			j += 2;
 			io_callbacks[j] = in_intr;
-			io_callbacks[j + 1] = NULL;
+			io_callbacks[j + 1] = out_intr;
 			io_names[j] = "input";
 			io_names[j + 1] = "output";
 		}


