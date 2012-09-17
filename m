Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2IQSWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:22:34 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42456 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2IQSWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:22:33 -0400
Date: Mon, 17 Sep 2012 14:22:28 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu
To: Henrik Rydberg <rydberg@euromail.se>
cc: Parag Warudkar <parag.lkml@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
In-Reply-To: <20120917162705.GA2854@polaris.bitmath.org>
Message-ID: <alpine.DEB.2.02.1209171416560.3412@ubuntu>
References: <alpine.DEB.2.02.1209151834120.2271@ubuntu> <20120915225841.GA3816@roeck-us.net> <alpine.DEB.2.02.1209151918210.2271@ubuntu> <alpine.DEB.2.02.1209152323490.2088@ubuntu> <20120916043116.GA4477@roeck-us.net> <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu> <20120916223003.GA2160@polaris.bitmath.org> <alpine.DEB.2.02.1209161957490.2808@ubuntu> <20120917162705.GA2854@polaris.bitmath.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Sep 2012, Henrik Rydberg wrote:

> The MBP10,1 experiences a lot of write errors with this patch.

I just noticed a single write failure - are you seeing something similar?

[ 1660.362997] applesmc: send_byte(0x00, 0x0300) fail: 0x00
[ 1660.363002] applesmc: LKSB: write data fail

Since the write fails are confirmed, I've locally dropped the send_byte 
changes and just kept the wait_read ones that haven't caused me any 
trouble yet.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 2827088..2ba298a 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -169,14 +169,14 @@ static int wait_read(void)
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
-
 	pr_warn("wait_read() fail: 0x%02x\n", status);
 	return -EIO;
 }
