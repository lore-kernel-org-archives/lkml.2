Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab0I3U1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:27:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55383 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405Ab0I3U1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:27:06 -0400
Date: Thu, 30 Sep 2010 22:27:02 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Ben Dooks (em, bedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/8] drivers/i2c/busses/i2c-amd8111.c: Fix unsigned return
   type
In-Reply-To: <Pine.LNX.4.64.1009292147060.25609@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1009302226270.10470@ask.diku.dk>
References: <Pine.LNX.4.64.1009080757050.27892@ask.diku.dk>
 <20100908093449.0adef429@hyperion.delvare> <Pine.LNX.4.64.1009081148040.3297@ask.diku.dk>
 <20100929174606.616e564c@endymion.delvare> <Pine.LNX.4.64.1009292147060.25609@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions the functions amd_ec_wait_write and amd_ec_wait_read have an
unsigned return type, but return a negative constant to indicate an error
condition.

A sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
identifier f;
constant C;
@@

 unsigned f(...)
 { <+...
*  return -C;
 ...+> }
// </smpl>

Fixing amd_ec_wait_write and amd_ec_wait_read leads to the need to adjust
the return type of the functions amd_ec_write and amd_ec_read, which are
the only functions that call amd_ec_wait_write and amd_ec_wait_read.
amd_ec_write and amd_ec_read, in turn, are only called from within the
function amd8111_access, which already returns a signed typed value.  Each
of the calls to amd_ec_write and amd_ec_read are updated using the
following semantic patch:

// <smpl>
@@
@@

+ status = amd_ec_write
- amd_ec_write
  (...);
+ if (status) return status;

@@
@@

+ status = amd_ec_read
- amd_ec_read
  (...);
+ if (status) return status;
// </smpl>

The patch also adds the declaration of the status variable.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Only compile tested.

 drivers/i2c/busses/i2c-amd8111.c    |  152 ++++++++++++++------
 1 files changed, 110 insertions(+), 42 deletions(-)

diff --git a/drivers/i2c/busses/i2c-amd8111.c b/drivers/i2c/busses/i2c-amd8111.c
index af1e5e2..e12c584 100644
--- a/drivers/i2c/busses/i2c-amd8111.c
+++ b/drivers/i2c/busses/i2c-amd8111.c
@@ -69,7 +69,7 @@ static struct pci_driver amd8111_driver;
  * ACPI 2.0 chapter 13 access of registers of the EC
  */
 
-static unsigned int amd_ec_wait_write(struct amd_smbus *smbus)
+static int amd_ec_wait_write(struct amd_smbus *smbus)
 {
 	int timeout = 500;
 
@@ -85,7 +85,7 @@ static unsigned int amd_ec_wait_write(struct amd_smbus *smbus)
 	return 0;
 }
 
-static unsigned int amd_ec_wait_read(struct amd_smbus *smbus)
+static int amd_ec_wait_read(struct amd_smbus *smbus)
 {
 	int timeout = 500;
 
@@ -101,7 +101,7 @@ static unsigned int amd_ec_wait_read(struct amd_smbus *smbus)
 	return 0;
 }
 
-static unsigned int amd_ec_read(struct amd_smbus *smbus, unsigned char address,
+static int amd_ec_read(struct amd_smbus *smbus, unsigned char address,
 		unsigned char *data)
 {
 	int status;
@@ -124,7 +124,7 @@ static unsigned int amd_ec_read(struct amd_smbus *smbus, unsigned char address,
 	return 0;
 }
 
-static unsigned int amd_ec_write(struct amd_smbus *smbus, unsigned char address,
+static int amd_ec_write(struct amd_smbus *smbus, unsigned char address,
 		unsigned char data)
 {
 	int status;
@@ -196,7 +196,7 @@ static s32 amd8111_access(struct i2c_adapter * adap, u16 addr,
 {
 	struct amd_smbus *smbus = adap->algo_data;
 	unsigned char protocol, len, pec, temp[2];
-	int i;
+	int i, status;
 
 	protocol = (read_write == I2C_SMBUS_READ) ? AMD_SMB_PRTCL_READ
 						  : AMD_SMB_PRTCL_WRITE;
@@ -209,38 +209,62 @@ static s32 amd8111_access(struct i2c_adapter * adap, u16 addr,
 			break;
 
 		case I2C_SMBUS_BYTE:
-			if (read_write == I2C_SMBUS_WRITE)
-				amd_ec_write(smbus, AMD_SMB_CMD, command);
+			if (read_write == I2C_SMBUS_WRITE) {
+				status = amd_ec_write(smbus, AMD_SMB_CMD,
+							command);
+				if (status)
+					return status;
+			}
 			protocol |= AMD_SMB_PRTCL_BYTE;
 			break;
 
 		case I2C_SMBUS_BYTE_DATA:
-			amd_ec_write(smbus, AMD_SMB_CMD, command);
-			if (read_write == I2C_SMBUS_WRITE)
-				amd_ec_write(smbus, AMD_SMB_DATA, data->byte);
+			status = amd_ec_write(smbus, AMD_SMB_CMD, command);
+			if (status)
+				return status;
+			if (read_write == I2C_SMBUS_WRITE) {
+				status = amd_ec_write(smbus, AMD_SMB_DATA,
+							data->byte);
+				if (status)
+					return status;
+			}
 			protocol |= AMD_SMB_PRTCL_BYTE_DATA;
 			break;
 
 		case I2C_SMBUS_WORD_DATA:
-			amd_ec_write(smbus, AMD_SMB_CMD, command);
+			status = amd_ec_write(smbus, AMD_SMB_CMD, command);
+			if (status)
+				return status;
 			if (read_write == I2C_SMBUS_WRITE) {
-				amd_ec_write(smbus, AMD_SMB_DATA,
+				status = amd_ec_write(smbus, AMD_SMB_DATA,
 					     data->word & 0xff);
-				amd_ec_write(smbus, AMD_SMB_DATA + 1,
+				if (status)
+					return status;
+				status = amd_ec_write(smbus, AMD_SMB_DATA + 1,
 					     data->word >> 8);
+				if (status)
+					return status;
 			}
 			protocol |= AMD_SMB_PRTCL_WORD_DATA | pec;
 			break;
 
 		case I2C_SMBUS_BLOCK_DATA:
-			amd_ec_write(smbus, AMD_SMB_CMD, command);
+			status = amd_ec_write(smbus, AMD_SMB_CMD, command);
+			if (status)
+				return status;
 			if (read_write == I2C_SMBUS_WRITE) {
 				len = min_t(u8, data->block[0],
 					    I2C_SMBUS_BLOCK_MAX);
-				amd_ec_write(smbus, AMD_SMB_BCNT, len);
-				for (i = 0; i < len; i++)
-					amd_ec_write(smbus, AMD_SMB_DATA + i,
-						     data->block[i + 1]);
+				status = amd_ec_write(smbus, AMD_SMB_BCNT, len);
+				if (status)
+					return status;
+				for (i = 0; i < len; i++) {
+					status =
+					  amd_ec_write(smbus, AMD_SMB_DATA + i,
+						       data->block[i + 1]);
+					if (status)
+						return status;
+				}
 			}
 			protocol |= AMD_SMB_PRTCL_BLOCK_DATA | pec;
 			break;
@@ -248,19 +272,35 @@ static s32 amd8111_access(struct i2c_adapter * adap, u16 addr,
 		case I2C_SMBUS_I2C_BLOCK_DATA:
 			len = min_t(u8, data->block[0],
 				    I2C_SMBUS_BLOCK_MAX);
-			amd_ec_write(smbus, AMD_SMB_CMD, command);
-			amd_ec_write(smbus, AMD_SMB_BCNT, len);
+			status = amd_ec_write(smbus, AMD_SMB_CMD, command);
+			if (status)
+				return status;
+			status = amd_ec_write(smbus, AMD_SMB_BCNT, len);
+			if (status)
+				return status;
 			if (read_write == I2C_SMBUS_WRITE)
-				for (i = 0; i < len; i++)
-					amd_ec_write(smbus, AMD_SMB_DATA + i,
-						     data->block[i + 1]);
+				for (i = 0; i < len; i++) {
+					status =
+					  amd_ec_write(smbus, AMD_SMB_DATA + i,
+						       data->block[i + 1]);
+					if (status)
+						return status;
+				}
 			protocol |= AMD_SMB_PRTCL_I2C_BLOCK_DATA;
 			break;
 
 		case I2C_SMBUS_PROC_CALL:
-			amd_ec_write(smbus, AMD_SMB_CMD, command);
-			amd_ec_write(smbus, AMD_SMB_DATA, data->word & 0xff);
-			amd_ec_write(smbus, AMD_SMB_DATA + 1, data->word >> 8);
+			status = amd_ec_write(smbus, AMD_SMB_CMD, command);
+			if (status)
+				return status;
+			status = amd_ec_write(smbus, AMD_SMB_DATA,
+						data->word & 0xff);
+			if (status)
+				return status;
+			status = amd_ec_write(smbus, AMD_SMB_DATA + 1,
+						data->word >> 8);
+			if (status)
+				return status;
 			protocol = AMD_SMB_PRTCL_PROC_CALL | pec;
 			read_write = I2C_SMBUS_READ;
 			break;
@@ -268,11 +308,18 @@ static s32 amd8111_access(struct i2c_adapter * adap, u16 addr,
 		case I2C_SMBUS_BLOCK_PROC_CALL:
 			len = min_t(u8, data->block[0],
 				    I2C_SMBUS_BLOCK_MAX - 1);
-			amd_ec_write(smbus, AMD_SMB_CMD, command);
-			amd_ec_write(smbus, AMD_SMB_BCNT, len);
-			for (i = 0; i < len; i++)
-				amd_ec_write(smbus, AMD_SMB_DATA + i,
+			status = amd_ec_write(smbus, AMD_SMB_CMD, command);
+			if (status)
+				return status;
+			status = amd_ec_write(smbus, AMD_SMB_BCNT, len);
+			if (status)
+				return status;
+			for (i = 0; i < len; i++) {
+				status = amd_ec_write(smbus, AMD_SMB_DATA + i,
 					     data->block[i + 1]);
+				if (status)
+					return status;
+			}
 			protocol = AMD_SMB_PRTCL_BLOCK_PROC_CALL | pec;
 			read_write = I2C_SMBUS_READ;
 			break;
@@ -282,24 +329,34 @@ static s32 amd8111_access(struct i2c_adapter * adap, u16 addr,
 			return -EOPNOTSUPP;
 	}
 
-	amd_ec_write(smbus, AMD_SMB_ADDR, addr << 1);
-	amd_ec_write(smbus, AMD_SMB_PRTCL, protocol);
+	status = amd_ec_write(smbus, AMD_SMB_ADDR, addr << 1);
+	if (status)
+		return status;
+	status = amd_ec_write(smbus, AMD_SMB_PRTCL, protocol);
+	if (status)
+		return status;
 
 	/* FIXME this discards status from ec_read(); so temp[0] will
 	 * hold stack garbage ... the rest of this routine will act
 	 * nonsensically.  Ignored ec_write() status might explain
 	 * some such failures...
 	 */
-	amd_ec_read(smbus, AMD_SMB_STS, temp + 0);
+	status = amd_ec_read(smbus, AMD_SMB_STS, temp + 0);
+	if (status)
+		return status;
 
 	if (~temp[0] & AMD_SMB_STS_DONE) {
 		udelay(500);
-		amd_ec_read(smbus, AMD_SMB_STS, temp + 0);
+		status = amd_ec_read(smbus, AMD_SMB_STS, temp + 0);
+		if (status)
+			return status;
 	}
 
 	if (~temp[0] & AMD_SMB_STS_DONE) {
 		msleep(1);
-		amd_ec_read(smbus, AMD_SMB_STS, temp + 0);
+		status = amd_ec_read(smbus, AMD_SMB_STS, temp + 0);
+		if (status)
+			return status;
 	}
 
 	if ((~temp[0] & AMD_SMB_STS_DONE) || (temp[0] & AMD_SMB_STS_STATUS))
@@ -311,24 +368,35 @@ static s32 amd8111_access(struct i2c_adapter * adap, u16 addr,
 	switch (size) {
 		case I2C_SMBUS_BYTE:
 		case I2C_SMBUS_BYTE_DATA:
-			amd_ec_read(smbus, AMD_SMB_DATA, &data->byte);
+			status = amd_ec_read(smbus, AMD_SMB_DATA, &data->byte);
+			if (status)
+				return status;
 			break;
 
 		case I2C_SMBUS_WORD_DATA:
 		case I2C_SMBUS_PROC_CALL:
-			amd_ec_read(smbus, AMD_SMB_DATA, temp + 0);
-			amd_ec_read(smbus, AMD_SMB_DATA + 1, temp + 1);
+			status = amd_ec_read(smbus, AMD_SMB_DATA, temp + 0);
+			if (status)
+				return status;
+			status = amd_ec_read(smbus, AMD_SMB_DATA + 1, temp + 1);
+			if (status)
+				return status;
 			data->word = (temp[1] << 8) | temp[0];
 			break;
 
 		case I2C_SMBUS_BLOCK_DATA:
 		case I2C_SMBUS_BLOCK_PROC_CALL:
-			amd_ec_read(smbus, AMD_SMB_BCNT, &len);
+			status = amd_ec_read(smbus, AMD_SMB_BCNT, &len);
+			if (status)
+				return status;
 			len = min_t(u8, len, I2C_SMBUS_BLOCK_MAX);
 		case I2C_SMBUS_I2C_BLOCK_DATA:
-			for (i = 0; i < len; i++)
-				amd_ec_read(smbus, AMD_SMB_DATA + i,
-					    data->block + i + 1);
+			for (i = 0; i < len; i++) {
+				status = amd_ec_read(smbus, AMD_SMB_DATA + i,
+							data->block + i + 1);
+				if (status)
+					return status;
+			}
 			data->block[0] = len;
 			break;
 	}
