Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461Ab2CAVuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:50:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46239 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965375Ab2CAVur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.134.104 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213927.438738671@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, rjw@sisk.pl, valdis.kletnieks@vt.edu,
        cloos@hjcloos.com, riesebie@lxtec.de,
        penguin-kernel@i-love.sakura.ne.jp, srivatsa.bhat@linux.vnet.ibm.com,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>
Subject: [ 32/34] firmware loader: allow builtin firmware load even if usermodehelper is disabled
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit caca9510ff4e5d842c0589110243d60927836222 ]

In commit a144c6a6c924 ("PM: Print a warning if firmware is requested
when tasks are frozen") we not only printed a warning if somebody tried
to load the firmware when tasks are frozen - we also failed the load.

But that check was done before the check for built-in firmware, and then
when we disallowed usermode helpers during bootup (commit 288d5abec831:
"Boot up with usermodehelper disabled"), that actually means that
built-in modules can no longer load their firmware even if the firmware
is built in too.  Which used to work, and some people depended on it for
the R100 driver.

So move the test for usermodehelper_is_disabled() down, to after
checking the built-in firmware.

This should fix:

	https://bugzilla.kernel.org/show_bug.cgi?id=40952

Reported-by: James Cloos <cloos@hjcloos.com>
Bisected-by: Elimar Riesebieter <riesebie@lxtec.de>
Cc: Michel Dänzer <michel@daenzer.net>
Cc: Rafael Wysocki <rjw@sisk.pl>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 drivers/base/firmware_class.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -489,11 +489,6 @@ _request_firmware(const struct firmware
 	if (!firmware_p)
 		return -EINVAL;
 
-	if (WARN_ON(usermodehelper_is_disabled())) {
-		dev_err(device, "firmware: %s will not be loaded\n", name);
-		return -EBUSY;
-	}
-
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
@@ -513,6 +508,12 @@ _request_firmware(const struct firmware
 		return 0;
 	}
 
+	if (WARN_ON(usermodehelper_is_disabled())) {
+		dev_err(device, "firmware: %s will not be loaded\n", name);
+		retval = -EBUSY;
+		goto out;
+	}
+
 	if (uevent)
 		dev_info(device, "firmware: requesting %s\n", name);
 


