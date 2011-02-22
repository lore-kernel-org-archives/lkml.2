Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1BVWfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:35:36 -0500
Received: from kroah.org ([198.145.64.141]:46597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab1BVWVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221838.275408480@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [12/70] vt: fix issue when fbcon wants to takeover a second time.
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit c55c63c6539499379ab4a7e8a5c0f857351fb946 upstream.

With framebuffer handover and multiple GPUs, we get into a
position where the fbcon unbinds the vesafb framebuffer for GPU 1,
but we still have a radeon framebuffer bound from GPU 0, so
we don't unregister the console driver. Then when we tried to bind
the new radeon framebuffer for GPU1 we never get to the bind
call as we fail due to the console being registered already.

This changes the return value to -EBUSY when the driver is
already registered and continues to bind for -EBUSY.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/vt/vt.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3524,7 +3524,7 @@ int register_con_driver(const struct con
 
 		/* already registered */
 		if (con_driver->con == csw)
-			retval = -EINVAL;
+			retval = -EBUSY;
 	}
 
 	if (retval)
@@ -3635,7 +3635,12 @@ int take_over_console(const struct consw
 	int err;
 
 	err = register_con_driver(csw, first, last);
-
+	/* if we get an busy error we still want to bind the console driver
+	 * and return success, as we may have unbound the console driver
+	 * but not unregistered it.
+	*/
+	if (err == -EBUSY)
+		err = 0;
 	if (!err)
 		bind_con_driver(csw, first, last, deflt);
 


