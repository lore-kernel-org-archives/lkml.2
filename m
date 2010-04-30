Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab0D3ROe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:14:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46060 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815Ab0D3RNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Zu6YOTosje0ZVeBAfk6ZnpFf7UYc57ju5bL5gRBGP71ouVd22bMYuCe74SWYWjiewy
         uDtRt22bnEXGjokQZSL7BkN1A6SVmZDvfshj1xNg6531XC2FL39rWMtXHr1Lh25nvovf
         pGGzThgA1gWluCmQkxMg42dtL36dMhdNudm7c=
Date: Fri, 30 Apr 2010 12:44:12 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: i2c-i801 retries on lost arbitration (resent: no gpg)
Message-ID: <20100430094412.GC3553@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soory, forgot to turn-off gpg.

Both i2c spec and ICH7 datasheet requires to restart transaction in
case of lost arbitration.

"No information is lost during the arbitration process. A master that
loses the arbitration can generate clock pulses until the end of the
byte in which it loses the arbitration and must restart its transaction
when the bus is idle."
        
Please see the following patch. Is it correct?

---

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 299b918..b7c21ee 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -446,100 +446,111 @@ static s32 i801_access(struct i2c_adapter * adap, u16 addr,
 {
 	int hwpec;
 	int block = 0;
-	int ret, xact = 0;
-
+	int ret, xact = 0, i = 0;
+	
 	hwpec = (i801_features & FEATURE_SMBUS_PEC) && (flags & I2C_CLIENT_PEC)
 		&& size != I2C_SMBUS_QUICK
 		&& size != I2C_SMBUS_I2C_BLOCK_DATA;
 
-	switch (size) {
-	case I2C_SMBUS_QUICK:
-		outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
-		       SMBHSTADD);
-		xact = I801_QUICK;
-		break;
-	case I2C_SMBUS_BYTE:
-		outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
-		       SMBHSTADD);
-		if (read_write == I2C_SMBUS_WRITE)
+	for (i = adap->retries; i >= 0; i--) {
+		switch (size) {
+		case I2C_SMBUS_QUICK:
+			outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
+				   SMBHSTADD);
+			xact = I801_QUICK;
+			break;
+		case I2C_SMBUS_BYTE:
+			outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
+				   SMBHSTADD);
+			if (read_write == I2C_SMBUS_WRITE)
+				outb_p(command, SMBHSTCMD);
+			xact = I801_BYTE;
+			break;
+		case I2C_SMBUS_BYTE_DATA:
+			outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
+				   SMBHSTADD);
 			outb_p(command, SMBHSTCMD);
-		xact = I801_BYTE;
-		break;
-	case I2C_SMBUS_BYTE_DATA:
-		outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
-		       SMBHSTADD);
-		outb_p(command, SMBHSTCMD);
-		if (read_write == I2C_SMBUS_WRITE)
-			outb_p(data->byte, SMBHSTDAT0);
-		xact = I801_BYTE_DATA;
-		break;
-	case I2C_SMBUS_WORD_DATA:
-		outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
-		       SMBHSTADD);
-		outb_p(command, SMBHSTCMD);
-		if (read_write == I2C_SMBUS_WRITE) {
-			outb_p(data->word & 0xff, SMBHSTDAT0);
-			outb_p((data->word & 0xff00) >> 8, SMBHSTDAT1);
-		}
-		xact = I801_WORD_DATA;
-		break;
-	case I2C_SMBUS_BLOCK_DATA:
-		outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
-		       SMBHSTADD);
-		outb_p(command, SMBHSTCMD);
-		block = 1;
-		break;
-	case I2C_SMBUS_I2C_BLOCK_DATA:
-		/* NB: page 240 of ICH5 datasheet shows that the R/#W
-		 * bit should be cleared here, even when reading */
-		outb_p((addr & 0x7f) << 1, SMBHSTADD);
-		if (read_write == I2C_SMBUS_READ) {
-			/* NB: page 240 of ICH5 datasheet also shows
-			 * that DATA1 is the cmd field when reading */
-			outb_p(command, SMBHSTDAT1);
-		} else
+			if (read_write == I2C_SMBUS_WRITE)
+				outb_p(data->byte, SMBHSTDAT0);
+			xact = I801_BYTE_DATA;
+			break;
+		case I2C_SMBUS_WORD_DATA:
+			outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
+				   SMBHSTADD);
 			outb_p(command, SMBHSTCMD);
-		block = 1;
-		break;
-	default:
-		dev_err(&I801_dev->dev, "Unsupported transaction %d\n", size);
-		return -EOPNOTSUPP;
-	}
-
-	if (hwpec)	/* enable/disable hardware PEC */
-		outb_p(inb_p(SMBAUXCTL) | SMBAUXCTL_CRC, SMBAUXCTL);
-	else
-		outb_p(inb_p(SMBAUXCTL) & (~SMBAUXCTL_CRC), SMBAUXCTL);
-
-	if(block)
-		ret = i801_block_transaction(data, read_write, size, hwpec);
-	else
-		ret = i801_transaction(xact | ENABLE_INT9);
-
-	/* Some BIOSes don't like it when PEC is enabled at reboot or resume
-	   time, so we forcibly disable it after every transaction. Turn off
-	   E32B for the same reason. */
-	if (hwpec || block)
-		outb_p(inb_p(SMBAUXCTL) & ~(SMBAUXCTL_CRC | SMBAUXCTL_E32B),
-		       SMBAUXCTL);
+			if (read_write == I2C_SMBUS_WRITE) {
+				outb_p(data->word & 0xff, SMBHSTDAT0);
+				outb_p((data->word & 0xff00) >> 8, SMBHSTDAT1);
+			}
+			xact = I801_WORD_DATA;
+			break;
+		case I2C_SMBUS_BLOCK_DATA:
+			outb_p(((addr & 0x7f) << 1) | (read_write & 0x01),
+				   SMBHSTADD);
+			outb_p(command, SMBHSTCMD);
+			block = 1;
+			break;
+		case I2C_SMBUS_I2C_BLOCK_DATA:
+			/* NB: page 240 of ICH5 datasheet shows that the R/#W
+			 * bit should be cleared here, even when reading */
+			outb_p((addr & 0x7f) << 1, SMBHSTADD);
+			if (read_write == I2C_SMBUS_READ) {
+				/* NB: page 240 of ICH5 datasheet also shows
+				 * that DATA1 is the cmd field when reading */
+				outb_p(command, SMBHSTDAT1);
+			} else
+				outb_p(command, SMBHSTCMD);
+			block = 1;
+			break;
+		default:
+			dev_err(&I801_dev->dev, "Unsupported transaction %d\n", size);
+			return -EOPNOTSUPP;
+		}
+		
+		if (hwpec)	/* enable/disable hardware PEC */
+			outb_p(inb_p(SMBAUXCTL) | SMBAUXCTL_CRC, SMBAUXCTL);
+		else
+			outb_p(inb_p(SMBAUXCTL) & (~SMBAUXCTL_CRC), SMBAUXCTL);
+		
+		if(block)
+			ret = i801_block_transaction(data, read_write, size, hwpec);
+		else
+			ret = i801_transaction(xact | ENABLE_INT9);
+		
+		/* Some BIOSes don't like it when PEC is enabled at reboot or resume
+		   time, so we forcibly disable it after every transaction. Turn off
+		   E32B for the same reason. */
+		if (hwpec || block)
+			outb_p(inb_p(SMBAUXCTL) & ~(SMBAUXCTL_CRC | SMBAUXCTL_E32B),
+				   SMBAUXCTL);
+
+		if (ret == -EAGAIN) {
+			dev_dbg(&I801_dev->dev, "Restarting transaction (probably due to lost arbitration)");
+			continue;
+		}
+		
+		if(block)
+			return ret;
+		if(ret)
+			return ret;
+		if ((read_write == I2C_SMBUS_WRITE) || (xact == I801_QUICK))
+			return 0;
+
+		switch (xact & 0x7f) {
+		case I801_BYTE:	/* Result put in SMBHSTDAT0 */
+		case I801_BYTE_DATA:
+			data->byte = inb_p(SMBHSTDAT0);
+			break;
+		case I801_WORD_DATA:
+			data->word = inb_p(SMBHSTDAT0) + (inb_p(SMBHSTDAT1) << 8);
+			break;
+		}
 
-	if(block)
-		return ret;
-	if(ret)
-		return ret;
-	if ((read_write == I2C_SMBUS_WRITE) || (xact == I801_QUICK))
 		return 0;
-
-	switch (xact & 0x7f) {
-	case I801_BYTE:	/* Result put in SMBHSTDAT0 */
-	case I801_BYTE_DATA:
-		data->byte = inb_p(SMBHSTDAT0);
-		break;
-	case I801_WORD_DATA:
-		data->word = inb_p(SMBHSTDAT0) + (inb_p(SMBHSTDAT1) << 8);
-		break;
 	}
-	return 0;
+
+	ret = -EREMOTEIO;
+	return ret;
 }
 
 
