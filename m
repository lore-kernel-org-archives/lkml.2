Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab0EJXit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:38:49 -0400
Received: from kroah.org ([198.145.64.141]:33062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab0EJWwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:09 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:20 2010
Message-Id: <20100510223320.894816433@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>
Subject: [041/117] i2c: Fix probing of FSC hardware monitoring chips
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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
 drivers/i2c/i2c-core.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1210,12 +1210,23 @@ static int i2c_detect_address(struct i2c
 		return 0;
 
 	/* Make sure there is something at this address */
-	if (i2c_smbus_xfer(adapter, addr, 0, 0, 0, I2C_SMBUS_QUICK, NULL) < 0)
-		return 0;
+	if (addr == 0x73 && (adapter->class & I2C_CLASS_HWMON)) {
+		/* Special probe for FSC hwmon chips */
+		union i2c_smbus_data dummy;
+
+		if (i2c_smbus_xfer(adapter, addr, 0, I2C_SMBUS_READ, 0,
+				   I2C_SMBUS_BYTE_DATA, &dummy) < 0)
+			return 0;
+	} else {
+		if (i2c_smbus_xfer(adapter, addr, 0, I2C_SMBUS_WRITE, 0,
+				   I2C_SMBUS_QUICK, NULL) < 0)
+			return 0;
 
-	/* Prevent 24RF08 corruption */
-	if ((addr & ~0x0f) == 0x50)
-		i2c_smbus_xfer(adapter, addr, 0, 0, 0, I2C_SMBUS_QUICK, NULL);
+		/* Prevent 24RF08 corruption */
+		if ((addr & ~0x0f) == 0x50)
+			i2c_smbus_xfer(adapter, addr, 0, I2C_SMBUS_WRITE, 0,
+				       I2C_SMBUS_QUICK, NULL);
+	}
 
 	/* Finally call the custom detection function */
 	memset(&info, 0, sizeof(struct i2c_board_info));


