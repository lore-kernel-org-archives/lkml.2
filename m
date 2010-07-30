Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab0G3SjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:39:19 -0400
Received: from kroah.org ([198.145.64.141]:57905 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759752Ab0G3Ry1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:27 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:35 2010
Message-Id: <20100730175135.579753500@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>,
        Jean-Marc Spaggiari <jean-marc@spaggiari.org>
Subject: [022/205] hwmon: (it87) Fix in7 on IT8720F
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 436cad2a41a40c6c32bd9152b63d17eeb1f7c99b upstream.

The IT8720F has no VIN7 pin, so VCCH should always be routed
internally to VIN7 with an internal divider. Curiously, there still
is a configuration bit to control this, which means it can be set
incorrectly. And even more curiously, many boards out there are
improperly configured, even though the IT8720F datasheet claims that
the internal routing of VCCH to VIN7 is the default setting. So we
force the internal routing in this case.

It turns out that all boards with the wrong setting are from Gigabyte,
so I suspect a BIOS bug. But it's easy enough to workaround in the
driver, so let's do it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jean-Marc Spaggiari <jean-marc@spaggiari.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/it87.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -80,6 +80,13 @@ superio_inb(int reg)
 	return inb(VAL);
 }
 
+static inline void
+superio_outb(int reg, int val)
+{
+	outb(reg, REG);
+	outb(val, VAL);
+}
+
 static int superio_inw(int reg)
 {
 	int val;
@@ -1517,6 +1524,21 @@ static int __init it87_find(unsigned sho
 			sio_data->vid_value = superio_inb(IT87_SIO_VID_REG);
 
 		reg = superio_inb(IT87_SIO_PINX2_REG);
+		/*
+		 * The IT8720F has no VIN7 pin, so VCCH should always be
+		 * routed internally to VIN7 with an internal divider.
+		 * Curiously, there still is a configuration bit to control
+		 * this, which means it can be set incorrectly. And even
+		 * more curiously, many boards out there are improperly
+		 * configured, even though the IT8720F datasheet claims
+		 * that the internal routing of VCCH to VIN7 is the default
+		 * setting. So we force the internal routing in this case.
+		 */
+		if (sio_data->type == it8720 && !(reg & (1 << 1))) {
+			reg |= (1 << 1);
+			superio_outb(IT87_SIO_PINX2_REG, reg);
+			pr_notice("it87: Routing internal VCCH to in7\n");
+		}
 		if (reg & (1 << 0))
 			pr_info("it87: in3 is VCC (+5V)\n");
 		if (reg & (1 << 1))


