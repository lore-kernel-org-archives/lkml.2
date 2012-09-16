Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2IPVWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 17:22:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60554 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2IPVWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:22:31 -0400
Date: Sun, 16 Sep 2012 17:22:21 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu
To: Henrik Rydberg <rydberg@euromail.se>
cc: Guenter Roeck <linux@roeck-us.net>, Parag Warudkar <parag.lkml@gmail.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
In-Reply-To: <20120916093520.GA5623@polaris.bitmath.org>
Message-ID: <alpine.DEB.2.02.1209161712070.14838@ubuntu>
References: <alpine.DEB.2.02.1209151834120.2271@ubuntu> <20120915225841.GA3816@roeck-us.net> <alpine.DEB.2.02.1209151918210.2271@ubuntu> <alpine.DEB.2.02.1209152323490.2088@ubuntu> <20120916043116.GA4477@roeck-us.net>
 <20120916093520.GA5623@polaris.bitmath.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Sep 2012, Henrik Rydberg wrote:

> On Sat, Sep 15, 2012 at 09:31:16PM -0700, Guenter Roeck wrote:
> > That looks terribly complicated. Better keep the loop, and just replace
> > 	udelay(us);
> > with something like
> > 	usleep_range(us, us << 1);
> > 
> > Alternatively, just use a constant such as
> > 	usleep_range(us, us + APPLESMC_MIN_WAIT);
> 
Well I don't think there is anything terribly complicated there - but I 
tried to make it simpler. Below patch seems to work better for me for my 
normal workload - I got no failures or other oddities with the default 
32ms timeout. I haven't tried very hard to get to the corner cases which 
earlier required a higher timeout. 

I would like to get this in for now if there aren't any further 
suggestions, as it fixes the failures by making it use the 
32ms maximum it was originally supposed to and for bonus it's also 
converted to use usleep_range which is better from PM standpoint.

> It would be worthwhile to check if there are other bits in status that
> encodes a busy state, similar to what we now have in send_byte(). This
> is what has finally made almost all machines error-free. Increasing
> the max wait is possible, of course, but it only kills the symptoms.
> 
> So, Parag, would it be possible for you to print the status field as
> you go through one of those long waits? If you find a bit that seems
> to change occasionally, you could try to use it as a busy indicator,
> and use the APPLESMC_RETRY_WAIT for that case.
> 
Henrik - if the below patch still results in failures we can 
revisit the long  wait cases. For now I am satisfied that there aren't any 
normal case failures like before.

Thanks,
Parag

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 2827088..569aa8d 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -168,14 +168,14 @@ static struct workqueue_struct *applesmc_led_wq;
 static int wait_read(void)
 {
 	u8 status;
-	int us;
-	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
-		udelay(us);
+	int us = APPLESMC_MIN_WAIT;
+	do {
 		status = inb(APPLESMC_CMD_PORT);
 		/* read: wait for smc to settle */
 		if (status & 0x01)
 			return 0;
-	}
+		usleep_range(us, us << 1);
+	} while ((us <<= 1) <= APPLESMC_MAX_WAIT);
 
 	pr_warn("wait_read() fail: 0x%02x\n", status);
 	return -EIO;
@@ -192,19 +192,22 @@ static int send_byte(u8 cmd, u16 port)
 
 	outb(cmd, port);
 	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
-		udelay(us);
 		status = inb(APPLESMC_CMD_PORT);
 		/* write: wait for smc to settle */
-		if (status & 0x02)
+		if (status & 0x02) {
+			usleep_range(us, us << 1);
 			continue;
+		}
 		/* ready: cmd accepted, return */
 		if (status & 0x04)
 			return 0;
 		/* timeout: give up */
-		if (us << 1 == APPLESMC_MAX_WAIT)
+		if (us << 1 > APPLESMC_MAX_WAIT) {
+			pr_warn("Timeout with us: %d\n", us);
 			break;
+		}
 		/* busy: long wait and resend */
-		udelay(APPLESMC_RETRY_WAIT);
+		usleep_range(APPLESMC_RETRY_WAIT, APPLESMC_RETRY_WAIT << 1);
 		outb(cmd, port);
 	}
 
 
