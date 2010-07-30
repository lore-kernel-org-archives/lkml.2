Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab0G3R4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:56:52 -0400
Received: from kroah.org ([198.145.64.141]:58610 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334Ab0G3R4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:08 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:42 2010
Message-Id: <20100730175142.404820479@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Paul Gortmaker <p_gortmaker@yahoo.com>
Subject: [096/205] rtc: fix ds1388 time corruption
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

commit 96fc3a45ea073136566f3c2676cad52f8b39a7df upstream.

The ds1307 driver misreads the ds1388 registers when checking for 12 or 24
hour mode.  Instead of checking the hour register it reads the minute
register.  Therefore the driver thinks minutes >= 40 has the 12HR bit set
and resets the minute register by zeroing the high bits.  This results in
minutes are reset to 0-9, jumping back in time 40 or 50 minutes.  The time
jump is also written back to the RTC.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-ds1307.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -775,7 +775,7 @@ static int __devinit ds1307_probe(struct
 
 read_rtc:
 	/* read RTC registers */
-	tmp = ds1307->read_block_data(ds1307->client, 0, 8, buf);
+	tmp = ds1307->read_block_data(ds1307->client, ds1307->offset, 8, buf);
 	if (tmp != 8) {
 		pr_debug("read error %d\n", tmp);
 		err = -EIO;
@@ -860,7 +860,7 @@ read_rtc:
 		if (ds1307->regs[DS1307_REG_HOUR] & DS1307_BIT_PM)
 			tmp += 12;
 		i2c_smbus_write_byte_data(client,
-				DS1307_REG_HOUR,
+				ds1307->offset + DS1307_REG_HOUR,
 				bin2bcd(tmp));
 	}
 


