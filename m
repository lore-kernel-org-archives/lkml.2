Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab1JIOAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 10:00:47 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:63031 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1JIOAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 10:00:46 -0400
Date: Sun, 9 Oct 2011 16:57:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wwang <wei_wang@realsil.com.cn>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:rts_pstor:Fix SDIO issue
Message-ID: <20111009135745.GO18470@longonot.mountain>
References: <1318125810-30505-1-git-send-email-wei_wang@realsil.com.cn>
 <20111009060644.GN18470@longonot.mountain>
 <4E9143B1.3040300@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9143B1.3040300@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090201.4E91A908.0035,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What I'm saying is, it's confusing to add another variable which is
only subtly different from retval.  Here is what it looks like after
we apply the patch.

	int reset_pass = 0;

	/* skip 45 lines */

	retval = sd_change_bank_voltage(chip, SD_IO_3V3);
	if (retval != STATUS_SUCCESS) {
		TRACE_RET(chip, STATUS_FAIL);
	}

	/* skip 30 lines */

	if (!reset_pass)
		TRACE_RET(chip, STATUS_FAIL);

The reviewer would have to read through 80 lines of code to find that
we don't care about the return value from sd_change_bank_voltage().
Don't do it that way.

Here is how I would write what it.  I can't actually test this since
I don't have the hardware...

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index fb62eaf..46bf0e1 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3134,39 +3134,36 @@ int reset_sd_card(struct rtsx_chip *chip)
 
 	if (chip->sd_ctl & RESET_MMC_FIRST) {
 		retval = reset_mmc(chip);
-		if ((retval != STATUS_SUCCESS) && !sd_check_err_code(chip, SD_NO_CARD)) {
+		if (retval != STATUS_SUCCESS) {
+			if (sd_check_err_code(chip, SD_NO_CARD))
+				TRACE_RET(chip, STATUS_FAIL);
+
 			retval = reset_sd(chip);
 			if (retval != STATUS_SUCCESS) {
-				if (CHECK_PID(chip, 0x5209)) {
-					retval = sd_change_bank_voltage(chip, SD_IO_3V3);
-					if (retval != STATUS_SUCCESS) {
-						TRACE_RET(chip, STATUS_FAIL);
-					}
-				}
+				if (CHECK_PID(chip, 0x5209))
+					sd_change_bank_voltage(chip, SD_IO_3V3);
+				TRACE_RET(chip, STATUS_FAIL);
 			}
 		}
 	} else {
 		retval = reset_sd(chip);
 		if (retval != STATUS_SUCCESS) {
-			if (sd_check_err_code(chip, SD_NO_CARD)) {
+			if (sd_check_err_code(chip, SD_NO_CARD))
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			if (CHECK_PID(chip, 0x5209)) {
 				retval = sd_change_bank_voltage(chip, SD_IO_3V3);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 			}
 
-			if (!chip->sd_io) {
-				retval = reset_mmc(chip);
-			}
-		}
-	}
+			if (chip->sd_io)
+				TRACE_RET(chip, STATUS_FAIL);
 
-	if (retval != STATUS_SUCCESS) {
-		TRACE_RET(chip, STATUS_FAIL);
+			retval = reset_mmc(chip);
+			if (retval != STATUS_SUCCESS)
+				TRACE_RET(chip, STATUS_FAIL);
+		}
 	}
 
 	retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
