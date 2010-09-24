Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab0IXQ4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:56:48 -0400
Received: from kroah.org ([198.145.64.141]:46153 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614Ab0IXQ2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:15 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:17 2010
Message-Id: <20100924162617.249154502@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [27/80] virtio: console: Fix poll blocking even though there is data to read
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 6df7aadcd9290807c464675098b5dd2dc9da5075 upstream.

I found this while working on a Linux agent for spice, the symptom I was
seeing was select blocking on the spice vdagent virtio serial port even
though there were messages queued up there.

virtio_console's port_fops_poll checks port->inbuf != NULL to determine
if read won't block. However if an application reads enough bytes from
inbuf through port_fops_read, to empty the current port->inbuf,
port->inbuf will be NULL even though there may be buffers left in the
virtqueue.

This causes poll() to block even though there is data to be read,
this patch fixes this by using will_read_block(port) instead of the
port->inbuf != NULL check.

Signed-off-By: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/virtio_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -646,7 +646,7 @@ static unsigned int port_fops_poll(struc
 	poll_wait(filp, &port->waitqueue, wait);
 
 	ret = 0;
-	if (port->inbuf)
+	if (!will_read_block(port))
 		ret |= POLLIN | POLLRDNORM;
 	if (!will_write_block(port))
 		ret |= POLLOUT;


