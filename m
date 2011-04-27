Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1D0QZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:25:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48252 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1D0QZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:25:17 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=3rvgeqzMqd0A:10 a=uHzB2e4Qac0A:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=pGLkceISAAAA:8 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=XGz2KfOUNL1kDKcHzHUA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=IcxpeKGZWnEA:10 a=LI9Vle30uBYA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Wed, 27 Apr 2011 11:25:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>, jeff.chua.linux@gmail.com
Cc: wlanfae@realtek.com, ino-news@spotteswoode.dnsalias.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Chua <jeff.chua.linux@gmail.com>

Driver r8712u is unable to handle ad-hoc mode. The issue is that when
the driver first starts, there will not be an SSID for association.
The fix is to always call the "select and join from scan" routine when
in ad-hoc mode.

Note: Ad-hoc mode worked intermittently before. If the driver had
previously been associated, then things were OK.

Signed-off-by: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
---

Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -68,7 +68,10 @@ static u8 do_join(struct _adapter *padap
 	pmlmepriv->fw_state |= _FW_UNDER_LINKING;
 	pmlmepriv->pscanned = plist;
 	pmlmepriv->to_join = true;
-	if (_queue_empty(queue) == true) {
+
+	/* adhoc mode will start with an empty queue, but skip checking */
+	if (!check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) &&
+	    _queue_empty(queue)) {
 		if (pmlmepriv->fw_state & _FW_UNDER_LINKING)
 			pmlmepriv->fw_state ^= _FW_UNDER_LINKING;
 		/* when set_ssid/set_bssid for do_join(), but scanning queue
