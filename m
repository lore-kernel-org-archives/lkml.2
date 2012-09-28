Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031260Ab2I1Tas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:30:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030227Ab2I1TBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: =?UTF-8?q?=5B=20160/262=5D=20USB=3A=20cdc-wdm=3A=20fix=20wdm=5Ffind=5Fdevice*=20return=20value?=
Date: Fri, 28 Sep 2012 11:51:29 -0700
Message-Id: <20120928183016.875384515@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 6a44886899ef8cc396e230e492e6a56a883889f3 upstream.

A logic error made the wdm_find_device* functions
return a bogus pointer into static data instead of
the intended NULL no matching device was found.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -134,12 +134,14 @@ static struct usb_driver wdm_driver;
 /* return intfdata if we own the interface, else look up intf in the list */
 static struct wdm_device *wdm_find_device(struct usb_interface *intf)
 {
-	struct wdm_device *desc = NULL;
+	struct wdm_device *desc;
 
 	spin_lock(&wdm_device_list_lock);
 	list_for_each_entry(desc, &wdm_device_list, device_list)
 		if (desc->intf == intf)
-			break;
+			goto found;
+	desc = NULL;
+found:
 	spin_unlock(&wdm_device_list_lock);
 
 	return desc;
@@ -147,12 +149,14 @@ static struct wdm_device *wdm_find_devic
 
 static struct wdm_device *wdm_find_device_by_minor(int minor)
 {
-	struct wdm_device *desc = NULL;
+	struct wdm_device *desc;
 
 	spin_lock(&wdm_device_list_lock);
 	list_for_each_entry(desc, &wdm_device_list, device_list)
 		if (desc->intf->minor == minor)
-			break;
+			goto found;
+	desc = NULL;
+found:
 	spin_unlock(&wdm_device_list_lock);
 
 	return desc;


