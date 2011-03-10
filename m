Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1CKADs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:03:48 -0500
Received: from kroah.org ([198.145.64.141]:45167 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab1CJX5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:36 2011
Message-Id: <20110310235536.221810926@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 02/29] virtio: console: Dont access vqs if device was unplugged
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit d7a62cd0332115d4c7c4689abea0d889a30d8349 upstream.

If a virtio-console device gets unplugged while a port is open, a
subsequent close() call on the port accesses vqs to free up buffers.
This can lead to a crash.

The buffers are already freed up as a result of the call to
unplug_ports() from virtcons_remove().  The fix is to simply not access
vq information if port->portdev is NULL.

Reported-by: juzhang <juzhang@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/virtio_console.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -387,6 +387,10 @@ static void discard_port_data(struct por
 	unsigned int len;
 	int ret;
 
+	if (!port->portdev) {
+		/* Device has been unplugged.  vqs are already gone. */
+		return;
+	}
 	vq = port->in_vq;
 	if (port->inbuf)
 		buf = port->inbuf;
@@ -469,6 +473,10 @@ static void reclaim_consumed_buffers(str
 	void *buf;
 	unsigned int len;
 
+	if (!port->portdev) {
+		/* Device has been unplugged.  vqs are already gone. */
+		return;
+	}
 	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
 		kfree(buf);
 		port->outvq_full = false;


