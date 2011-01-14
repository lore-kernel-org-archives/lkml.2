Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1ANUxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 15:53:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50570 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1ANUxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 15:53:40 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=ylaNbVlZgDkA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=EI1qvWizz0FC-POzBZIA:9 a=p6YJ5XOWQE7sDGzZEK8A:7 a=RNtAC6AtJRwxsaz9IEuUybvQNQYA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Fri, 14 Jan 2011 14:54:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: florian.c.schilhabel@googlemail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: r8712u: Fix memory leak in firmware loading
Message-ID: <4d30b7f0.qtIWkLa/SHY0hXZK%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error path leaks the firmware struct.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/hal_init.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 32088a6..84be383 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -128,12 +128,13 @@ static u8 rtl8712_dl_fw(struct _adapter *padapter)
 	u8 *ptmpchar = NULL, *ppayload, *ptr;
 	struct tx_desc *ptx_desc;
 	u32 txdscp_sz = sizeof(struct tx_desc);
+	u8 ret = _FAIL;
 
 	ulfilelength = rtl871x_open_fw(padapter, &phfwfile_hdl, &pmappedfw);
 	if (pmappedfw && (ulfilelength > 0)) {
 		update_fwhdr(&fwhdr, pmappedfw);
 		if (chk_fwhdr(&fwhdr, ulfilelength) == _FAIL)
-			goto exit_fail;
+			goto firmware_rel;
 		fill_fwpriv(padapter, &fwhdr.fwpriv);
 		/* firmware check ok */
 		maxlen = (fwhdr.img_IMEM_size > fwhdr.img_SRAM_size) ?
@@ -141,7 +142,7 @@ static u8 rtl8712_dl_fw(struct _adapter *padapter)
 		maxlen += txdscp_sz;
 		ptmpchar = _malloc(maxlen + FWBUFF_ALIGN_SZ);
 		if (ptmpchar == NULL)
-			return _FAIL;
+			goto firmware_rel;
 
 		ptx_desc = (struct tx_desc *)(ptmpchar + FWBUFF_ALIGN_SZ -
 			    ((addr_t)(ptmpchar) & (FWBUFF_ALIGN_SZ - 1)));
@@ -273,11 +274,13 @@ static u8 rtl8712_dl_fw(struct _adapter *padapter)
 			goto exit_fail;
 	} else
 		goto exit_fail;
-	return _SUCCESS;
+	ret = _SUCCESS;
 
 exit_fail:
 	kfree(ptmpchar);
-	return _FAIL;
+firmware_rel:
+	release_firmware((struct firmware *)phfwfile_hdl);
+	return ret;
 }
 
 uint rtl8712_hal_init(struct _adapter *padapter)
-- 
1.7.1

