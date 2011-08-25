Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1HYGRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:17:05 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:36811 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752532Ab1HYGRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:17:00 -0400
From: Joe Perches <joe@perches.com>
To: Henry Ptasinski <henryp@broadcom.com>, linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Arend Van Spriel <arend@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        devel@linuxdriverproject.org, Greg KH <gregkh@suse.de>,
        Kan Yan <kanyan@broadcom.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: brcmfmac: Consolidate debugging macros
Date: Wed, 24 Aug 2011 23:16:48 -0700
Message-Id: <927eab8b5c950c13991911cd4c16457a5d618bc7.1314252671.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert multiple BRCMF_<debug_level> macros to a single
brcmf_dbg(level, fmt, ...) macro.

Remove the now unnecessary double parentheses in the uses
of the old macros when converting to brcmf_dbg.

Delete all uses of "%s: [fmt]", __func__, args... and move
the "%s: ", __func__ to the macro for consistency.

Coalesce long formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   46 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  163 ++---
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |   66 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |  228 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h      |   46 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |  201 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  806 +++++++++------------
 7 files changed, 694 insertions(+), 862 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 0c845c9..8448b8b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -86,8 +86,7 @@ brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 	if (!set && !(arg && len))
 		return -EINVAL;
 
-	BRCMF_TRACE(("%s: Enter (%s %s)\n", __func__, (set ? "set" : "get"),
-		  name));
+	brcmf_dbg(TRACE, "Enter (%s %s)\n", set ? "set" : "get", name);
 
 	vi = brcmu_iovar_lookup(sdioh_iovars, name);
 	if (vi == NULL) {
@@ -168,7 +167,7 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 {
 	struct brcmf_sdio_dev *sdiodev = dev_get_drvdata(&func->card->dev);
 
-	BRCMF_TRACE(("brcmf: ***IRQHandler\n"));
+	brcmf_dbg(TRACE, "***IRQHandler\n");
 
 	sdio_release_host(func);
 
@@ -179,7 +178,7 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
 {
-	BRCMF_TRACE(("%s: Entering\n", __func__));
+	brcmf_dbg(TRACE, "Entering\n");
 
 	sdio_claim_host(sdiodev->func[1]);
 	sdio_claim_irq(sdiodev->func[1], brcmf_sdioh_irqhandler);
@@ -190,7 +189,7 @@ int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
 
 int brcmf_sdcard_intr_dereg(struct brcmf_sdio_dev *sdiodev)
 {
-	BRCMF_TRACE(("%s: Entering\n", __func__));
+	brcmf_dbg(TRACE, "Entering\n");
 
 	sdio_claim_host(sdiodev->func[1]);
 	sdio_release_irq(sdiodev->func[1]);
@@ -216,8 +215,8 @@ u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 	if (err)
 		*err = status;
 
-	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
-		     __func__, fnc_num, addr, data));
+	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, u8data = 0x%x\n",
+		  fnc_num, addr, data);
 
 	return data;
 }
@@ -239,8 +238,8 @@ brcmf_sdcard_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 	if (err)
 		*err = status;
 
-	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
-		     __func__, fnc_num, addr, data));
+	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, u8data = 0x%x\n",
+		  fnc_num, addr, data);
 }
 
 int brcmf_sdcard_cis_read(struct brcmf_sdio_dev *sdiodev, uint func, u8 * cis,
@@ -260,7 +259,7 @@ int brcmf_sdcard_cis_read(struct brcmf_sdio_dev *sdiodev, uint func, u8 * cis,
 			 into the provided buffer. */
 		tmp_buf = kmalloc(length, GFP_ATOMIC);
 		if (tmp_buf == NULL) {
-			BRCMF_ERROR(("%s: out of memory\n", __func__));
+			brcmf_dbg(ERROR, "out of memory\n");
 			return -ENOMEM;
 		}
 		memcpy(tmp_buf, cis, length);
@@ -302,7 +301,7 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size)
 	u32 word = 0;
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 
-	BRCMF_INFO(("%s:fun = 1, addr = 0x%x, ", __func__, addr));
+	brcmf_dbg(INFO, "fun = 1, addr = 0x%x\n", addr);
 
 	if (bar0 != sdiodev->sbwad) {
 		if (brcmf_sdcard_set_sbaddr_window(sdiodev, bar0))
@@ -320,7 +319,7 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size)
 
 	sdiodev->regfail = (status != 0);
 
-	BRCMF_INFO(("u32data = 0x%x\n", word));
+	brcmf_dbg(INFO, "u32data = 0x%x\n", word);
 
 	/* if ok, return appropriately masked word */
 	if (status == 0) {
@@ -338,8 +337,7 @@ u32 brcmf_sdcard_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size)
 	}
 
 	/* otherwise, bad sdio access or invalid size */
-	BRCMF_ERROR(("%s: error reading addr 0x%04x size %d\n", __func__,
-		      addr, size));
+	brcmf_dbg(ERROR, "error reading addr 0x%04x size %d\n", addr, size);
 	return 0xFFFFFFFF;
 }
 
@@ -350,8 +348,8 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	BRCMF_INFO(("%s:fun = 1, addr = 0x%x, uint%ddata = 0x%x\n",
-		     __func__, addr, size * 8, data));
+	brcmf_dbg(INFO, "fun = 1, addr = 0x%x, uint%ddata = 0x%x\n",
+		  addr, size * 8, data);
 
 	if (bar0 != sdiodev->sbwad) {
 		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
@@ -372,8 +370,8 @@ u32 brcmf_sdcard_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr, uint size,
 	if (status == 0)
 		return 0;
 
-	BRCMF_ERROR(("%s: error writing 0x%08x to addr 0x%04x size %d\n",
-		      __func__, data, addr, size));
+	brcmf_dbg(ERROR, "error writing 0x%08x to addr 0x%04x size %d\n",
+		  data, addr, size);
 	return 0xFFFFFFFF;
 }
 
@@ -393,8 +391,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
-		     __func__, fn, addr, nbytes));
+	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n", fn, addr, nbytes);
 
 	/* Async not implemented yet */
 	if (flags & SDIO_REQ_ASYNC)
@@ -430,8 +427,7 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	BRCMF_INFO(("%s:fun = %d, addr = 0x%x, size = %d\n",
-		     __func__, fn, addr, nbytes));
+	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n", fn, addr, nbytes);
 
 	/* Async not implemented yet */
 	if (flags & SDIO_REQ_ASYNC)
@@ -470,13 +466,13 @@ int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 {
 	char t_func = (char)fn;
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* issue abort cmd52 command through F0 */
 	brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
 				 SDIO_CCCR_ABORT, &t_func);
 
-	BRCMF_TRACE(("%s: Exit\n", __func__));
+	brcmf_dbg(TRACE, "Exit\n");
 	return 0;
 }
 
@@ -502,7 +498,7 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	/* try to attach to the target device */
 	sdiodev->bus = brcmf_sdbrcm_probe(0, 0, 0, 0, regs, sdiodev);
 	if (!sdiodev->bus) {
-		BRCMF_ERROR(("%s: device attach failed\n", __func__));
+		brcmf_dbg(ERROR, "device attach failed\n");
 		ret = -ENODEV;
 		goto out;
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index fca966c..0b92cef 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -111,21 +111,21 @@ static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 	u32 fbraddr;
 	u8 func;
 
-	BRCMF_TRACE(("%s\n", __func__));
+	brcmf_dbg(TRACE, "\n");
 
 	/* Get the Card's common CIS address */
 	sdiodev->func_cis_ptr[0] = brcmf_sdioh_get_cisaddr(sdiodev,
 							   SDIO_CCCR_CIS);
-	BRCMF_INFO(("%s: Card's Common CIS Ptr = 0x%x\n", __func__,
-		 sdiodev->func_cis_ptr[0]));
+	brcmf_dbg(INFO, "Card's Common CIS Ptr = 0x%x\n",
+		  sdiodev->func_cis_ptr[0]);
 
 	/* Get the Card's function CIS (for each function) */
 	for (fbraddr = SDIO_FBR_BASE(1), func = 1;
 	     func <= sdiodev->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
 		sdiodev->func_cis_ptr[func] =
 		    brcmf_sdioh_get_cisaddr(sdiodev, SDIO_FBR_CIS + fbraddr);
-		BRCMF_INFO(("%s: Function %d CIS Ptr = 0x%x\n", __func__, func,
-			 sdiodev->func_cis_ptr[func]));
+		brcmf_dbg(INFO, "Function %d CIS Ptr = 0x%x\n",
+			  func, sdiodev->func_cis_ptr[func]);
 	}
 
 	/* Enable Function 1 */
@@ -133,8 +133,7 @@ static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 	err_ret = sdio_enable_func(sdiodev->func[1]);
 	sdio_release_host(sdiodev->func[1]);
 	if (err_ret)
-		BRCMF_ERROR(("brcmf_sdioh_enablefuncs: Failed to enable F1 "
-			"Err: 0x%08x\n", err_ret));
+		brcmf_dbg(ERROR, "Failed to enable F1 Err: 0x%08x\n", err_ret);
 
 	return false;
 }
@@ -146,7 +145,7 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 {
 	int err_ret = 0;
 
-	BRCMF_TRACE(("%s\n", __func__));
+	brcmf_dbg(TRACE, "\n");
 
 	sdiodev->num_funcs = 2;
 
@@ -154,7 +153,7 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 	err_ret = sdio_set_block_size(sdiodev->func[1], 64);
 	sdio_release_host(sdiodev->func[1]);
 	if (err_ret) {
-		BRCMF_ERROR(("%s: Failed to set F1 blocksize\n", __func__));
+		brcmf_dbg(ERROR, "Failed to set F1 blocksize\n");
 		goto out;
 	}
 
@@ -162,21 +161,21 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 	err_ret = sdio_set_block_size(sdiodev->func[2], sd_f2_blocksize);
 	sdio_release_host(sdiodev->func[2]);
 	if (err_ret) {
-		BRCMF_ERROR(("%s: Failed to set F2 blocksize"
-			" to %d\n", __func__, sd_f2_blocksize));
+		brcmf_dbg(ERROR, "Failed to set F2 blocksize to %d\n",
+			  sd_f2_blocksize);
 		goto out;
 	}
 
 	brcmf_sdioh_enablefuncs(sdiodev);
 
 out:
-	BRCMF_TRACE(("%s: Done\n", __func__));
+	brcmf_dbg(TRACE, "Done\n");
 	return err_ret;
 }
 
 void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 {
-	BRCMF_TRACE(("%s\n", __func__));
+	brcmf_dbg(TRACE, "\n");
 
 	/* Disable Function 2 */
 	sdio_claim_host(sdiodev->func[2]);
@@ -199,7 +198,7 @@ static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 	for (i = 0; i < 3; i++) {
 		if ((brcmf_sdioh_card_regread(sdiodev, 0, regaddr, 1,
 				&regdata)) != SUCCESS)
-			BRCMF_ERROR(("%s: Can't read!\n", __func__));
+			brcmf_dbg(ERROR, "Can't read!\n");
 
 		*ptr++ = (u8) regdata;
 		regaddr++;
@@ -220,22 +219,21 @@ brcmf_sdioh_cis_read(struct brcmf_sdio_dev *sdiodev, uint func,
 	u32 foo;
 	u8 *cis = cisd;
 
-	BRCMF_TRACE(("%s: Func = %d\n", __func__, func));
+	brcmf_dbg(TRACE, "Func = %d\n", func);
 
 	if (!sdiodev->func_cis_ptr[func]) {
 		memset(cis, 0, length);
-		BRCMF_ERROR(("%s: no func_cis_ptr[%d]\n", __func__, func));
+		brcmf_dbg(ERROR, "no func_cis_ptr[%d]\n", func);
 		return -ENOTSUPP;
 	}
 
-	BRCMF_ERROR(("%s: func_cis_ptr[%d]=0x%04x\n", __func__, func,
-		sdiodev->func_cis_ptr[func]));
+	brcmf_dbg(ERROR, "func_cis_ptr[%d]=0x%04x\n",
+		  func, sdiodev->func_cis_ptr[func]);
 
 	for (count = 0; count < length; count++) {
 		offset = sdiodev->func_cis_ptr[func] + count;
 		if (brcmf_sdioh_card_regread(sdiodev, 0, offset, 1, &foo) < 0) {
-			BRCMF_ERROR(("%s: regread failed: Can't read CIS\n",
-				__func__));
+			brcmf_dbg(ERROR, "regread failed: Can't read CIS\n");
 			return -EIO;
 		}
 
@@ -252,8 +250,7 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 {
 	int err_ret;
 
-	BRCMF_INFO(("%s: rw=%d, func=%d, addr=0x%05x\n", __func__, rw, func,
-		 regaddr));
+	brcmf_dbg(INFO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait, sdiodev);
 	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
@@ -272,22 +269,18 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 						    sdio_enable_func
 						    (sdiodev->func[2]);
 						if (err_ret)
-							BRCMF_ERROR((
-								"request_byte: "
-								"enable F2 "
-								"failed:%d\n",
-								 err_ret));
+							brcmf_dbg(ERROR,
+								  "enable F2 failed:%d\n",
+								  err_ret);
 					} else {
 						/* Disable Function 2 */
 						err_ret =
 						    sdio_disable_func
 						    (sdiodev->func[2]);
 						if (err_ret)
-							BRCMF_ERROR((
-								"request_byte: "
-								"Disab F2 "
-								"failed:%d\n",
-								 err_ret));
+							brcmf_dbg(ERROR,
+								  "Disable F2 failed:%d\n",
+								  err_ret);
 					}
 					sdio_release_host(sdiodev->func[2]);
 				}
@@ -305,8 +298,8 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 					    regaddr, &err_ret);
 				sdio_release_host(sdiodev->func[func]);
 			} else if (regaddr < 0xF0) {
-				BRCMF_ERROR(("brcmf: F0 Wr:0x%02x: write "
-					"disallowed\n", regaddr));
+				brcmf_dbg(ERROR, "F0 Wr:0x%02x: write disallowed\n",
+					  regaddr);
 			} else {
 				/* Claim host controller, perform F0 write,
 				 and release */
@@ -341,9 +334,8 @@ brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 	}
 
 	if (err_ret)
-		BRCMF_ERROR(("brcmf: Failed to %s byte F%d:@0x%05x=%02x, "
-			"Err: %d\n", rw ? "Write" : "Read", func, regaddr,
-			*byte, err_ret));
+		brcmf_dbg(ERROR, "Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
+			  rw ? "write" : "read", func, regaddr, *byte, err_ret);
 
 	return err_ret;
 }
@@ -355,12 +347,12 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 	int err_ret = -EIO;
 
 	if (func == 0) {
-		BRCMF_ERROR(("%s: Only CMD52 allowed to F0.\n", __func__));
+		brcmf_dbg(ERROR, "Only CMD52 allowed to F0\n");
 		return -EINVAL;
 	}
 
-	BRCMF_INFO(("%s: cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
-		 __func__, cmd_type, rw, func, addr, nbytes));
+	brcmf_dbg(INFO, "cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
+		  cmd_type, rw, func, addr, nbytes);
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait, sdiodev);
 	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
@@ -375,8 +367,7 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 			sdio_writew(sdiodev->func[func], (*word & 0xFFFF),
 				    addr, &err_ret);
 		else
-			BRCMF_ERROR(("%s: Invalid nbytes: %d\n",
-				     __func__, nbytes));
+			brcmf_dbg(ERROR, "Invalid nbytes: %d\n", nbytes);
 	} else {		/* CMD52 Read */
 		if (nbytes == 4)
 			*word =
@@ -386,16 +377,15 @@ brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev, uint cmd_type, uint rw,
 			    sdio_readw(sdiodev->func[func], addr,
 				       &err_ret) & 0xFFFF;
 		else
-			BRCMF_ERROR(("%s: Invalid nbytes: %d\n",
-				     __func__, nbytes));
+			brcmf_dbg(ERROR, "Invalid nbytes: %d\n", nbytes);
 	}
 
 	/* Release host controller */
 	sdio_release_host(sdiodev->func[func]);
 
 	if (err_ret)
-		BRCMF_ERROR(("brcmf: Failed to %s word, Err: 0x%08x\n",
-			rw ? "Write" : "Read", err_ret));
+		brcmf_dbg(ERROR, "Failed to %s word, Err: 0x%08x\n",
+			  rw ? "write" : "read", err_ret);
 
 	return err_ret;
 }
@@ -411,7 +401,7 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 
 	struct sk_buff *pnext;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait, sdiodev);
 	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
@@ -442,15 +432,13 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 		}
 
 		if (err_ret) {
-			BRCMF_ERROR(("%s: %s FAILED %p[%d], addr=0x%05x, "
-				 "pkt_len=%d, ERR=0x%08x\n", __func__,
-				 (write) ? "TX" : "RX",
-				 pnext, SGCount, addr, pkt_len, err_ret));
+			brcmf_dbg(ERROR, "%s FAILED %p[%d], addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
+				  write ? "TX" : "RX", pnext, SGCount, addr,
+				  pkt_len, err_ret);
 		} else {
-			BRCMF_TRACE(("%s: %s xfr'd %p[%d], addr=0x%05x, "
-				     "len=%d\n", __func__,
-				     (write) ? "TX" : "RX",
-				     pnext, SGCount, addr, pkt_len));
+			brcmf_dbg(TRACE, "%s xfr'd %p[%d], addr=0x%05x, len=%d\n",
+				  write ? "TX" : "RX", pnext, SGCount, addr,
+				  pkt_len);
 		}
 
 		if (!fifo)
@@ -462,7 +450,7 @@ brcmf_sdioh_request_packet(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 	/* Release host controller */
 	sdio_release_host(sdiodev->func[func]);
 
-	BRCMF_TRACE(("%s: Exit\n", __func__));
+	brcmf_dbg(TRACE, "Exit\n");
 	return err_ret;
 }
 
@@ -490,18 +478,18 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
 	int Status;
 	struct sk_buff *mypkt = NULL;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait, sdiodev);
 	BRCMF_PM_RESUME_RETURN_ERROR(-EIO, sdiodev);
 	/* Case 1: we don't have a packet. */
 	if (pkt == NULL) {
-		BRCMF_DATA(("%s: Creating new %s Packet, len=%d\n",
-			 __func__, write ? "TX" : "RX", buflen_u));
+		brcmf_dbg(DATA, "Creating new %s Packet, len=%d\n",
+			  write ? "TX" : "RX", buflen_u);
 		mypkt = brcmu_pkt_buf_get_skb(buflen_u);
 		if (!mypkt) {
-			BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed: "
-				     "len %d\n", __func__, buflen_u));
+			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
+				  buflen_u);
 			return -EIO;
 		}
 
@@ -522,12 +510,12 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
 		 * Case 2: We have a packet, but it is unaligned.
 		 * In this case, we cannot have a chain (pkt->next == NULL)
 		 */
-		BRCMF_DATA(("%s: Creating aligned %s Packet, len=%d\n",
-			 __func__, write ? "TX" : "RX", pkt->len));
+		brcmf_dbg(DATA, "Creating aligned %s Packet, len=%d\n",
+			  write ? "TX" : "RX", pkt->len);
 		mypkt = brcmu_pkt_buf_get_skb(pkt->len);
 		if (!mypkt) {
-			BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed: "
-				     "len %d\n", __func__, pkt->len));
+			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
+				  pkt->len);
 			return -EIO;
 		}
 
@@ -545,8 +533,8 @@ brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev, uint pio_dma,
 		brcmu_pkt_buf_free_skb(mypkt);
 	} else {		/* case 3: We have a packet and
 				 it is aligned. */
-		BRCMF_DATA(("%s: Aligned %s Packet, direct DMA\n",
-			 __func__, write ? "Tx" : "Rx"));
+		brcmf_dbg(DATA, "Aligned %s Packet, direct DMA\n",
+			  write ? "Tx" : "Rx");
 		Status = brcmf_sdioh_request_packet(sdiodev, fix_inc, write,
 						    func, addr, pkt);
 	}
@@ -567,14 +555,14 @@ brcmf_sdioh_card_regread(struct brcmf_sdio_dev *sdiodev, int func, u32 regaddr,
 					 &temp);
 		*data = temp;
 		*data &= 0xff;
-		BRCMF_DATA(("%s: byte read data=0x%02x\n", __func__, *data));
+		brcmf_dbg(DATA, "byte read data=0x%02x\n", *data);
 	} else {
 		brcmf_sdioh_request_word(sdiodev, 0, SDIOH_READ, func, regaddr,
 					 data, regsize);
 		if (regsize == 2)
 			*data &= 0xffff;
 
-		BRCMF_DATA(("%s: word read data=0x%08x\n", __func__, *data));
+		brcmf_dbg(DATA, "word read data=0x%08x\n", *data);
 	}
 
 	return SUCCESS;
@@ -585,16 +573,15 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 {
 	int ret = 0;
 	struct brcmf_sdio_dev *sdiodev;
-	BRCMF_TRACE(("sdio_probe: %s Enter\n", __func__));
-	BRCMF_TRACE(("sdio_probe: func->class=%x\n", func->class));
-	BRCMF_TRACE(("sdio_vendor: 0x%04x\n", func->vendor));
-	BRCMF_TRACE(("sdio_device: 0x%04x\n", func->device));
-	BRCMF_TRACE(("Function#: 0x%04x\n", func->num));
+	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(TRACE, "func->class=%x\n", func->class);
+	brcmf_dbg(TRACE, "sdio_vendor: 0x%04x\n", func->vendor);
+	brcmf_dbg(TRACE, "sdio_device: 0x%04x\n", func->device);
+	brcmf_dbg(TRACE, "Function#: 0x%04x\n", func->num);
 
 	if (func->num == 1) {
 		if (dev_get_drvdata(&func->card->dev)) {
-			BRCMF_ERROR(("%s: card private drvdata occupied.\n",
-				     __func__));
+			brcmf_dbg(ERROR, "card private drvdata occupied\n");
 			return -ENXIO;
 		}
 		sdiodev = kzalloc(sizeof(struct brcmf_sdio_dev), GFP_KERNEL);
@@ -614,7 +601,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		sdiodev->func[2] = func;
 
 		brcmf_cfg80211_sdio_func(func);
-		BRCMF_TRACE(("F2 found, calling brcmf_sdio_probe...\n"));
+		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_probe...\n");
 		ret = brcmf_sdio_probe(sdiodev);
 	}
 
@@ -624,15 +611,15 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 static void brcmf_ops_sdio_remove(struct sdio_func *func)
 {
 	struct brcmf_sdio_dev *sdiodev;
-	BRCMF_TRACE(("%s Enter\n", __func__));
-	BRCMF_INFO(("func->class=%x\n", func->class));
-	BRCMF_INFO(("sdio_vendor: 0x%04x\n", func->vendor));
-	BRCMF_INFO(("sdio_device: 0x%04x\n", func->device));
-	BRCMF_INFO(("Function#: 0x%04x\n", func->num));
+	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(INFO, "func->class=%x\n", func->class);
+	brcmf_dbg(INFO, "sdio_vendor: 0x%04x\n", func->vendor);
+	brcmf_dbg(INFO, "sdio_device: 0x%04x\n", func->device);
+	brcmf_dbg(INFO, "Function#: 0x%04x\n", func->num);
 
 	if (func->num == 2) {
 		sdiodev = dev_get_drvdata(&func->card->dev);
-		BRCMF_TRACE(("F2 found, calling brcmf_sdio_remove...\n"));
+		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_remove...\n");
 		brcmf_sdio_remove(sdiodev);
 		dev_set_drvdata(&func->card->dev, NULL);
 		kfree(sdiodev);
@@ -648,7 +635,7 @@ static int brcmf_sdio_suspend(struct device *dev)
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	int ret = 0;
 
-	BRCMF_TRACE(("%s\n", __func__));
+	brcmf_dbg(TRACE, "\n");
 
 	sdiodev = dev_get_drvdata(&func->card->dev);
 
@@ -656,13 +643,13 @@ static int brcmf_sdio_suspend(struct device *dev)
 
 	sdio_flags = sdio_get_host_pm_caps(sdiodev->func[1]);
 	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
-		BRCMF_ERROR(("Host can't keep power while suspended\n"));
+		brcmf_dbg(ERROR, "Host can't keep power while suspended\n");
 		return -EINVAL;
 	}
 
 	ret = sdio_set_host_pm_flags(sdiodev->func[1], MMC_PM_KEEP_POWER);
 	if (ret) {
-		BRCMF_ERROR(("Failed to set pm_flags\n"));
+		brcmf_dbg(ERROR, "Failed to set pm_flags\n");
 		return ret;
 	}
 
@@ -689,7 +676,7 @@ static int brcmf_sdio_resume(struct device *dev)
 int brcmf_sdio_function_init(void)
 {
 	int error = 0;
-	BRCMF_TRACE(("brcmf_sdio_function_init: %s Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	error = sdio_register_driver(&brcmf_sdmmc_driver);
 
@@ -701,7 +688,7 @@ int brcmf_sdio_function_init(void)
 */
 void brcmf_sdio_function_cleanup(void)
 {
-	BRCMF_TRACE(("%s Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	sdio_unregister_driver(&brcmf_sdmmc_driver);
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 345acab..1ac8057 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -104,7 +104,7 @@ static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 	int len = le32_to_cpu(prot->msg.len) +
 			sizeof(struct brcmf_proto_cdc_ioctl);
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* NOTE : cdc->msg.len holds the desired length of the buffer to be
 	 *        returned. Only up to CDC_MAX_MSG_SIZE of this buffer area
@@ -123,7 +123,7 @@ static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 	int ret;
 	struct brcmf_proto *prot = drvr->prot;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	do {
 		ret = brcmf_sdbrcm_bus_rxctl(drvr->bus,
@@ -146,8 +146,8 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	int ret = 0, retries = 0;
 	u32 id, flags = 0;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
-	BRCMF_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
+	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(CTL, "cmd %d len %d\n", cmd, len);
 
 	/* Respond "bcmerror" and "bcmerrorstr" with local cache */
 	if (cmd == BRCMF_C_GET_VAR && buf) {
@@ -174,8 +174,8 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	ret = brcmf_proto_cdc_msg(drvr);
 	if (ret < 0) {
-		BRCMF_ERROR(("brcmf_proto_cdc_query_ioctl: brcmf_proto_cdc_msg "
-			     "failed w/status %d\n", ret));
+		brcmf_dbg(ERROR, "brcmf_proto_cdc_msg failed w/status %d\n",
+			  ret);
 		goto done;
 	}
 
@@ -191,9 +191,8 @@ retry:
 	if ((id < prot->reqid) && (++retries < RETRIES))
 		goto retry;
 	if (id != prot->reqid) {
-		BRCMF_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			     brcmf_ifname(drvr, ifidx), __func__, id,
-			     prot->reqid));
+		brcmf_dbg(ERROR, "%s: unexpected request id %d (expected %d)\n",
+			  brcmf_ifname(drvr, ifidx), id, prot->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -227,8 +226,8 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	int ret = 0;
 	u32 flags, id;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
-	BRCMF_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
+	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(CTL, "cmd %d len %d\n", cmd, len);
 
 	memset(msg, 0, sizeof(struct brcmf_proto_cdc_ioctl));
 
@@ -253,9 +252,8 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	id = (flags & CDCF_IOC_ID_MASK) >> CDCF_IOC_ID_SHIFT;
 
 	if (id != prot->reqid) {
-		BRCMF_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			     brcmf_ifname(drvr, ifidx), __func__, id,
-			     prot->reqid));
+		brcmf_dbg(ERROR, "%s: unexpected request id %d (expected %d)\n",
+			  brcmf_ifname(drvr, ifidx), id, prot->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -279,25 +277,23 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 	int ret = -1;
 
 	if (drvr->busstate == BRCMF_BUS_DOWN) {
-		BRCMF_ERROR(("%s : bus is down. we have nothing to do\n",
-			     __func__));
+		brcmf_dbg(ERROR, "bus is down. we have nothing to do.\n");
 		return ret;
 	}
 	brcmf_os_proto_block(drvr);
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (len > BRCMF_C_IOCTL_MAXLEN)
 		goto done;
 
 	if (prot->pending == true) {
-		BRCMF_TRACE(("CDC packet is pending!!!! cmd=0x%x (%lu) "
-			     "lastcmd=0x%x (%lu)\n",
-			     ioc->cmd, (unsigned long)ioc->cmd, prot->lastcmd,
-			     (unsigned long)prot->lastcmd));
+		brcmf_dbg(TRACE, "CDC packet is pending!!!! cmd=0x%x (%lu) lastcmd=0x%x (%lu)\n",
+			  ioc->cmd, (unsigned long)ioc->cmd, prot->lastcmd,
+			  (unsigned long)prot->lastcmd);
 		if ((ioc->cmd == BRCMF_C_SET_VAR) ||
 		    (ioc->cmd == BRCMF_C_GET_VAR))
-			BRCMF_TRACE(("iovar cmd=%s\n", (char *)buf));
+			brcmf_dbg(TRACE, "iovar cmd=%s\n", (char *)buf);
 
 		goto done;
 	}
@@ -358,7 +354,7 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 {
 	struct brcmf_proto_bdc_header *h;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Push BDC header used to convey priority for buses that don't */
 
@@ -381,13 +377,13 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, int *ifidx,
 {
 	struct brcmf_proto_bdc_header *h;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Pop BDC header used to convey priority for buses that don't */
 
 	if (pktbuf->len < BDC_HEADER_LEN) {
-		BRCMF_ERROR(("%s: rx data too short (%d < %d)\n", __func__,
-			     pktbuf->len, BDC_HEADER_LEN));
+		brcmf_dbg(ERROR, "rx data too short (%d < %d)\n",
+			  pktbuf->len, BDC_HEADER_LEN);
 		return -EBADE;
 	}
 
@@ -395,22 +391,20 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, int *ifidx,
 
 	*ifidx = BDC_GET_IF_IDX(h);
 	if (*ifidx >= BRCMF_MAX_IFS) {
-		BRCMF_ERROR(("%s: rx data ifnum out of range (%d)\n",
-			     __func__, *ifidx));
+		brcmf_dbg(ERROR, "rx data ifnum out of range (%d)\n", *ifidx);
 		return -EBADE;
 	}
 
 	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
 	    BDC_PROTO_VER) {
-		BRCMF_ERROR(("%s: non-BDC packet received, flags 0x%x\n",
-			     brcmf_ifname(drvr, *ifidx), h->flags));
+		brcmf_dbg(ERROR, "%s: non-BDC packet received, flags 0x%x\n",
+			  brcmf_ifname(drvr, *ifidx), h->flags);
 		return -EBADE;
 	}
 
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
-		BRCMF_INFO(("%s: BDC packet received with good rx-csum, "
-			    "flags 0x%x\n",
-			    brcmf_ifname(drvr, *ifidx), h->flags));
+		brcmf_dbg(INFO, "%s: BDC packet received with good rx-csum, flags 0x%x\n",
+			  brcmf_ifname(drvr, *ifidx), h->flags);
 		PKTSETSUMGOOD(pktbuf, true);
 	}
 
@@ -427,13 +421,13 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 
 	cdc = kzalloc(sizeof(struct brcmf_proto), GFP_ATOMIC);
 	if (!cdc) {
-		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
+		brcmf_dbg(ERROR, "kmalloc failed\n");
 		goto fail;
 	}
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((unsigned long)(&cdc->msg + 1) != (unsigned long)cdc->buf) {
-		BRCMF_ERROR(("struct brcmf_proto is not correctly defined\n"));
+		brcmf_dbg(ERROR, "struct brcmf_proto is not correctly defined\n");
 		goto fail;
 	}
 
@@ -472,7 +466,7 @@ int brcmf_proto_init(struct brcmf_pub *drvr)
 	int ret = 0;
 	char buf[128];
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	brcmf_os_proto_block(drvr);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index bd655a3..059289a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -172,7 +172,7 @@ brcmf_c_doiovar(struct brcmf_pub *drvr, const struct brcmu_iovar *vi,
 	int bcmerror = 0;
 	s32 int_val = 0;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	bcmerror = brcmu_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
 	if (bcmerror != 0)
@@ -267,8 +267,8 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 		p = discard_oldest ? brcmu_pktq_pdeq(q, eprec) :
 			brcmu_pktq_pdeq_tail(q, eprec);
 		if (p == NULL)
-			BRCMF_ERROR(("%s: brcmu_pktq_penq() failed, oldest %d.",
-				     __func__, discard_oldest));
+			brcmf_dbg(ERROR, "brcmu_pktq_penq() failed, oldest %d\n",
+				  discard_oldest);
 
 		brcmu_pkt_buf_free_skb(p);
 	}
@@ -276,7 +276,7 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 	/* Enqueue */
 	p = brcmu_pktq_penq(q, prec, pkt);
 	if (p == NULL)
-		BRCMF_ERROR(("%s: brcmu_pktq_penq() failed.", __func__));
+		brcmf_dbg(ERROR, "brcmu_pktq_penq() failed\n");
 
 	return p != NULL;
 }
@@ -290,7 +290,7 @@ brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
 	const struct brcmu_iovar *vi = NULL;
 	u32 actionid;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (name == NULL || len < 0)
 		return -EINVAL;
@@ -309,8 +309,8 @@ brcmf_c_iovar_op(struct brcmf_pub *drvr, const char *name,
 		goto exit;
 	}
 
-	BRCMF_CTL(("%s: %s %s, len %d plen %d\n", __func__,
-		   name, (set ? "set" : "get"), len, plen));
+	brcmf_dbg(CTL, "%s %s, len %d plen %d\n",
+		  name, set ? "set" : "get", len, plen);
 
 	/* set up 'params' pointer in case this is a set command so that
 	 * the convenience int and bool code can be common to set and get
@@ -342,7 +342,7 @@ int brcmf_c_ioctl(struct brcmf_pub *drvr, struct brcmf_c_ioctl *ioc, void *buf,
 {
 	int bcmerror = 0;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (!buf)
 		return -EINVAL;
@@ -498,9 +498,9 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			event_name = event_names[i].event_name;
 	}
 
-	BRCMF_EVENT(("EVENT: %s, event ID = %d\n", event_name, event_type));
-	BRCMF_EVENT(("flags 0x%04x, status %d, reason %d, auth_type %d"
-		     " MAC %s\n", flags, status, reason, auth_type, eabuf));
+	brcmf_dbg(EVENT, "EVENT: %s, event ID = %d\n", event_name, event_type);
+	brcmf_dbg(EVENT, "flags 0x%04x, status %d, reason %d, auth_type %d MAC %s\n",
+		  flags, status, reason, auth_type, eabuf);
 
 	if (flags & BRCMF_EVENT_MSG_LINK)
 		link = true;
@@ -513,35 +513,34 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 	case BRCMF_E_START:
 	case BRCMF_E_DEAUTH:
 	case BRCMF_E_DISASSOC:
-		BRCMF_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
+		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s\n", event_name, eabuf);
 		break;
 
 	case BRCMF_E_ASSOC_IND:
 	case BRCMF_E_REASSOC_IND:
-		BRCMF_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
+		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s\n", event_name, eabuf);
 		break;
 
 	case BRCMF_E_ASSOC:
 	case BRCMF_E_REASSOC:
 		if (status == BRCMF_E_STATUS_SUCCESS)
-			BRCMF_EVENT(("MACEVENT: %s, MAC %s, SUCCESS\n",
-				     event_name, eabuf));
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, SUCCESS\n",
+				  event_name, eabuf);
 		else if (status == BRCMF_E_STATUS_TIMEOUT)
-			BRCMF_EVENT(("MACEVENT: %s, MAC %s, TIMEOUT\n",
-				     event_name, eabuf));
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, TIMEOUT\n",
+				  event_name, eabuf);
 		else if (status == BRCMF_E_STATUS_FAIL)
-			BRCMF_EVENT(("MACEVENT: %s, MAC %s, FAILURE,"
-				     " reason %d\n", event_name, eabuf,
-				     (int)reason));
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, FAILURE, reason %d\n",
+				  event_name, eabuf, (int)reason);
 		else
-			BRCMF_EVENT(("MACEVENT: %s, MAC %s, unexpected status "
-				     "%d\n", event_name, eabuf, (int)status));
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, unexpected status %d\n",
+				  event_name, eabuf, (int)status);
 		break;
 
 	case BRCMF_E_DEAUTH_IND:
 	case BRCMF_E_DISASSOC_IND:
-		BRCMF_EVENT(("MACEVENT: %s, MAC %s, reason %d\n", event_name,
-			     eabuf, (int)reason));
+		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, reason %d\n",
+			  event_name, eabuf, (int)reason);
 		break;
 
 	case BRCMF_E_AUTH:
@@ -555,18 +554,17 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			auth_str = err_msg;
 		}
 		if (event_type == BRCMF_E_AUTH_IND)
-			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s\n", event_name,
-				     eabuf, auth_str));
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s\n",
+				  event_name, eabuf, auth_str);
 		else if (status == BRCMF_E_STATUS_SUCCESS)
-			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s, SUCCESS\n",
-				     event_name, eabuf, auth_str));
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, SUCCESS\n",
+				  event_name, eabuf, auth_str);
 		else if (status == BRCMF_E_STATUS_TIMEOUT)
-			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
-				     event_name, eabuf, auth_str));
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
+				  event_name, eabuf, auth_str);
 		else if (status == BRCMF_E_STATUS_FAIL) {
-			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s, FAILURE, "
-				     "reason %d\n",
-				     event_name, eabuf, auth_str, (int)reason));
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, FAILURE, reason %d\n",
+				  event_name, eabuf, auth_str, (int)reason);
 		}
 
 		break;
@@ -575,63 +573,63 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 	case BRCMF_E_ROAM:
 	case BRCMF_E_SET_SSID:
 		if (status == BRCMF_E_STATUS_SUCCESS)
-			BRCMF_EVENT(("MACEVENT: %s, MAC %s\n", event_name,
-				     eabuf));
+			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s\n",
+				  event_name, eabuf);
 		else if (status == BRCMF_E_STATUS_FAIL)
-			BRCMF_EVENT(("MACEVENT: %s, failed\n", event_name));
+			brcmf_dbg(EVENT, "MACEVENT: %s, failed\n", event_name);
 		else if (status == BRCMF_E_STATUS_NO_NETWORKS)
-			BRCMF_EVENT(("MACEVENT: %s, no networks found\n",
-				     event_name));
+			brcmf_dbg(EVENT, "MACEVENT: %s, no networks found\n",
+				  event_name);
 		else
-			BRCMF_EVENT(("MACEVENT: %s, unexpected status %d\n",
-				     event_name, (int)status));
+			brcmf_dbg(EVENT, "MACEVENT: %s, unexpected status %d\n",
+				  event_name, (int)status);
 		break;
 
 	case BRCMF_E_BEACON_RX:
 		if (status == BRCMF_E_STATUS_SUCCESS)
-			BRCMF_EVENT(("MACEVENT: %s, SUCCESS\n", event_name));
+			brcmf_dbg(EVENT, "MACEVENT: %s, SUCCESS\n", event_name);
 		else if (status == BRCMF_E_STATUS_FAIL)
-			BRCMF_EVENT(("MACEVENT: %s, FAIL\n", event_name));
+			brcmf_dbg(EVENT, "MACEVENT: %s, FAIL\n", event_name);
 		else
-			BRCMF_EVENT(("MACEVENT: %s, status %d\n", event_name,
-				     status));
+			brcmf_dbg(EVENT, "MACEVENT: %s, status %d\n",
+				  event_name, status);
 		break;
 
 	case BRCMF_E_LINK:
-		BRCMF_EVENT(("MACEVENT: %s %s\n", event_name,
-			     link ? "UP" : "DOWN"));
+		brcmf_dbg(EVENT, "MACEVENT: %s %s\n",
+			  event_name, link ? "UP" : "DOWN");
 		break;
 
 	case BRCMF_E_MIC_ERROR:
-		BRCMF_EVENT(("MACEVENT: %s, MAC %s, Group %d, Flush %d\n",
-			     event_name, eabuf, group, flush_txq));
+		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, Group %d, Flush %d\n",
+			  event_name, eabuf, group, flush_txq);
 		break;
 
 	case BRCMF_E_ICV_ERROR:
 	case BRCMF_E_UNICAST_DECODE_ERROR:
 	case BRCMF_E_MULTICAST_DECODE_ERROR:
-		BRCMF_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
+		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s\n", event_name, eabuf);
 		break;
 
 	case BRCMF_E_TXFAIL:
-		BRCMF_EVENT(("MACEVENT: %s, RA %s\n", event_name, eabuf));
+		brcmf_dbg(EVENT, "MACEVENT: %s, RA %s\n", event_name, eabuf);
 		break;
 
 	case BRCMF_E_SCAN_COMPLETE:
 	case BRCMF_E_PMKID_CACHE:
-		BRCMF_EVENT(("MACEVENT: %s\n", event_name));
+		brcmf_dbg(EVENT, "MACEVENT: %s\n", event_name);
 		break;
 
 	case BRCMF_E_PFN_NET_FOUND:
 	case BRCMF_E_PFN_NET_LOST:
 	case BRCMF_E_PFN_SCAN_COMPLETE:
-		BRCMF_EVENT(("PNOEVENT: %s\n", event_name));
+		brcmf_dbg(EVENT, "PNOEVENT: %s\n", event_name);
 		break;
 
 	case BRCMF_E_PSK_SUP:
 	case BRCMF_E_PRUNE:
-		BRCMF_EVENT(("MACEVENT: %s, status %d, reason %d\n",
-			   event_name, (int)status, (int)reason));
+		brcmf_dbg(EVENT, "MACEVENT: %s, status %d, reason %d\n",
+			  event_name, (int)status, (int)reason);
 		break;
 
 	case BRCMF_E_TRACE:
@@ -645,11 +643,9 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			memcpy(&hdr, buf, sizeof(struct msgtrace_hdr));
 
 			if (hdr.version != MSGTRACE_VERSION) {
-				BRCMF_ERROR(
-				    ("\nMACEVENT: %s [unsupported version --> "
-				     "brcmf version:%d dongle version:%d]\n",
-				     event_name, MSGTRACE_VERSION, hdr.version)
-				);
+				brcmf_dbg(ERROR, "MACEVENT: %s [unsupported version --> brcmf version:%d dongle version:%d]\n",
+					  event_name,
+					  MSGTRACE_VERSION, hdr.version);
 				/* Reset datalen to avoid display below */
 				datalen = 0;
 				break;
@@ -661,18 +657,14 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 
 			if (be32_to_cpu(hdr.discarded_bytes)
 			    || be32_to_cpu(hdr.discarded_printf))
-				BRCMF_ERROR(("\nWLC_E_TRACE: [Discarded traces "
-					     "in dongle -->discarded_bytes %d "
-					     "discarded_printf %d]\n",
-					     be32_to_cpu(hdr.discarded_bytes),
-					     be32_to_cpu(hdr.discarded_printf)))
-					     ;
+				brcmf_dbg(ERROR, "WLC_E_TRACE: [Discarded traces in dongle --> discarded_bytes %d discarded_printf %d]\n",
+					  be32_to_cpu(hdr.discarded_bytes),
+					  be32_to_cpu(hdr.discarded_printf));
 
 			nblost = be32_to_cpu(hdr.seqnum) - seqnum_prev - 1;
 			if (nblost > 0)
-				BRCMF_ERROR(("\nWLC_E_TRACE: [Event lost --> "
-					     "seqnum %d nblost %d\n",
-					     be32_to_cpu(hdr.seqnum), nblost));
+				brcmf_dbg(ERROR, "WLC_E_TRACE: [Event lost --> seqnum %d nblost %d\n",
+					  be32_to_cpu(hdr.seqnum), nblost);
 			seqnum_prev = be32_to_cpu(hdr.seqnum);
 
 			/* Display the trace buffer. Advance from \n to \n to
@@ -693,24 +685,24 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 		break;
 
 	case BRCMF_E_RSSI:
-		BRCMF_EVENT(("MACEVENT: %s %d\n", event_name,
-			     be32_to_cpu(*((int *)event_data))));
+		brcmf_dbg(EVENT, "MACEVENT: %s %d\n",
+			  event_name, be32_to_cpu(*((int *)event_data)));
 		break;
 
 	default:
-		BRCMF_EVENT(("MACEVENT: %s %d, MAC %s, status %d, reason %d, "
-			     "auth %d\n", event_name, event_type, eabuf,
-			     (int)status, (int)reason, (int)auth_type));
+		brcmf_dbg(EVENT, "MACEVENT: %s %d, MAC %s, status %d, reason %d, auth %d\n",
+			  event_name, event_type, eabuf,
+			  (int)status, (int)reason, (int)auth_type);
 		break;
 	}
 
 	/* show any appended data */
 	if (datalen) {
 		buf = (unsigned char *) event_data;
-		BRCMF_EVENT((" data (%d) : ", datalen));
+		brcmf_dbg(EVENT, " data (%d) : ", datalen);
 		for (i = 0; i < datalen; i++)
-			BRCMF_EVENT((" 0x%02x ", *buf++));
-		BRCMF_EVENT(("\n"));
+			brcmf_dbg(EVENT, " 0x%02x ", *buf++);
+		brcmf_dbg(EVENT, "\n");
 	}
 }
 #endif				/* SHOW_EVENTS */
@@ -727,14 +719,14 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 	int evlen;
 
 	if (memcmp(BRCM_OUI, &pvt_data->hdr.oui[0], DOT11_OUI_LEN)) {
-		BRCMF_ERROR(("%s: mismatched OUI, bailing\n", __func__));
+		brcmf_dbg(ERROR, "mismatched OUI, bailing\n");
 		return -EBADE;
 	}
 
 	/* BRCM event pkt may be unaligned - use xxx_ua to load user_subtype. */
 	if (get_unaligned_be16(&pvt_data->hdr.usr_subtype) !=
 	    BCMILCP_BCM_SUBTYPE_EVENT) {
-		BRCMF_ERROR(("%s: mismatched subtype, bailing\n", __func__));
+		brcmf_dbg(ERROR, "mismatched subtype, bailing\n");
 		return -EBADE;
 	}
 
@@ -755,7 +747,7 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 		{
 			struct brcmf_if_event *ifevent =
 					(struct brcmf_if_event *) event_data;
-			BRCMF_TRACE(("%s: if event\n", __func__));
+			brcmf_dbg(TRACE, "if event\n");
 
 			if (ifevent->ifidx > 0 &&
 				 ifevent->ifidx < BRCMF_MAX_IFS) {
@@ -768,9 +760,8 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 				else
 					brcmf_del_if(drvr_priv, ifevent->ifidx);
 			} else {
-				BRCMF_ERROR(("%s: Invalid ifidx %d for %s\n",
-					     __func__, ifevent->ifidx,
-					     event->ifname));
+				brcmf_dbg(ERROR, "Invalid ifidx %d for %s\n",
+					  ifevent->ifidx, event->ifname);
 			}
 		}
 		/* send up the if event: btamp user needs it */
@@ -787,16 +778,16 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 		/* Fall through: this should get _everything_  */
 
 		*ifidx = brcmf_ifname2idx(drvr_priv, event->ifname);
-		BRCMF_TRACE(("%s: MAC event %d, flags %x, status %x\n",
-			     __func__, type, flags, status));
+		brcmf_dbg(TRACE, "MAC event %d, flags %x, status %x\n",
+			  type, flags, status);
 
 		/* put it back to BRCMF_E_NDIS_LINK */
 		if (type == BRCMF_E_NDIS_LINK) {
 			u32 temp;
 
 			temp = get_unaligned_be32(&event->event_type);
-			BRCMF_TRACE(("Converted to WLC_E_LINK type %d\n",
-				     temp));
+			brcmf_dbg(TRACE, "Converted to WLC_E_LINK type %d\n",
+				  temp);
 
 			temp = be32_to_cpu(BRCMF_E_NDIS_LINK);
 			memcpy((void *)(&pvt_data->msg.event_type), &temp,
@@ -817,12 +808,12 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
 {
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
-		BRCMF_ERROR(("Mask invalid format. Needs to start with 0x\n"));
+		brcmf_dbg(ERROR, "Mask invalid format. Needs to start with 0x\n");
 		return -EINVAL;
 	}
 	src = src + 2;		/* Skip past 0x */
 	if (strlen(src) % 2 != 0) {
-		BRCMF_ERROR(("Mask invalid format. Length must be even.\n"));
+		brcmf_dbg(ERROR, "Mask invalid format. Length must be even.\n");
 		return -EINVAL;
 	}
 	for (i = 0; *src != '\0'; i++) {
@@ -856,7 +847,7 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 
 	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save) {
-		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
+		brcmf_dbg(ERROR, "kmalloc failed\n");
 		goto fail;
 	}
 	arg_org = arg_save;
@@ -866,7 +857,7 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 
 	i = 0;
 	if (NULL == argv[i]) {
-		BRCMF_ERROR(("No args provided\n"));
+		brcmf_dbg(ERROR, "No args provided\n");
 		goto fail;
 	}
 
@@ -893,11 +884,10 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 	rc = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
-		BRCMF_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
-			     __func__, arg, rc));
+		brcmf_dbg(TRACE, "failed to add pktfilter %s, retcode = %d\n",
+			  arg, rc);
 	else
-		BRCMF_TRACE(("%s: successfully added pktfilter %s\n",
-			     __func__, arg));
+		brcmf_dbg(TRACE, "successfully added pktfilter %s\n", arg);
 
 	/* Contorl the master mode */
 	brcmu_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
@@ -906,8 +896,8 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 				       sizeof(buf));
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
-		BRCMF_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
-			     __func__, arg, rc));
+		brcmf_dbg(TRACE, "failed to add pktfilter %s, retcode = %d\n",
+			  arg, rc);
 
 fail:
 	kfree(arg_org);
@@ -930,7 +920,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 
 	arg_save = kstrdup(arg, GFP_ATOMIC);
 	if (!arg_save) {
-		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
+		brcmf_dbg(ERROR, "kmalloc failed\n");
 		goto fail;
 	}
 
@@ -938,7 +928,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 
 	buf = kmalloc(PKTFILTER_BUF_SIZE, GFP_ATOMIC);
 	if (!buf) {
-		BRCMF_ERROR(("%s: kmalloc failed\n", __func__));
+		brcmf_dbg(ERROR, "kmalloc failed\n");
 		goto fail;
 	}
 
@@ -948,7 +938,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 
 	i = 0;
 	if (NULL == argv[i]) {
-		BRCMF_ERROR(("No args provided\n"));
+		brcmf_dbg(ERROR, "No args provided\n");
 		goto fail;
 	}
 
@@ -965,7 +955,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 		pkt_filter.id = (u32)res;
 
 	if (NULL == argv[++i]) {
-		BRCMF_ERROR(("Polarity not provided\n"));
+		brcmf_dbg(ERROR, "Polarity not provided\n");
 		goto fail;
 	}
 
@@ -975,7 +965,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 		pkt_filter.negate_match = (u32)res;
 
 	if (NULL == argv[++i]) {
-		BRCMF_ERROR(("Filter type not provided\n"));
+		brcmf_dbg(ERROR, "Filter type not provided\n");
 		goto fail;
 	}
 
@@ -985,7 +975,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 		pkt_filter.type = (u32)res;
 
 	if (NULL == argv[++i]) {
-		BRCMF_ERROR(("Offset not provided\n"));
+		brcmf_dbg(ERROR, "Offset not provided\n");
 		goto fail;
 	}
 
@@ -995,7 +985,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 		pkt_filter.u.pattern.offset = (u32)res;
 
 	if (NULL == argv[++i]) {
-		BRCMF_ERROR(("Bitmask not provided\n"));
+		brcmf_dbg(ERROR, "Bitmask not provided\n");
 		goto fail;
 	}
 
@@ -1005,7 +995,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 		   (argv[i], (char *)pkt_filterp->u.pattern.mask_and_pattern);
 
 	if (NULL == argv[++i]) {
-		BRCMF_ERROR(("Pattern not provided\n"));
+		brcmf_dbg(ERROR, "Pattern not provided\n");
 		goto fail;
 	}
 
@@ -1016,7 +1006,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 				   mask_and_pattern[mask_size]);
 
 	if (mask_size != pattern_size) {
-		BRCMF_ERROR(("Mask and pattern not the same size\n"));
+		brcmf_dbg(ERROR, "Mask and pattern not the same size\n");
 		goto fail;
 	}
 
@@ -1037,11 +1027,10 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	rc = rc >= 0 ? 0 : rc;
 
 	if (rc)
-		BRCMF_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
-			     __func__, arg, rc));
+		brcmf_dbg(TRACE, "failed to add pktfilter %s, retcode = %d\n",
+			  arg, rc);
 	else
-		BRCMF_TRACE(("%s: successfully added pktfilter %s\n",
-			     __func__, arg));
+		brcmf_dbg(TRACE, "successfully added pktfilter %s\n", arg);
 
 fail:
 	kfree(arg_org);
@@ -1059,11 +1048,11 @@ void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
-		BRCMF_TRACE(("%s: failed to set ARP offload mode to 0x%x, "
-			     "retcode = %d\n", __func__, arp_mode, retcode));
+		brcmf_dbg(TRACE, "failed to set ARP offload mode to 0x%x, retcode = %d\n",
+			  arp_mode, retcode);
 	else
-		BRCMF_TRACE(("%s: successfully set ARP offload mode to 0x%x\n",
-			     __func__, arp_mode));
+		brcmf_dbg(TRACE, "successfully set ARP offload mode to 0x%x\n",
+			  arp_mode);
 }
 
 void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
@@ -1076,11 +1065,11 @@ void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
-		BRCMF_TRACE(("%s: failed to enabe ARP offload to %d, "
-			     "retcode = %d\n", __func__, arp_enable, retcode));
+		brcmf_dbg(TRACE, "failed to enable ARP offload to %d, retcode = %d\n",
+			  arp_enable, retcode);
 	else
-		BRCMF_TRACE(("%s: successfully enabed ARP offload to %d\n",
-			     __func__, arp_enable));
+		brcmf_dbg(TRACE, "successfully enabled ARP offload to %d\n",
+			  arp_enable);
 }
 
 int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
@@ -1103,8 +1092,7 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 		if (brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_COUNTRY,
 					      drvr->country_code,
 					      sizeof(drvr->country_code)) < 0)
-			BRCMF_ERROR(("%s: country code setting failed\n",
-				     __func__));
+			brcmf_dbg(ERROR, "country code setting failed\n");
 	}
 
 	/* query for 'ver' to get version info from firmware */
@@ -1114,7 +1102,7 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 	brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
-	BRCMF_ERROR(("Firmware version = %s\n", buf));
+	brcmf_dbg(ERROR, "Firmware version = %s\n", buf);
 
 	/* Match Host and Dongle rx alignment */
 	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
index 5be4d7a..7467922 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
@@ -19,25 +19,21 @@
 
 #if defined(BCMDBG)
 
-#define BRCMF_ERROR(args) \
-	do {if ((brcmf_msg_level & BRCMF_ERROR_VAL) && (net_ratelimit())) \
-		printk args; } while (0)
-#define BRCMF_TRACE(args)	do {if (brcmf_msg_level & BRCMF_TRACE_VAL) \
-					printk args; } while (0)
-#define BRCMF_INFO(args)	do {if (brcmf_msg_level & BRCMF_INFO_VAL) \
-					printk args; } while (0)
-#define BRCMF_DATA(args)	do {if (brcmf_msg_level & BRCMF_DATA_VAL) \
-					printk args; } while (0)
-#define BRCMF_CTL(args)		do {if (brcmf_msg_level & BRCMF_CTL_VAL) \
-					printk args; } while (0)
-#define BRCMF_TIMER(args)	do {if (brcmf_msg_level & BRCMF_TIMER_VAL) \
-					printk args; } while (0)
-#define BRCMF_INTR(args)	do {if (brcmf_msg_level & BRCMF_INTR_VAL) \
-					printk args; } while (0)
-#define BRCMF_GLOM(args)	do {if (brcmf_msg_level & BRCMF_GLOM_VAL) \
-					printk args; } while (0)
-#define BRCMF_EVENT(args)	do {if (brcmf_msg_level & BRCMF_EVENT_VAL) \
-					printk args; } while (0)
+#define brcmf_dbg(level, fmt, ...)					\
+do {									\
+	if (BRCMF_ERROR_VAL == BRCMF_##level##_VAL) {			\
+		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
+			if (net_ratelimit())				\
+				printk(KERN_DEBUG "%s: " fmt,		\
+				       __func__, ##__VA_ARGS__);	\
+		}							\
+	} else {							\
+		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
+			printk(KERN_DEBUG "%s: " fmt,			\
+			       __func__, ##__VA_ARGS__);		\
+		}							\
+	}								\
+} while (0)
 
 #define BRCMF_DATA_ON()		(brcmf_msg_level & BRCMF_DATA_VAL)
 #define BRCMF_CTL_ON()		(brcmf_msg_level & BRCMF_CTL_VAL)
@@ -47,20 +43,12 @@
 
 #else	/* (defined BCMDBG) || (defined BCMDBG) */
 
-#define BRCMF_ERROR(args)  do {if (net_ratelimit()) printk args; } while (0)
-#define BRCMF_TRACE(args)
-#define BRCMF_INFO(args)
-#define BRCMF_DATA(args)
-#define BRCMF_CTL(args)
-#define BRCMF_TIMER(args)
-#define BRCMF_INTR(args)
-#define BRCMF_GLOM(args)
-#define BRCMF_EVENT(args)
+#define brcmf_dbg(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 
 #define BRCMF_DATA_ON()		0
 #define BRCMF_CTL_ON()		0
 #define BRCMF_HDRS_ON()		0
-#define BRCMF_BYTES_ON()		0
+#define BRCMF_BYTES_ON()	0
 #define BRCMF_GLOM_ON()		0
 
 #endif				/* defined(BCMDBG) */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 29c19ba..312f953 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -163,7 +163,7 @@ int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name)
 		    && !strncmp(drvr_priv->iflist[i]->name, name, IFNAMSIZ))
 			break;
 
-	BRCMF_TRACE(("%s: return idx %d for \"%s\"\n", __func__, i, name));
+	brcmf_dbg(TRACE, "return idx %d for \"%s\"\n", i, name);
 
 	return i;		/* default - the primary interface */
 }
@@ -173,12 +173,12 @@ char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 	struct brcmf_info *drvr_priv = drvr->info;
 
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
-		BRCMF_ERROR(("%s: ifidx %d out of range\n", __func__, ifidx));
+		brcmf_dbg(ERROR, "ifidx %d out of range\n", ifidx);
 		return "<if_bad>";
 	}
 
 	if (drvr_priv->iflist[ifidx] == NULL) {
-		BRCMF_ERROR(("%s: null i/f %d\n", __func__, ifidx));
+		brcmf_dbg(ERROR, "null i/f %d\n", ifidx);
 		return "<if_null>";
 	}
 
@@ -210,8 +210,8 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	buflen = sizeof("mcast_list") + sizeof(cnt) + (cnt * ETH_ALEN);
 	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!bufp) {
-		BRCMF_ERROR(("%s: out of memory for mcast_list, cnt %d\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx), cnt));
+		brcmf_dbg(ERROR, "%s: out of memory for mcast_list, cnt %d\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx), cnt);
 		return;
 	}
 
@@ -238,8 +238,8 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		BRCMF_ERROR(("%s: set mcast_list failed, cnt %d\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx), cnt));
+		brcmf_dbg(ERROR, "%s: set mcast_list failed, cnt %d\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx), cnt);
 		allmulti = cnt ? true : allmulti;
 	}
 
@@ -253,18 +253,17 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	buflen = sizeof("allmulti") + sizeof(allmulti);
 	buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!buf) {
-		BRCMF_ERROR(("%s: out of memory for allmulti\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx)));
+		brcmf_dbg(ERROR, "%s: out of memory for allmulti\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx));
 		return;
 	}
 	allmulti = cpu_to_le32(allmulti);
 
 	if (!brcmu_mkiovar
 	    ("allmulti", (void *)&allmulti, sizeof(allmulti), buf, buflen)) {
-		BRCMF_ERROR(("%s: mkiovar failed for allmulti, datalen %d "
-			     "buflen %u\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx),
-			     (int)sizeof(allmulti), buflen));
+		brcmf_dbg(ERROR, "%s: mkiovar failed for allmulti, datalen %d buflen %u\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx),
+			  (int)sizeof(allmulti), buflen);
 		kfree(buf);
 		return;
 	}
@@ -277,9 +276,9 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		BRCMF_ERROR(("%s: set allmulti %d failed\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx),
-			     le32_to_cpu(allmulti)));
+		brcmf_dbg(ERROR, "%s: set allmulti %d failed\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx),
+			  le32_to_cpu(allmulti));
 	}
 
 	kfree(buf);
@@ -298,9 +297,9 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		BRCMF_ERROR(("%s: set promisc %d failed\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx),
-			     le32_to_cpu(allmulti)));
+		brcmf_dbg(ERROR, "%s: set promisc %d failed\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx),
+			  le32_to_cpu(allmulti));
 	}
 }
 
@@ -311,11 +310,10 @@ _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *addr)
 	struct brcmf_ioctl ioc;
 	int ret;
 
-	BRCMF_TRACE(("%s enter\n", __func__));
-	if (!brcmu_mkiovar
-	    ("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
-		BRCMF_ERROR(("%s: mkiovar failed for cur_etheraddr\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx)));
+	brcmf_dbg(TRACE, "enter\n");
+	if (!brcmu_mkiovar("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
+		brcmf_dbg(ERROR, "%s: mkiovar failed for cur_etheraddr\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx));
 		return -1;
 	}
 	memset(&ioc, 0, sizeof(ioc));
@@ -326,8 +324,8 @@ _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *addr)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0)
-		BRCMF_ERROR(("%s: set cur_etheraddr failed\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx)));
+		brcmf_dbg(ERROR, "%s: set cur_etheraddr failed\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx));
 	else
 		memcpy(drvr_priv->iflist[ifidx]->net->dev_addr, addr, ETH_ALEN);
 
@@ -346,7 +344,7 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 
 	drvr_priv = ifp->info;
 
-	BRCMF_TRACE(("%s: idx %d, state %d\n", __func__, ifp->idx, ifp->state));
+	brcmf_dbg(TRACE, "idx %d, state %d\n", ifp->idx, ifp->state);
 
 	switch (ifp->state) {
 	case BRCMF_E_IF_ADD:
@@ -355,9 +353,8 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		 * in case we missed the BRCMF_E_IF_DEL event.
 		 */
 		if (ifp->net != NULL) {
-			BRCMF_ERROR(("%s: ERROR: netdev:%s already exists, "
-				     "try free & unregister\n",
-				     __func__, ifp->net->name));
+			brcmf_dbg(ERROR, "ERROR: netdev:%s already exists, try free & unregister\n",
+				  ifp->net->name);
 			netif_stop_queue(ifp->net);
 			unregister_netdev(ifp->net);
 			free_netdev(ifp->net);
@@ -365,7 +362,7 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		/* Allocate etherdev, including space for private structure */
 		ifp->net = alloc_etherdev(sizeof(drvr_priv));
 		if (!ifp->net) {
-			BRCMF_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
+			brcmf_dbg(ERROR, "OOM - alloc_etherdev\n");
 			ret = -ENOMEM;
 		}
 		if (ret == 0) {
@@ -374,9 +371,8 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 			       sizeof(drvr_priv));
 			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
 			if (err != 0) {
-				BRCMF_ERROR(("%s: brcmf_net_attach failed, "
-					     "err %d\n",
-					     __func__, err));
+				brcmf_dbg(ERROR, "brcmf_net_attach failed, err %d\n",
+					  err);
 				ret = -EOPNOTSUPP;
 			} else {
 #ifdef SOFTAP
@@ -391,17 +387,15 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 					 wl0.1 is ready */
 				up(&ap_eth_sema);
 #endif
-				BRCMF_TRACE(("\n ==== pid:%x, net_device for "
-					     "if:%s created ===\n\n",
-					     current->pid, ifp->net->name));
+				brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
+					  current->pid, ifp->net->name);
 				ifp->state = 0;
 			}
 		}
 		break;
 	case BRCMF_E_IF_DEL:
 		if (ifp->net != NULL) {
-			BRCMF_TRACE(("\n%s: got 'WLC_E_IF_DEL' state\n",
-				     __func__));
+			brcmf_dbg(TRACE, "got 'WLC_E_IF_DEL' state\n");
 			netif_stop_queue(ifp->net);
 			unregister_netdev(ifp->net);
 			ret = BRCMF_DEL_IF;	/* Make sure the free_netdev()
@@ -409,7 +403,7 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		}
 		break;
 	default:
-		BRCMF_ERROR(("%s: bad op %d\n", __func__, ifp->state));
+		brcmf_dbg(ERROR, "bad op %d\n", ifp->state);
 		break;
 	}
 
@@ -458,26 +452,21 @@ static int _brcmf_sysioc_thread(void *data)
 					brcmf_op_if(ifentry);
 #ifdef SOFTAP
 				if (drvr_priv->iflist[i] == NULL) {
-					BRCMF_TRACE(("\n\n %s: interface %d "
-						     "removed!\n", __func__,
-						     i));
+					brcmf_dbg(TRACE, "interface %d removed!\n",
+						  i);
 					continue;
 				}
 
 				if (in_ap && drvr_priv->set_macaddress) {
-					BRCMF_TRACE(("attempt to set MAC for"
-						     " %s in AP Mode,"
-						     " blocked.\n",
-						     ifentry->net->name));
+					brcmf_dbg(TRACE, "attempt to set MAC for %s in AP Mode, blocked.\n",
+						  ifentry->net->name);
 					drvr_priv->set_macaddress = false;
 					continue;
 				}
 
 				if (in_ap && drvr_priv->set_multicast) {
-					BRCMF_TRACE(("attempt to set MULTICAST "
-						     "list for %s in AP Mode, "
-						     "blocked.\n",
-						     ifentry->net->name));
+					brcmf_dbg(TRACE, "attempt to set MULTICAST list for %s in AP Mode, blocked.\n",
+						  ifentry->net->name);
 					drvr_priv->set_multicast = false;
 					continue;
 				}
@@ -561,20 +550,19 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 	int ifidx;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Reject if down */
 	if (!drvr_priv->pub.up || (drvr_priv->pub.busstate == BRCMF_BUS_DOWN)) {
-		BRCMF_ERROR(("%s: xmit rejected pub.up=%d busstate=%d\n",
-			     __func__, drvr_priv->pub.up,
-			     drvr_priv->pub.busstate));
+		brcmf_dbg(ERROR, "xmit rejected pub.up=%d busstate=%d\n",
+			  drvr_priv->pub.up, drvr_priv->pub.busstate);
 		netif_stop_queue(net);
 		return -ENODEV;
 	}
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
 	if (ifidx == BRCMF_BAD_IF) {
-		BRCMF_ERROR(("%s: bad ifidx %d\n", __func__, ifidx));
+		brcmf_dbg(ERROR, "bad ifidx %d\n", ifidx);
 		netif_stop_queue(net);
 		return -ENODEV;
 	}
@@ -583,15 +571,15 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 	if (skb_headroom(skb) < drvr_priv->pub.hdrlen) {
 		struct sk_buff *skb2;
 
-		BRCMF_INFO(("%s: insufficient headroom\n",
-			    brcmf_ifname(&drvr_priv->pub, ifidx)));
+		brcmf_dbg(INFO, "%s: insufficient headroom\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx));
 		drvr_priv->pub.tx_realloc++;
 		skb2 = skb_realloc_headroom(skb, drvr_priv->pub.hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
-			BRCMF_ERROR(("%s: skb_realloc_headroom failed\n",
-				     brcmf_ifname(&drvr_priv->pub, ifidx)));
+			brcmf_dbg(ERROR, "%s: skb_realloc_headroom failed\n",
+				  brcmf_ifname(&drvr_priv->pub, ifidx));
 			ret = -ENOMEM;
 			goto done;
 		}
@@ -614,7 +602,7 @@ void brcmf_txflowcontrol(struct brcmf_pub *drvr, int ifidx, bool state)
 	struct net_device *net;
 	struct brcmf_info *drvr_priv = drvr->info;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	drvr->txoff = state;
 	net = drvr_priv->iflist[ifidx]->net;
@@ -636,7 +624,7 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 	struct brcmf_if *ifp;
 	struct brcmf_event_msg event;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	save_pktbuf = skb;
 
@@ -728,7 +716,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 	struct brcmf_if *ifp;
 	int ifidx;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
 	if (ifidx == BRCMF_BAD_IF)
@@ -774,13 +762,13 @@ static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 	if (ret < 0) {
 		/* Check for older dongle image that doesn't support toe_ol */
 		if (ret == -EIO) {
-			BRCMF_ERROR(("%s: toe not supported by device\n",
-				     brcmf_ifname(&drvr_priv->pub, ifidx)));
+			brcmf_dbg(ERROR, "%s: toe not supported by device\n",
+				  brcmf_ifname(&drvr_priv->pub, ifidx));
 			return -EOPNOTSUPP;
 		}
 
-		BRCMF_INFO(("%s: could not get toe_ol: ret=%d\n",
-			    brcmf_ifname(&drvr_priv->pub, ifidx), ret));
+		brcmf_dbg(INFO, "%s: could not get toe_ol: ret=%d\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
 		return ret;
 	}
 
@@ -810,8 +798,8 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		BRCMF_ERROR(("%s: could not set toe_ol: ret=%d\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx), ret));
+		brcmf_dbg(ERROR, "%s: could not set toe_ol: ret=%d\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
 		return ret;
 	}
 
@@ -824,8 +812,8 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
-		BRCMF_ERROR(("%s: could not set toe: ret=%d\n",
-			     brcmf_ifname(&drvr_priv->pub, ifidx), ret));
+		brcmf_dbg(ERROR, "%s: could not set toe: ret=%d\n",
+			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
 		return ret;
 	}
 
@@ -857,7 +845,7 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void *uaddr)
 	u32 toe_cmpnt, csum_dir;
 	int ret;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* all ethtool calls start with a cmd word */
 	if (copy_from_user(&cmd, uaddr, sizeof(u32)))
@@ -883,7 +871,7 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void *uaddr)
 
 		/* otherwise, require dongle to be up */
 		else if (!drvr_priv->pub.up) {
-			BRCMF_ERROR(("%s: dongle is not up\n", __func__));
+			brcmf_dbg(ERROR, "dongle is not up\n");
 			return -ENODEV;
 		}
 
@@ -896,8 +884,8 @@ static int brcmf_ethtool(struct brcmf_info *drvr_priv, void *uaddr)
 		sprintf(info.version, "%lu", drvr_priv->pub.drv_version);
 		if (copy_to_user(uaddr, &info, sizeof(info)))
 			return -EFAULT;
-		BRCMF_CTL(("%s: given %*s, returning %s\n", __func__,
-			   (int)sizeof(drvname), drvname, info.driver));
+		brcmf_dbg(CTL, "given %*s, returning %s\n",
+			  (int)sizeof(drvname), drvname, info.driver);
 		break;
 
 		/* Get toe offload components from dongle */
@@ -972,7 +960,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	bool is_set_key_cmd;
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
-	BRCMF_TRACE(("%s: ifidx %d, cmd 0x%04x\n", __func__, ifidx, cmd));
+	brcmf_dbg(TRACE, "ifidx %d, cmd 0x%04x\n", ifidx, cmd);
 
 	if (ifidx == BRCMF_BAD_IF)
 		return -1;
@@ -1036,7 +1024,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 
 	/* send to dongle (must be up, and wl) */
 	if ((drvr_priv->pub.busstate != BRCMF_BUS_DATA)) {
-		BRCMF_ERROR(("%s DONGLE_DOWN,__func__\n", __func__));
+		brcmf_dbg(ERROR, "DONGLE_DOWN\n");
 		bcmerror = -EIO;
 		goto done;
 	}
@@ -1080,7 +1068,7 @@ static int brcmf_netdev_stop(struct net_device *net)
 #if !defined(IGNORE_ETH0_DOWN)
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_cfg80211_down();
 	if (drvr_priv->pub.up == 0)
 		return 0;
@@ -1089,8 +1077,7 @@ static int brcmf_netdev_stop(struct net_device *net)
 	drvr_priv->pub.up = 0;
 	netif_stop_queue(net);
 #else
-	BRCMF_ERROR(("BYPASS %s:due to BRCM compilation: under investigation\n",
-		     __func__));
+	brcmf_dbg(ERROR, "BYPASSed due to BRCM compilation: under investigation\n");
 #endif				/* !defined(IGNORE_ETH0_DOWN) */
 
 	return 0;
@@ -1103,15 +1090,14 @@ static int brcmf_netdev_open(struct net_device *net)
 	int ifidx = brcmf_net2idx(drvr_priv, net);
 	s32 ret = 0;
 
-	BRCMF_TRACE(("%s: ifidx %d\n", __func__, ifidx));
+	brcmf_dbg(TRACE, "ifidx %d\n", ifidx);
 
 	if (ifidx == 0) {	/* do it only for primary eth0 */
 
 		/* try to bring up bus */
 		ret = brcmf_bus_start(&drvr_priv->pub);
 		if (ret != 0) {
-			BRCMF_ERROR(("%s: failed with code %d\n",
-				     __func__, ret));
+			brcmf_dbg(ERROR, "failed with code %d\n", ret);
 			return -1;
 		}
 		atomic_set(&drvr_priv->pend_8021x_cnt, 0);
@@ -1131,8 +1117,7 @@ static int brcmf_netdev_open(struct net_device *net)
 	netif_start_queue(net);
 	drvr_priv->pub.up = 1;
 	if (unlikely(brcmf_cfg80211_up())) {
-		BRCMF_ERROR(("%s: failed to bring up cfg80211\n",
-			     __func__));
+		brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
 		return -1;
 	}
 
@@ -1145,13 +1130,13 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *net,
 {
 	struct brcmf_if *ifp;
 
-	BRCMF_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, net));
+	brcmf_dbg(TRACE, "idx %d, handle->%p\n", ifidx, net);
 
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
 		ifp = kmalloc(sizeof(struct brcmf_if), GFP_ATOMIC);
 		if (!ifp) {
-			BRCMF_ERROR(("%s: OOM - struct brcmf_if\n", __func__));
+			brcmf_dbg(ERROR, "OOM - struct brcmf_if\n");
 			return -ENOMEM;
 		}
 	}
@@ -1177,11 +1162,11 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 {
 	struct brcmf_if *ifp;
 
-	BRCMF_TRACE(("%s: idx %d\n", __func__, ifidx));
+	brcmf_dbg(TRACE, "idx %d\n", ifidx);
 
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
-		BRCMF_ERROR(("%s: Null interface\n", __func__));
+		brcmf_dbg(ERROR, "Null interface\n");
 		return;
 	}
 
@@ -1195,19 +1180,19 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	struct brcmf_info *drvr_priv = NULL;
 	struct net_device *net;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Allocate etherdev, including space for private structure */
 	net = alloc_etherdev(sizeof(drvr_priv));
 	if (!net) {
-		BRCMF_ERROR(("%s: OOM - alloc_etherdev\n", __func__));
+		brcmf_dbg(ERROR, "OOM - alloc_etherdev\n");
 		goto fail;
 	}
 
 	/* Allocate primary brcmf_info */
 	drvr_priv = kzalloc(sizeof(struct brcmf_info), GFP_ATOMIC);
 	if (!drvr_priv) {
-		BRCMF_ERROR(("%s: OOM - alloc brcmf_info\n", __func__));
+		brcmf_dbg(ERROR, "OOM - alloc brcmf_info\n");
 		goto fail;
 	}
 
@@ -1244,13 +1229,13 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 
 	/* Attach and link in the protocol */
 	if (brcmf_proto_attach(&drvr_priv->pub) != 0) {
-		BRCMF_ERROR(("brcmf_prot_attach failed\n"));
+		brcmf_dbg(ERROR, "brcmf_prot_attach failed\n");
 		goto fail;
 	}
 
 	/* Attach and link in the cfg80211 */
 	if (unlikely(brcmf_cfg80211_attach(net, &drvr_priv->pub))) {
-		BRCMF_ERROR(("wl_cfg80211_attach failed\n"));
+		brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
 		goto fail;
 	}
 
@@ -1289,19 +1274,18 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 	/* Room for "event_msgs" + '\0' + bitvec */
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
 
-	BRCMF_TRACE(("%s:\n", __func__));
+	brcmf_dbg(TRACE, "\n");
 
 	/* Bring up the bus */
 	ret = brcmf_sdbrcm_bus_init(&drvr_priv->pub, true);
 	if (ret != 0) {
-		BRCMF_ERROR(("%s, brcmf_sdbrcm_bus_init failed %d\n", __func__,
-			     ret));
+		brcmf_dbg(ERROR, "brcmf_sdbrcm_bus_init failed %d\n", ret);
 		return ret;
 	}
 
 	/* If bus is not ready, can't come up */
 	if (drvr_priv->pub.busstate != BRCMF_BUS_DATA) {
-		BRCMF_ERROR(("%s failed bus is not ready\n", __func__));
+		brcmf_dbg(ERROR, "failed bus is not ready\n");
 		return -ENODEV;
 	}
 
@@ -1361,7 +1345,7 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 	u8 temp_addr[ETH_ALEN] = {
 		0x00, 0x90, 0x4c, 0x11, 0x22, 0x33};
 
-	BRCMF_TRACE(("%s: ifidx %d\n", __func__, ifidx));
+	brcmf_dbg(TRACE, "ifidx %d\n", ifidx);
 
 	net = drvr_priv->iflist[ifidx]->net;
 	net->netdev_ops = &brcmf_netdev_ops_pri;
@@ -1376,7 +1360,7 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 	}
 
 	if (ifidx == 1) {
-		BRCMF_TRACE(("%s ACCESS POINT MAC:\n", __func__));
+		brcmf_dbg(TRACE, "ACCESS POINT MAC:\n");
 		/*  ACCESSPOINT INTERFACE CASE */
 		temp_addr[0] |= 0X02;	/* set bit 2 ,
 			 - Locally Administered address  */
@@ -1391,12 +1375,11 @@ int brcmf_net_attach(struct brcmf_pub *drvr, int ifidx)
 	memcpy(net->dev_addr, temp_addr, ETH_ALEN);
 
 	if (register_netdev(net) != 0) {
-		BRCMF_ERROR(("%s: couldn't register the net device\n",
-			     __func__));
+		brcmf_dbg(ERROR, "couldn't register the net device\n");
 		goto fail;
 	}
 
-	BRCMF_INFO(("%s: Broadcom Dongle Host Driver\n", net->name));
+	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", net->name);
 
 	return 0;
 
@@ -1409,7 +1392,7 @@ static void brcmf_bus_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (drvr) {
 		drvr_priv = drvr->info;
@@ -1427,7 +1410,7 @@ void brcmf_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_info *drvr_priv;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (drvr) {
 		drvr_priv = drvr->info;
@@ -1467,7 +1450,7 @@ void brcmf_detach(struct brcmf_pub *drvr)
 
 static void __exit brcmf_module_cleanup(void)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	brcmf_bus_unregister();
 }
@@ -1476,12 +1459,12 @@ static int __init brcmf_module_init(void)
 {
 	int error;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	error = brcmf_bus_register();
 
 	if (error) {
-		BRCMF_ERROR(("%s: brcmf_bus_register failed\n", __func__));
+		brcmf_dbg(ERROR, "brcmf_bus_register failed\n");
 		goto failed;
 	}
 	return 0;
@@ -1583,7 +1566,7 @@ int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size)
 	/* open file to write */
 	fp = filp_open("/tmp/mem_dump", O_WRONLY | O_CREAT, 0640);
 	if (!fp) {
-		BRCMF_ERROR(("%s: open file error\n", __func__));
+		brcmf_dbg(ERROR, "open file error\n");
 		ret = -1;
 		goto exit;
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 7632a0e..8e59086 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -859,7 +859,7 @@ r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 	if (*retryvar) {
 		bus->regfails += (*retryvar-1);
 		if (*retryvar > retry_limit) {
-			BRCMF_ERROR(("FAILED READ %Xh\n", reg_offset));
+			brcmf_dbg(ERROR, "FAILED READ %Xh\n", reg_offset);
 			*regvar = 0;
 		}
 	}
@@ -878,8 +878,8 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 	if (*retryvar) {
 		bus->regfails += (*retryvar-1);
 		if (*retryvar > retry_limit)
-			BRCMF_ERROR(("FAILED REGISTER WRITE"
-				     " %Xh\n", reg_offset));
+			brcmf_dbg(ERROR, "FAILED REGISTER WRITE %Xh\n",
+				  reg_offset);
 	}
 }
 
@@ -954,8 +954,8 @@ static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size)
 {
 	s32 min_size = DONGLE_MIN_MEMSIZE;
 	/* Restrict the memsize to user specified limit */
-	BRCMF_ERROR(("user: Restrict the dongle ram size to %d, min %d\n",
-		     brcmf_dongle_memsize, min_size));
+	brcmf_dbg(ERROR, "user: Restrict the dongle ram size to %d, min %d\n",
+		  brcmf_dongle_memsize, min_size);
 	if ((brcmf_dongle_memsize > min_size) &&
 	    (brcmf_dongle_memsize < (s32) bus->orig_ramsize))
 		bus->ramsize = brcmf_dongle_memsize;
@@ -986,7 +986,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 	u8 clkctl, clkreq, devctl;
 	unsigned long timeout;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	clkctl = 0;
 
@@ -1002,8 +1002,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				       SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
 		if (err) {
-			BRCMF_ERROR(("%s: HT Avail request error: %d\n",
-				     __func__, err));
+			brcmf_dbg(ERROR, "HT Avail request error: %d\n", err);
 			return -EBADE;
 		}
 
@@ -1019,8 +1018,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		clkctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
-			BRCMF_ERROR(("%s: HT Avail read error: %d\n",
-				     __func__, err));
+			brcmf_dbg(ERROR, "HT Avail read error: %d\n", err);
 			return -EBADE;
 		}
 
@@ -1031,15 +1029,15 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 					SDIO_FUNC_1,
 					SBSDIO_DEVICE_CTL, &err);
 			if (err) {
-				BRCMF_ERROR(("%s: Devctl error setting CA:"
-					     " %d\n", __func__, err));
+				brcmf_dbg(ERROR, "Devctl error setting CA: %d\n",
+					  err);
 				return -EBADE;
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 					       SBSDIO_DEVICE_CTL, devctl, &err);
-			BRCMF_INFO(("CLKCTL: set PENDING\n"));
+			brcmf_dbg(INFO, "CLKCTL: set PENDING\n");
 			bus->clkstate = CLK_PENDING;
 
 			return 0;
@@ -1067,26 +1065,23 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 				usleep_range(5000, 10000);
 		}
 		if (err) {
-			BRCMF_ERROR(("%s: HT Avail request error: %d\n",
-				     __func__, err));
+			brcmf_dbg(ERROR, "HT Avail request error: %d\n", err);
 			return -EBADE;
 		}
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			BRCMF_ERROR(("%s: HT Avail timeout (%d): "
-				     "clkctl 0x%02x\n", __func__,
-				     PMU_MAX_TRANSITION_DLY, clkctl));
+			brcmf_dbg(ERROR, "HT Avail timeout (%d): clkctl 0x%02x\n",
+				  PMU_MAX_TRANSITION_DLY, clkctl);
 			return -EBADE;
 		}
 
 		/* Mark clock available */
 		bus->clkstate = CLK_AVAIL;
-		BRCMF_INFO(("CLKCTL: turned ON\n"));
+		brcmf_dbg(INFO, "CLKCTL: turned ON\n");
 
 #if defined(BCMDBG)
 		if (bus->alp_only != true) {
 			if (SBSDIO_ALPONLY(clkctl))
-				BRCMF_ERROR(("%s: HT Clock should be on.\n",
-					     __func__));
+				brcmf_dbg(ERROR, "HT Clock should be on\n");
 		}
 #endif				/* defined (BCMDBG) */
 
@@ -1107,10 +1102,10 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 		bus->clkstate = CLK_SDONLY;
 		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, clkreq, &err);
-		BRCMF_INFO(("CLKCTL: turned OFF\n"));
+		brcmf_dbg(INFO, "CLKCTL: turned OFF\n");
 		if (err) {
-			BRCMF_ERROR(("%s: Failed access turning clock off:"
-				     " %d\n", __func__, err));
+			brcmf_dbg(ERROR, "Failed access turning clock off: %d\n",
+				  err);
 			return -EBADE;
 		}
 	}
@@ -1120,7 +1115,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 /* Change idle/active SD state */
 static int brcmf_sdbrcm_sdclk(struct brcmf_bus *bus, bool on)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (on)
 		bus->clkstate = CLK_SDONLY;
@@ -1137,7 +1132,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 	uint oldstate = bus->clkstate;
 #endif				/* BCMDBG */
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Early exit if we're already there */
 	if (bus->clkstate == target) {
@@ -1166,8 +1161,8 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 		else if (bus->clkstate == CLK_AVAIL)
 			brcmf_sdbrcm_htclk(bus, false, false);
 		else
-			BRCMF_ERROR(("brcmf_sdbrcm_clkctl: request for %d -> %d"
-				     "\n", bus->clkstate, target));
+			brcmf_dbg(ERROR, "request for %d -> %d\n",
+				  bus->clkstate, target);
 		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
 		break;
 
@@ -1181,8 +1176,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 		break;
 	}
 #ifdef BCMDBG
-	BRCMF_INFO(("brcmf_sdbrcm_clkctl: %d -> %d\n",
-		    oldstate, bus->clkstate));
+	brcmf_dbg(INFO, "%d -> %d\n", oldstate, bus->clkstate);
 #endif				/* BCMDBG */
 
 	return 0;
@@ -1192,9 +1186,9 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 {
 	uint retries = 0;
 
-	BRCMF_INFO(("brcmf_sdbrcm_bussleep: request %s (currently %s)\n",
-		    (sleep ? "SLEEP" : "WAKE"),
-		    (bus->sleeping ? "SLEEP" : "WAKE")));
+	brcmf_dbg(INFO, "request %s (currently %s)\n",
+		  sleep ? "SLEEP" : "WAKE",
+		  bus->sleeping ? "SLEEP" : "WAKE");
 
 	/* Done if we're already in the requested state */
 	if (sleep == bus->sleeping)
@@ -1213,8 +1207,7 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		w_sdreg32(bus, SMB_USE_OOB,
 			  offsetof(struct sdpcmd_regs, tosbmailbox), &retries);
 		if (retries > retry_limit)
-			BRCMF_ERROR(("CANNOT SIGNAL CHIP, "
-				     "WILL NOT WAKE UP!!\n"));
+			brcmf_dbg(ERROR, "CANNOT SIGNAL CHIP, WILL NOT WAKE UP!!\n");
 
 		/* Turn off our contribution to the HT clock request */
 		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
@@ -1258,7 +1251,7 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 				  &retries);
 
 		if (retries > retry_limit)
-			BRCMF_ERROR(("CANNOT SIGNAL CHIP TO CLEAR OOB!!\n"));
+			brcmf_dbg(ERROR, "CANNOT SIGNAL CHIP TO CLEAR OOB!!\n");
 
 		/* Make sure we have SD bus access */
 		brcmf_sdbrcm_clkctl(bus, CLK_SDONLY, false);
@@ -1289,7 +1282,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 	struct sk_buff *new;
 	int i;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->drvr->dongle_reset) {
 		ret = -EPERM;
@@ -1302,14 +1295,13 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 	pad = ((unsigned long)frame % BRCMF_SDALIGN);
 	if (pad) {
 		if (skb_headroom(pkt) < pad) {
-			BRCMF_INFO(("%s: insufficient headroom %d for %d pad\n",
-				    __func__, skb_headroom(pkt), pad));
+			brcmf_dbg(INFO, "insufficient headroom %d for %d pad\n",
+				  skb_headroom(pkt), pad);
 			bus->drvr->tx_realloc++;
 			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
 			if (!new) {
-				BRCMF_ERROR(("%s: couldn't allocate new "
-					     "%d-byte packet\n", __func__,
-					     pkt->len + BRCMF_SDALIGN));
+				brcmf_dbg(ERROR, "couldn't allocate new %d-byte packet\n",
+					  pkt->len + BRCMF_SDALIGN);
 				ret = -ENOMEM;
 				goto done;
 			}
@@ -1383,8 +1375,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 		if (ret < 0) {
 			/* On failure, abort the command
 			 and terminate the frame */
-			BRCMF_INFO(("%s: sdio error %d, abort command and "
-				    "terminate frame.\n", __func__, ret));
+			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
+				  ret);
 			bus->tx_sderrs++;
 
 			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
@@ -1432,7 +1424,7 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 	int ret = -EBADE;
 	uint datalen, prec;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	datalen = pkt->len;
 
@@ -1448,8 +1440,8 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 	    || bus->dpc_sched || (!DATAOK(bus))
 	    || (bus->flowcontrol & NBITVAL(prec))
 	    || (bus->clkstate != CLK_AVAIL)) {
-		BRCMF_TRACE(("%s: deferring pktq len %d\n", __func__,
-			     pktq_len(&bus->txq)));
+		brcmf_dbg(TRACE, "deferring pktq len %d\n",
+			  pktq_len(&bus->txq));
 		bus->fcqueued++;
 
 		/* Priority based enq */
@@ -1459,7 +1451,7 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 			skb_pull(pkt, SDPCM_HDRLEN);
 			brcmf_txcomplete(bus->drvr, pkt, false);
 			brcmu_pkt_buf_free_skb(pkt);
-			BRCMF_ERROR(("%s: out of bus->txq !!!\n", __func__));
+			brcmf_dbg(ERROR, "out of bus->txq !!!\n");
 			ret = -ENOSR;
 		} else {
 			ret = 0;
@@ -1487,7 +1479,7 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 		/* Make sure back plane ht clk is on, no pending allowed */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, true);
 
-		BRCMF_TRACE(("%s: calling txpkt\n", __func__));
+		brcmf_dbg(TRACE, "calling txpkt\n");
 		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
 		if (ret)
 			bus->drvr->tx_errors++;
@@ -1518,7 +1510,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 
 	struct brcmf_pub *drvr = bus->drvr;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	tx_prec_map = ~bus->flowcontrol;
 
@@ -1572,7 +1564,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	int ret = -1;
 	int i;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->drvr->dongle_reset)
 		return -EIO;
@@ -1631,9 +1623,8 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	put_unaligned_le32(0, frame + SDPCM_FRAMETAG_LEN + sizeof(swheader));
 
 	if (!DATAOK(bus)) {
-		BRCMF_INFO(("%s: No bus credit bus->tx_max %d,"
-			    " bus->tx_seq %d\n", __func__,
-			    bus->tx_max, bus->tx_seq));
+		brcmf_dbg(INFO, "No bus credit bus->tx_max %d, bus->tx_seq %d\n",
+			  bus->tx_max, bus->tx_seq);
 		bus->ctrl_frame_stat = true;
 		/* Send from dpc */
 		bus->ctrl_frame_buf = frame;
@@ -1642,11 +1633,10 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 		brcmf_sdbrcm_wait_for_event(bus, &bus->ctrl_frame_stat);
 
 		if (bus->ctrl_frame_stat == false) {
-			BRCMF_INFO(("%s: ctrl_frame_stat == false\n",
-				    __func__));
+			brcmf_dbg(INFO, "ctrl_frame_stat == false\n");
 			ret = 0;
 		} else {
-			BRCMF_INFO(("%s: ctrl_frame_stat == true\n", __func__));
+			brcmf_dbg(INFO, "ctrl_frame_stat == true\n");
 			ret = -1;
 		}
 	}
@@ -1674,9 +1664,8 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 			if (ret < 0) {
 				/* On failure, abort the command and
 				 terminate the frame */
-				BRCMF_INFO(("%s: sdio error %d, abort command "
-					    "and terminate frame.\n",
-					    __func__, ret));
+				brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
+					  ret);
 				bus->tx_sderrs++;
 
 				brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
@@ -1732,7 +1721,7 @@ brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	uint rxlen = 0;
 	bool pending;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->drvr->dongle_reset)
 		return -EIO;
@@ -1747,20 +1736,20 @@ brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	brcmf_sdbrcm_sdunlock(bus);
 
 	if (rxlen) {
-		BRCMF_CTL(("%s: resumed on rxctl frame, got %d expected %d\n",
-			   __func__, rxlen, msglen));
+		brcmf_dbg(CTL, "resumed on rxctl frame, got %d expected %d\n",
+			  rxlen, msglen);
 	} else if (timeleft == 0) {
-		BRCMF_ERROR(("%s: resumed on timeout\n", __func__));
+		brcmf_dbg(ERROR, "resumed on timeout\n");
 #ifdef BCMDBG
 		brcmf_sdbrcm_sdlock(bus);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
 		brcmf_sdbrcm_sdunlock(bus);
 #endif				/* BCMDBG */
 	} else if (pending == true) {
-		BRCMF_CTL(("%s: cancelled\n", __func__));
+		brcmf_dbg(CTL, "cancelled\n");
 		return -ERESTARTSYS;
 	} else {
-		BRCMF_CTL(("%s: resumed for unknown reason?\n", __func__));
+		brcmf_dbg(CTL, "resumed for unknown reason?\n");
 #ifdef BCMDBG
 		brcmf_sdbrcm_sdlock(bus);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
@@ -1984,20 +1973,19 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 	/* Set the backplane window to include the start address */
 	bcmerror = brcmf_sdbrcm_set_siaddr_window(bus, address);
 	if (bcmerror) {
-		BRCMF_ERROR(("%s: window change failed\n", __func__));
+		brcmf_dbg(ERROR, "window change failed\n");
 		goto xfer_done;
 	}
 
 	/* Do the transfer(s) */
 	while (size) {
-		BRCMF_INFO(("%s: %s %d bytes at offset 0x%08x in window"
-			    " 0x%08x\n", __func__, (write ? "write" : "read"),
-			    dsize, sdaddr, (address & SBSDIO_SBWINDOW_MASK)));
+		brcmf_dbg(INFO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
+			  write ? "write" : "read", dsize,
+			  sdaddr, address & SBSDIO_SBWINDOW_MASK);
 		bcmerror = brcmf_sdcard_rwdata(bus->sdiodev, write,
 					       sdaddr, data, dsize);
 		if (bcmerror) {
-			BRCMF_ERROR(("%s: membytes transfer failed\n",
-				     __func__));
+			brcmf_dbg(ERROR, "membytes transfer failed\n");
 			break;
 		}
 
@@ -2008,8 +1996,7 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 			address += dsize;
 			bcmerror = brcmf_sdbrcm_set_siaddr_window(bus, address);
 			if (bcmerror) {
-				BRCMF_ERROR(("%s: window change failed\n",
-					     __func__));
+				brcmf_dbg(ERROR, "window change failed\n");
 				break;
 			}
 			sdaddr = 0;
@@ -2022,8 +2009,8 @@ xfer_done:
 	if (brcmf_sdbrcm_set_siaddr_window(bus,
 					   brcmf_sdcard_cur_sbwad(
 							bus->sdiodev)))
-		BRCMF_ERROR(("%s: FAILED to set window back to 0x%x\n",
-			     __func__, brcmf_sdcard_cur_sbwad(bus->sdiodev)));
+		brcmf_dbg(ERROR, "FAILED to set window back to 0x%x\n",
+			  brcmf_sdcard_cur_sbwad(bus->sdiodev));
 
 	return bcmerror;
 }
@@ -2044,15 +2031,15 @@ brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
 
 	addr = le32_to_cpu(addr);
 
-	BRCMF_INFO(("sdpcm_shared address 0x%08X\n", addr));
+	brcmf_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
 
 	/*
 	 * Check if addr is valid.
 	 * NVRAM length at the end of memory should have been overwritten.
 	 */
 	if (addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff)) {
-		BRCMF_ERROR(("%s: address (0x%08x) of sdpcm_shared invalid\n",
-			     __func__, addr));
+		brcmf_dbg(ERROR, "address (0x%08x) of sdpcm_shared invalid\n",
+			  addr);
 		return -EBADE;
 	}
 
@@ -2072,10 +2059,9 @@ brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
 	sh->msgtrace_addr = le32_to_cpu(sh->msgtrace_addr);
 
 	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
-		BRCMF_ERROR(("%s: sdpcm_shared version %d in brcmf "
-			     "is different than sdpcm_shared version %d in dongle\n",
-			     __func__, SDPCM_SHARED_VERSION,
-			     sh->flags & SDPCM_SHARED_VERSION_MASK));
+		brcmf_dbg(ERROR, "sdpcm_shared version %d in brcmf is different than sdpcm_shared version %d in dongle\n",
+			  SDPCM_SHARED_VERSION,
+			  sh->flags & SDPCM_SHARED_VERSION_MASK);
 		return -EBADE;
 	}
 
@@ -2093,7 +2079,7 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 	struct sdpcm_shared sdpcm_shared;
 	struct brcmu_strbuf strbuf;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (data == NULL) {
 		/*
@@ -2103,8 +2089,7 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 		size = msize;
 		mbuffer = data = kmalloc(msize, GFP_ATOMIC);
 		if (mbuffer == NULL) {
-			BRCMF_ERROR(("%s: kmalloc(%d) failed\n", __func__,
-				     msize));
+			brcmf_dbg(ERROR, "kmalloc(%d) failed\n", msize);
 			bcmerror = -ENOMEM;
 			goto done;
 		}
@@ -2112,7 +2097,7 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 
 	str = kmalloc(maxstrlen, GFP_ATOMIC);
 	if (str == NULL) {
-		BRCMF_ERROR(("%s: kmalloc(%d) failed\n", __func__, maxstrlen));
+		brcmf_dbg(ERROR, "kmalloc(%d) failed\n", maxstrlen);
 		bcmerror = -ENOMEM;
 		goto done;
 	}
@@ -2194,7 +2179,7 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 	}
 
 	if (sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP))
-		BRCMF_ERROR(("%s: %s\n", __func__, strbuf.origbuf));
+		brcmf_dbg(ERROR, "%s\n", strbuf.origbuf);
 
 #ifdef BCMDBG
 	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP)
@@ -2222,7 +2207,7 @@ static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
 	size = bus->ramsize;
 	buf = kmalloc(size, GFP_ATOMIC);
 	if (!buf) {
-		BRCMF_ERROR(("%s: Out of memory (%d bytes)\n", __func__, size));
+		brcmf_dbg(ERROR, "Out of memory (%d bytes)\n", size);
 		return -1;
 	}
 
@@ -2234,7 +2219,7 @@ static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
 		ret = brcmf_sdbrcm_membytes(bus, false, start, databuf,
 					  read_size);
 		if (ret) {
-			BRCMF_ERROR(("%s: Error membytes %d\n", __func__, ret));
+			brcmf_dbg(ERROR, "Error membytes %d\n", ret);
 			kfree(buf);
 			return -1;
 		}
@@ -2249,7 +2234,7 @@ static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
 
 	/* free buf before return !!! */
 	if (brcmf_write_to_file(bus->drvr, buf, bus->ramsize)) {
-		BRCMF_ERROR(("%s: Error writing to files\n", __func__));
+		brcmf_dbg(ERROR, "Error writing to files\n");
 		return -1;
 	}
 
@@ -2340,7 +2325,7 @@ int brcmf_sdbrcm_downloadvars(struct brcmf_bus *bus, void *arg, int len)
 {
 	int bcmerror = 0;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Basic sanity checks */
 	if (bus->drvr->up) {
@@ -2378,9 +2363,8 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 	s32 int_val = 0;
 	bool bool_val = 0;
 
-	BRCMF_TRACE(("%s: Enter, action %d name %s params %p plen %d arg %p "
-		     "len %d val_size %d\n", __func__, actionid, name, params,
-		     plen, arg, len, val_size));
+	brcmf_dbg(TRACE, "Enter, action %d name %s params %p plen %d arg %p len %d val_size %d\n",
+		  actionid, name, params, plen, arg, len, val_size);
 
 	bcmerror = brcmu_iovar_lencheck(vi, arg, len, IOV_ISSET(actionid));
 	if (bcmerror != 0)
@@ -2476,25 +2460,22 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 			/* Do some validation */
 			dsize = set ? plen - (2 * sizeof(int)) : len;
 			if (dsize < size) {
-				BRCMF_ERROR(("%s: error on %s membytes, addr "
-					     "0x%08x size %d dsize %d\n",
-					     __func__, (set ? "set" : "get"),
-					     address, size, dsize));
+				brcmf_dbg(ERROR, "error on %s membytes, addr 0x%08x size %d dsize %d\n",
+					  set ? "set" : "get",
+					  address, size, dsize);
 				bcmerror = -EINVAL;
 				break;
 			}
 
-			BRCMF_INFO(("%s: Request to %s %d bytes at address "
-				    "0x%08x\n", __func__,
-				    (set ? "write" : "read"), size, address));
+			brcmf_dbg(INFO, "Request to %s %d bytes at address 0x%08x\n",
+				  set ? "write" : "read", size, address);
 
 			/* If we know about SOCRAM, check for a fit */
 			if ((bus->orig_ramsize) &&
 			    ((address > bus->orig_ramsize)
 			     || (address + size > bus->orig_ramsize))) {
-				BRCMF_ERROR(("%s: ramsize 0x%08x doesn't have"
-					     " %d bytes at 0x%08x\n", __func__,
-					     bus->orig_ramsize, size, address));
+				brcmf_dbg(ERROR, "ramsize 0x%08x doesn't have %d bytes at 0x%08x\n",
+					  bus->orig_ramsize, size, address);
 				bcmerror = -EINVAL;
 				break;
 			}
@@ -2721,17 +2702,16 @@ static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
 #endif				/* BCMDBG */
 
 	case IOV_SVAL(IOV_DEVRESET):
-		BRCMF_TRACE(("%s: Called set IOV_DEVRESET=%d dongle_reset=%d "
-			     "busstate=%d\n",
-			     __func__, bool_val, bus->drvr->dongle_reset,
-			     bus->drvr->busstate));
+		brcmf_dbg(TRACE, "Called set IOV_DEVRESET=%d dongle_reset=%d busstate=%d\n",
+			  bool_val, bus->drvr->dongle_reset,
+			  bus->drvr->busstate);
 
 		brcmf_bus_devreset(bus->drvr, (u8) bool_val);
 
 		break;
 
 	case IOV_GVAL(IOV_DEVRESET):
-		BRCMF_TRACE(("%s: Called get IOV_DEVRESET\n", __func__));
+		brcmf_dbg(TRACE, "Called get IOV_DEVRESET\n");
 
 		/* Get its status */
 		int_val = (bool) bus->drvr->dongle_reset;
@@ -2813,7 +2793,7 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 		    brcmf_sdbrcm_membytes(bus, true, varaddr, vbuffer, varsize);
 #ifdef BCMDBG
 		/* Verify NVRAM bytes */
-		BRCMF_INFO(("Compare NVRAM dl & ul; varsize=%d\n", varsize));
+		brcmf_dbg(INFO, "Compare NVRAM dl & ul; varsize=%d\n", varsize);
 		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
 		if (!nvram_ularray)
 			return -ENOMEM;
@@ -2826,17 +2806,14 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 		    brcmf_sdbrcm_membytes(bus, false, varaddr, nvram_ularray,
 				     varsize);
 		if (bcmerror) {
-			BRCMF_ERROR(("%s: error %d on reading %d nvram bytes"
-				     " at 0x%08x\n", __func__, bcmerror,
-				     varsize, varaddr));
+			brcmf_dbg(ERROR, "error %d on reading %d nvram bytes at 0x%08x\n",
+				  bcmerror, varsize, varaddr);
 		}
 		/* Compare the org NVRAM with the one read from RAM */
 		if (memcmp(vbuffer, nvram_ularray, varsize))
-			BRCMF_ERROR(("%s: Downloaded NVRAM image is "
-				     "corrupted.\n", __func__));
+			brcmf_dbg(ERROR, "Downloaded NVRAM image is corrupted\n");
 		else
-			BRCMF_ERROR(("%s: Download/Upload/Compare of"
-				     " NVRAM ok.\n", __func__));
+			brcmf_dbg(ERROR, "Download/Upload/Compare of NVRAM ok\n");
 
 		kfree(nvram_ularray);
 #endif				/* BCMDBG */
@@ -2845,9 +2822,10 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 	}
 
 	/* adjust to the user specified RAM */
-	BRCMF_INFO(("Physical memory size: %d, usable memory size: %d\n",
-		    bus->orig_ramsize, bus->ramsize));
-	BRCMF_INFO(("Vars are at %d, orig varsize is %d\n", varaddr, varsize));
+	brcmf_dbg(INFO, "Physical memory size: %d, usable memory size: %d\n",
+		  bus->orig_ramsize, bus->ramsize);
+	brcmf_dbg(INFO, "Vars are at %d, orig varsize is %d\n",
+		  varaddr, varsize);
 	varsize = ((bus->orig_ramsize - 4) - varaddr);
 
 	/*
@@ -2863,8 +2841,8 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 		varsizew = cpu_to_le32(varsizew);
 	}
 
-	BRCMF_INFO(("New varsize is %d, length token=0x%08x\n", varsize,
-		    varsizew));
+	brcmf_dbg(INFO, "New varsize is %d, length token=0x%08x\n",
+		  varsize, varsizew);
 
 	/* Write the length token to the last word */
 	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->orig_ramsize - 4),
@@ -2902,15 +2880,14 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 		regdata &= (SBTML_RESET | SBTML_REJ_MASK |
 			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 		if ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) != regdata) {
-			BRCMF_ERROR(("%s: SOCRAM core is down after reset?\n",
-				     __func__));
+			brcmf_dbg(ERROR, "SOCRAM core is down after reset?\n");
 			bcmerror = -EBADE;
 			goto fail;
 		}
 
 		bcmerror = brcmf_sdbrcm_write_vars(bus);
 		if (bcmerror) {
-			BRCMF_ERROR(("%s: no vars written to RAM\n", __func__));
+			brcmf_dbg(ERROR, "no vars written to RAM\n");
 			bcmerror = 0;
 		}
 
@@ -2938,7 +2915,7 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 	int val_size;
 	u32 actionid;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (name == NULL || len < 0)
 		return -EINVAL;
@@ -2974,8 +2951,8 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 		goto exit;
 	}
 
-	BRCMF_CTL(("%s: %s %s, len %d plen %d\n", __func__,
-		   name, (set ? "set" : "get"), len, plen));
+	brcmf_dbg(CTL, "%s %s, len %d plen %d\n",
+		  name, set ? "set" : "get", len, plen);
 
 	/* set up 'params' pointer in case this is a set command so that
 	 * the convenience int and bool code can be common to set and get
@@ -3008,7 +2985,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 	uint retries;
 	int err;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (enforce_mutex)
 		brcmf_sdbrcm_sdlock(bus);
@@ -3048,11 +3025,10 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err)
-		BRCMF_ERROR(("%s: Failed to force clock for F2: err %d\n",
-			     __func__, err));
+		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
 
 	/* Turn off the bus (F2), free any pending packets */
-	BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
+	brcmf_dbg(INTR, "disable SDIO interrupts\n");
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
 			 SDIO_FUNC_ENABLE_1, NULL);
 
@@ -3096,7 +3072,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	int err, ret = 0;
 	u8 saveclk;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* try to download image and nvram to the dongle */
 	if (drvr->busstate == BRCMF_BUS_DOWN) {
@@ -3129,8 +3105,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
-		BRCMF_ERROR(("%s: Failed to force clock for F2: err %d\n",
-			     __func__, err));
+		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
 		goto exit;
 	}
 
@@ -3154,8 +3129,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 			msleep_interruptible(20);
 	}
 
-	BRCMF_INFO(("%s: enable 0x%02x, ready 0x%02x\n",
-		    __func__, enable, ready));
+	brcmf_dbg(INFO, "enable 0x%02x, ready 0x%02x\n", enable, ready);
 
 	/* If F2 successfully enabled, set core and enable interrupts */
 	if (ready == enable) {
@@ -3186,8 +3160,7 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	/* Host registration for OOB interrupt */
 	if (brcmf_sdio_register_oob_intr(bus->dhd)) {
 		brcmf_sdbrcm_wd_timer(bus, 0);
-		BRCMF_ERROR(("%s Host failed to resgister for OOB\n",
-			     __func__));
+		brcmf_dbg(ERROR, "Host failed to resgister for OOB\n");
 		ret = -ENODEV;
 		goto exit;
 	}
@@ -3214,9 +3187,9 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 	u8 hi, lo;
 	int err;
 
-	BRCMF_ERROR(("%s: %sterminate frame%s\n", __func__,
-		     (abort ? "abort command, " : ""),
-		     (rtx ? ", send NAK" : "")));
+	brcmf_dbg(ERROR, "%sterminate frame%s\n",
+		  abort ? "abort command, " : "",
+		  rtx ? ", send NAK" : "");
 
 	if (abort)
 		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
@@ -3238,19 +3211,16 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 			break;
 
 		if ((hi > (lastrbc >> 8)) && (lo > (lastrbc & 0x00ff))) {
-			BRCMF_ERROR(("%s: count growing: last 0x%04x now "
-				     "0x%04x\n",
-				     __func__, lastrbc, ((hi << 8) + lo)));
+			brcmf_dbg(ERROR, "count growing: last 0x%04x now 0x%04x\n",
+				  lastrbc, (hi << 8) + lo);
 		}
 		lastrbc = (hi << 8) + lo;
 	}
 
 	if (!retries)
-		BRCMF_ERROR(("%s: count never zeroed: last 0x%04x\n",
-			     __func__, lastrbc));
+		brcmf_dbg(ERROR, "count never zeroed: last 0x%04x\n", lastrbc);
 	else
-		BRCMF_INFO(("%s: flush took %d iterations\n", __func__,
-			    (0xffff - retries)));
+		brcmf_dbg(INFO, "flush took %d iterations\n", 0xffff - retries);
 
 	if (rtx) {
 		bus->rxrtx++;
@@ -3277,7 +3247,7 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	int sdret;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Set rxctl for frame (w/optional alignment) */
 	bus->rxctl = bus->rxbuf;
@@ -3311,17 +3281,16 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	/* Drop if the read is too big or it exceeds our maximum */
 	if ((rdlen + firstread) > bus->drvr->maxctl) {
-		BRCMF_ERROR(("%s: %d-byte control read exceeds %d-byte"
-			     " buffer\n", __func__, rdlen, bus->drvr->maxctl));
+		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte buffer\n",
+			  rdlen, bus->drvr->maxctl);
 		bus->drvr->rx_errors++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		goto done;
 	}
 
 	if ((len - doff) > bus->drvr->maxctl) {
-		BRCMF_ERROR(("%s: %d-byte ctl frame (%d-byte ctl data) exceeds "
-			     "%d-byte limit\n",
-			     __func__, len, (len - doff), bus->drvr->maxctl));
+		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
+			  len, len - doff, bus->drvr->maxctl);
 		bus->drvr->rx_errors++;
 		bus->rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
@@ -3338,8 +3307,8 @@ brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
 
 	/* Control frame failures need retransmission */
 	if (sdret < 0) {
-		BRCMF_ERROR(("%s: read %d control bytes failed: %d\n",
-			     __func__, rdlen, sdret));
+		brcmf_dbg(ERROR, "read %d control bytes failed: %d\n",
+			  rdlen, sdret);
 		bus->rxc_errors++;
 		brcmf_sdbrcm_rxfail(bus, true, true);
 		goto done;
@@ -3381,8 +3350,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 	/* If packets, issue read(s) and send up packet chain */
 	/* Return sequence numbers consumed? */
 
-	BRCMF_TRACE(("brcmf_sdbrcm_rxglom: start: glomd %p glom %p\n",
-		     bus->glomd, bus->glom));
+	brcmf_dbg(TRACE, "start: glomd %p glom %p\n", bus->glomd, bus->glom);
 
 	/* If there's a descriptor, generate the packet chain */
 	if (bus->glomd) {
@@ -3390,9 +3358,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		dlen = (u16) (bus->glomd->len);
 		dptr = bus->glomd->data;
 		if (!dlen || (dlen & 1)) {
-			BRCMF_ERROR(("%s: bad glomd len(%d),"
-				     " ignore descriptor\n",
-				     __func__, dlen));
+			brcmf_dbg(ERROR, "bad glomd len(%d), ignore descriptor\n",
+				  dlen);
 			dlen = 0;
 		}
 
@@ -3403,15 +3370,14 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			dptr += sizeof(u16);
 			if ((sublen < SDPCM_HDRLEN) ||
 			    ((num == 0) && (sublen < (2 * SDPCM_HDRLEN)))) {
-				BRCMF_ERROR(("%s: descriptor len %d bad: %d\n",
-					     __func__, num, sublen));
+				brcmf_dbg(ERROR, "descriptor len %d bad: %d\n",
+					  num, sublen);
 				pnext = NULL;
 				break;
 			}
 			if (sublen % BRCMF_SDALIGN) {
-				BRCMF_ERROR(("%s: sublen %d not multiple of"
-					     " %d\n", __func__, sublen,
-					     BRCMF_SDALIGN));
+				brcmf_dbg(ERROR, "sublen %d not multiple of %d\n",
+					  sublen, BRCMF_SDALIGN);
 				usechain = false;
 			}
 			totlen += sublen;
@@ -3427,9 +3393,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			/* Allocate/chain packet for next subframe */
 			pnext = brcmu_pkt_buf_get_skb(sublen + BRCMF_SDALIGN);
 			if (pnext == NULL) {
-				BRCMF_ERROR(("%s: bcm_pkt_buf_get_skb failed, "
-					     "num %d len %d\n", __func__,
-					     num, sublen));
+				brcmf_dbg(ERROR, "bcm_pkt_buf_get_skb failed, num %d len %d\n",
+					  num, sublen);
 				break;
 			}
 			if (!pfirst) {
@@ -3446,15 +3411,12 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		/* If all allocations succeeded, save packet chain
 			 in bus structure */
 		if (pnext) {
-			BRCMF_GLOM(("%s: allocated %d-byte packet chain for %d "
-				    "subframes\n", __func__, totlen, num));
+			brcmf_dbg(GLOM, "allocated %d-byte packet chain for %d subframes\n",
+				  totlen, num);
 			if (BRCMF_GLOM_ON() && bus->nextlen) {
 				if (totlen != bus->nextlen) {
-					BRCMF_GLOM(("%s: glomdesc mismatch: "
-						    "nextlen %d glomdesc %d "
-						    "rxseq %d\n", __func__,
-						    bus->nextlen,
-						    totlen, rxseq));
+					brcmf_dbg(GLOM, "glomdesc mismatch: nextlen %d glomdesc %d rxseq %d\n",
+						  bus->nextlen, totlen, rxseq);
 				}
 			}
 			bus->glom = pfirst;
@@ -3476,12 +3438,11 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		 or had one from before */
 	if (bus->glom) {
 		if (BRCMF_GLOM_ON()) {
-			BRCMF_GLOM(("%s: try superframe read, packet chain:\n",
-				    __func__));
+			brcmf_dbg(GLOM, "try superframe read, packet chain:\n");
 			for (pnext = bus->glom; pnext; pnext = pnext->next) {
-				BRCMF_GLOM(("    %p: %p len 0x%04x (%d)\n",
-					    pnext, (u8 *) (pnext->data),
-					    pnext->len, pnext->len));
+				brcmf_dbg(GLOM, "    %p: %p len 0x%04x (%d)\n",
+					  pnext, (u8 *) (pnext->data),
+					  pnext->len, pnext->len);
 			}
 		}
 
@@ -3507,23 +3468,22 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			sublen = (u16) brcmu_pktfrombuf(pfirst, 0, dlen,
 						bus->dataptr);
 			if (sublen != dlen) {
-				BRCMF_ERROR(("%s: FAILED TO COPY, dlen %d "
-					     "sublen %d\n",
-					     __func__, dlen, sublen));
+				brcmf_dbg(ERROR, "FAILED TO COPY, dlen %d sublen %d\n",
+					  dlen, sublen);
 				errcode = -1;
 			}
 			pnext = NULL;
 		} else {
-			BRCMF_ERROR(("COULDN'T ALLOC %d-BYTE GLOM, "
-				     "FORCE FAILURE\n", dlen));
+			brcmf_dbg(ERROR, "COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
+				  dlen);
 			errcode = -1;
 		}
 		bus->f2rxdata++;
 
 		/* On failure, kill the superframe, allow a couple retries */
 		if (errcode < 0) {
-			BRCMF_ERROR(("%s: glom read of %d bytes failed: %d\n",
-				     __func__, dlen, errcode));
+			brcmf_dbg(ERROR, "glom read of %d bytes failed: %d\n",
+				  dlen, errcode);
 			bus->drvr->rx_errors++;
 
 			if (bus->glomerr++ < 3) {
@@ -3554,8 +3514,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 		seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
 		bus->nextlen = dptr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
 		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			BRCMF_INFO(("%s: nextlen too large (%d) seq %d\n",
-				    __func__, bus->nextlen, seq));
+			brcmf_dbg(INFO, "nextlen too large (%d) seq %d\n",
+				  bus->nextlen, seq);
 			bus->nextlen = 0;
 		}
 		doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
@@ -3563,48 +3523,42 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 		errcode = 0;
 		if ((u16)~(sublen ^ check)) {
-			BRCMF_ERROR(("%s (superframe): HW hdr error: len/check "
-				     "0x%04x/0x%04x\n", __func__, sublen,
-				     check));
+			brcmf_dbg(ERROR, "(superframe): HW hdr error: len/check 0x%04x/0x%04x\n",
+				  sublen, check);
 			errcode = -1;
 		} else if (roundup(sublen, bus->blocksize) != dlen) {
-			BRCMF_ERROR(("%s (superframe): len 0x%04x, rounded "
-				     "0x%04x, expect 0x%04x\n",
-				     __func__, sublen,
-				     roundup(sublen, bus->blocksize), dlen));
+			brcmf_dbg(ERROR, "(superframe): len 0x%04x, rounded 0x%04x, expect 0x%04x\n",
+				  sublen, roundup(sublen, bus->blocksize),
+				  dlen);
 			errcode = -1;
 		} else if (SDPCM_PACKET_CHANNEL(&dptr[SDPCM_FRAMETAG_LEN]) !=
 			   SDPCM_GLOM_CHANNEL) {
-			BRCMF_ERROR(("%s (superframe): bad channel %d\n",
-				   __func__,
-				   SDPCM_PACKET_CHANNEL(&dptr
-							[SDPCM_FRAMETAG_LEN])));
+			brcmf_dbg(ERROR, "(superframe): bad channel %d\n",
+				  SDPCM_PACKET_CHANNEL(
+					  &dptr[SDPCM_FRAMETAG_LEN]));
 			errcode = -1;
 		} else if (SDPCM_GLOMDESC(&dptr[SDPCM_FRAMETAG_LEN])) {
-			BRCMF_ERROR(("%s (superframe): got 2nd descriptor?\n",
-				     __func__));
+			brcmf_dbg(ERROR, "(superframe): got 2nd descriptor?\n");
 			errcode = -1;
 		} else if ((doff < SDPCM_HDRLEN) ||
 			   (doff > (pfirst->len - SDPCM_HDRLEN))) {
-			BRCMF_ERROR(("%s (superframe): Bad data offset %d: "
-				     "HW %d pkt %d min %d\n",
-				     __func__, doff, sublen,
-				     pfirst->len, SDPCM_HDRLEN));
+			brcmf_dbg(ERROR, "(superframe): Bad data offset %d: HW %d pkt %d min %d\n",
+				  doff, sublen, pfirst->len, SDPCM_HDRLEN);
 			errcode = -1;
 		}
 
 		/* Check sequence number of superframe SW header */
 		if (rxseq != seq) {
-			BRCMF_INFO(("%s: (superframe) rx_seq %d, expected %d\n",
-				    __func__, seq, rxseq));
+			brcmf_dbg(INFO, "(superframe) rx_seq %d, expected %d\n",
+				  seq, rxseq);
 			bus->rx_badseq++;
 			rxseq = seq;
 		}
 
 		/* Check window for sanity */
 		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			BRCMF_ERROR(("%s: unlikely tx max %d with tx_seq %d\n",
-				     __func__, txmax, bus->tx_seq));
+			brcmf_dbg(ERROR, "unlikely tx max %d with tx_seq %d\n",
+				  txmax, bus->tx_seq);
 			txmax = bus->tx_seq + 2;
 		}
 		bus->tx_max = txmax;
@@ -3631,25 +3585,21 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 #endif
 
 			if ((u16)~(sublen ^ check)) {
-				BRCMF_ERROR(("%s (subframe %d): HW hdr error: "
-					     "len/check 0x%04x/0x%04x\n",
-					     __func__, num, sublen, check));
+				brcmf_dbg(ERROR, "(subframe %d): HW hdr error: len/check 0x%04x/0x%04x\n",
+					  num, sublen, check);
 				errcode = -1;
 			} else if ((sublen > dlen) || (sublen < SDPCM_HDRLEN)) {
-				BRCMF_ERROR(("%s (subframe %d): length mismatch"
-					     ": len 0x%04x, expect 0x%04x\n",
-					     __func__, num, sublen, dlen));
+				brcmf_dbg(ERROR, "(subframe %d): length mismatch: len 0x%04x, expect 0x%04x\n",
+					  num, sublen, dlen);
 				errcode = -1;
 			} else if ((chan != SDPCM_DATA_CHANNEL) &&
 				   (chan != SDPCM_EVENT_CHANNEL)) {
-				BRCMF_ERROR(("%s (subframe %d): bad channel"
-					     " %d\n", __func__, num, chan));
+				brcmf_dbg(ERROR, "(subframe %d): bad channel %d\n",
+					  num, chan);
 				errcode = -1;
 			} else if ((doff < SDPCM_HDRLEN) || (doff > sublen)) {
-				BRCMF_ERROR(("%s (subframe %d): Bad data offset"
-					     " %d: HW %d min %d\n",
-					     __func__, num, doff, sublen,
-					     SDPCM_HDRLEN));
+				brcmf_dbg(ERROR, "(subframe %d): Bad data offset %d: HW %d min %d\n",
+					  num, doff, sublen, SDPCM_HDRLEN);
 				errcode = -1;
 			}
 		}
@@ -3687,17 +3637,16 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 			seq = SDPCM_PACKET_SEQUENCE(&dptr[SDPCM_FRAMETAG_LEN]);
 			doff = SDPCM_DOFFSET_VALUE(&dptr[SDPCM_FRAMETAG_LEN]);
 
-			BRCMF_GLOM(("%s: Get subframe %d, %p(%p/%d), sublen %d "
-				    "chan %d seq %d\n",
-				    __func__, num, pfirst, pfirst->data,
-				    pfirst->len, sublen, chan, seq));
+			brcmf_dbg(GLOM, "Get subframe %d, %p(%p/%d), sublen %d chan %d seq %d\n",
+				  num, pfirst, pfirst->data,
+				  pfirst->len, sublen, chan, seq);
 
 			/* precondition: chan == SDPCM_DATA_CHANNEL ||
 					 chan == SDPCM_EVENT_CHANNEL */
 
 			if (rxseq != seq) {
-				BRCMF_GLOM(("%s: rx_seq %d, expected %d\n",
-					    __func__, seq, rxseq));
+				brcmf_dbg(GLOM, "rx_seq %d, expected %d\n",
+					  seq, rxseq);
 				bus->rx_badseq++;
 				rxseq = seq;
 			}
@@ -3722,8 +3671,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 				continue;
 			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx,
 						       pfirst) != 0) {
-				BRCMF_ERROR(("%s: rx protocol error\n",
-					     __func__));
+				brcmf_dbg(ERROR, "rx protocol error\n");
 				bus->drvr->rx_errors++;
 				brcmu_pkt_buf_free_skb(pfirst);
 				if (plast)
@@ -3742,11 +3690,10 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 #ifdef BCMDBG
 			if (BRCMF_GLOM_ON()) {
-				BRCMF_GLOM(("%s subframe %d to stack, %p"
-					    "(%p/%d) nxt/lnk %p/%p\n",
-					    __func__, num, pfirst, pfirst->data,
-					    pfirst->len, pfirst->next,
-					    pfirst->prev));
+				brcmf_dbg(GLOM, "subframe %d to stack, %p (%p/%d) nxt/lnk %p/%p\n",
+					  num, pfirst, pfirst->data,
+					  pfirst->len, pfirst->next,
+					  pfirst->prev);
 				print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
 						pfirst->data,
 						min_t(int, pfirst->len, 32));
@@ -3786,7 +3733,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 	int ifidx = 0;
 	uint rxcount = 0;	/* Total frames read */
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Not finished unless we encounter no more frames indication */
 	*finished = false;
@@ -3798,10 +3745,10 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		/* Handle glomming separately */
 		if (bus->glom || bus->glomd) {
 			u8 cnt;
-			BRCMF_GLOM(("%s: calling rxglom: glomd %p, glom %p\n",
-				    __func__, bus->glomd, bus->glom));
+			brcmf_dbg(GLOM, "calling rxglom: glomd %p, glom %p\n",
+				  bus->glomd, bus->glom);
 			cnt = brcmf_sdbrcm_rxglom(bus, rxseq);
-			BRCMF_GLOM(("%s: rxglom returned %d\n", __func__, cnt));
+			brcmf_dbg(GLOM, "rxglom returned %d\n", cnt);
 			rxseq += cnt - 1;
 			rxleft = (rxleft > cnt) ? (rxleft - cnt) : 1;
 			continue;
@@ -3844,12 +3791,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			pkt = brcmu_pkt_buf_get_skb(rdlen + BRCMF_SDALIGN);
 			if (!pkt) {
 				/* Give up on data, request rtx of events */
-				BRCMF_ERROR(("%s (nextlen): "
-					     "brcmu_pkt_buf_get_skb "
-					     "failed:"
-					     " len %d rdlen %d expected"
-					     " rxseq %d\n", __func__,
-					     len, rdlen, rxseq));
+				brcmf_dbg(ERROR, "(nextlen): brcmu_pkt_buf_get_skb failed: len %d rdlen %d expected rxseq %d\n",
+					  len, rdlen, rxseq);
 				continue;
 			} else {
 				PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
@@ -3864,9 +3807,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 				bus->f2rxdata++;
 
 				if (sdret < 0) {
-					BRCMF_ERROR(("%s (nextlen): read %d"
-						     " bytes failed: %d\n",
-						     __func__, rdlen, sdret));
+					brcmf_dbg(ERROR, "(nextlen): read %d bytes failed: %d\n",
+						  rdlen, sdret);
 					brcmu_pkt_buf_free_skb(pkt);
 					bus->drvr->rx_errors++;
 					/* Force retry w/normal header read.
@@ -3887,18 +3829,15 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* All zeros means readahead info was bad */
 			if (!(len | check)) {
-				BRCMF_INFO(("%s (nextlen): read zeros in HW "
-					    "header???\n", __func__));
+				brcmf_dbg(INFO, "(nextlen): read zeros in HW header???\n");
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
 
 			/* Validate check bytes */
 			if ((u16)~(len ^ check)) {
-				BRCMF_ERROR(("%s (nextlen): HW hdr error:"
-					     " nextlen/len/check"
-					     " 0x%04x/0x%04x/0x%04x\n",
-					     __func__, nextlen, len, check));
+				brcmf_dbg(ERROR, "(nextlen): HW hdr error: nextlen/len/check 0x%04x/0x%04x/0x%04x\n",
+					  nextlen, len, check);
 				bus->rx_badhdr++;
 				brcmf_sdbrcm_rxfail(bus, false, false);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
@@ -3907,8 +3846,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* Validate frame length */
 			if (len < SDPCM_HDRLEN) {
-				BRCMF_ERROR(("%s (nextlen): HW hdr length "
-					     "invalid: %d\n", __func__, len));
+				brcmf_dbg(ERROR, "(nextlen): HW hdr length invalid: %d\n",
+					  len);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
 			}
@@ -3918,11 +3857,9 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			if (len_consistent) {
 				/* Mismatch, force retry w/normal
 					header (may be >4K) */
-				BRCMF_ERROR(("%s (nextlen): mismatch, "
-					     "nextlen %d len %d rnd %d; "
-					     "expected rxseq %d\n",
-					     __func__, nextlen,
-					     len, roundup(len, 16), rxseq));
+				brcmf_dbg(ERROR, "(nextlen): mismatch, nextlen %d len %d rnd %d; expected rxseq %d\n",
+					  nextlen, len, roundup(len, 16),
+					  rxseq);
 				brcmf_sdbrcm_rxfail(bus, true, true);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
@@ -3942,9 +3879,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 			    bus->rxhdr[SDPCM_FRAMETAG_LEN +
 				       SDPCM_NEXTLEN_OFFSET];
 			if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-				BRCMF_INFO(("%s (nextlen): got frame w/nextlen"
-					    " too large (%d), seq %d\n",
-					    __func__, bus->nextlen, seq));
+				brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
+					  bus->nextlen, seq);
 				bus->nextlen = 0;
 			}
 
@@ -3967,17 +3903,16 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* Check and update sequence number */
 			if (rxseq != seq) {
-				BRCMF_INFO(("%s (nextlen): rx_seq %d, expected "
-					    "%d\n", __func__, seq, rxseq));
+				brcmf_dbg(INFO, "(nextlen): rx_seq %d, expected %d\n",
+					  seq, rxseq);
 				bus->rx_badseq++;
 				rxseq = seq;
 			}
 
 			/* Check window for sanity */
 			if ((u8) (txmax - bus->tx_seq) > 0x40) {
-				BRCMF_ERROR(("%s: got unlikely tx max %d with "
-					     "tx_seq %d\n",
-					     __func__, txmax, bus->tx_seq));
+				brcmf_dbg(ERROR, "got unlikely tx max %d with tx_seq %d\n",
+					  txmax, bus->tx_seq);
 				txmax = bus->tx_seq + 2;
 			}
 			bus->tx_max = txmax;
@@ -3995,9 +3930,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 #endif
 
 			if (chan == SDPCM_CONTROL_CHANNEL) {
-				BRCMF_ERROR(("%s (nextlen): readahead"
-					     " on control packet %d?\n",
-					     __func__, seq));
+				brcmf_dbg(ERROR, "(nextlen): readahead on control packet %d?\n",
+					  seq);
 				/* Force retry w/normal header read */
 				bus->nextlen = 0;
 				brcmf_sdbrcm_rxfail(bus, false, true);
@@ -4007,9 +3941,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 			/* Validate data offset */
 			if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-				BRCMF_ERROR(("%s (nextlen): bad data offset %d:"
-					     " HW len %d min %d\n", __func__,
-					     doff, len, SDPCM_HDRLEN));
+				brcmf_dbg(ERROR, "(nextlen): bad data offset %d: HW len %d min %d\n",
+					  doff, len, SDPCM_HDRLEN);
 				brcmf_sdbrcm_rxfail(bus, false, false);
 				brcmf_sdbrcm_pktfree2(bus, pkt);
 				continue;
@@ -4027,8 +3960,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		bus->f2rxhdrs++;
 
 		if (sdret < 0) {
-			BRCMF_ERROR(("%s: RXHEADER FAILED: %d\n", __func__,
-				     sdret));
+			brcmf_dbg(ERROR, "RXHEADER FAILED: %d\n", sdret);
 			bus->rx_hdrfail++;
 			brcmf_sdbrcm_rxfail(bus, true, true);
 			continue;
@@ -4053,8 +3985,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Validate check bytes */
 		if ((u16) ~(len ^ check)) {
-			BRCMF_ERROR(("%s: HW hdr err: len/check "
-				     "0x%04x/0x%04x\n", __func__, len, check));
+			brcmf_dbg(ERROR, "HW hdr err: len/check 0x%04x/0x%04x\n",
+				  len, check);
 			bus->rx_badhdr++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
@@ -4062,8 +3994,7 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Validate frame length */
 		if (len < SDPCM_HDRLEN) {
-			BRCMF_ERROR(("%s: HW hdr length invalid: %d\n",
-				     __func__, len));
+			brcmf_dbg(ERROR, "HW hdr length invalid: %d\n", len);
 			continue;
 		}
 
@@ -4075,9 +4006,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Validate data offset */
 		if ((doff < SDPCM_HDRLEN) || (doff > len)) {
-			BRCMF_ERROR(("%s: Bad data offset %d: HW len %d,"
-				     " min %d seq %d\n", __func__, doff,
-				     len, SDPCM_HDRLEN, seq));
+			brcmf_dbg(ERROR, "Bad data offset %d: HW len %d, min %d seq %d\n",
+				  doff, len, SDPCM_HDRLEN, seq);
 			bus->rx_badhdr++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
 			continue;
@@ -4087,9 +4017,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		bus->nextlen =
 		    bus->rxhdr[SDPCM_FRAMETAG_LEN + SDPCM_NEXTLEN_OFFSET];
 		if ((bus->nextlen << 4) > MAX_RX_DATASZ) {
-			BRCMF_INFO(("%s (nextlen): got frame w/nextlen too"
-				    " large (%d), seq %d\n",
-				    __func__, bus->nextlen, seq));
+			brcmf_dbg(INFO, "(nextlen): got frame w/nextlen too large (%d), seq %d\n",
+				  bus->nextlen, seq);
 			bus->nextlen = 0;
 		}
 
@@ -4109,16 +4038,15 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		/* Check and update sequence number */
 		if (rxseq != seq) {
-			BRCMF_INFO(("%s: rx_seq %d, expected %d\n", __func__,
-				    seq, rxseq));
+			brcmf_dbg(INFO, "rx_seq %d, expected %d\n", seq, rxseq);
 			bus->rx_badseq++;
 			rxseq = seq;
 		}
 
 		/* Check window for sanity */
 		if ((u8) (txmax - bus->tx_seq) > 0x40) {
-			BRCMF_ERROR(("%s: unlikely tx max %d with tx_seq %d\n",
-				     __func__, txmax, bus->tx_seq));
+			brcmf_dbg(ERROR, "unlikely tx max %d with tx_seq %d\n",
+				  txmax, bus->tx_seq);
 			txmax = bus->tx_seq + 2;
 		}
 		bus->tx_max = txmax;
@@ -4153,8 +4081,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 
 		if ((rdlen + firstread) > MAX_RX_DATASZ) {
 			/* Too long -- skip this frame */
-			BRCMF_ERROR(("%s: too long: len %d rdlen %d\n",
-				     __func__, len, rdlen));
+			brcmf_dbg(ERROR, "too long: len %d rdlen %d\n",
+				  len, rdlen);
 			bus->drvr->rx_errors++;
 			bus->rx_toolong++;
 			brcmf_sdbrcm_rxfail(bus, false, false);
@@ -4164,9 +4092,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		pkt = brcmu_pkt_buf_get_skb(rdlen + firstread + BRCMF_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
-			BRCMF_ERROR(("%s: brcmu_pkt_buf_get_skb failed:"
-				     " rdlen %d chan %d\n", __func__, rdlen,
-				     chan));
+			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: rdlen %d chan %d\n",
+				  rdlen, chan);
 			bus->drvr->rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false, RETRYCHAN(chan));
 			continue;
@@ -4184,11 +4111,10 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 		bus->f2rxdata++;
 
 		if (sdret < 0) {
-			BRCMF_ERROR(("%s: read %d %s bytes failed: %d\n",
-				     __func__, rdlen,
-				     ((chan == SDPCM_EVENT_CHANNEL) ? "event"
-				     : ((chan == SDPCM_DATA_CHANNEL) ? "data"
-				     : "test")), sdret));
+			brcmf_dbg(ERROR, "read %d %s bytes failed: %d\n", rdlen,
+				  ((chan == SDPCM_EVENT_CHANNEL) ? "event"
+				   : ((chan == SDPCM_DATA_CHANNEL) ? "data"
+				      : "test")), sdret);
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->drvr->rx_errors++;
 			brcmf_sdbrcm_rxfail(bus, true, RETRYCHAN(chan));
@@ -4211,8 +4137,8 @@ deliver:
 		/* Save superframe descriptor and allocate packet frame */
 		if (chan == SDPCM_GLOM_CHANNEL) {
 			if (SDPCM_GLOMDESC(&bus->rxhdr[SDPCM_FRAMETAG_LEN])) {
-				BRCMF_GLOM(("%s: glom descriptor, %d bytes:\n",
-					    __func__, len));
+				brcmf_dbg(GLOM, "glom descriptor, %d bytes:\n",
+					  len);
 #ifdef BCMDBG
 				if (BRCMF_GLOM_ON()) {
 					printk(KERN_DEBUG "Glom Data:\n");
@@ -4225,8 +4151,8 @@ deliver:
 				skb_pull(pkt, SDPCM_HDRLEN);
 				bus->glomd = pkt;
 			} else {
-				BRCMF_ERROR(("%s: glom superframe w/o "
-					     "descriptor!\n", __func__));
+				brcmf_dbg(ERROR, "%s: glom superframe w/o "
+					  "descriptor!\n", __func__);
 				brcmf_sdbrcm_rxfail(bus, false, false);
 			}
 			continue;
@@ -4240,7 +4166,7 @@ deliver:
 			brcmu_pkt_buf_free_skb(pkt);
 			continue;
 		} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pkt) != 0) {
-			BRCMF_ERROR(("%s: rx protocol error\n", __func__));
+			brcmf_dbg(ERROR, "rx protocol error\n");
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->drvr->rx_errors++;
 			continue;
@@ -4255,11 +4181,11 @@ deliver:
 #ifdef BCMDBG
 	/* Message if we hit the limit */
 	if (!rxleft)
-		BRCMF_DATA(("%s: hit rx limit of %d frames\n", __func__,
-			    maxframes));
+		brcmf_dbg(DATA, "hit rx limit of %d frames\n",
+			  maxframes);
 	else
 #endif				/* BCMDBG */
-		BRCMF_DATA(("%s: processed %d frames\n", __func__, rxcount));
+		brcmf_dbg(DATA, "processed %d frames\n", rxcount);
 	/* Back off rxseq if awaiting rtx, update rx_seq */
 	if (bus->rxskip)
 		rxseq--;
@@ -4275,7 +4201,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 	u8 fcbits;
 	uint retries = 0;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Read mailbox data and ack that we did so */
 	r_sdreg32(bus, &hmb_data,
@@ -4288,10 +4214,10 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 
 	/* Dongle recomposed rx frames, accept them again */
 	if (hmb_data & HMB_DATA_NAKHANDLED) {
-		BRCMF_INFO(("Dongle reports NAK handled, expect rtx of %d\n",
-			    bus->rx_seq));
+		brcmf_dbg(INFO, "Dongle reports NAK handled, expect rtx of %d\n",
+			  bus->rx_seq);
 		if (!bus->rxskip)
-			BRCMF_ERROR(("%s: unexpected NAKHANDLED!\n", __func__));
+			brcmf_dbg(ERROR, "unexpected NAKHANDLED!\n");
 
 		bus->rxskip = false;
 		intstatus |= I_HMB_FRAME_IND;
@@ -4305,12 +4231,12 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 		    (hmb_data & HMB_DATA_VERSION_MASK) >>
 		    HMB_DATA_VERSION_SHIFT;
 		if (bus->sdpcm_ver != SDPCM_PROT_VERSION)
-			BRCMF_ERROR(("Version mismatch, dongle reports %d, "
-				     "expecting %d\n",
-				     bus->sdpcm_ver, SDPCM_PROT_VERSION));
+			brcmf_dbg(ERROR, "Version mismatch, dongle reports %d, "
+				  "expecting %d\n",
+				  bus->sdpcm_ver, SDPCM_PROT_VERSION);
 		else
-			BRCMF_INFO(("Dongle ready, protocol version %d\n",
-				    bus->sdpcm_ver));
+			brcmf_dbg(INFO, "Dongle ready, protocol version %d\n",
+				  bus->sdpcm_ver);
 	}
 
 	/*
@@ -4338,8 +4264,8 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 			 HMB_DATA_FC |
 			 HMB_DATA_FWREADY |
 			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK))
-		BRCMF_ERROR(("Unknown mailbox data content: 0x%02x\n",
-			     hmb_data));
+		brcmf_dbg(ERROR, "Unknown mailbox data content: 0x%02x\n",
+			  hmb_data);
 
 	return intstatus;
 }
@@ -4354,7 +4280,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 	bool rxdone = true;	/* Flag for no more read data */
 	bool resched = false;	/* Flag indicating resched wanted */
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Start with leftover status bits */
 	intstatus = bus->intstatus;
@@ -4371,8 +4297,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 		devctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					       SBSDIO_DEVICE_CTL, &err);
 		if (err) {
-			BRCMF_ERROR(("%s: error reading DEVCTL: %d\n",
-				     __func__, err));
+			brcmf_dbg(ERROR, "error reading DEVCTL: %d\n", err);
 			bus->drvr->busstate = BRCMF_BUS_DOWN;
 		}
 #endif				/* BCMDBG */
@@ -4381,29 +4306,29 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 		clkctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
-			BRCMF_ERROR(("%s: error reading CSR: %d\n", __func__,
-				     err));
+			brcmf_dbg(ERROR, "error reading CSR: %d\n",
+				  err);
 			bus->drvr->busstate = BRCMF_BUS_DOWN;
 		}
 
-		BRCMF_INFO(("DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
-			    devctl, clkctl));
+		brcmf_dbg(INFO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
+			  devctl, clkctl);
 
 		if (SBSDIO_HTAV(clkctl)) {
 			devctl = brcmf_sdcard_cfg_read(bus->sdiodev,
 						       SDIO_FUNC_1,
 						       SBSDIO_DEVICE_CTL, &err);
 			if (err) {
-				BRCMF_ERROR(("%s: error reading DEVCTL: %d\n",
-					     __func__, err));
+				brcmf_dbg(ERROR, "error reading DEVCTL: %d\n",
+					  err);
 				bus->drvr->busstate = BRCMF_BUS_DOWN;
 			}
 			devctl &= ~SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 				SBSDIO_DEVICE_CTL, devctl, &err);
 			if (err) {
-				BRCMF_ERROR(("%s: error writing DEVCTL: %d\n",
-					     __func__, err));
+				brcmf_dbg(ERROR, "error writing DEVCTL: %d\n",
+					  err);
 				bus->drvr->busstate = BRCMF_BUS_DOWN;
 			}
 			bus->clkstate = CLK_AVAIL;
@@ -4466,23 +4391,23 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
 
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
-		BRCMF_ERROR(("Dongle reports WR_OOSYNC\n"));
+		brcmf_dbg(ERROR, "Dongle reports WR_OOSYNC\n");
 		intstatus &= ~I_WR_OOSYNC;
 	}
 
 	if (intstatus & I_RD_OOSYNC) {
-		BRCMF_ERROR(("Dongle reports RD_OOSYNC\n"));
+		brcmf_dbg(ERROR, "Dongle reports RD_OOSYNC\n");
 		intstatus &= ~I_RD_OOSYNC;
 	}
 
 	if (intstatus & I_SBINT) {
-		BRCMF_ERROR(("Dongle reports SBINT\n"));
+		brcmf_dbg(ERROR, "Dongle reports SBINT\n");
 		intstatus &= ~I_SBINT;
 	}
 
 	/* Would be active due to wake-wlan in gSPI */
 	if (intstatus & I_CHIPACTIVE) {
-		BRCMF_INFO(("Dongle reports CHIPACTIVE\n"));
+		brcmf_dbg(INFO, "Dongle reports CHIPACTIVE\n");
 		intstatus &= ~I_CHIPACTIVE;
 	}
 
@@ -4514,8 +4439,8 @@ clkwait:
 		if (ret < 0) {
 			/* On failure, abort the command and
 				terminate the frame */
-			BRCMF_INFO(("%s: sdio error %d, abort command and "
-				    "terminate frame.\n", __func__, ret));
+			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
+				  ret);
 			bus->tx_sderrs++;
 
 			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
@@ -4544,7 +4469,7 @@ clkwait:
 		if (ret == 0)
 			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
 
-		BRCMF_INFO(("Return_dpc value is : %d\n", ret));
+		brcmf_dbg(INFO, "Return_dpc value is : %d\n", ret);
 		bus->ctrl_frame_stat = false;
 		brcmf_sdbrcm_wait_event_wakeup(bus);
 	}
@@ -4563,14 +4488,12 @@ clkwait:
 		 no resched or interrupts */
 	if ((bus->drvr->busstate == BRCMF_BUS_DOWN) ||
 	    brcmf_sdcard_regfail(bus->sdiodev)) {
-		BRCMF_ERROR(("%s: failed backplane access over SDIO, halting "
-			     "operation %d\n", __func__,
-			     brcmf_sdcard_regfail(bus->sdiodev)));
+		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation %d\n",
+			  brcmf_sdcard_regfail(bus->sdiodev));
 		bus->drvr->busstate = BRCMF_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
-		BRCMF_INFO(("%s: rescheduled due to CLK_PENDING awaiting "
-			    "I_CHIPACTIVE interrupt\n", __func__));
+		brcmf_dbg(INFO, "rescheduled due to CLK_PENDING awaiting I_CHIPACTIVE interrupt\n");
 		resched = true;
 	} else if (bus->intstatus || bus->ipend ||
 		(!bus->fcstate && brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol)
@@ -4596,16 +4519,15 @@ void brcmf_sdbrcm_isr(void *arg)
 {
 	struct brcmf_bus *bus = (struct brcmf_bus *) arg;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (!bus) {
-		BRCMF_ERROR(("%s : bus is null pointer , exit\n", __func__));
+		brcmf_dbg(ERROR, "bus is null pointer, exiting\n");
 		return;
 	}
 
 	if (bus->drvr->busstate == BRCMF_BUS_DOWN) {
-		BRCMF_ERROR(("%s : bus is down. we have nothing to do\n",
-			   __func__));
+		brcmf_dbg(ERROR, "bus is down. we have nothing to do\n");
 		return;
 	}
 	/* Count the interrupt call */
@@ -4614,16 +4536,16 @@ void brcmf_sdbrcm_isr(void *arg)
 
 	/* Shouldn't get this interrupt if we're sleeping? */
 	if (bus->sleeping) {
-		BRCMF_ERROR(("INTERRUPT WHILE SLEEPING??\n"));
+		brcmf_dbg(ERROR, "INTERRUPT WHILE SLEEPING??\n");
 		return;
 	}
 
 	/* Disable additional interrupts (is this needed now)? */
 	if (!bus->intr)
-		BRCMF_ERROR(("brcmf_sdbrcm_isr() w/o interrupt configured!\n"));
+		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
 
 #if defined(SDIO_ISR_THREAD)
-	BRCMF_TRACE(("Calling brcmf_sdbrcm_dpc() from %s\n", __func__));
+	brcmf_dbg(TRACE, "Calling brcmf_sdbrcm_dpc()\n");
 	while (brcmf_sdbrcm_dpc(bus))
 		;
 #else
@@ -4637,7 +4559,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 {
 	struct brcmf_bus *bus;
 
-	BRCMF_TIMER(("%s: Enter\n", __func__));
+	brcmf_dbg(TIMER, "Enter\n");
 
 	bus = drvr->bus;
 
@@ -4817,7 +4739,7 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 
 	brcmf_c_init();
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* We make an assumption about address window mappings:
 	 * regsva == SI_ENUM_BASE*/
@@ -4825,8 +4747,7 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	/* Allocate private bus interface state */
 	bus = kzalloc(sizeof(struct brcmf_bus), GFP_ATOMIC);
 	if (!bus) {
-		BRCMF_ERROR(("%s: kmalloc of struct dhd_bus failed\n",
-			     __func__));
+		brcmf_dbg(ERROR, "kmalloc of struct dhd_bus failed\n");
 		goto fail;
 	}
 	bus->sdiodev = sdiodev;
@@ -4837,8 +4758,7 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 
 	/* attempt to attach to the dongle */
 	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
-		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_attach failed\n",
-			     __func__));
+		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_attach failed\n");
 		goto fail;
 	}
 
@@ -4893,47 +4813,43 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 	/* Attach to the brcmf/OS/network interface */
 	bus->drvr = brcmf_attach(bus, SDPCM_RESERVE);
 	if (!bus->drvr) {
-		BRCMF_ERROR(("%s: brcmf_attach failed\n", __func__));
+		brcmf_dbg(ERROR, "brcmf_attach failed\n");
 		goto fail;
 	}
 
 	/* Allocate buffers */
 	if (!(brcmf_sdbrcm_probe_malloc(bus))) {
-		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_malloc failed\n",
-			     __func__));
+		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_malloc failed\n");
 		goto fail;
 	}
 
 	if (!(brcmf_sdbrcm_probe_init(bus))) {
-		BRCMF_ERROR(("%s: brcmf_sdbrcm_probe_init failed\n", __func__));
+		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_init failed\n");
 		goto fail;
 	}
 
 	/* Register interrupt callback, but mask it (not operational yet). */
-	BRCMF_INTR(("%s: disable SDIO interrupts (not interested yet)\n",
-		    __func__));
+	brcmf_dbg(INTR, "disable SDIO interrupts (not interested yet)\n");
 	ret = brcmf_sdcard_intr_reg(bus->sdiodev);
 	if (ret != 0) {
-		BRCMF_ERROR(("%s: FAILED: sdcard_intr_reg returned %d\n",
-			     __func__, ret));
+		brcmf_dbg(ERROR, "FAILED: sdcard_intr_reg returned %d\n", ret);
 		goto fail;
 	}
-	BRCMF_INTR(("%s: registered SDIO interrupt function ok\n", __func__));
+	brcmf_dbg(INTR, "registered SDIO interrupt function ok\n");
 
-	BRCMF_INFO(("%s: completed!!\n", __func__));
+	brcmf_dbg(INFO, "completed!!\n");
 
 	/* if firmware path present try to download and bring up bus */
 	ret = brcmf_bus_start(bus->drvr);
 	if (ret != 0) {
 		if (ret == -ENOLINK) {
-			BRCMF_ERROR(("%s: dongle is not responding\n",
-				     __func__));
+			brcmf_dbg(ERROR, "dongle is not responding\n");
 			goto fail;
 		}
 	}
 	/* Ok, have the per-port tell the stack we're open for business */
 	if (brcmf_net_attach(bus->drvr, 0) != 0) {
-		BRCMF_ERROR(("%s: Net attach failed!!\n", __func__));
+		brcmf_dbg(ERROR, "Net attach failed!!\n");
 		goto fail;
 	}
 
@@ -4956,8 +4872,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 
 	/* Return the window to backplane enumeration space for core access */
 	if (brcmf_sdbrcm_set_siaddr_window(bus, SI_ENUM_BASE))
-		BRCMF_ERROR(("%s: FAILED to return to SI_ENUM_BASE\n",
-			     __func__));
+		brcmf_dbg(ERROR, "FAILED to return to SI_ENUM_BASE\n");
 
 #ifdef BCMDBG
 	printk(KERN_DEBUG "F1 signature read @0x18000000=0x%4x\n",
@@ -4979,21 +4894,18 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
-		BRCMF_ERROR(("brcmf_sdbrcm_probe: ChipClkCSR access: err %d"
-			     " wrote 0x%02x read 0x%02x\n",
-			     err, BRCMF_INIT_CLKCTL1, clkctl));
+		brcmf_dbg(ERROR, "ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
+			  err, BRCMF_INIT_CLKCTL1, clkctl);
 		goto fail;
 	}
 
 	if (brcmf_sdbrcm_chip_attach(bus, regsva)) {
-		BRCMF_ERROR(("%s: brcmf_sdbrcm_chip_attach failed!\n",
-			     __func__));
+		brcmf_dbg(ERROR, "brcmf_sdbrcm_chip_attach failed!\n");
 		goto fail;
 	}
 
 	if (!brcmf_sdbrcm_chipmatch((u16) bus->ci->chip)) {
-		BRCMF_ERROR(("%s: unsupported chip: 0x%04x\n",
-			     __func__, bus->ci->chip));
+		brcmf_dbg(ERROR, "unsupported chip: 0x%04x\n", bus->ci->chip);
 		goto fail;
 	}
 
@@ -5004,16 +4916,15 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 		  CORE_SB(bus->ci->armcorebase, sbidhigh), 4);
 	bus->orig_ramsize = bus->ci->ramsize;
 	if (!(bus->orig_ramsize)) {
-		BRCMF_ERROR(("%s: failed to find SOCRAM memory!\n",
-			     __func__));
+		brcmf_dbg(ERROR, "failed to find SOCRAM memory!\n");
 		goto fail;
 	}
 	bus->ramsize = bus->orig_ramsize;
 	if (brcmf_dongle_memsize)
 		brcmf_sdbrcm_setmemsize(bus, brcmf_dongle_memsize);
 
-	BRCMF_ERROR(("DHD: dongle ram size is set to %d(orig %d)\n",
-		     bus->ramsize, bus->orig_ramsize));
+	brcmf_dbg(ERROR, "DHD: dongle ram size is set to %d(orig %d)\n",
+		  bus->ramsize, bus->orig_ramsize);
 
 	/* Set core control so an SDIO reset does a backplane reset */
 	reg_addr = bus->ci->buscorebase +
@@ -5042,7 +4953,7 @@ fail:
 
 static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->drvr->maxctl) {
 		bus->rxblen =
@@ -5050,8 +4961,8 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus)
 			    ALIGNMENT) + BRCMF_SDALIGN;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf)) {
-			BRCMF_ERROR(("%s: kmalloc of %d-byte rxbuf failed\n",
-				     __func__, bus->rxblen));
+			brcmf_dbg(ERROR, "kmalloc of %d-byte rxbuf failed\n",
+				  bus->rxblen);
 			goto fail;
 		}
 	}
@@ -5059,8 +4970,8 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus)
 	/* Allocate buffer to receive glomed packet */
 	bus->databuf = kmalloc(MAX_DATA_BUF, GFP_ATOMIC);
 	if (!(bus->databuf)) {
-		BRCMF_ERROR(("%s: kmalloc of %d-byte databuf failed\n",
-			     __func__, MAX_DATA_BUF));
+		brcmf_dbg(ERROR, "kmalloc of %d-byte databuf failed\n",
+			  MAX_DATA_BUF);
 		/* release rxbuf which was already located as above */
 		if (!bus->rxblen)
 			kfree(bus->rxbuf);
@@ -5082,7 +4993,7 @@ fail:
 
 static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_0, SDIO_CCCR_IOEx,
@@ -5112,9 +5023,8 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 			    false) != 0)
 		bus->sd_rxchain = false;
 	else
-		BRCMF_INFO(("%s: bus module (through sdiocard API) %s"
-			    " chaining\n", __func__, bus->sd_rxchain
-			    ? "supports" : "does not support"));
+		brcmf_dbg(INFO, "bus module (through sdiocard API) %s chaining\n",
+			  bus->sd_rxchain ? "supports" : "does not support");
 
 	bus->use_rxchain = (bool) bus->sd_rxchain;
 
@@ -5139,7 +5049,7 @@ brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 /* Detach and free everything */
 static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus) {
 		/* De-register interrupt handler */
@@ -5156,12 +5066,12 @@ static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
 		kfree(bus);
 	}
 
-	BRCMF_TRACE(("%s: Disconnected\n", __func__));
+	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
 static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->drvr && bus->drvr->dongle_reset)
 		return;
@@ -5176,7 +5086,7 @@ static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
 
 static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->drvr && bus->drvr->dongle_reset)
 		return;
@@ -5190,24 +5100,24 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 		bus->vars = NULL;
 	}
 
-	BRCMF_TRACE(("%s: Disconnected\n", __func__));
+	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
 void brcmf_sdbrcm_disconnect(void *ptr)
 {
 	struct brcmf_bus *bus = (struct brcmf_bus *)ptr;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus)
 		brcmf_sdbrcm_release(bus);
 
-	BRCMF_TRACE(("%s: Disconnected\n", __func__));
+	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
 int brcmf_bus_register(void)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Sanity check on the module parameters */
 	do {
@@ -5220,7 +5130,7 @@ int brcmf_bus_register(void)
 		    && brcmf_deferred_tx)
 			break;
 
-		BRCMF_ERROR(("Invalid module parameters.\n"));
+		brcmf_dbg(ERROR, "Invalid module parameters.\n");
 		return -EINVAL;
 	} while (0);
 
@@ -5229,7 +5139,7 @@ int brcmf_bus_register(void)
 
 void brcmf_bus_unregister(void)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	brcmf_sdio_unregister();
 }
@@ -5241,22 +5151,21 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 	u8 *memblock = NULL, *memptr;
 	int ret;
 
-	BRCMF_INFO(("%s: Enter\n", __func__));
+	brcmf_dbg(INFO, "Enter\n");
 
 	bus->fw_name = BCM4329_FW_NAME;
 	ret = request_firmware(&bus->firmware, bus->fw_name,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
-		BRCMF_ERROR(("%s: Fail to request firmware %d\n",
-			     __func__, ret));
+		brcmf_dbg(ERROR, "Fail to request firmware %d\n", ret);
 		return ret;
 	}
 	bus->fw_ptr = 0;
 
 	memptr = memblock = kmalloc(MEMBLOCK + BRCMF_SDALIGN, GFP_ATOMIC);
 	if (memblock == NULL) {
-		BRCMF_ERROR(("%s: Failed to allocate memory %d bytes\n",
-			     __func__, MEMBLOCK));
+		brcmf_dbg(ERROR, "Failed to allocate memory %d bytes\n",
+			  MEMBLOCK);
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -5269,9 +5178,8 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 		brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus))) {
 		ret = brcmf_sdbrcm_membytes(bus, true, offset, memptr, len);
 		if (ret) {
-			BRCMF_ERROR(("%s: error %d on writing %d membytes at "
-				     "0x%08x\n", __func__, ret, MEMBLOCK,
-				     offset));
+			brcmf_dbg(ERROR, "error %d on writing %d membytes at 0x%08x\n",
+				  ret, MEMBLOCK, offset);
 			goto err;
 		}
 
@@ -5349,15 +5257,15 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 	ret = request_firmware(&bus->firmware, bus->nv_name,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
-		BRCMF_ERROR(("%s: Fail to request nvram %d\n", __func__, ret));
+		brcmf_dbg(ERROR, "Fail to request nvram %d\n", ret);
 		return ret;
 	}
 	bus->fw_ptr = 0;
 
 	memblock = kmalloc(MEMBLOCK, GFP_ATOMIC);
 	if (memblock == NULL) {
-		BRCMF_ERROR(("%s: Failed to allocate memory %d bytes\n",
-			     __func__, MEMBLOCK));
+		brcmf_dbg(ERROR, "Failed to allocate memory %d bytes\n",
+			  MEMBLOCK);
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -5373,11 +5281,9 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 		if (len)
 			ret = brcmf_sdbrcm_downloadvars(bus, memblock, len + 1);
 		if (ret)
-			BRCMF_ERROR(("%s: error downloading vars: %d\n",
-				     __func__, ret));
+			brcmf_dbg(ERROR, "error downloading vars: %d\n", ret);
 	} else {
-		BRCMF_ERROR(("%s: error reading nvram file: %d\n",
-			     __func__, len));
+		brcmf_dbg(ERROR, "error reading nvram file: %d\n", len);
 		ret = -EIO;
 	}
 
@@ -5396,27 +5302,23 @@ static int _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 
 	/* Keep arm in reset */
 	if (brcmf_sdbrcm_download_state(bus, true)) {
-		BRCMF_ERROR(("%s: error placing ARM core in reset\n",
-			     __func__));
+		brcmf_dbg(ERROR, "error placing ARM core in reset\n");
 		goto err;
 	}
 
 	/* External image takes precedence if specified */
 	if (brcmf_sdbrcm_download_code_file(bus)) {
-		BRCMF_ERROR(("%s: dongle image file download failed\n",
-			     __func__));
+		brcmf_dbg(ERROR, "dongle image file download failed\n");
 		goto err;
 	}
 
 	/* External nvram takes precedence if specified */
 	if (brcmf_sdbrcm_download_nvram(bus))
-		BRCMF_ERROR(("%s: dongle nvram file download failed\n",
-			     __func__));
+		brcmf_dbg(ERROR, "dongle nvram file download failed\n");
 
 	/* Take arm out of reset */
 	if (brcmf_sdbrcm_download_state(bus, false)) {
-		BRCMF_ERROR(("%s: error getting out of ARM core reset\n",
-			     __func__));
+		brcmf_dbg(ERROR, "error getting out of ARM core reset\n");
 		goto err;
 	}
 
@@ -5457,14 +5359,14 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 			bus->drvr->dongle_reset = true;
 			bus->drvr->up = false;
 
-			BRCMF_TRACE(("%s:  WLAN OFF DONE\n", __func__));
+			brcmf_dbg(TRACE, "WLAN OFF DONE\n");
 			/* App can now remove power from device */
 		} else
 			bcmerror = -EIO;
 	} else {
 		/* App must have restored power to device before calling */
 
-		BRCMF_TRACE(("\n\n%s: == WLAN ON ==\n", __func__));
+		brcmf_dbg(TRACE, " == WLAN ON ==\n");
 
 		if (bus->drvr->dongle_reset) {
 			/* Turn on WLAN */
@@ -5479,16 +5381,14 @@ int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 					bus->drvr->dongle_reset = false;
 					bus->drvr->up = true;
 
-					BRCMF_TRACE(("%s: WLAN ON DONE\n",
-						     __func__));
+					brcmf_dbg(TRACE, "WLAN ON DONE\n");
 				} else
 					bcmerror = -EIO;
 			} else
 				bcmerror = -EIO;
 		} else {
 			bcmerror = -EISCONN;
-			BRCMF_ERROR(("%s: Set DEVRESET=false invoked when"
-				     " device is on\n", __func__));
+			brcmf_dbg(ERROR, "Set DEVRESET=false invoked when device is on\n");
 			bcmerror = -EIO;
 		}
 		brcmf_sdbrcm_wd_timer(bus, brcmf_watchdog_ms);
@@ -5514,8 +5414,7 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 
-	BRCMF_INFO(("%s: chipid=0x%x chiprev=%d\n",
-		    __func__, ci->chip, ci->chiprev));
+	brcmf_dbg(INFO, "chipid=0x%x chiprev=%d\n", ci->chip, ci->chiprev);
 
 	/* Address of cores for new chips should be added here */
 	switch (ci->chip) {
@@ -5526,8 +5425,7 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->ramsize = BCM4329_RAMSIZE;
 		break;
 	default:
-		BRCMF_ERROR(("%s: chipid 0x%x is not supported\n",
-			     __func__, ci->chip));
+		brcmf_dbg(ERROR, "chipid 0x%x is not supported\n", ci->chip);
 		return -ENODEV;
 	}
 
@@ -5544,9 +5442,8 @@ brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	ci->buscorerev = SBCOREREV(regdata);
 	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
 
-	BRCMF_INFO(("%s: ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
-		    __func__, ci->ccrev, ci->pmurev,
-		    ci->buscorerev, ci->buscoretype));
+	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
+		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
 
 	/* get chipcommon capabilites */
 	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
@@ -5587,7 +5484,7 @@ brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatehigh), 4);
 		if (regdata & SBTMH_BUSY)
-			BRCMF_ERROR(("%s: ARM core still busy\n", __func__));
+			brcmf_dbg(ERROR, "ARM core still busy\n");
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbidlow), 4);
@@ -5641,12 +5538,12 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	int err;
 	u8 clkval, clkset;
 
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	/* alloc chip_info_t */
 	ci = kzalloc(sizeof(struct chip_info), GFP_ATOMIC);
 	if (NULL == ci) {
-		BRCMF_ERROR(("%s: malloc failed!\n", __func__));
+		brcmf_dbg(ERROR, "malloc failed!\n");
 		return -ENOMEM;
 	}
 
@@ -5656,7 +5553,7 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 			       SBSDIO_FUNC1_CHIPCLKCSR,	clkset, &err);
 	if (err) {
-		BRCMF_ERROR(("%s: error writing for HT off\n", __func__));
+		brcmf_dbg(ERROR, "error writing for HT off\n");
 		goto fail;
 	}
 
@@ -5672,8 +5569,8 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 				!SBSDIO_ALPAV(clkval)),
 				PMU_MAX_TRANSITION_DLY);
 		if (!SBSDIO_ALPAV(clkval)) {
-			BRCMF_ERROR(("%s: timeout on ALPAV wait,"
-				     " clkval 0x%02x\n", __func__, clkval));
+			brcmf_dbg(ERROR, "timeout on ALPAV wait, clkval 0x%02x\n",
+				  clkval);
 			err = -EBUSY;
 			goto fail;
 		}
@@ -5684,8 +5581,8 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 				clkset, &err);
 		udelay(65);
 	} else {
-		BRCMF_ERROR(("%s: ChipClkCSR access: wrote 0x%02x"
-			     " read 0x%02x\n", __func__, clkset, clkval));
+		brcmf_dbg(ERROR, "ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
+			  clkset, clkval);
 		err = -EACCES;
 		goto fail;
 	}
@@ -5844,10 +5741,9 @@ static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 		str_shift = 11;
 		break;
 	default:
-		BRCMF_ERROR(("No SDIO Drive strength init"
-			     "done for chip %s rev %d pmurev %d\n",
-			     brcmu_chipname(bus->ci->chip, chn, 8),
-			     bus->ci->chiprev, bus->ci->pmurev));
+		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
+			  brcmu_chipname(bus->ci->chip, chn, 8),
+			  bus->ci->chiprev, bus->ci->pmurev);
 		break;
 	}
 
@@ -5875,15 +5771,15 @@ static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
 			4, cc_data_temp);
 
-		BRCMF_INFO(("SDIO: %dmA drive strength selected, "
-			    "set to 0x%08x\n", drivestrength, cc_data_temp));
+		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
+			  drivestrength, cc_data_temp);
 	}
 }
 
 static void
 brcmf_sdbrcm_chip_detach(struct brcmf_bus *bus)
 {
-	BRCMF_TRACE(("%s: Enter\n", __func__));
+	brcmf_dbg(TRACE, "Enter\n");
 
 	kfree(bus->ci);
 	bus->ci = NULL;
-- 
1.7.6.405.gc1be0

