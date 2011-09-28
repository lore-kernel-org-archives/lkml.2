Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1I1WvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:51:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015Ab1I1WvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:51:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:49 2011
Message-Id: <20110928220148.989353666@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Rafael Wysocki <rjw@sisk.pl>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Borislav Petkov <bp@alien8.de>,
        Lucas Villa Real <lucasvr@gobolinux.org>
Subject: [224/244] firmware loader: allow builtin firmware load even if usermodehelper is disabled
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit caca9510ff4e5d842c0589110243d60927836222 upstream.

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
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Lucas Villa Real <lucasvr@gobolinux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/firmware_class.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -521,11 +521,6 @@ static int _request_firmware(const struc
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
@@ -539,6 +534,12 @@ static int _request_firmware(const struc
 		return 0;
 	}
 
+	if (WARN_ON(usermodehelper_is_disabled())) {
+		dev_err(device, "firmware: %s will not be loaded\n", name);
+		retval = -EBUSY;
+		goto out;
+	}
+
 	if (uevent)
 		dev_dbg(device, "firmware: requesting %s\n", name);
 


