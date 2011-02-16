Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab1BPCIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:08:01 -0500
Received: from kroah.org ([198.145.64.141]:48853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758114Ab1BPBtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:58 2011
Message-Id: <20110216014658.123013800@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [038/115] [media] radio-aimslab.c: Fix gcc 4.5+ bug
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -31,7 +31,6 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
-#include <linux/delay.h>	/* udelay			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 #include <linux/io.h>		/* outb, outb_p			*/
@@ -71,27 +70,17 @@ static struct rtrack rtrack_card;
 
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
 
@@ -120,7 +109,7 @@ static int rt_setvol(struct rtrack *rt,
 
 	if (vol == 0) {			/* volume = 0 means mute the card */
 		outb(0x48, rt->io);	/* volume down but still "on"	*/
-		sleep_delay(2000000);	/* make sure it's totally down	*/
+		msleep(2000);	/* make sure it's totally down	*/
 		outb(0xd0, rt->io);	/* volume steady, off		*/
 		rt->curvol = 0;		/* track the volume state!	*/
 		mutex_unlock(&rt->lock);
@@ -155,7 +144,7 @@ static void send_0_byte(struct rtrack *r
 		outb_p(128+64+16+8+  1, rt->io);  /* on + wr-enable + data low */
 		outb_p(128+64+16+8+2+1, rt->io);  /* clock */
 	}
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static void send_1_byte(struct rtrack *rt)
@@ -169,7 +158,7 @@ static void send_1_byte(struct rtrack *r
 		outb_p(128+64+16+8+4+2+1, rt->io); /* clock */
 	}
 
-	sleep_delay(1000);
+	msleep(1);
 }
 
 static int rt_setfreq(struct rtrack *rt, unsigned long freq)
@@ -423,7 +412,7 @@ static int __init rtrack_init(void)
 
 	/* this ensures that the volume is all the way down  */
 	outb(0x48, rt->io);		/* volume down but still "on"	*/
-	sleep_delay(2000000);	/* make sure it's totally down	*/
+	msleep(2000);	/* make sure it's totally down	*/
 	outb(0xc0, rt->io);		/* steady volume, mute card	*/
 
 	return 0;


