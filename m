Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab2IPDbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 23:31:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40188 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2IPDaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 23:30:07 -0400
Date: Sat, 15 Sep 2012 23:29:58 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu
To: Parag Warudkar <parag.lkml@gmail.com>
cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, rydberg@euromail.se, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
In-Reply-To: <alpine.DEB.2.02.1209151918210.2271@ubuntu>
Message-ID: <alpine.DEB.2.02.1209152323490.2088@ubuntu>
References: <alpine.DEB.2.02.1209151834120.2271@ubuntu> <20120915225841.GA3816@roeck-us.net> <alpine.DEB.2.02.1209151918210.2271@ubuntu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Sep 2012, Parag Warudkar wrote:

> 
> 
> On Sat, 15 Sep 2012, Guenter Roeck wrote:
> > 
> > Also, since the delay time can get quite large, would it make sense to replace
> > udelay with usleep_range() ?
> > 
> 
> Yes, I think that would be a good thing to do. We could sleep in range of 
> us<<=1 and us<<1 and if usleep_range() returns actual sleep time we can 
> factor that in for next loop iteration if necessary. Gotta think a bit on 
> that one.
> 
> I will rework the patch to fix the loop termination and keep the bump to 
> 0x10000 in place and possibly also experiment with usleep_range().
> 

Below is what I am experimenting with right now. I chose to keep the 
APPLESMC_MAX_WAIT to current 0x8000 (32ms). With the fixed loop 
termination and use of usleep_range() instead of udelay - I will try to 
run this a couple days and see if I can recreate the failure within 32ms.

Does this look ok? (I haven't yet changed send_byte to use usleep_range - 
if this approach looks ok I can change that as well.)

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 2827088..6610037 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -168,15 +168,20 @@ static struct workqueue_struct *applesmc_led_wq;
 static int wait_read(void)
 {
 	u8 status;
-	int us;
-	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
-		udelay(us);
+	unsigned long r1_us = APPLESMC_MIN_WAIT;
+	unsigned long r2_us;
+	do {
 		status = inb(APPLESMC_CMD_PORT);
 		/* read: wait for smc to settle */
 		if (status & 0x01)
 			return 0;
-	}
-
+		r2_us = r1_us << 2;
+		if (r2_us > APPLESMC_MAX_WAIT)
+			goto fail;
+		usleep_range(r1_us, r2_us);
+		r1_us = r2_us;
+	} while (1);
+fail:
 	pr_warn("wait_read() fail: 0x%02x\n", status);
 	return -EIO;
 }
@@ -191,12 +196,13 @@ static int send_byte(u8 cmd, u16 port)
 	int us;
 
 	outb(cmd, port);
-	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
-		udelay(us);
+	for (us = APPLESMC_MIN_WAIT; us <= APPLESMC_MAX_WAIT; us <<= 1) {
 		status = inb(APPLESMC_CMD_PORT);
 		/* write: wait for smc to settle */
-		if (status & 0x02)
+		if (status & 0x02) {
+			udelay(us);
 			continue;
+		}
 		/* ready: cmd accepted, return */
 		if (status & 0x04)
 			return 0;
