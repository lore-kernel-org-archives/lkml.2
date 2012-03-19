Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab2CSXlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:41:50 -0400
Received: from soma.ebfe.org ([78.47.47.242]:34382 "EHLO soma.ebfe.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746Ab2CSXlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:41:46 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 19:41:46 EDT
From: Michael Gehring <mg@ebfe.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Michael Gehring <mg@ebfe.org>
Subject: [PATCH] tty/vt: set_get_cmap() check user buffer
Date: Tue, 20 Mar 2012 00:34:01 +0100
Message-Id: <1332200041-31052-1-git-send-email-mg@ebfe.org>
X-Mailer: git-send-email 1.7.9.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_get_cmap() ignores the result of {get,put}_user(), causing ioctl(vt,
{G,P}IO_CMAP, 0xdeadbeef) to silently fail.

Another side effect of this: calling the PIO_CMAP ioctl with an invalid
buffer will zero the default colormap and the palette for all vts (all
colors set to black).

Use access_ok() and return -EFAULT when appropriate.

Signed-off-by: Michael Gehring <mg@ebfe.org>
---
 drivers/tty/vt/vt.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index e716839..176b2a1 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3897,15 +3897,18 @@ static int set_get_cmap(unsigned char __user *arg, int set)
 
     WARN_CONSOLE_UNLOCKED();
 
+    if (!access_ok(set ? VERIFY_READ : VERIFY_WRITE, arg, 3 * 16))
+	return -EFAULT;
+
     for (i = 0; i < 16; i++)
 	if (set) {
-	    get_user(default_red[i], arg++);
-	    get_user(default_grn[i], arg++);
-	    get_user(default_blu[i], arg++);
+	    __get_user(default_red[i], arg++);
+	    __get_user(default_grn[i], arg++);
+	    __get_user(default_blu[i], arg++);
 	} else {
-	    put_user(default_red[i], arg++);
-	    put_user(default_grn[i], arg++);
-	    put_user(default_blu[i], arg++);
+	    __put_user(default_red[i], arg++);
+	    __put_user(default_grn[i], arg++);
+	    __put_user(default_blu[i], arg++);
 	}
     if (set) {
 	for (i = 0; i < MAX_NR_CONSOLES; i++)
-- 
1.7.9.4

