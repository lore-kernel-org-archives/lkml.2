Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab0IXQ5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:57:51 -0400
Received: from kroah.org ([198.145.64.141]:46117 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab0IXQ2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:11 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:16 2010
Message-Id: <20100924162616.825130362@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>
Subject: [22/80] Staging: vt6655: fix buffer overflow
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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

---
 drivers/staging/vt6655/wpactl.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -766,9 +766,14 @@ static int wpa_set_associate(PSDevice pD
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


