Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0IOVux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:50:53 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:59659 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab0IOVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:50:51 -0400
Subject: [PATCH] drivers/usb/serial/mos*: prevent reading uninitialized
 stack memory
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 17:44:16 -0400
Message-ID: <1284587056.6275.100.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TIOCGICOUNT device ioctl in both mos7720.c and mos7840.c allows
unprivileged users to read uninitialized stack memory, because the
"reserved" member of the serial_icounter_struct struct declared on the
stack is not altered or zeroed before being copied back to the user.
This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

diff -urp linux-2.6.35.4.orig/drivers/usb/serial/mos7720.c linux-2.6.35.4/drivers/usb/serial/mos7720.c
--- linux-2.6.35.4.orig/drivers/usb/serial/mos7720.c	2010-08-26 19:47:12.000000000 -0400
+++ linux-2.6.35.4/drivers/usb/serial/mos7720.c	2010-09-15 11:42:01.877375361 -0400
@@ -2024,6 +2024,9 @@ static int mos7720_ioctl(struct tty_stru
 
 	case TIOCGICOUNT:
 		cnow = mos7720_port->icount;
+
+		memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 		icount.cts = cnow.cts;
 		icount.dsr = cnow.dsr;
 		icount.rng = cnow.rng;
diff -urp linux-2.6.35.4.orig/drivers/usb/serial/mos7840.c linux-2.6.35.4/drivers/usb/serial/mos7840.c
--- linux-2.6.35.4.orig/drivers/usb/serial/mos7840.c	2010-08-26 19:47:12.000000000 -0400
+++ linux-2.6.35.4/drivers/usb/serial/mos7840.c	2010-09-15 11:42:39.237375173 -0400
@@ -2273,6 +2273,9 @@ static int mos7840_ioctl(struct tty_stru
 	case TIOCGICOUNT:
 		cnow = mos7840_port->icount;
 		smp_rmb();
+
+		memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 		icount.cts = cnow.cts;
 		icount.dsr = cnow.dsr;
 		icount.rng = cnow.rng;






