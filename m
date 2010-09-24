Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab0IXQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:16 -0400
Received: from kroah.org ([198.145.64.141]:46143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab0IXQ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:14 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:17 2010
Message-Id: <20100924162617.159396524@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [26/80] virtio: console: Prevent userspace from submitting NULL buffers
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit 65745422a898741ee0e7068ef06624ab06e8aefa upstream.

A userspace could submit a buffer with 0 length to be written to the
host.  Prevent such a situation.

This was not needed previously, but recent changes in the way write()
works exposed this condition to trigger a virtqueue event to the host,
causing a NULL buffer to be sent across.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/virtio_console.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -596,6 +596,10 @@ static ssize_t port_fops_write(struct fi
 	ssize_t ret;
 	bool nonblock;
 
+	/* Userspace could be out to fool us */
+	if (!count)
+		return 0;
+
 	port = filp->private_data;
 
 	nonblock = filp->f_flags & O_NONBLOCK;


