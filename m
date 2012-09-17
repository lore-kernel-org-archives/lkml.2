Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2IQALk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:11:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51608 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2IQALj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:11:39 -0400
Date: Sun, 16 Sep 2012 20:11:29 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu
To: Henrik Rydberg <rydberg@euromail.se>
cc: Parag Warudkar <parag.lkml@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
In-Reply-To: <20120916223003.GA2160@polaris.bitmath.org>
Message-ID: <alpine.DEB.2.02.1209161957490.2808@ubuntu>
References: <alpine.DEB.2.02.1209151834120.2271@ubuntu> <20120915225841.GA3816@roeck-us.net> <alpine.DEB.2.02.1209151918210.2271@ubuntu> <alpine.DEB.2.02.1209152323490.2088@ubuntu> <20120916043116.GA4477@roeck-us.net> <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu> <20120916223003.GA2160@polaris.bitmath.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Sep 2012, Henrik Rydberg wrote:

> What exact model is this?

MacBookPro6,1 - 2010 17" MBP.

> 
> In addition to Guenter's comments, it is not clear what part of this
> patch makes things work for you. Is it a) the doubling of the wait
> time, or b) the zero initial wait? Or c) just randomly a little bit
> better?

I have addressed Guenter's comments in the revised patch below - I've 
minimized the deviation from the original code - only thing additional is 
usleep_range which I believe is a good thing to do.

> 
> If a), that is very valuable information, and the patch can be
> simplified further. If b), just crank up the wait time and be done
> with it. If c), well, then we don't have a case for a patch.
> 
I initially experimented with different max wait values and came to the 
conclusion that 0x20000 was good enough to reduce the errors to zero. But 
then Guenter pointed out that the original loop terminated too early - 
that means it only waited 16 ms instead of 32. I then corrected the loop 
termination but kept the original 32ms max wait and used usleep_range() 
instead of udelay() - testing with this gave me no errors whereas earlier 
the errors were readily reproducible and significant in quanity.

So I guess actually sleeping for 32ms along with the upward variability 
introduced by usleep_range() is helping with the fix.

> Also, it is not enough to test this on one machine, for fairly obvious
> reasons. I don't mind testing on a couple of machines close by (MBA3,1
> MBP10,1), once the comments have been addressed. However, a machine
> from around 2008 should be tested as well, since they behave
> differently.

Since we are keeping the changes minimal and using the same 32 ms max wait 
as originally intended I think this patch can only make things better. It 
sure does make things better on my machine but it will not hurt to test it 
on other models.

Parag

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 2827088..a168a8f 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -169,12 +169,13 @@ static int wait_read(void)
 {
 	u8 status;
 	int us;
-	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
-		udelay(us);
+	for (us = APPLESMC_MIN_WAIT; us <= APPLESMC_MAX_WAIT; us <<= 1) {
 		status = inb(APPLESMC_CMD_PORT);
 		/* read: wait for smc to settle */
 		if (status & 0x01)
 			return 0;
+		if (us < APPLESMC_MAX_WAIT)
+			usleep_range(us, us << 1);
 	}
 
 	pr_warn("wait_read() fail: 0x%02x\n", status);
@@ -192,7 +193,7 @@ static int send_byte(u8 cmd, u16 port)
 
 	outb(cmd, port);
 	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
-		udelay(us);
+		usleep_range(us, us << 1);
 		status = inb(APPLESMC_CMD_PORT);
 		/* write: wait for smc to settle */
 		if (status & 0x02)
@@ -204,7 +205,7 @@ static int send_byte(u8 cmd, u16 port)
 		if (us << 1 == APPLESMC_MAX_WAIT)
 			break;
 		/* busy: long wait and resend */
-		udelay(APPLESMC_RETRY_WAIT);
+		usleep_range(APPLESMC_RETRY_WAIT, APPLESMC_RETRY_WAIT << 1);
 		outb(cmd, port);
 	}
 
