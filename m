Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab1DYUsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:48:01 -0400
Received: from 1wt.eu ([62.212.114.60]:34234 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab1DYUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:39 -0400
Message-Id: <20110425200237.815849347@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 111/173] USB: cdc-acm: fix potential null-pointer dereference on disconnect
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 7e7797e7f6f7bfab73fca02c65e40eaa5bb9000c upstream.

Fix potential null-pointer exception on disconnect introduced by commit
11ea859d64b69a747d6b060b9ed1520eab1161fe (USB: additional power savings
for cdc-acm devices that support remote wakeup).

Only access acm->dev after making sure it is non-null in control urb
completion handler.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: longterm-2.6.27/drivers/usb/class/cdc-acm.c
===================================================================
--- longterm-2.6.27.orig/drivers/usb/class/cdc-acm.c	2011-01-23 10:52:26.000000000 +0100
+++ longterm-2.6.27/drivers/usb/class/cdc-acm.c	2011-04-25 16:30:06.372280691 +0200
@@ -285,6 +285,8 @@
 	if (!ACM_READY(acm))
 		goto exit;
 
+	usb_mark_last_busy(acm->dev);
+
 	data = (unsigned char *)(dr + 1);
 	switch (dr->bNotificationType) {
 
@@ -319,7 +321,6 @@
 			break;
 	}
 exit:
-	usb_mark_last_busy(acm->dev);
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",


