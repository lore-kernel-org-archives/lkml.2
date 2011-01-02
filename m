Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1ABHwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:52:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:35665 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1ABHXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Carpenter <error27@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 126/260] Staging: vt6655: fix buffer overflow
Date: Sun,  2 Jan 2011 02:17:02 -0500
Message-Id: <1293952756-15010-127-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:27.0712 (UTC) FILETIME=[CF49E000:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit dd173abfead903c7df54e977535973f3312cd307 upstream.

"param->u.wpa_associate.wpa_ie_len" comes from the user.  We should
check it so that the copy_from_user() doesn't overflow the buffer.

Also further down in the function, we assume that if
"param->u.wpa_associate.wpa_ie_len" is set then "abyWPAIE[0]" is
initialized.  To make that work, I changed the test here to say that if
"wpa_ie_len" is set then "wpa_ie" has to be a valid pointer or we return
-EINVAL.

Oddly, we only use the first element of the abyWPAIE[] array.  So I
suspect there may be some other issues in this function.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/vt6655/wpactl.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 574e0b0..a078f6f 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -767,9 +767,14 @@ static int wpa_set_associate(PSDevice pDevice,
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ie_len = %d\n", param->u.wpa_associate.wpa_ie_len);
 
 
-	if (param->u.wpa_associate.wpa_ie &&
-	    copy_from_user(&abyWPAIE[0], param->u.wpa_associate.wpa_ie, param->u.wpa_associate.wpa_ie_len))
-	    return -EINVAL;
+	if (param->u.wpa_associate.wpa_ie_len) {
+		if (!param->u.wpa_associate.wpa_ie)
+			return -EINVAL;
+		if (param->u.wpa_associate.wpa_ie_len > sizeof(abyWPAIE))
+			return -EINVAL;
+		if (copy_from_user(&abyWPAIE[0], param->u.wpa_associate.wpa_ie, param->u.wpa_associate.wpa_ie_len))
+			return -EFAULT;
+	}
 
 	if (param->u.wpa_associate.mode == 1)
 	    pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
-- 
1.7.3.3

