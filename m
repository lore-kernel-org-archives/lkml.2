Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1BBOzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 09:55:00 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44793 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1BBOy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:54:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EHt2V9DxxA7wY5MhtDgQGk750HEeDUMabyC7q2NokKePIjkd+G0Wea2rA9qj6f9HPh
         hiNe9XDrwxIZpL3qcWWG/6Mi9hM109vfjCHWsn3GyoUqnBOm+yoZ6MuspbAhQNfAP1aW
         VTXySYqN0kxL+d1wE0ypgrzMt2/OFksmgv8Jo=
Message-ID: <4D497073.4000109@lwfinger.net>
Date: Wed, 02 Feb 2011 08:55:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Mark Einon <mark.einon@gmail.com>
CC: greg@kroah.com, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8712: Switch from large inline firmware file
 to use the firmware interface
References: <1296607614-5326-1-git-send-email-mark.einon@gmail.com>	<4D48B24B.8020305@lwfinger.net> <AANLkTikXfScGU93epfcgHXrBQwDELdGS1y8zeHkpu=n4@mail.gmail.com>
In-Reply-To: <AANLkTikXfScGU93epfcgHXrBQwDELdGS1y8zeHkpu=n4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 03:13 AM, Mark Einon wrote:
> Hi Larry,
> 
>     I don't think these patches are equivalent, could you explain what
> you mean? I can't find an equivalent use of request_firmware() in the
> driver prior to this patch, or from the Jan 14 changes.

---
Here is patch 3 of 4:

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/TODO       |    2 --
 drivers/staging/rtl8712/hal_init.c |   22 +++++++++++++++++-----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/TODO b/drivers/staging/rtl8712/TODO
index 2aa5deb..d8dfe5b 100644
--- a/drivers/staging/rtl8712/TODO
+++ b/drivers/staging/rtl8712/TODO
@@ -3,8 +3,6 @@ TODO:
 - switch to use LIB80211
 - switch to use MAC80211
 - checkpatch.pl fixes - only a few remain
-- switch from large inline firmware file to use the firmware interface
-  and add the file to the linux-firmware package.

 Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
 Larry Finger <Larry.Finger@lwfinger.net> and
diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 84be383..52ab2d5 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -31,7 +31,6 @@
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "rtl871x_byteorder.h"
-#include "farray.h"
 #include "usb_osintf.h"

 #define FWBUFF_ALIGN_SZ 512
@@ -40,11 +39,24 @@
 static u32 rtl871x_open_fw(struct _adapter *padapter, void **pphfwfile_hdl,
 		    const u8 **ppmappedfw)
 {
-	u32 len;
+	int rc;
+	const char firmware_file[] = "rtl8712u/rtl8712u.bin";
+	const struct firmware **praw = (const struct firmware **)
+				       (pphfwfile_hdl);
+	struct dvobj_priv *pdvobjpriv = (struct dvobj_priv *)
+					(&padapter->dvobjpriv);
+	struct usb_device *pusbdev = pdvobjpriv->pusbdev;

-	*ppmappedfw = f_array;
-	len = sizeof(f_array);
-	return len;
+	printk(KERN_INFO "r8712u: Loading firmware from \"%s\"\n",
+	       firmware_file);
+	rc = request_firmware(praw, firmware_file, &pusbdev->dev);
+	if (rc < 0) {
+		printk(KERN_ERR "r8712u: Unable to load firmware\n");
+		printk(KERN_ERR "r8712u: Install latest linux-firmware\n");
+		return 0;
+	}
+	*ppmappedfw = (u8 *)((*praw)->data);
+	return (*praw)->size;
 }

 static void fill_fwpriv(struct _adapter *padapter, struct fw_priv *pfwpriv)
-- 1.7.1

The large farray.h is deleted in 4 of 4:

 drivers/staging/rtl8712/Kconfig    |    1 +
 drivers/staging/rtl8712/farray.h   |10197 ------------------------------------
 drivers/staging/rtl8712/hal_init.c |    3 +-
 3 files changed, 3 insertions(+), 10198 deletions(-)
 delete mode 100644 drivers/staging/rtl8712/farray.h


Note that inclusion of the "git rm" command with git generating the patch avoids
spamming the list with the 10,198 lines that were deleted.

Larry
