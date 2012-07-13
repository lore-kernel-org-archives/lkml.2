Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161509Ab2GMLc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 07:32:59 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:63539 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932175Ab2GMLcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 07:32:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIIGAFBbdWOb/2dsb2JhbABFhWiyN4EHgkoECwFGNQImAl8TiBGoSJMIgSCKHYRjgRIDlTqQBoJhgV0
X-IronPort-AV: E=Sophos;i="4.77,579,1336341600"; 
   d="scan'208";a="543096047"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: ipack/devices/ipoctal: fix dereference NULL pointer
Date: Fri, 13 Jul 2012 13:33:13 +0200
Message-Id: <1342179194-728-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After opening and closing the file /dev/ipoctal.X.Y.Z for the second time, it
gives a kernel oops due to a dereference of a NULL pointer.

The problem was that tty->driver_data was not properly initialized when
accessing the file for the second time.

Reported-by: Alberto Garcia Gonzalez <agarcia@igalia.com>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index a5af423..a1aae40 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -114,8 +114,6 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 
 	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
 			     CR_ENABLE_RX);
-	tty->driver_data = ipoctal;
-
 	return 0;
 }
 
@@ -136,6 +134,8 @@ static int ipoctal_open(struct tty_struct *tty, struct file *file)
 	if (atomic_read(&ipoctal->open[channel]))
 		return -EBUSY;
 
+	tty->driver_data = ipoctal;
+
 	res = tty_port_open(&ipoctal->tty_port[channel], tty, file);
 	if (res)
 		return res;
-- 
1.7.10.4

