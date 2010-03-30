Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab0C3XUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:30 -0400
Received: from kroah.org ([198.145.64.141]:45684 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab0C3XTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:20 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:27 2010
Message-Id: <20100330224727.426715293@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [011/156] i2c-powermac: Be less verbose in the absence of real errors.
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 8e4b980c28c91cfe9d0ce0431bc0af56e146b49e upstream.

Be less verbose in the absence of real errors. We don't have to report
failed probes to the users, it's only confusing them.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Andrey Gusev <ronne@list.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-powermac.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -122,9 +122,14 @@ static s32 i2c_powermac_smbus_xfer(	stru
 
 	rc = pmac_i2c_xfer(bus, addrdir, subsize, subaddr, buf, len);
 	if (rc) {
-		dev_err(&adap->dev,
-			"I2C transfer at 0x%02x failed, size %d, err %d\n",
-			addrdir >> 1, size, rc);
+		if (rc == -ENXIO)
+			dev_dbg(&adap->dev,
+				"I2C transfer at 0x%02x failed, size %d, "
+				"err %d\n", addrdir >> 1, size, rc);
+		else
+			dev_err(&adap->dev,
+				"I2C transfer at 0x%02x failed, size %d, "
+				"err %d\n", addrdir >> 1, size, rc);
 		goto bail;
 	}
 
@@ -175,10 +180,16 @@ static int i2c_powermac_master_xfer(	str
 		goto bail;
 	}
 	rc = pmac_i2c_xfer(bus, addrdir, 0, 0, msgs->buf, msgs->len);
-	if (rc < 0)
-		dev_err(&adap->dev, "I2C %s 0x%02x failed, err %d\n",
-			addrdir & 1 ? "read from" : "write to", addrdir >> 1,
-			rc);
+	if (rc < 0) {
+		if (rc == -ENXIO)
+			dev_dbg(&adap->dev, "I2C %s 0x%02x failed, err %d\n",
+				addrdir & 1 ? "read from" : "write to",
+				addrdir >> 1, rc);
+		else
+			dev_err(&adap->dev, "I2C %s 0x%02x failed, err %d\n",
+				addrdir & 1 ? "read from" : "write to",
+				addrdir >> 1, rc);
+	}
  bail:
 	pmac_i2c_close(bus);
 	return rc < 0 ? rc : 1;


