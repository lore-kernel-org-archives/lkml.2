Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab0EYSRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:17:37 -0400
Received: from kroah.org ([198.145.64.141]:44402 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933449Ab0EYSRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:34 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:13 2010
Message-Id: <20100525181213.850086958@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>
Subject: [18/25] i2c: Fix probing of FSC hardware monitoring chips
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit b1d4b390ea4bb480e65974ce522a04022608a8df upstream.

Some FSC hardware monitoring chips (Syleus at least) doesn't like
quick writes we typically use to probe for I2C chips. Use a regular
byte read instead for the address they live at (0x73). These are the
only known chips living at this address on PC systems.

For clarity, this fix should not be needed for kernels 2.6.30 and
later, as we started instantiating the hwmon devices explicitly based
on DMI data. Still, this fix is valuable in the following two cases:
* Support for recent FSC chips on older kernels. The DMI-based device
  instantiation is more difficult to backport than the device support
  itself.
* Case where the DMI-based device instantiation fails, whatever the
  reason. We fall back to probing in that case, so it should work.

This fixes kernel bug #15634:
https://bugzilla.kernel.org/show_bug.cgi?id=15634

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/i2c/i2c-core.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1269,14 +1269,24 @@ static int i2c_detect_address(struct i2c
 
 	/* Make sure there is something at this address, unless forced */
 	if (kind < 0) {
-		if (i2c_smbus_xfer(adapter, addr, 0, 0, 0,
-				   I2C_SMBUS_QUICK, NULL) < 0)
-			return 0;
+		if (addr == 0x73 && (adapter->class & I2C_CLASS_HWMON)) {
+			/* Special probe for FSC hwmon chips */
+			union i2c_smbus_data dummy;
 
-		/* prevent 24RF08 corruption */
-		if ((addr & ~0x0f) == 0x50)
-			i2c_smbus_xfer(adapter, addr, 0, 0, 0,
-				       I2C_SMBUS_QUICK, NULL);
+			if (i2c_smbus_xfer(adapter, addr, 0, I2C_SMBUS_READ, 0,
+					   I2C_SMBUS_BYTE_DATA, &dummy) < 0)
+				return 0;
+		} else {
+			if (i2c_smbus_xfer(adapter, addr, 0, I2C_SMBUS_WRITE, 0,
+					   I2C_SMBUS_QUICK, NULL) < 0)
+				return 0;
+
+			/* Prevent 24RF08 corruption */
+			if ((addr & ~0x0f) == 0x50)
+				i2c_smbus_xfer(adapter, addr, 0,
+					       I2C_SMBUS_WRITE, 0,
+					       I2C_SMBUS_QUICK, NULL);
+		}
 	}
 
 	/* Finally call the custom detection function */


