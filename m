Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab2HPNRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:17:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24079 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2HPNRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:17:13 -0400
Date: Thu, 16 Aug 2012 16:16:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] TTY: tty_alloc_driver() returns error pointers
Message-ID: <20120816131656.GB23279@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We changed these from alloc_tty_driver() to tty_alloc_driver() so the
error handling needs to modified to check for IS_ERR() instead of NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed on linux-next.

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index f5a27c6..2bace84 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -448,14 +448,14 @@ static void __init legacy_pty_init(void)
 			TTY_DRIVER_RESET_TERMIOS |
 			TTY_DRIVER_REAL_RAW |
 			TTY_DRIVER_DYNAMIC_ALLOC);
-	if (!pty_driver)
+	if (IS_ERR(pty_driver))
 		panic("Couldn't allocate pty driver");
 
 	pty_slave_driver = tty_alloc_driver(legacy_count,
 			TTY_DRIVER_RESET_TERMIOS |
 			TTY_DRIVER_REAL_RAW |
 			TTY_DRIVER_DYNAMIC_ALLOC);
-	if (!pty_slave_driver)
+	if (IS_ERR(pty_slave_driver))
 		panic("Couldn't allocate pty slave driver");
 
 	pty_driver->driver_name = "pty_master";
@@ -682,7 +682,7 @@ static void __init unix98_pty_init(void)
 			TTY_DRIVER_DYNAMIC_DEV |
 			TTY_DRIVER_DEVPTS_MEM |
 			TTY_DRIVER_DYNAMIC_ALLOC);
-	if (!ptm_driver)
+	if (IS_ERR(ptm_driver))
 		panic("Couldn't allocate Unix98 ptm driver");
 	pts_driver = tty_alloc_driver(NR_UNIX98_PTY_MAX,
 			TTY_DRIVER_RESET_TERMIOS |
@@ -690,7 +690,7 @@ static void __init unix98_pty_init(void)
 			TTY_DRIVER_DYNAMIC_DEV |
 			TTY_DRIVER_DEVPTS_MEM |
 			TTY_DRIVER_DYNAMIC_ALLOC);
-	if (!pts_driver)
+	if (IS_ERR(pts_driver))
 		panic("Couldn't allocate Unix98 pts driver");
 
 	ptm_driver->driver_name = "pty_master";
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 3b17a04..56e616b 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1048,8 +1048,8 @@ static int __init moxa_init(void)
 	moxaDriver = tty_alloc_driver(MAX_PORTS + 1,
 			TTY_DRIVER_REAL_RAW |
 			TTY_DRIVER_DYNAMIC_DEV);
-	if (!moxaDriver)
-		return -ENOMEM;
+	if (IS_ERR(moxaDriver))
+		return PTR_ERR(moxaDriver);
 
 	moxaDriver->name = "ttyMX";
 	moxaDriver->major = ttymajor;
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index d9335ae..5db08c7 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2813,8 +2813,8 @@ static int __init synclink_cs_init(void)
 	serial_driver = tty_alloc_driver(MAX_DEVICE_COUNT,
 			TTY_DRIVER_REAL_RAW |
 			TTY_DRIVER_DYNAMIC_DEV);
-	if (!serial_driver) {
-		rc = -ENOMEM;
+	if (IS_ERR(serial_driver)) {
+		rc = PTR_ERR(serial_driver);
 		goto err;
 	}
 
diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index 561f8aa..af98f6d 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -187,8 +187,8 @@ static int __init ttyprintk_init(void)
 			TTY_DRIVER_RESET_TERMIOS |
 			TTY_DRIVER_REAL_RAW |
 			TTY_DRIVER_UNNUMBERED_NODE);
-	if (!ttyprintk_driver)
-		return ret;
+	if (IS_ERR(ttyprintk_driver))
+		return PTR_ERR(ttyprintk_driver);
 
 	ttyprintk_driver->driver_name = "ttyprintk";
 	ttyprintk_driver->name = "ttyprintk";
