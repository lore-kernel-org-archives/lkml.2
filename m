Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab0G3Rng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:43:36 -0400
Received: from kroah.org ([198.145.64.141]:36176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464Ab0G3RgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:36:03 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:13 2010
Message-Id: <20100730173113.777154885@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [123/140] V4L/DVB: FusionHDTV: Use quick reads for I2C IR device probing
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 806b07c29b711aaf90c81d2a19711607769f8246 upstream.

IR support on FusionHDTV cards is broken since kernel 2.6.31. One side
effect of the switch to the standard binding model for IR I2C devices
was to let i2c-core do the probing instead of the ir-kbd-i2c driver.
There is a slight difference between the two probe methods: i2c-core
uses 0-byte writes, while the ir-kbd-i2c was using 0-byte reads. As
some IR I2C devices only support reads, the new probe method fails to
detect them.

For now, revert to letting the driver do the probe, using 0-byte
reads. In the future, i2c-core will be extended to let callers of
i2c_new_probed_device() provide a custom probing function.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: "Timothy D. Lenz" <tlenz@vorgon.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-i2c.c |   12 +++++++++++-
 drivers/media/video/cx88/cx88-i2c.c       |   16 +++++++++++++++-
 2 files changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/media/video/cx23885/cx23885-i2c.c
+++ b/drivers/media/video/cx23885/cx23885-i2c.c
@@ -365,7 +365,17 @@ int cx23885_i2c_register(struct cx23885_
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list);
+		/*
+		 * We can't call i2c_new_probed_device() because it uses
+		 * quick writes for probing and the IR receiver device only
+		 * replies to reads.
+		 */
+		if (i2c_smbus_xfer(&bus->i2c_adap, addr_list[0], 0,
+				   I2C_SMBUS_READ, 0, I2C_SMBUS_QUICK,
+				   NULL) >= 0) {
+			info.addr = addr_list[0];
+			i2c_new_device(&bus->i2c_adap, &info);
+		}
 	}
 
 	return bus->i2c_rc;
--- a/drivers/media/video/cx88/cx88-i2c.c
+++ b/drivers/media/video/cx88/cx88-i2c.c
@@ -188,10 +188,24 @@ int cx88_i2c_init(struct cx88_core *core
 			0x18, 0x6b, 0x71,
 			I2C_CLIENT_END
 		};
+		const unsigned short *addrp;
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-		i2c_new_probed_device(&core->i2c_adap, &info, addr_list);
+		/*
+		 * We can't call i2c_new_probed_device() because it uses
+		 * quick writes for probing and at least some R receiver
+		 * devices only reply to reads.
+		 */
+		for (addrp = addr_list; *addrp != I2C_CLIENT_END; addrp++) {
+			if (i2c_smbus_xfer(&core->i2c_adap, *addrp, 0,
+					   I2C_SMBUS_READ, 0,
+					   I2C_SMBUS_QUICK, NULL) >= 0) {
+				info.addr = *addrp;
+				i2c_new_device(&core->i2c_adap, &info);
+				break;
+			}
+		}
 	}
 	return core->i2c_rc;
 }


