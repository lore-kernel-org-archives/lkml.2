Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab0FVOKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:10:22 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45647 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175Ab0FVOKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:10:20 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2] i2c/mips: Fix error return codes from Sibyte i2c bus driver
Date: Tue, 22 Jun 2010 07:09:08 -0700
Message-ID: <1277215748-31510-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sibyte i2c bus driver returns non-descriptive error values.
Update to return error values as defined in Documentation/i2c/fault-codes.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
v2: Return -ENXIO for missing ACK and -EIO for other errors
---
 drivers/i2c/busses/i2c-sibyte.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-sibyte.c b/drivers/i2c/busses/i2c-sibyte.c
index 3d76a18..0fe505d 100644
--- a/drivers/i2c/busses/i2c-sibyte.c
+++ b/drivers/i2c/busses/i2c-sibyte.c
@@ -94,7 +94,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
 		}
 		break;
 	default:
-		return -1;      /* XXXKW better error code? */
+		return -EOPNOTSUPP;
 	}
 
 	while (csr_in32(SMB_CSR(adap, R_SMB_STATUS)) & M_SMB_BUSY)
@@ -104,7 +104,7 @@ static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
 	if (error & M_SMB_ERROR) {
 		/* Clear error bit by writing a 1 */
 		csr_out32(M_SMB_ERROR, SMB_CSR(adap, R_SMB_STATUS));
-		return -1;      /* XXXKW better error code? */
+		return (error & M_SMB_ERROR_TYPE) ? -EIO : -ENXIO;
 	}
 
 	if (data_bytes == 1)
-- 
1.7.0.87.g0901d

