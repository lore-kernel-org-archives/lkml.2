Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1AaQbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:31:14 -0500
Received: from kroah.org ([198.145.64.141]:46364 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab1AaQbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:31:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/5] vt: fix issue when fbcon wants to takeover a second time.
Date: Mon, 31 Jan 2011 08:31:06 -0800
Message-Id: <1296491470-23096-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110131162852.GA22875@kroah.com>
References: <20110131162852.GA22875@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

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
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 76407ec..4f6ae05 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3545,7 +3545,7 @@ int register_con_driver(const struct consw *csw, int first, int last)
 
 		/* already registered */
 		if (con_driver->con == csw)
-			retval = -EINVAL;
+			retval = -EBUSY;
 	}
 
 	if (retval)
@@ -3656,7 +3656,12 @@ int take_over_console(const struct consw *csw, int first, int last, int deflt)
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
 
-- 
1.7.1

