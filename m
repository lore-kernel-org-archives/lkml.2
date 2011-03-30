Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab1C3WFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:05:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:4384 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225Ab1C3VGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132843"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mchehab@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [42/275] radio-aimslab.c: Fix gcc 4.5+ bug
Message-Id: <20110330210437.E25AD3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/radio/radio-aimslab.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

Index: linux-2.6.35.y/drivers/media/radio/radio-aimslab.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/radio/radio-aimslab.c	2011-03-29 22:51:52.415381990 -0700
+++ linux-2.6.35.y/drivers/media/radio/radio-aimslab.c	2011-03-29 23:54:46.149821568 -0700
@@ -31,7 +31,6 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
-#include <linux/delay.h>	/* udelay			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 #include <linux/io.h>		/* outb, outb_p			*/
@@ -71,27 +70,17 @@
 
 /* local things */
 
-static void sleep_delay(long n)
-{
-	/* Sleep nicely for 'n' uS */
-	int d = n / msecs_to_jiffies(1000);
-	if (!d)
-		udelay(n);
-	else
-		msleep(jiffies_to_msecs(d));
-}
-
 static void rt_decvol(struct rtrack *rt)
 {
 	outb(0x58, rt->io);		/* volume down + sigstr + on	*/
-	sleep_delay(100000);
+	msleep(100);
 	outb(0xd8, rt->io);		/* volume steady + sigstr + on	*/
 }
 
 static void rt_incvol(struct rtrack *rt)
 {
 	outb(0x98, rt->io);		/* volume up + sigstr + on	*/
-	sleep_delay(100000);
+	msleep(100);
 	outb(0xd8, rt->io);		/* volume steady + sigstr + on	*/
 }
 
@@ -120,7 +109,7 @@
 
 	if (vol == 0) {			/* volume = 0 means mute the card */
 		outb(0x48, rt->io);	/* volume down but still "on"	*/
-		sleep_delay(2000000);	/* make sure it's totally down	*/
+		msleep(2000);	/* make sure it's totally down	*/
 		outb(0xd0, rt->io);	/* volume steady, off		*/
 		rt->curvol = 0;		/* track the volume state!	*/
 		mutex_unlock(&rt->lock);
@@ -155,7 +144,7 @@
 		outb_p(128+64+16+8+  1, rt->io);  /* on + wr-enable + data low */
 		outb_p(128+64+16+8+2+1, rt->io);  /* clock */
 	}
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static void send_1_byte(struct rtrack *rt)
@@ -169,7 +158,7 @@
 		outb_p(128+64+16+8+4+2+1, rt->io); /* clock */
 	}
 
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static int rt_setfreq(struct rtrack *rt, unsigned long freq)
@@ -427,7 +416,7 @@
 
 	/* this ensures that the volume is all the way down  */
 	outb(0x48, rt->io);		/* volume down but still "on"	*/
-	sleep_delay(2000000);	/* make sure it's totally down	*/
+	msleep(2000);	/* make sure it's totally down	*/
 	outb(0xc0, rt->io);		/* steady volume, mute card	*/
 
 	return 0;
