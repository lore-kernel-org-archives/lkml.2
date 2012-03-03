Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2CCDGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 22:06:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18614 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2CCDGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 22:06:52 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TtU46XPs5IkA:10 a=TRgVYD6ZyiEA:10 a=z1_pVKzIgUwA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=yPCof4ZbAAAA:8 a=yQdBAQUQAAAA:8 a=0vJaVQtncHHANOe9kJEA:9 a=CjuIK1q_8ugA:10 a=7DSvI1NPTFQA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Fri, 02 Mar 2012 21:06:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@linux-foundation.org>
Cc: dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: r8712u: Fix Smatch warning
Message-ID: <4f518ac9.EJKoo6JMfhftduHd%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 2080913e017a: "staging: r8712u: Fix regression caused by 
commit 8c213fa" from Feb 25, 2012, leads to the following Smatch 
complaint:

drivers/staging/rtl8712/usb_intf.c:629 r871xu_dev_remove()
	 warn: variable dereferenced before check 'padapter' (see line 625)

The fix is to move the new statements inside the block where padapter
is not NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: staging/drivers/staging/rtl8712/usb_intf.c
===================================================================
--- staging.orig/drivers/staging/rtl8712/usb_intf.c
+++ staging/drivers/staging/rtl8712/usb_intf.c
@@ -620,12 +620,12 @@ static void r871xu_dev_remove(struct usb
 	struct _adapter *padapter = netdev_priv(pnetdev);
 	struct usb_device *udev = interface_to_usbdev(pusb_intf);
 
-	if (padapter->fw_found)
-		release_firmware(padapter->fw);
-	/* never exit with a firmware callback pending */
-	wait_for_completion(&padapter->rtl8712_fw_ready);
 	usb_set_intfdata(pusb_intf, NULL);
 	if (padapter) {
+		if (padapter->fw_found)
+			release_firmware(padapter->fw);
+		/* never exit with a firmware callback pending */
+		wait_for_completion(&padapter->rtl8712_fw_ready);
 		if (drvpriv.drv_registered == true)
 			padapter->bSurpriseRemoved = true;
 		if (pnetdev != NULL) {
