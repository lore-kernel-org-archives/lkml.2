Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1DYUXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:05 -0400
Received: from 1wt.eu ([62.212.114.60]:33691 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab1DYUXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:00 -0400
Message-Id: <20110425200233.603936859@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 014/173] [media] radio-aimslab.c: Fix gcc 4.5+ bug
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit e3c92215198cb6aa00ad38db2780faa6b72e0a3f upstream.

gcc 4.5+ doesn't properly evaluate some inlined expressions.
A previous patch were proposed by Andrew Morton using noinline.
However, the entire inlined function is bogus, so let's just
remove it and be happy.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/radio/radio-aimslab.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

Index: longterm-2.6.27/drivers/media/radio/radio-aimslab.c
===================================================================
--- longterm-2.6.27.orig/drivers/media/radio/radio-aimslab.c	2011-01-23 10:52:18.000000000 +0100
+++ longterm-2.6.27/drivers/media/radio/radio-aimslab.c	2011-04-25 11:58:08.977279111 +0200
@@ -31,7 +31,6 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
-#include <linux/delay.h>	/* udelay			*/
 #include <asm/io.h>		/* outb, outb_p			*/
 #include <asm/uaccess.h>	/* copy to/from user		*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
@@ -60,27 +59,17 @@
 
 /* local things */
 
-static void sleep_delay(long n)
-{
-	/* Sleep nicely for 'n' uS */
-	int d=n/msecs_to_jiffies(1000);
-	if(!d)
-		udelay(n);
-	else
-		msleep(jiffies_to_msecs(d));
-}
-
 static void rt_decvol(void)
 {
 	outb(0x58, io);		/* volume down + sigstr + on	*/
-	sleep_delay(100000);
+	msleep(100);
 	outb(0xd8, io);		/* volume steady + sigstr + on	*/
 }
 
 static void rt_incvol(void)
 {
 	outb(0x98, io);		/* volume up + sigstr + on	*/
-	sleep_delay(100000);
+	msleep(100);
 	outb(0xd8, io);		/* volume steady + sigstr + on	*/
 }
 
@@ -109,7 +98,7 @@
 
 	if(vol == 0) {			/* volume = 0 means mute the card */
 		outb(0x48, io);		/* volume down but still "on"	*/
-		sleep_delay(2000000);	/* make sure it's totally down	*/
+		msleep(2000);		/* make sure it's totally down	*/
 		outb(0xd0, io);		/* volume steady, off		*/
 		dev->curvol = 0;	/* track the volume state!	*/
 		mutex_unlock(&lock);
@@ -144,7 +133,7 @@
 		outb_p(128+64+16+8+  1, port);  /* on + wr-enable + data low */
 		outb_p(128+64+16+8+2+1, port);  /* clock */
 	}
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static void send_1_byte(int port, struct rt_device *dev)
@@ -158,7 +147,7 @@
 		outb_p(128+64+16+8+4+2+1, port); /* clock */
 	}
 
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static int rt_setfreq(struct rt_device *dev, unsigned long freq)
@@ -440,7 +429,7 @@
 
 	/* this ensures that the volume is all the way down  */
 	outb(0x48, io);		/* volume down but still "on"	*/
-	sleep_delay(2000000);	/* make sure it's totally down	*/
+	msleep(2000);		/* make sure it's totally down	*/
 	outb(0xc0, io);		/* steady volume, mute card	*/
 	rtrack_unit.curvol = 0;
 


