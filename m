Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0DNDBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:01:38 -0400
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:51607 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab0DNDBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:01:37 -0400
X-MXL-Hash: 4bc530111d877e0e-139d979da1e02a9e8fbd7cf48cef36dce8caea25
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Greg KH <greg@kroah.com>, "ss@aao.gov.au" <ss@aao.gov.au>
Date: Tue, 13 Apr 2010 22:01:31 -0500
Subject: [PATCH] staging/dt3155: fix wait_ibsyclr function
Thread-Topic: [PATCH] staging/dt3155: fix wait_ibsyclr function
Thread-Index: AcrbfskJ1LWv7JbdTr+cH3EmIZF2xQ==
Message-ID: <0D753D10438DA54287A00B0270842697636D5B78D9@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010040801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=UWhJqbO6U5wA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=i00gxMtYAAAA:8 a=_oV]
X-AnalysisOut: [-_3fp0TDCNF5Le3wA:9 a=Ufmv2ZJQeAL5YEMgOq8A:7 a=qGPOOK7qc_o]
X-AnalysisOut: [pPD0BuVJ4HPad-_0A:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=]
X-AnalysisOut: [0kPLrQdw3YYA:10 a=GVOgsflweOz2VKJA:21 a=aTlMbw_eP2Bdzplk:2]
X-AnalysisOut: [1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3E31mmE010050

The wait_ibsyclr function is supposed to return the status of the I2C
cycle.  Currently it will always return FALSE because the IIC_CSR2
register is not re-read in order to update the cached register value.
This results in the NEW_CYCLE bit still being 1.

The current code actually works correctly only because the return
value of {Read|Write}I2C is not checked in the driver.

Fix wait_ibsyclr by actually reading the IIC_CSR2 register to get the
updated status.  While here, change the return type to be an actual
errno instead of the private TRUE/FALSE define and remove the now
obvious comments about the return value.

Also, remove the local variable 'writestat' in WriteI2C and just
return the result of wait_ibsyclr.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_io.c b/drivers/staging/dt3155/dt3155_io.c
index 6b9c685..7792e71 100644
--- a/drivers/staging/dt3155/dt3155_io.c
+++ b/drivers/staging/dt3155/dt3155_io.c
@@ -74,23 +74,22 @@ u8 i2c_pm_lut_data;
  * wait_ibsyclr()
  *
  * This function handles read/write timing and r/w timeout error
- *
- * Returns TRUE  if NEW_CYCLE clears
- * Returns FALSE if NEW_CYCLE doesn't clear in roughly 3 msecs, otherwise
- * returns 0
  */
 static int wait_ibsyclr(u8 *lpReg)
 {
 	/* wait 100 microseconds */
 	udelay(100L);
 	/* __delay(loops_per_sec/10000); */
+
+	ReadMReg(lpReg + IIC_CSR2, iic_csr2_r.reg);
 	if (iic_csr2_r.fld.NEW_CYCLE) {
 		/* if NEW_CYCLE didn't clear */
 		/* TIMEOUT ERROR */
 		dt3155_errno = DT_ERR_I2C_TIMEOUT;
-		return FALSE;
-	} else
-		return TRUE;	/* no error */
+		return -ETIMEDOUT;
+	}
+
+	return 0;	/* no error */
 }
 
 /*
@@ -101,14 +100,9 @@ static int wait_ibsyclr(u8 *lpReg)
  * 1st parameter is pointer to 32-bit register base address
  * 2nd parameter is reg. index;
  * 3rd is value to be written
- *
- * Returns TRUE   -  Successful completion
- *         FALSE  -  Timeout error - cycle did not complete!
  */
 int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
 {
-	int writestat;	/* status for return */
-
 	/* read 32 bit IIC_CSR2 register data into union */
 
 	ReadMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
@@ -126,8 +120,7 @@ int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
 	WriteMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
 
 	/* wait for IIC cycle to finish */
-	writestat = wait_ibsyclr(lpReg);
-	return writestat;
+	return wait_ibsyclr(lpReg);
 }
 
 /*
@@ -138,9 +131,6 @@ int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
  * 1st parameter is pointer to 32-bit register base address
  * 2nd parameter is reg. index;
  * 3rd is adrs of value to be read
- *
- * Returns TRUE   -  Successful completion
- *         FALSE  -  Timeout error - cycle did not complete!
  */
 int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal)
 {
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
