Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab1D2S6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:44 -0400
Received: from kroah.org ([198.145.64.141]:50373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933377Ab1D2S6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:56 2011
Message-Id: <20110429185656.332756993@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [39/55] virtio: console: Enable call to hvc_remove() on console port remove
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit afa2689e19073cd2e762d0f2c1358fab1ab9f18c upstream.

This call was disabled as hot-unplugging one virtconsole port led to
another virtconsole port freezing.

Upon testing it again, this now works, so enable it.

In addition, a bug was found in qemu wherein removing a port of one type
caused the guest output from another port to stop working.  I doubt it
was just this bug that caused it (since disabling the hvc_remove() call
did allow other ports to continue working), but since it's all solved
now, we're fine with hot-unplugging of virtconsole ports.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/virtio_console.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1280,18 +1280,7 @@ static void unplug_port(struct port *por
 		spin_lock_irq(&pdrvdata_lock);
 		list_del(&port->cons.list);
 		spin_unlock_irq(&pdrvdata_lock);
-#if 0
-		/*
-		 * hvc_remove() not called as removing one hvc port
-		 * results in other hvc ports getting frozen.
-		 *
-		 * Once this is resolved in hvc, this functionality
-		 * will be enabled.  Till that is done, the -EPIPE
-		 * return from get_chars() above will help
-		 * hvc_console.c to clean up on ports we remove here.
-		 */
 		hvc_remove(port->cons.hvc);
-#endif
 	}
 
 	/* Remove unused data this port might have received. */


