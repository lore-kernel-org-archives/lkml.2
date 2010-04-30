Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0D3QyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:54:00 -0400
Received: from kroah.org ([198.145.64.141]:53028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970Ab0D3Qxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:53:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jirislaby@gmail.com>,
       Dan Carpenter <error27@gmail.com>, Andreas Pretzsch <apr@cn-eng.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] tty: Fix regressions in the char driver conversion
Date: Fri, 30 Apr 2010 09:37:38 -0700
Message-Id: <1272645460-16491-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100430163654.GB16424@kroah.com>
References: <20100430163654.GB16424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This forgot to update a field in the old char drivers. The fact nobody
has basically noticed (except one mxser user) rather suggests most of these
drivers could go into the bitbucket.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Andreas Pretzsch <apr@cn-eng.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/isicom.c    |    9 +++++++--
 drivers/char/istallion.c |    2 ++
 drivers/char/mxser.c     |    3 ++-
 drivers/char/riscom8.c   |    1 +
 drivers/char/stallion.c  |    7 ++++---
 5 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 0fa2e4a..c1ab303 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -879,8 +879,8 @@ static int isicom_open(struct tty_struct *tty, struct file *filp)
 	if (tport == NULL)
 		return -ENODEV;
 	port = container_of(tport, struct isi_port, port);
-	card = &isi_card[BOARD(tty->index)];
 
+	tty->driver_data = port;
 	return tty_port_open(tport, tty, filp);
 }
 
@@ -936,7 +936,12 @@ static void isicom_shutdown(struct tty_port *port)
 static void isicom_close(struct tty_struct *tty, struct file *filp)
 {
 	struct isi_port *ip = tty->driver_data;
-	struct tty_port *port = &ip->port;
+	struct tty_port *port;
+
+	if (ip == NULL)
+		return;
+
+	port = &ip->port;
 	if (isicom_paranoia_check(ip, tty->name, "isicom_close"))
 		return;
 	tty_port_close(port, tty, filp);
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 4cd6c52..4e395c9 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -827,6 +827,8 @@ static int stli_open(struct tty_struct *tty, struct file *filp)
 		return -ENODEV;
 	if (portp->devnr < 1)
 		return -ENODEV;
+
+	tty->driver_data = portp;
 	return tty_port_open(&portp->port, tty, filp);
 }
 
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 4702305..d2692d4 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1011,6 +1011,7 @@ static int mxser_open(struct tty_struct *tty, struct file *filp)
 	if (!info->ioaddr)
 		return -ENODEV;
 
+	tty->driver_data = info;
 	return tty_port_open(&info->port, tty, filp);
 }
 
@@ -1074,7 +1075,7 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 	struct mxser_port *info = tty->driver_data;
 	struct tty_port *port = &info->port;
 
-	if (tty->index == MXSER_PORTS)
+	if (tty->index == MXSER_PORTS || info == NULL)
 		return;
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 0a8d1e5..b02332a 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -909,6 +909,7 @@ static int rc_open(struct tty_struct *tty, struct file *filp)
 	if (error)
 		return error;
 
+	tty->driver_data = port;
 	return tty_port_open(&port->port, tty, filp);
 }
 
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 0e511d6..6049fd7 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -724,7 +724,6 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
 {
 	struct stlport	*portp;
 	struct stlbrd	*brdp;
-	struct tty_port *port;
 	unsigned int	minordev, brdnr, panelnr;
 	int		portnr;
 
@@ -754,7 +753,8 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
 	portp = brdp->panels[panelnr]->ports[portnr];
 	if (portp == NULL)
 		return -ENODEV;
-	port = &portp->port;
+
+	tty->driver_data = portp;
 	return tty_port_open(&portp->port, tty, filp);
 
 }
@@ -841,7 +841,8 @@ static void stl_close(struct tty_struct *tty, struct file *filp)
 	pr_debug("stl_close(tty=%p,filp=%p)\n", tty, filp);
 
 	portp = tty->driver_data;
-	BUG_ON(portp == NULL);
+	if(portp == NULL)
+		return;
 	tty_port_close(&portp->port, tty, filp);
 }
 
-- 
1.7.0.4

