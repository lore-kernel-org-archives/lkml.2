Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab2KVWj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:39:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:49022 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab2KVSdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 12/83] virtio: Dont access index after unregister.
Date: Wed, 21 Nov 2012 16:41:34 -0800
Message-Id: <20121122004213.832113336@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cornelia Huck <cornelia.huck@de.ibm.com>

commit 237242bddc99041e15a4ca51b8439657cadaff17 upstream.

Virtio wants to release used indices after the corresponding
virtio device has been unregistered. However, virtio does not
hold an extra reference, giving up its last reference with
device_unregister(), making accessing dev->index afterwards
invalid.

I actually saw problems when testing my (not-yet-merged)
virtio-ccw code:

- device_add virtio-net,id=xxx
-> creates device virtio<n> with n>0

- device_del xxx
-> deletes virtio<n>, but calls ida_simple_remove with an
   index of 0

- device_add virtio-net,id=xxx
-> tries to add virtio0, which is still in use...

So let's save the index we want to release before calling
device_unregister().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -225,8 +225,10 @@ EXPORT_SYMBOL_GPL(register_virtio_device
 
 void unregister_virtio_device(struct virtio_device *dev)
 {
+	int index = dev->index; /* save for after device release */
+
 	device_unregister(&dev->dev);
-	ida_simple_remove(&virtio_index_ida, dev->index);
+	ida_simple_remove(&virtio_index_ida, index);
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 


