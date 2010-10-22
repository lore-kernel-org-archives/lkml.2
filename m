Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab0JVTDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:03:37 -0400
Received: from kroah.org ([198.145.64.141]:34393 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759490Ab0JVS5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:01 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:34 2010
Message-Id: <20101022185234.797428224@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amit Shah <amit.shah@redhat.com>, Hans de Goede <hdegoede@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [083/103] virtio: console: Dont block entire guest if host doesnt read data
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit 531295e63be8c2b8b909d7400739e8b8df60d61f upstream.

If the host is slow in reading data or doesn't read data at all,
blocking write calls not only blocked the program that called write()
but the entire guest itself.

To overcome this, let's not block till the host signals it has given
back the virtio ring element we passed it.  Instead, send the buffer to
the host and return to userspace.  This operation then becomes similar
to how non-blocking writes work, so let's use the existing code for this
path as well.

This code change also ensures blocking write calls do get blocked if
there's not enough room in the virtio ring as well as they don't return
-EAGAIN to userspace.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/virtio_console.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -459,9 +459,12 @@ static ssize_t send_buf(struct port *por
 
 	/*
 	 * Wait till the host acknowledges it pushed out the data we
-	 * sent.  This is done for ports in blocking mode or for data
-	 * from the hvc_console; the tty operations are performed with
-	 * spinlocks held so we can't sleep here.
+	 * sent.  This is done for data from the hvc_console; the tty
+	 * operations are performed with spinlocks held so we can't
+	 * sleep here.  An alternative would be to copy the data to a
+	 * buffer and relax the spinning requirement.  The downside is
+	 * we need to kmalloc a GFP_ATOMIC buffer each time the
+	 * console driver writes something out.
 	 */
 	while (!virtqueue_get_buf(out_vq, &len))
 		cpu_relax();
@@ -626,6 +629,14 @@ static ssize_t port_fops_write(struct fi
 		goto free_buf;
 	}
 
+	/*
+	 * We now ask send_buf() to not spin for generic ports -- we
+	 * can re-use the same code path that non-blocking file
+	 * descriptors take for blocking file descriptors since the
+	 * wait is already done and we're certain the write will go
+	 * through to the host.
+	 */
+	nonblock = true;
 	ret = send_buf(port, buf, count, nonblock);
 
 	if (nonblock && ret > 0)


