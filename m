Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946893Ab2ERXNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:13:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946710Ab2ERXGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:06:51 -0400
Message-Id: <20120518212651.849347106@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Amit Shah <amit.shah@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [ 29/47] virtio: console: tell host of open ports after resume from s3/s4
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit fa8b66ccd2d200b64496cfedcce90bf54fe7d6e9 upstream.

If a port was open before going into one of the sleep states, the port
can continue normal operation after restore.  However, the host has to
be told that the guest side of the connection is open to restore
pre-suspend state.

This wasn't noticed so far due to a bug in qemu that was fixed recently
(which marked the guest-side connection as always open).

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/virtio_console.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1901,6 +1901,13 @@ static int virtcons_restore(struct virti
 
 		/* Get port open/close status on the host */
 		send_control_msg(port, VIRTIO_CONSOLE_PORT_READY, 1);
+
+		/*
+		 * If a port was open at the time of suspending, we
+		 * have to let the host know that it's still open.
+		 */
+		if (port->guest_connected)
+			send_control_msg(port, VIRTIO_CONSOLE_PORT_OPEN, 1);
 	}
 	return 0;
 }


